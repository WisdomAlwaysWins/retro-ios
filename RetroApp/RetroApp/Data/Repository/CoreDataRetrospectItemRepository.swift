//
//  CoreDataRetrospectItemRepository.swift
//  RetroApp
//
//  Created by J on 3/30/26.
//

import CoreData
import Foundation

/// ``RetrospectItemRepositoryProtocol``의 Core Data 구현체.
///
/// Domain 레이어의 ``RetrospectItem`` Entity를 Core Data로 저장/조회/수정/삭제한다.
/// ``RetrospectItemMapper``를 통해 ManagedObject와 Domain Entity 간 변환을 수행한다.
final class CoreDataRetrospectItemRepository: RetrospectItemRepositoryProtocol {

    // MARK: - Properties

    private let coreDataStack: CoreDataStack

    // MARK: - Init

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    // MARK: - Create

    /// 회고 항목을 Core Data에 저장한다.
    ///
    /// - Parameter item: 저장할 항목
    /// - Returns: 저장된 항목
    func save(_ item: RetrospectItem) async throws -> RetrospectItem {
        _ = RetrospectItemMapper.toManagedObject(item, context: coreDataStack.viewContext)
        try coreDataStack.saveContext(coreDataStack.viewContext)
        return item
    }

    /// 여러 회고 항목을 일괄 저장한다.
    ///
    /// 모든 항목을 context에 추가한 뒤 `save()`를 한 번만 호출하여
    /// 트랜잭션 효율을 높인다.
    /// - Parameter items: 저장할 항목 배열
    /// - Returns: 저장된 항목 배열
    func saveAll(_ items: [RetrospectItem]) async throws -> [RetrospectItem] {
        for item in items {
            _ = RetrospectItemMapper.toManagedObject(item, context: coreDataStack.viewContext)
        }

        try coreDataStack.saveContext(coreDataStack.viewContext)
        return items
    }

    // MARK: - Read

    /// 특정 회고의 항목 목록을 조회한다.
    ///
    /// `order` 오름차순으로 정렬하여 반환한다.
    /// - Parameter retrospectId: 회고 식별자
    /// - Returns: 항목 배열
    func fetchByRetrospectId(_ retrospectId: UUID) async throws -> [RetrospectItem] {
        let request = NSFetchRequest<RetrospectItemEntity>(entityName: "RetrospectItemEntity")
        request.predicate = NSPredicate(format: "retrospectId == %@", retrospectId as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]

        do {
            let response = try coreDataStack.viewContext.fetch(request)
            return response.map { RetrospectItemMapper.toEntity($0) }
        } catch {
            throw error
        }
    }

    /// 미해결 Try 항목 목록을 조회한다.
    ///
    /// 새 회고 작성 시 이월 배너에 표시할 항목을 가져온다.
    /// 조건: `isResolved == false`
    /// - Returns: 미해결 Try 항목 배열
    func fetchUnresolvedTries() async throws -> [RetrospectItem] {
        let request = NSFetchRequest<RetrospectItemEntity>(entityName: "RetrospectItemEntity")
        request.predicate = NSPredicate(format: "isResolved == NO")

        do {
            let response = try coreDataStack.viewContext.fetch(request)
            return response.map { RetrospectItemMapper.toEntity($0) }
        } catch {
            throw error
        }
    }

    // MARK: - Update

    /// 회고 항목을 업데이트한다.
    ///
    /// ID로 기존 ManagedObject를 찾아 ``RetrospectItemMapper``로 값을 덮어쓴다.
    /// - Parameter item: 업데이트할 항목
    /// - Returns: 업데이트된 항목
    /// - Throws: ``RetrospectError/itemNotFound`` — 해당 ID의 항목이 없을 때
    func update(_ item: RetrospectItem) async throws -> RetrospectItem {
        let request = NSFetchRequest<RetrospectItemEntity>(entityName: "RetrospectItemEntity")
        request.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)

        do {
            let response = try coreDataStack.viewContext.fetch(request)

            guard let managed = response.first else {
                throw RetrospectError.itemNotFound
            }

            RetrospectItemMapper.update(managed, from: item)
            try coreDataStack.saveContext(coreDataStack.viewContext)

            return item
        } catch {
            throw error
        }
    }

    // MARK: - Delete

    /// 회고 항목을 삭제한다.
    ///
    /// - Parameter id: 삭제할 항목의 식별자
    /// - Throws: ``RetrospectError/itemNotFound`` — 해당 ID의 항목이 없을 때
    func delete(_ id: UUID) async throws {
        let request = NSFetchRequest<RetrospectItemEntity>(entityName: "RetrospectItemEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let response = try coreDataStack.viewContext.fetch(request)

            guard let managed = response.first else {
                throw RetrospectError.itemNotFound
            }

            coreDataStack.viewContext.delete(managed)
            try coreDataStack.saveContext(coreDataStack.viewContext)
        } catch {
            throw error
        }
    }
}
