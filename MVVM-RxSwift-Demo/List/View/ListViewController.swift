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
    private let viewModel = ListViewModel()
    private let disposeBag = DisposeBag()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                
                if let selectedRowIndexPath = self?.tableView.indexPathForSelectedRow {
                    self?.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
//        tableView.rx
//            .itemSelected
//            .bind { [weak self] indexPath in
//
//            }
//            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .asDriver()
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.isLoading
            .asDriver()
            .map { !$0 }
            .drive(activityIndicator.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func showDetails(for launch: Launch) {
        let viewModel = DetailsViewModel(launch: launch)
        let viewController = DetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
