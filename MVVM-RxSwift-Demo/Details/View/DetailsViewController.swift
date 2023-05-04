//
//  DetailsViewController.swift
//  MVVM-RxSwift-Demo
//
//  Created by Armand Kaguermanov on 02/05/2023.
//

import UIKit
import SnapKit
import Kingfisher

class DetailsViewController: UIViewController {
    private let viewModel: DetailsViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionTextView = UITextView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    weak var coordinator: DetailsCoordinator?
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setUp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if isMovingFromParent {
            coordinator?.didFinishDetails()
            // alternate option:
//            coordinator?.parentCoordinator?.childDidFinish(coordinator!)
        }
    }
    
    private func setUp() {
        title = viewModel.navigationTitle
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionTextView)
        imageView.addSubview(activityIndicator)
        
        imageView.contentMode = .scaleAspectFill
        
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        
        descriptionTextView.font = UIFont.systemFont(ofSize: 17)
        descriptionTextView.textColor = .secondaryLabel
        descriptionTextView.isEditable = false
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.backgroundColor = .clear
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func configure() {
        titleLabel.text = viewModel.launch.name
        descriptionTextView.text = viewModel.launch.details ??
        "No description available"
        
        if let imageUrl = viewModel.launch.links?.patch.large,
           let url = URL(string: imageUrl) {
            
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            imageView.kf.setImage(
                with: url,
                placeholder: nil,
                options: nil,
                completionHandler: { [weak self] result in
                    switch result {
                    case .success(_):
                        self?.activityIndicator.stopAnimating()
                        self?.activityIndicator.isHidden = true
                    case .failure(let error):
                        print(error.localizedDescription)
                        self?.activityIndicator.stopAnimating()
                        self?.activityIndicator.isHidden = true
                    }
                })
        }
    }
}
