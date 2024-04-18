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
    
    // Closure to handle the minus button tap event
    var minusButtonTappedHandler: (() -> Void)?
    
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
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = GetirColor.purple
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private let attributeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
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
    
    // Add a label below the plus button
    var quantityLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = GetirColor.purple
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 3
        button.layer.masksToBounds = false
        
        let minusImage = UIImage(systemName: "minus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        let tintedMinusImage = minusImage?.withTintColor(GetirColor.purple, renderingMode: .alwaysOriginal)
        button.setImage(tintedMinusImage, for: .normal)
        
        button.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        
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
        contentView.addSubview(quantityLabel)
        contentView.addSubview(minusButton)
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
        nameLabel.frame = CGRect(x: padding, y: priceLabel.frame.maxY, width: contentView.bounds.width - 2 * padding, height: 20)
        attributeLabel.frame = CGRect(x: padding, y: nameLabel.frame.maxY, width: contentView.bounds.width - 2 * padding, height: 20)
        addButton.frame = CGRect(x: contentView.bounds.width - padding - 20, y: padding - 12, width: 32, height: 32)
        // Position the quantity label below the plus button
        quantityLabel.frame = CGRect(x: contentView.bounds.width - padding - 20, y: addButton.frame.maxY, width: 32, height: 32)
        // Position the minus button next to the quantity label
        minusButton.frame = CGRect(x: contentView.bounds.width - padding - 20, y: quantityLabel.frame.maxY, width: 32, height: 32)
    }
    
    
    func configure(id: String, with imageURL: URL?, price: String, name: String, attribute: String, numberOfAdded: Int?) {
        
        self.id = id
        
        if let imageURL = imageURL {
            // Use Kingfisher to load the image asynchronously
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: imageURL)
        } else {
            // Set a placeholder image if imageURL is nil
            imageView.image = UIImage(named: "bag.jpeg")
        }
        
        
        var formattedPrice: String? {
            guard let priceDouble = Double(price) else { return nil }
                
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = "₺"
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
                
            return formatter.string(from: NSNumber(value: priceDouble))
        }
        
        priceLabel.text = formattedPrice ?? "₺0.00"
        nameLabel.text = name.trimmingCharacters(in: .whitespacesAndNewlines)
        attributeLabel.text = attribute.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        if let numberOfAdded = numberOfAdded {
            // Set the text of the quantity label
            quantityLabel.isHidden = numberOfAdded <= 0
            quantityLabel.text = "\(numberOfAdded)"
            
            // Toggle the visibility of the minus button based on the quantity
            minusButton.isHidden = numberOfAdded <= 0
            
            if minusButton.isHidden == false {
                addButton.layer.cornerRadius = 10
                addButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                
                minusButton.layer.cornerRadius = 10
                minusButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            } else {
                addButton.layer.cornerRadius = 10
                addButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            }
            
            if numberOfAdded == 1 {
                let trashImage = UIImage(named: "purpleTrash")
                let tintedTrashImage = trashImage?.withTintColor(GetirColor.purple, renderingMode: .alwaysOriginal)
                minusButton.setImage(tintedTrashImage, for: .normal)
            } else {
                let minusImage = UIImage(systemName: "minus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
                let tintedMinusImage = minusImage?.withTintColor(GetirColor.purple, renderingMode: .alwaysOriginal)
                minusButton.setImage(tintedMinusImage, for: .normal)
            }
        }
        
    }
    
    @objc private func plusButtonTapped() {
        // Change borderView color to purple
        plusButtonTappedHandler?()
    }
    
    @objc private func minusButtonTapped() {
        // Call the minus button tapped handler
        minusButtonTappedHandler?()
    }
}
