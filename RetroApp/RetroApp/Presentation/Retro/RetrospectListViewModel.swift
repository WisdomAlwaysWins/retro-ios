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
    var onError: ((String) -> Void)?

    init(fetchRetrospectListUseCase: FetchRetrospectListUseCaseProtocol) {
        self.fetchRetrospectListUseCase = fetchRetrospectListUseCase
    }

    func fetchRetrospects() {
        Task {
            do {
                retrospects = try await fetchRetrospectListUseCase.execute()
                onRetrospectsFetched?()
            } catch {
                onError?(error.localizedDescription)
            }
        }
    }
}
