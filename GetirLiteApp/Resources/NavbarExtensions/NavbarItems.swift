//
//  NavbarItems.swift
//  GetirLiteApp
//
//  Created by GradByte on 20.04.2024.
//

import Foundation
import UIKit

class NavbarItems {
    static let shared = NavbarItems()
    
    func navbarBasketButton(detailPagePresenter: ProductDetailPresenterObjCProtocol? = nil, listingPagePresenter: ProductListingPresenterObjCProtocol? = nil) -> UIBarButtonItem {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
        
        let bagView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        bagView.backgroundColor = .white
        
        let imageView = UIImageView(frame: CGRect(x: (bagView.bounds.width - 32) / 2, y: (bagView.bounds.height - 32) / 2, width: 32, height: 32))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "bag1")
        
        bagView.addSubview(imageView)
        containerView.addSubview(bagView)
        
        let billView = UIView(frame: CGRect(x: 36, y: 0, width: 64, height: 36))
        billView.backgroundColor = GetirColor.almostWhiteGray
        
        let billLabel = UILabel(frame: billView.bounds)
        billLabel.textAlignment = .center
        billLabel.textColor = GetirColor.purple
        billLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₺"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        if let formattedAmount = formatter.string(from: NSNumber(value: LocalData.shared.totalBill)) {
            billLabel.text = formattedAmount
        }
        
        billView.addSubview(billLabel)
        containerView.addSubview(billView)
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        
        if let presenter = detailPagePresenter {
            let gesture = UITapGestureRecognizer(target: presenter, action:  #selector(presenter.navbarBasketButtonTapped))
            containerView.addGestureRecognizer(gesture)
        }
        
        if let presenter = listingPagePresenter {
            let gesture = UITapGestureRecognizer(target: presenter, action:  #selector(presenter.navbarBasketButtonTapped))
            containerView.addGestureRecognizer(gesture)
        }
        
        
        let customButton = UIBarButtonItem(customView: containerView)
        return customButton
    }
    
    func createCloseButton(detailPagePresenter: ProductDetailPresenterObjCProtocol? = nil, cartPagePresenter: ShoppingCartPresenterObjCProtocol? = nil) -> UIBarButtonItem {
        let closeButton = UIButton(type: .custom)
        let xImage = UIImage(named: "x_button")
        
        closeButton.setImage(xImage, for: .normal)
        
        if let presenter = detailPagePresenter {
            closeButton.addTarget(presenter, action: #selector(presenter.closeButtonTapped), for: .touchUpInside)
        }
        
        if let presenter = cartPagePresenter {
            closeButton.addTarget(presenter, action: #selector(presenter.closeButtonTapped), for: .touchUpInside)
        }
        
        closeButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        containerView.addSubview(closeButton)
        
        let closeBarButtonItem = UIBarButtonItem(customView: containerView)
        return closeBarButtonItem
    }
    
    func createDeleteButton(cartPagePresenter: ShoppingCartPresenterObjCProtocol? = nil) -> UIBarButtonItem {
        let deleteButton = UIButton(type: .custom)
        let trashImage = UIImage(named: "trash")
        deleteButton.setImage(trashImage, for: .normal)
        
        if let presenter = cartPagePresenter {
            deleteButton.addTarget(presenter, action: #selector(presenter.deleteButtonTapped), for: .touchUpInside)
        }
        
        deleteButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        containerView.addSubview(deleteButton)
        
        let deleteBarButtonItem = UIBarButtonItem(customView: containerView)
        return deleteBarButtonItem
    }
}
