//
//  ProductCell.swift
//  GetirLiteApp
//
//  Created by GradByte on 16.04.2024.
//

import UIKit
import Kingfisher

class ProductCell: UICollectionViewCell {
    
    var id = ""
    
    // Closure to handle the plus button tap event
    var plusButtonTappedHandler: (() -> Void)?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let borderView: UIView = {
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
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 3
        button.layer.masksToBounds = false
        
        let plusImage = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        let tintedPlusImage = plusImage?.withTintColor(GetirColor.purple, renderingMode: .alwaysOriginal)
        button.setImage(tintedPlusImage, for: .normal)
        
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)

                
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(borderView)
        contentView.addSubview(imageView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(attributeLabel)
        contentView.addSubview(addButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        borderView.layer.borderColor = GetirColor.almostWhiteGray.cgColor // Reset to default color
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
        addButton.frame = CGRect(x: contentView.bounds.width - padding - 20, y: padding - 12, width: 32, height: 32)
    }
    
    
    func configure(id: String, with imageURL: URL?, price: String, name: String, attribute: String) {
        
        self.id = id
        
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
    
    @objc private func plusButtonTapped() {
        // Change borderView color to purple
        plusButtonTappedHandler?()
        // borderView.layer.borderColor = GetirColor.purple.cgColor
    }
}
