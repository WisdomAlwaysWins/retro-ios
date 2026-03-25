//
//  UpdateRetrospectUseCase.swift
//  RetroApp
//
//  Created by J on 3/26/26.
//

import Foundation

/// 회고를 수정하는 UseCase.
///
/// ## 비즈니스 규칙
/// - 드래프트 상태: 자유롭게 수정 가능
/// - 확정 상태: 수정 가능하지만 `isEdited`가 `true`로 변경됨
/// - 항목이 0개가 되면 수정 불가
protocol UpdateRetrospectUseCaseProtocol: Sendable {
    func execute(
        _ retrospect: Retrospect,
        items: [RetrospectItem]
    ) async throws -> Retrospect
}

final class UpdateRetrospectUseCase: UpdateRetrospectUseCaseProtocol {

    private let retrospectRepository: RetrospectRepositoryProtocol
    private let itemRepository: RetrospectItemRepositoryProtocol

    init(
        retrospectRepository: RetrospectRepositoryProtocol,
        itemRepository: RetrospectItemRepositoryProtocol) {
        self.retrospectRepository = retrospectRepository
        self.itemRepository = itemRepository
    }

    func execute(
        _ retrospect: Retrospect,
        items: [RetrospectItem]
    ) async throws -> Retrospect {
        guard !items.isEmpty else {
            throw RetrospectError.emptyItems
        }

        let updated: Retrospect

        if retrospect.status == .confirmed {
            updated = Retrospect(
                id: retrospect.id,
                title: retrospect.title,
                formatId: retrospect.formatId,
                status: retrospect.status,
                isEdited: true,
                type: retrospect.type,
                teamId: retrospect.teamId,
                sessionId: retrospect.sessionId,
                timerDuration: retrospect.timerDuration,
                createdAt: retrospect.createdAt,
                confirmedAt: retrospect.confirmedAt
            )
        } else {
            updated = Retrospect(
                id: retrospect.id,
                title: retrospect.title,
                formatId: retrospect.formatId,
                status: retrospect.status,
                isEdited: false,
                type: retrospect.type,
                teamId: retrospect.teamId,
                sessionId: retrospect.sessionId,
                timerDuration: retrospect.timerDuration,
                createdAt: retrospect.createdAt,
                confirmedAt: retrospect.confirmedAt
            )
        }

        let savedRetrospect = try await retrospectRepository.update(updated)

        _ = try await itemRepository.saveAll(items)

        return savedRetrospect

    }
}
