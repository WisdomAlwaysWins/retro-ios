//
//  CreateRetrospectUseCaseProtocol.swift
//  RetroApp
//
//  Created by J on 3/23/26.
//

import Foundation

/// 새 회고를 생성하는 UseCase.
///
/// 회고 제목(선택), 포맷, 항목을 받아 드래프트 상태의 회고를 생성한다.
///
/// ## 비즈니스 규칙
/// - 항목이 최소 1개 이상이어야 생성 가능
/// - 생성 시 `status`는 항상 `.draft`
/// - `id`와 `createdAt`은 자동 할당
///
/// ## 사용 예시
/// ```swift
/// let retro = try await createRetrospectUseCase.execute(
///     title: "Sprint 4 회고",
///     formatId: kptFormatId,
///     items: [keepItem, problemItem, tryItem]
/// )
/// ```
protocol CreateRetrospectUseCaseProtocol: Sendable {
    func execute(
        title: String?,
        formatId: UUID,
        items: [RetrospectItem],
        timerDuration: Int?
    ) async throws -> Retrospect
}

final class CreateRetrospectUseCase: CreateRetrospectUseCaseProtocol {

    private let retrospectRepository: RetrospectRepositoryProtocol
    private let itemRepository: RetrospectItemRepositoryProtocol

    init(
        retrospectRepository: RetrospectRepositoryProtocol,
        itemRepository: RetrospectItemRepositoryProtocol
    ) {
        self.retrospectRepository = retrospectRepository
        self.itemRepository = itemRepository
    }

    func execute(
        title: String?,
        formatId: UUID,
        items: [RetrospectItem],
        timerDuration: Int?
    ) async throws -> Retrospect {
        guard !items.isEmpty else {
            throw RetrospectError.emptyItems
        }

        let retrospect = Retrospect(
            id: UUID(),
            title: title,
            formatId: formatId,
            status: .draft,
            isEdited: false,
            type: .personal,
            teamId: nil,
            sessionId: nil,
            timerDuration: timerDuration,
            createdAt: Date(),
            confirmedAt: nil
        )

        let savedRetrospect = try await retrospectRepository.save(retrospect)

        let itemsWithRetrospectId = items.map { item in
            RetrospectItem(
                id: item.id,
                retrospectId: savedRetrospect.id,
                categoryName: item.categoryName,
                content: item.content,
                linkedTryId: item.linkedTryId,
                isResolved: item.isResolved,
                order: item.order
            )
        }

        _ = try await itemRepository.saveAll(itemsWithRetrospectId)

        return savedRetrospect
    }
}
