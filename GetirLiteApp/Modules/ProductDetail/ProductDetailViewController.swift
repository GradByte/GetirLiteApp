//
//  ProductDetailViewController.swift
//  GetirLiteApp
//
//  Created by GradByte on 17.04.2024.
//

import Foundation
import UIKit
import Kingfisher

final class ProductDetailViewController: UIViewController, ProductDetailViewControllerProtocol {
    
    private let presenter: ProductDetailPresenter
    
    init(presenter: ProductDetailPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad(view: self)
        setupNavigationBar()
    }
    
}

extension ProductDetailViewController {
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = GetirColor.purple
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]
        appearance.titleTextAttributes = titleTextAttributes
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        title = "Ürün Detayı"
        

        navigationItem.leftBarButtonItem = createCloseButton()
        if LocalData.shared.totalBill > 0.0 {
            navigationItem.rightBarButtonItem = navbarBasketButton()
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem()
        }
    }
    private func createCloseButton() -> UIBarButtonItem {
        let closeButton = UIButton(type: .custom)
        let xImage = UIImage(named: "x_button")
        closeButton.setImage(xImage, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        // Set the size of the button to match the image size
        closeButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        // Wrap the button in a container view to add padding if needed
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        containerView.addSubview(closeButton)
        
        // Create a UIBarButtonItem with the container view
        let closeBarButtonItem = UIBarButtonItem(customView: containerView)
        return closeBarButtonItem
    }
    
    @objc func closeButtonTapped() {
        self.presenter.routeToProductListing()
    }
    
    private func navbarBasketButton() -> UIBarButtonItem {
        
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
        billLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold) // Reduce font size to fit
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
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.navbarBasketButtonTapped))
        containerView.addGestureRecognizer(gesture)
        
        let customButton = UIBarButtonItem(customView: containerView)
        
        return customButton
    }
    
    // Action for the navbarBasketButton
    @objc private func navbarBasketButtonTapped() {
        self.presenter.routeToShoppingCart()
    }
}
