//
//  ProductCell.swift
//  GetirLiteApp
//
//  Created by GradByte on 16.04.2024.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let attributeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(attributeLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: contentView.bounds.height * 0.5)
        priceLabel.frame = CGRect(x: 0, y: contentView.bounds.height * 0.5, width: contentView.bounds.width, height: 20)
        nameLabel.frame = CGRect(x: 0, y: contentView.bounds.height * 0.5 + 20, width: contentView.bounds.width, height: 20)
        attributeLabel.frame = CGRect(x: 0, y: contentView.bounds.height * 0.5 + 40, width: contentView.bounds.width, height: 20)
    }
    
    func configure(with image: UIImage?, price: String, name: String, attribute: String) {
        imageView.image = image
        priceLabel.text = price
        nameLabel.text = name
        attributeLabel.text = attribute
    }
}
