//
//  RetrospectListViewController.swift
//  RetroApp
//
//  Created by J on 3/30/26.
//

import Foundation
import UIKit

/// 회고 목록을 표시하는 ViewController.
///
/// ``RetrospectListViewModel``에서 데이터를 가져와 UITableView에 표시한다.
/// ViewModel의 closure 바인딩으로 데이터 변경 시 테이블뷰를 갱신한다.
final class RetrospectListViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: RetrospectListViewModel

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: Init

    init(viewModel: RetrospectListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "내 회고"

        setupTableView()
        bindViewModel()
        viewModel.fetchRetrospects()
    }

    // MARK: - Setup

    private func setupTableView() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RetrospectCell")
    }

    // MARK: - Binding

    /// ViewModel의 데이터 변경을 감지하여 UI를 갱신한다.
    private func bindViewModel() {
        viewModel.onRetrospectsFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        viewModel.onError = { message in
            // TODO: Alert으로 교체 예정
        }
    }

    // MARK: - Formatter

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 회고"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()

    private func formatDate(_ date: Date) -> String {
        Self.dateFormatter.string(from: date)
    }
}

// MARK: - UITableViewDataSource

extension RetrospectListViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.retrospects.count
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "RetrospectCell")
        let retrospect = viewModel.retrospects[indexPath.row]

        cell.textLabel?.text = retrospect.title ?? formatDate(retrospect.createdAt)
        cell.detailTextLabel?.text = retrospect.status.rawValue

        return cell
    }
}
