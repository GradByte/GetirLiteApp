//
//  SplashInteractor.swift
//  GetirLiteApp
//
//  Created by GradByte on 11.04.2024.
//

import Foundation

protocol SplashInteractorProtocol: AnyObject {
    func checkInternetConnection()
}

protocol SplashInteractorOutputProtocol: AnyObject {
    func internetConnection(status: Bool)
}

final class SplashInteractor {
    var output: SplashInteractorOutputProtocol?
}

extension SplashInteractor: SplashInteractorProtocol {
    
    func checkInternetConnection() {
        let internetStatus = true // Check the internet status if needed.
        self.output?.internetConnection(status: internetStatus)
    }
    
}
