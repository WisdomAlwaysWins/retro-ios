//
//  CoreDataRetrospectFormatRepository.swift
//  RetroApp
//
//  Created by J on 3/30/26.
//

import CoreData
import Foundation

/// ``RetrospectFormatRepositoryProtocol``의 Core Data 구현체.
///
/// 빌트인 포맷(KPT, 4Ls 등) 조회와 커스텀 포맷 저장/삭제를 담당한다.
/// ``RetrospectFormatMapper``를 통해 ManagedObject와 Domain Entity 간 변환을 수행한다.
final class CoreDataRetrospectFormatRepository: RetrospectFormatRepositoryProtocol {
    // MARK: - Properties

    private let coreDataStack: CoreDataStack

    // MARK: - Init

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    // MARK: - Read

    /// 전체 포맷 목록을 조회한다.
    ///
    /// 빌트인 포맷이 먼저, 커스텀 포맷이 뒤에 오도록 정렬한다.
    /// 같은 그룹 내에서는 이름 오름차순으로 정렬한다.
    /// - Returns: 포맷 배열
    func fetchAll() async throws -> [RetrospectFormat] {
        let request = NSFetchRequest<RetrospectFormatEntity>(entityName: "RetrospectFormatEntity")
        request.sortDescriptors = [
            NSSortDescriptor(key: "isBuiltIn", ascending: false),
            NSSortDescriptor(key: "name", ascending: true)
        ]

        do {
            let response = try coreDataStack.viewContext.fetch(request)
            return response.map { RetrospectFormatMapper.toEntity($0) }
        } catch {
            throw error
        }
    }

    /// 특정 포맷을 ID로 조회한다.
    ///
    /// - Parameter id: 조회할 포맷의 식별자
    /// - Returns: 해당 포맷
    /// - Throws: ``RetrospectError/notFound`` — 해당 ID의 포맷이 없을 때
    func fetchById(_ id: UUID) async throws -> RetrospectFormat {
        let request = NSFetchRequest<RetrospectFormatEntity>(entityName: "RetrospectFormatEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let response = try coreDataStack.viewContext.fetch(request)

            guard let managed = response.first else {
                throw RetrospectError.formatNotFound
            }

            return RetrospectFormatMapper.toEntity(managed)
        } catch {
            throw error
        }
    }

    // MARK: - Create

    /// 커스텀 포맷을 Core Data에 저장한다.
    ///
    /// `isBuiltIn`은 항상 `false`로 설정된다.
    /// - Parameter format: 저장할 포맷
    /// - Returns: 저장된 포맷
    func save(_ format: RetrospectFormat) async throws -> RetrospectFormat {
        let managed = RetrospectFormatMapper.toManagedObject(format, context: coreDataStack.viewContext)
        managed.isBuiltIn = false

        try coreDataStack.saveContext(coreDataStack.viewContext)
        return format
    }

    // MARK: - Delete

    /// 커스텀 포맷을 삭제한다.
    ///
    /// 빌트인 포맷은 삭제할 수 없다. 시도 시 ``RetrospectError/cannotDeleteBuiltInFormat`` 에러.
    /// - Parameter id: 삭제할 포맷의 식별자
    /// - Throws: ``RetrospectError/notFound`` — 해당 ID의 포맷이 없을 때
    /// - Throws: ``RetrospectError/cannotDeleteBuiltInFormat`` — 빌트인 포맷 삭제 시도 시
    func delete(_ id: UUID) async throws {
        let request = NSFetchRequest<RetrospectFormatEntity>(entityName: "RetrospectFormatEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let response = try coreDataStack.viewContext.fetch(request)

            guard let managed = response.first else {
                throw RetrospectError.formatNotFound
            }

            guard !managed.isBuiltIn else {
                throw RetrospectError.cannotDeleteBuiltInFormat
            }

            coreDataStack.viewContext.delete(managed)
            try coreDataStack.saveContext(coreDataStack.viewContext)
        } catch {
            throw error
        }
    }
}
