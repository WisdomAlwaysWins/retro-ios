//
//  RetrospectMapper.swift
//  RetroApp
//
//  Created by J on 3/26/26.
//

import CoreData
import Foundation

/// ``Retrospect`` Domain Entity와 Core Data ManagedObject 간 변환을 담당하는 Mapper.
///
/// Data 레이어에서만 사용한다.
/// Domain 레이어는 ManagedObject의 존재를 알지 못한다.
enum RetrospectMapper {

    // MARK: - ManagedObject → Domain Entity

    /// Core Data의 `RetrospectEntity`를 Domain의 ``Retrospect``로 변환한다.
    ///
    /// ManagedObject의 Optional 프로퍼티는 기본값으로 처리한다.
    /// - Parameter managed: 변환할 ManagedObject
    /// - Returns: Domain Entity
    static func toEntity(_ managed: RetrospectEntity) -> Retrospect {
        return Retrospect(
            id: managed.id ?? UUID(),
            title: managed.title,
            formatId: managed.formatId ?? UUID(),
            status: RetrospectStatus(rawValue: managed.status ?? "") ?? .draft,
            isEdited: managed.isEdited,
            type: RetrospectType(rawValue: managed.type ?? "") ?? .personal,
            teamId: managed.teamId ?? UUID(),
            sessionId: managed.sessionId ?? UUID(),
            timerDuration: managed.timerDuration == 0 ? nil : Int(managed.timerDuration),
            createdAt: managed.createdAt ?? Date(),
            confirmedAt: managed.confirmedAt ?? Date())
    }

    // MARK: - Domain Entity → ManagedObject

    /// Domain의 ``Retrospect``를 Core Data의 `RetrospectEntity`로 변환한다.
    ///
    /// 새 ManagedObject를 생성하여 프로퍼티를 채운다.
    /// - Parameters:
    ///   - entity: 변환할 Domain Entity
    ///   - context: ManagedObject를 생성할 Core Data Context
    /// - Returns: 생성된 ManagedObject
    static func toManagedObject(_ entity: Retrospect, context: NSManagedObjectContext) -> RetrospectEntity {
        let managed = RetrospectEntity(context: context)
        managed.id = entity.id
        managed.title = entity.title
        managed.formatId = entity.formatId
        managed.status = entity.status.rawValue
        managed.isEdited = entity.isEdited
        managed.type = entity.type.rawValue
        managed.teamId = entity.teamId
        managed.sessionId = entity.sessionId
        managed.timerDuration = Int32(entity.timerDuration ?? 0)
        managed.createdAt = entity.createdAt
        managed.confirmedAt = entity.confirmedAt
        return managed
    }

    // MARK: - Domain Entity → 기존 ManagedObject 업데이트

    /// 기존 ManagedObject에 Domain Entity의 값을 덮어쓴다.
    ///
    /// 새 ManagedObject를 생성하지 않고 기존 객체를 업데이트할 때 사용한다.
    /// Repository의 `update` 메서드에서 활용된다.
    /// - Parameters:
    ///   - managed: 업데이트할 기존 ManagedObject
    ///   - entity: 새 값을 가진 Domain Entity
    static func update(_ managed: RetrospectEntity, from entity: Retrospect) {
        managed.title = entity.title
        managed.formatId = entity.formatId
        managed.status = entity.status.rawValue
        managed.isEdited = entity.isEdited
        managed.type = entity.type.rawValue
        managed.teamId = entity.teamId
        managed.sessionId = entity.sessionId
        managed.timerDuration = Int32(entity.timerDuration ?? 0)
        managed.createdAt = entity.createdAt
        managed.confirmedAt = entity.confirmedAt
    }
}
