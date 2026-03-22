//
//  RetrospectItemRepositoryProtocol.swift
//  RetroApp
//
//  Created by J on 3/20/26.
//

import Foundation

/// 회고 항목 데이터 접근을 추상화하는 Repository Protocol.
///
/// ``RetrospectItem``의 CRUD와 Try 이월 관련 조회를 담당한다.
protocol RetrospectItemRepositoryProtocol: Sendable {

    /// 회고 항목을 저장한다.
    ///
    /// - Parameter item: 저장할 항목
    /// - Returns: 저장된 항목
    func save(_ item: RetrospectItem) async throws -> RetrospectItem

    /// 여러 회고 항목을 일괄 저장한다.
    ///
    /// 회고 작성 시 여러 항목을 한번에 저장할 때 사용한다.
    /// - Parameter items: 저장할 항목 배열
    /// - Returns: 저장된 항목 배열
    func saveAll(_ items: [RetrospectItem]) async throws -> [RetrospectItem]

    /// 특정 회고의 항목 목록을 조회한다.
    ///
    /// `order` 기준 오름차순으로 정렬하여 반환한다.
    /// - Parameter retrospectId: 회고 식별자
    /// - Returns: 항목 배열
    func fetchByRetrospectId(_ retrospectId: UUID) async throws -> [RetrospectItem]

    /// 회고 항목을 업데이트한다.
    ///
    /// 내용 수정, 순서 변경, 해결 여부 변경 시 사용한다.
    /// - Parameter item: 업데이트할 항목
    /// - Returns: 업데이트된 항목
    func update(_ item: RetrospectItem) async throws -> RetrospectItem

    /// 회고 항목을 삭제한다.
    ///
    /// - Parameter id: 삭제할 항목의 식별자
    func delete(_ id: UUID) async throws

    /// 미해결 Try 항목 목록을 조회한다.
    ///
    /// 새 회고 작성 시 이월 배너에 표시할 항목을 가져온다.
    /// 조건: `isResolved == false` && 카테고리가 "Try" 계열
    /// - Returns: 미해결 Try 항목 배열
    func fetchUnresolvedTries() async throws -> [RetrospectItem]
}
