//
//  ListViewController.swift
//  MVVM-RxSwift-Demo
//
//  Created by Armand Kaguermanov on 02/05/2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Moya

class ListViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel: ListViewModel
    private let disposeBag = DisposeBag()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    weak var coordinator: ListCoordinator?
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        viewModel.fetchLaunches()
    }
    
    override func loadView() {
        super.loadView()
        setUp()
    }
    
    private func setUp() {
        title = viewModel.navigationTitle
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
        tableView.rowHeight = 80
    }

    private func showDetails(for launch: Launch) {
        coordinator?.showDetails(for: launch)
        
        if let selectedRowIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRowIndexPath, animated: true)
        }
    }
    
    private func showError(_ error: AppError) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

// MARK: - RxSwift Binding
extension ListViewController {
    private func bind() {
        viewModel.launches
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(
                cellIdentifier: TableViewCell.reuseIdentifier,
                cellType: TableViewCell.self)) { _, launch, cell in
                    cell.configure(with: CellViewModel(launch: launch))
                }
                .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(Launch.self)
            .asDriver()
            .drive(onNext: { [weak self] launch in
                self?.showDetails(for: launch)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.prefetchRows
            .asDriver()
            .withLatestFrom(viewModel.launches.asDriver()) { indexPaths, launches in
                guard let maxRow = indexPaths.map({ $0.row }).max() else { return false }
                return maxRow >= launches.count - 1
            }
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                self?.viewModel.fetchLaunches()
            })
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .asDriver()
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .asDriver()
            .map { !$0 }
            .drive(activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.error
            .asDriver()
            .drive(onNext: { [weak self] error in
                if let error = error {
                    self?.showError(error)
                }
            })
            .disposed(by: disposeBag)
    }
}
