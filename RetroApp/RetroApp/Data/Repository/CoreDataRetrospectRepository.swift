//
//  CoreDataRetrospectRepository.swift
//  RetroApp
//
//  Created by J on 3/30/26.
//

import CoreData
import Foundation

/// ``RetrospectRepositoryProtocol``의 Core Data 구현체.
///
/// Domain 레이어의 ``Retrospect`` Entity를 Core Data로 저장/조회/수정/삭제한다.
/// ``RetrospectMapper``를 통해 ManagedObject와 Domain Entity 간 변환을 수행한다.
final class CoreDataRetrospectRepository: RetrospectRepositoryProtocol {

    // MARK: - Properties

    private let coreDataStack: CoreDataStack

    // MARK: - Init

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    // MARK: - CRUD

    /// 새 회고를 Core Data에 저장한다.
    ///
    /// UseCase에서 `id`와 `createdAt`이 할당된 상태로 전달된다.
    /// - Parameter retrospect: 저장할 회고
    /// - Returns: 저장된 회고
    func save(_ retrospect: Retrospect) async throws -> Retrospect {
        _ = RetrospectMapper.toManagedObject(retrospect, context: coreDataStack.viewContext)
        try coreDataStack.saveContext(coreDataStack.viewContext)
        return retrospect
    }

    /// 전체 회고 목록을 최신순으로 조회한다.
    ///
    /// `createdAt` 내림차순으로 정렬하여 반환한다.
    /// - Returns: 회고 배열
    func fetchAll() async throws -> [Retrospect] {
        let request = NSFetchRequest<RetrospectEntity>(entityName: "RetrospectEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        do {
            let response = try coreDataStack.viewContext.fetch(request)
            return response.map { RetrospectMapper.toEntity($0) }
        } catch {
            throw error
        }
    }

    /// 특정 회고를 ID로 조회한다.
    ///
    /// - Parameter id: 조회할 회고의 식별자
    /// - Returns: 해당 회고
    /// - Throws: ``RetrospectError/retrospectNotFound`` — 해당 ID의 회고가 없을 때
    func fetchById(_ id: UUID) async throws -> Retrospect {
        let request = NSFetchRequest<RetrospectEntity>(entityName: "RetrospectEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let response = try coreDataStack.viewContext.fetch(request)

            guard let managed = response.first else {
                throw RetrospectError.retrospectNotFound
            }

            return RetrospectMapper.toEntity(managed)
        } catch {
            throw error
        }
    }

    /// 특정 날짜의 회고 목록을 조회한다.
    ///
    /// 해당 날짜의 00:00:00부터 다음 날 00:00:00 사이의 회고를 반환한다.
    /// 달력 뷰에서 날짜를 탭했을 때 사용한다.
    /// - Parameter date: 조회할 날짜 (시간 무시, 날짜만 비교)
    /// - Returns: 해당 날짜의 회고 배열
    func fetchByDate(_ date: Date) async throws -> [Retrospect] {
        let request = NSFetchRequest<RetrospectEntity>(entityName: "RetrospectEntity")

        let start = Calendar.current.startOfDay(for: date)
        let end = Calendar.current.date(byAdding: .day, value: 1, to: start)!

        request.predicate = NSPredicate(
            format: "createdAt >= %@ AND createdAt < %@",
            start as CVarArg,
            end as CVarArg
        )

        do {
            let response = try coreDataStack.viewContext.fetch(request)
            return response.map { RetrospectMapper.toEntity($0) }
        } catch {
            throw error
        }
    }

    /// 기존 회고를 업데이트한다.
    ///
    /// ID로 기존 ManagedObject를 찾아 ``RetrospectMapper``로 값을 덮어쓴다.
    /// - Parameter retrospect: 업데이트할 회고
    /// - Returns: 업데이트된 회고
    /// - Throws: ``RetrospectError/retrospectNotFound`` — 해당 ID의 회고가 없을 때
    func update(_ retrospect: Retrospect) async throws -> Retrospect {
        let request = NSFetchRequest<RetrospectEntity>(entityName: "RetrospectEntity")
        request.predicate = NSPredicate(format: "id == %@", retrospect.id as CVarArg)

        do {
            let response = try coreDataStack.viewContext.fetch(request)

            guard let managed = response.first else {
                throw RetrospectError.retrospectNotFound
            }

            RetrospectMapper.update(managed, from: retrospect)
            try coreDataStack.saveContext(coreDataStack.viewContext)

            return retrospect
        } catch {
            throw error
        }
    }

    /// 회고를 삭제한다.
    ///
    /// ID로 ManagedObject를 찾아 context에서 삭제한다.
    /// 연관된 ``RetrospectItem``의 cascade 삭제는 Core Data relationship 설정에 의존한다.
    /// - Parameter id: 삭제할 회고의 식별자
    /// - Throws: ``RetrospectError/retrospectNotFound`` — 해당 ID의 회고가 없을 때
    func delete(_ id: UUID) async throws {
        let request = NSFetchRequest<RetrospectEntity>(entityName: "RetrospectEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let response = try coreDataStack.viewContext.fetch(request)

            guard let managed = response.first else {
                throw RetrospectError.retrospectNotFound
            }

            coreDataStack.viewContext.delete(managed)
            try coreDataStack.saveContext(coreDataStack.viewContext)
        } catch {
            throw error
        }
    }

    // MARK: - Calendar

    /// 해당 월에 회고가 존재하는 날짜 목록을 조회한다.
    ///
    /// 해당 월 1일 00:00:00부터 다음 달 1일 00:00:00 사이의 회고에서
    /// `createdAt`만 추출하여 반환한다.
    /// 달력 뷰에서 회고가 있는 날짜에 점을 표시하기 위해 사용한다.
    /// - Parameter month: 조회할 월 (해당 월의 아무 날짜)
    /// - Returns: 회고가 있는 날짜 배열
    func fetchDatesWithRetrospect(in month: Date) async throws -> [Date] {
        let request = NSFetchRequest<RetrospectEntity>(entityName: "RetrospectEntity")

        let components = Calendar.current.dateComponents([.year, .month], from: month)
        let start = Calendar.current.date(from: components)!
        let end = Calendar.current.date(byAdding: .month, value: 1, to: start)!

        request.predicate = NSPredicate(
            format: "createdAt >= %@ AND createdAt < %@",
            start as CVarArg,
            end as CVarArg
        )

        do {
            let response = try coreDataStack.viewContext.fetch(request)
            return response.compactMap { $0.createdAt }
        } catch {
            throw error
        }
    }
}
