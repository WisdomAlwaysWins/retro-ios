//
//  DeleteRetrospectUseCase.swift
//  RetroApp
//
//  Created by J on 3/26/26.
//

import Foundation

/// 회고를 삭제하는 UseCase.
///
/// ## 비즈니스 규칙
/// - 드래프트/확정 모두 삭제 가능
/// - 연관된 ``RetrospectItem``도 함께 삭제됨 (Repository에서 cascade 처리)
protocol DeleteRetrospectUseCaseProtocol: Sendable {
    func execute(id: UUID) async throws
}

final class DeleteRetrospectUseCase: DeleteRetrospectUseCaseProtocol {

    private let repository: RetrospectRepositoryProtocol

    init(repository: RetrospectRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: UUID) async throws {
        try await repository.delete(id)
    }
}
