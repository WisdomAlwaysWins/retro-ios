//
//  RetrospectRepositoryProtocol.swift
//  RetroApp
//
//  Created by J on 3/20/26.
//

import Foundation

/// 회고 데이터 접근을 추상화하는 Repository Protocol.
///
/// Domain 레이어에서 정의하며, Data 레이어에서 구현체를 제공한다.
/// UseCase는 이 Protocol에만 의존하고, 실제 저장소(Core Data, API 등)는 알지 못한다.
///
/// ## 구현체 예시
/// - `CoreDataRetrospectRepository`: 로컬 Core Data 저장소
/// - `RemoteRetrospectRepository`: 서버 API
protocol RetrospectRepositoryProtocol {

    /// 새 회고를 저장한다.
    ///
    /// 드래프트 상태로 생성되며, `id`와 `createdAt`이 UseCase에서 할당된 상태로 전달된다.
    /// - Parameter retrospect: 저장할 회고
    /// - Returns: 저장된 회고
    func save(_ retrospect: Retrospect) async throws -> Retrospect

    /// 전체 회고 목록을 조회한다.
    ///
    /// 최신순(createdAt 내림차순)으로 정렬하여 반환한다.
    /// - Returns: 회고 배열
    func fetchAll() async throws -> [Retrospect]

    /// 특정 회고를 ID로 조회한다.
    ///
    /// - Parameter id: 조회할 회고의 식별자
    /// - Returns: 해당 회고. 없으면 에러
    func fetchById(_ id: UUID) async throws -> Retrospect

    /// 특정 날짜의 회고 목록을 조회한다.
    ///
    /// 달력 뷰에서 날짜를 탭했을 때 사용한다.
    /// - Parameter date: 조회할 날짜 (시간 무시, 날짜만 비교)
    /// - Returns: 해당 날짜의 회고 배열
    func fetchByDate(_ date: Date) async throws -> [Retrospect]

    /// 회고를 업데이트한다.
    ///
    /// 확정 상태에서 수정 시 `isEdited`가 `true`로 변경된다.
    /// - Parameter retrospect: 업데이트할 회고
    /// - Returns: 업데이트된 회고
    func update(_ retrospect: Retrospect) async throws -> Retrospect

    /// 회고를 삭제한다.
    ///
    /// 연관된 ``RetrospectItem``도 함께 삭제된다 (cascade).
    /// - Parameter id: 삭제할 회고의 식별자
    func delete(_ id: UUID) async throws

    /// 회고가 존재하는 날짜 목록을 조회한다.
    ///
    /// 달력 뷰에서 점을 표시하기 위해 사용한다.
    /// - Parameter month: 조회할 월 (해당 월의 아무 날짜)
    /// - Returns: 회고가 있는 날짜 배열
    func fetchDatesWithRetrospect(in month: Date) async throws -> [Date]
}
