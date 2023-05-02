//
//  CellView.swift
//  MVVM-RxSwift-Demo
//
//  Created by Armand Kaguermanov on 02/05/2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CellView: UIView {
    let image = UIImageView()
    let title = UILabel()
    let subtitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        addSubview(image)
        addSubview(title)
        addSubview(subtitle)
        
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 30
        image.clipsToBounds = true
        
        title.font = UIFont.boldSystemFont(ofSize: 17)
        title.numberOfLines = 0
        
        subtitle.font = UIFont.systemFont(ofSize: 15)
        subtitle.textColor = .gray
        subtitle.numberOfLines = 0
        
        image.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(60)
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(image)
        }
        
        subtitle.snp.makeConstraints { make in
            make.leading.equalTo(title)
            make.trailing.equalTo(title)
            make.top.equalTo(title.snp.bottom).offset(4)
        }
    }
    
    func configure(with viewModel: CellViewModel) {
        title.text = viewModel.title
        subtitle.text = viewModel.subtitle
        
        if let url = URL(string: viewModel.imageUrl) {
            image.kf.setImage(with: url)
        }
    }
    
    func reset() {
        title.text = nil
        subtitle.text = nil
        
        image.kf.cancelDownloadTask()
        image.kf.setImage(with: URL(string: ""))
        image.image = nil
    }
}
