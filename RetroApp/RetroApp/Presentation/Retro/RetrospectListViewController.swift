//
//  RetrospectListViewController.swift
//  RetroApp
//
//  Created by J on 3/30/26.
//

import Foundation
import UIKit

final class RetrospectListViewController: UIViewController {
    private let viewModel: RetrospectListViewModel

    init(viewModel: RetrospectListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel.fetchRetrospects()
    }
}
