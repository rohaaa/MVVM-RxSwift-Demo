//
//  TableViewCell.swift
//  MVVM-RxSwift-Demo
//
//  Created by Armand Kaguermanov on 02/05/2023.
//

import UIKit
import Kingfisher

class TableViewCell: UITableViewCell {
    static let reuseIdentifier = "TableViewCell"
    
    private let cellView = CellView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        contentView.addSubview(cellView)
        
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with viewModel: CellViewModel) {
        cellView.configure(with: viewModel)
    }
}

extension TableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        cellView.title.text = nil
        cellView.subtitle.text = nil
        cellView.image.image = nil
    }
}
