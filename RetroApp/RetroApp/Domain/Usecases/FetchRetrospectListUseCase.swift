//
//  FetchRetrospectListUseCase.swift
//  RetroApp
//
//  Created by J on 3/23/26.
//

import Foundation

/// 전체 회고 목록을 조회하는 UseCase.
///
/// 최신순으로 정렬된 회고 배열을 반환한다.
/// 리스트 뷰에서 사용한다.
protocol FetchRetrospectListUseCaseProtocol: Sendable {
    func execute() async throws -> [Retrospect]
}

final class FetchRetrospectListUseCase: FetchRetrospectListUseCaseProtocol {

    private let repository: RetrospectRepositoryProtocol

    init(repository: RetrospectRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Retrospect] {
        try await repository.fetchAll()
    }
}
