//
//  RetrospectItemMapper.swift
//  RetroApp
//
//  Created by J on 3/29/26.
//

import CoreData
import Foundation

/// ``RetrospectItem`` Domain Entity와 Core Data ManagedObject 간 변환을 담당하는 Mapper.
enum RetrospectItemMapper {

    // MARK: - ManagedObject → Domain Entity

    static func toEntity(_ managed: RetrospectItemEntity) -> RetrospectItem {
        RetrospectItem(
            id: managed.id ?? UUID(),
            retrospectId: managed.retrospectId ?? UUID(),
            categoryName: managed.categoryName ?? "",
            content: managed.content ?? "",
            linkedTryId: managed.linkedTryId,
            isResolved: managed.isResolved,
            order: Int(managed.order)
        )
    }

    // MARK: - Domain Entity → ManagedObject

    static func toManagedObject(
        _ entity: RetrospectItem,
        retrospect: RetrospectEntity,
        context: NSManagedObjectContext,
    ) -> RetrospectItemEntity {
        let managed = RetrospectItemEntity(context: context)

        managed.id = entity.id
        managed.retrospectId = retrospect.id
        managed.retrospect = retrospect
        managed.categoryName = entity.categoryName
        managed.content = entity.content
        managed.linkedTryId = entity.linkedTryId
        managed.isResolved = entity.isResolved
        managed.order = Int32(entity.order)
        return managed
    }

    // MARK: - Domain Entity → 기존 ManagedObject 업데이트

    static func update(_ managed: RetrospectItemEntity, from entity: RetrospectItem) {
        managed.retrospectId = entity.retrospectId
        managed.categoryName = entity.categoryName
        managed.content = entity.content
        managed.linkedTryId = entity.linkedTryId
        managed.isResolved = entity.isResolved
        managed.order = Int32(entity.order)
    }
}
