//
//  FetchRetrospectByDateUseCase.swift
//  RetroApp
//
//  Created by J on 3/26/26.
//

import Foundation

/// 특정 날짜의 회고를 조회하는 UseCase.
///
/// 달력 뷰에서 날짜를 탭했을 때 사용한다.
protocol FetchRetrospectByDateUseCaseProtocol: Sendable {
    func execute(date: Date) async throws -> [Retrospect]
}

final class FetchRetrospectByDateUseCase: FetchRetrospectByDateUseCaseProtocol {

    private let repository: RetrospectRepositoryProtocol

    init(repository: RetrospectRepositoryProtocol) {
        self.repository = repository
    }

    func execute(date: Date) async throws -> [Retrospect] {
        try await repository.fetchByDate(date)
    }
}
