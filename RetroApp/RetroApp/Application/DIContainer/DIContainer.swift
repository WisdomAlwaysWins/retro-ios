//
//  DIContainer.swift
//  RetroApp
//
//  Created by J on 3/30/26.
//

import Foundation

/// 앱 전체의 의존성을 조립하는 컨테이너.
///
/// CoreDataStack → Repository → UseCase 순서로 생성하며,
/// `lazy var`로 필요한 시점에 초기화된다.
final class DIContainer {

    // MARK: - Core Data

    let coreDataStack: CoreDataStack

    // MARK: - Repository

    lazy var retrospectRepository = CoreDataRetrospectRepository(coreDataStack: coreDataStack)
    lazy var retrospectItemRepository = CoreDataRetrospectItemRepository(coreDataStack: coreDataStack)
    lazy var retrospectFormatRepository = CoreDataRetrospectFormatRepository(coreDataStack: coreDataStack)

    // MARK: - Init

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    // MARK: - UseCase

    lazy var createRetrospectUseCase = CreateRetrospectUseCase(
        retrospectRepository: retrospectRepository,
        itemRepository: retrospectItemRepository
    )

    lazy var fetchRetrospectListUseCase = FetchRetrospectListUseCase(
        repository: retrospectRepository
    )

    lazy var fetchRetrospectByDateUseCase = FetchRetrospectByDateUseCase(
        repository: retrospectRepository
    )

    lazy var updateRetrospectUseCase = UpdateRetrospectUseCase(
        retrospectRepository: retrospectRepository,
        itemRepository: retrospectItemRepository
    )

    lazy var deleteRetrospectUseCase = DeleteRetrospectUseCase(
        repository: retrospectRepository
    )

    lazy var confirmRetrospectUseCase = ConfirmRetrospectUseCase(
        retrospectRepository: retrospectRepository,
        itemRepository: retrospectItemRepository
    )

    lazy var fetchUnresolvedTriesUseCase = FetchUnresolvedTriesUseCase(
        repository: retrospectItemRepository
    )

    lazy var fetchRetrospectFormatsUseCase = FetchRetrospectFormatsUseCase(
        repository: retrospectFormatRepository
    )
}
