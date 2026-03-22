//
//  RetrospectFormatRepositoryProtocol.swift
//  RetroApp
//
//  Created by J on 3/20/26.
//

import Foundation

/// 회고 포맷 데이터 접근을 추상화하는 Repository Protocol.
///
/// 빌트인 포맷(KPT, 4Ls 등) 조회와 커스텀 포맷 CRUD를 담당한다.
protocol RetrospectFormatRepositoryProtocol: Sendable {

    /// 전체 포맷 목록을 조회한다.
    ///
    /// 빌트인 포맷이 먼저, 커스텀 포맷이 뒤에 오도록 정렬한다.
    /// - Returns: 포맷 배열
    func fetchAll() async throws -> [RetrospectFormat]

    /// 특정 포맷을 ID로 조회한다.
    ///
    /// - Parameter id: 조회할 포맷의 식별자
    /// - Returns: 해당 포맷. 없으면 에러
    func fetchById(_ id: UUID) async throws -> RetrospectFormat

    /// 커스텀 포맷을 저장한다.
    ///
    /// `isBuiltIn`은 항상 `false`로 설정된다.
    /// - Parameter format: 저장할 포맷
    /// - Returns: 저장된 포맷
    func save(_ format: RetrospectFormat) async throws -> RetrospectFormat

    /// 커스텀 포맷을 삭제한다.
    ///
    /// 빌트인 포맷은 삭제할 수 없다. 시도 시 에러.
    /// - Parameter id: 삭제할 포맷의 식별자
    func delete(_ id: UUID) async throws
}
