//
//  BackgroundDecorationView.swift
//  GetirLiteApp
//
//  Created by GradByte on 19.04.2024.
//

import UIKit

class BackgroundDecorationView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white // Set the desired background color here
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
