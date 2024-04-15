//
//  SplashProtocols.swift
//  GetirLiteApp
//
//  Created by GradByte on 15.04.2024.
//

import Foundation

protocol SplashViewControllerProtocol: AnyObject {
    func noInternetConnection()
}

protocol SplashPresenterProtocol: AnyObject {
    func viewDidAppear()
}

protocol SplashInteractorProtocol: AnyObject {
    func checkInternetConnection()
}

protocol SplashInteractorOutputProtocol: AnyObject {
    func internetConnection(status: Bool)
}

protocol SplashRouterProtocol {
    func navigate(_ route: SplashRoutes)
}
