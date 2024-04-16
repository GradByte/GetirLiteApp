//
//  ProductCell.swift
//  GetirLiteApp
//
//  Created by GradByte on 16.04.2024.
//

import UIKit
import Kingfisher

class ProductCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear // Make the background clear
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = GetirColor.almostWhiteGray.cgColor // Gray border color
        return view
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = GetirColor.purple
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
        contentView.addSubview(borderView)
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
        
        let padding: CGFloat = 10
        
        // Calculate the available height for the subviews after adding padding
        // let availableHeight = contentView.bounds.height - padding * 2
        
        // Set the imageView frame to be a square with side length equal to the available width
        let imageViewSize = contentView.bounds.width - 2 * padding
        imageView.frame = CGRect(x: padding, y: padding, width: imageViewSize, height: imageViewSize)
        
        borderView.frame = imageView.frame.insetBy(dx: -1, dy: -1) // Make the borderView frame slightly larger than imageView
        priceLabel.frame = CGRect(x: padding, y: imageView.frame.maxY + padding, width: contentView.bounds.width - 2 * padding, height: 20)
        nameLabel.frame = CGRect(x: padding, y: priceLabel.frame.maxY + padding, width: contentView.bounds.width - 2 * padding, height: 20)
        attributeLabel.frame = CGRect(x: padding, y: nameLabel.frame.maxY + padding, width: contentView.bounds.width - 2 * padding, height: 20)
    }

    
    func configure(with imageURL: URL?, price: String, name: String, attribute: String) {
        if let imageURL = imageURL {
            // Use Kingfisher to load the image asynchronously
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: imageURL)
        } else {
            // Set a placeholder image if imageURL is nil
            imageView.image = UIImage(named: "bag.jpeg")
        }
        
        priceLabel.text = price
        nameLabel.text = name
        attributeLabel.text = attribute
    }
}
