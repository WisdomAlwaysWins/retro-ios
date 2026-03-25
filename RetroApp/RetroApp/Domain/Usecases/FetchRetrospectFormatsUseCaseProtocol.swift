//
//  FetchRetrospectFormatsUseCaseProtocol.swift
//  RetroApp
//
//  Created by J on 3/26/26.
//

import Foundation

/// 회고 포맷 목록을 조회하는 UseCase.
///
/// 포맷 선택 화면에서 사용한다.
/// 빌트인 포맷이 먼저, 커스텀 포맷이 뒤에 오도록 정렬한다.
protocol FetchRetrospectFormatsUseCaseProtocol: Sendable {
    func execute() async throws -> [RetrospectFormat]
}

final class FetchRetrospectFormatsUseCase: FetchRetrospectFormatsUseCaseProtocol {

    private let repository: RetrospectFormatRepositoryProtocol

    init(repository: RetrospectFormatRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [RetrospectFormat] {
        try await repository.fetchAll()
    }
}
