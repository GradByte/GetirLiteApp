//
//  SplashInteractor.swift
//  GetirLiteApp
//
//  Created by GradByte on 11.04.2024.
//

import Foundation


final class SplashInteractor {
    var output: SplashInteractorOutputProtocol?
}

extension SplashInteractor: SplashInteractorProtocol {
    
    func checkInternetConnection() {
        let internetStatus = true // Check the internet status if needed. But there is an internet connection in this case :)
        self.output?.internetConnection(status: internetStatus)
    }
    
}
