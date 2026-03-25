//
//  ConfirmRetrospectUseCase.swift
//  RetroApp
//
//  Created by J on 3/26/26.
//

import Foundation

/// 회고를 확정(제출)하는 UseCase.
///
/// ## 비즈니스 규칙
/// - 드래프트 상태에서만 확정 가능
/// - 이미 확정된 회고를 다시 확정하면 에러
/// - 확정 시 `status`가 `.confirmed`, `confirmedAt`에 현재 시각 기록
/// - 항목이 0개면 확정 불가
protocol ConfirmRetrospectUseCaseProtocol: Sendable {
    func execute(id: UUID) async throws -> Retrospect
}

final class ConfirmRetrospectUseCase: ConfirmRetrospectUseCaseProtocol {

    private let retrospectRepository: RetrospectRepositoryProtocol
    private let itemRepository: RetrospectItemRepositoryProtocol

    init(
        retrospectRepository: RetrospectRepositoryProtocol,
        itemRepository: RetrospectItemRepositoryProtocol
    ) {
        self.retrospectRepository = retrospectRepository
        self.itemRepository = itemRepository
    }

    func execute(id: UUID) async throws -> Retrospect {
        let retrospect = try await retrospectRepository.fetchById(id)

        guard retrospect.status == .draft else {
            throw RetrospectError.alreadyConfirmed
        }

        let items = try await itemRepository.fetchByRetrospectId(id)

        guard !items.isEmpty else {
            throw RetrospectError.emptyItems
        }

        let confirmed = Retrospect(
            id: retrospect.id,
            title: retrospect.title,
            formatId: retrospect.formatId,
            status: .confirmed,
            isEdited: false,
            type: retrospect.type,
            teamId: retrospect.teamId,
            sessionId: retrospect.sessionId,
            timerDuration: retrospect.timerDuration,
            createdAt: retrospect.createdAt,
            confirmedAt: Date()
        )

        return try await retrospectRepository.update(confirmed)
    }
}
