//
//  RetrospectListViewModel.swift
//  RetroApp
//
//  Created by J on 3/30/26.
//

import Foundation

final class RetrospectListViewModel {

    private let fetchRetrospectListUseCase: FetchRetrospectListUseCaseProtocol

    private(set) var retrospects: [Retrospect] = []
    var onRetrospectsFetched: (() -> Void)?

    init(fetchRetrospectListUseCase: FetchRetrospectListUseCaseProtocol) {
        self.fetchRetrospectListUseCase = fetchRetrospectListUseCase
    }

    func fetchRetrospects() {
        Task {
            do {
                retrospects = try await fetchRetrospectListUseCase.execute()
                onRetrospectsFetched?()
            } catch {
                // TODO: 에러 처리 (나중에 추가)
            }
        }
    }
}
