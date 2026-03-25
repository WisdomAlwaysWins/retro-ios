//
//  FetchUnresolvedTriesUseCase.swift
//  RetroApp
//
//  Created by J on 3/26/26.
//

import Foundation

/// 미해결 Try 항목을 조회하는 UseCase.
///
/// 새 회고 작성 시 이월 배너에 표시할 미해결 Try 목록을 가져온다.
/// "해결됨" 또는 "이월" 선택의 기반 데이터가 된다.
protocol FetchUnresolvedTriesUseCaseProtocol: Sendable {
    func execute() async throws -> [RetrospectItem]
}

final class FetchUnresolvedTriesUseCase: FetchUnresolvedTriesUseCaseProtocol {

    private let repository: RetrospectItemRepositoryProtocol

    init(repository: RetrospectItemRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [RetrospectItem] {
        try await repository.fetchUnresolvedTries()
    }
}
