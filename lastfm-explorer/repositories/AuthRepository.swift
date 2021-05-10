//
//  LoginRepository.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 09/05/2021.
//

import RxSwift

// Incomplete functionality for now

public protocol AuthRepository: AutoMockable {
    var isLoggedIn: Bool { get }
    func login(username: String, password: String) -> Single<String>
}

public class ConcreteAuthRepository: AuthRepository {
    private let loggedInKey = "user_authenticated"
    public var isLoggedIn: Bool {
        get {
            UserDefaults.standard.bool(forKey: loggedInKey)
        }
        set {
            guard newValue != UserDefaults.standard.bool(forKey: loggedInKey) else { return }
            UserDefaults.standard.set(newValue, forKey: loggedInKey)
        }
    }
    
    private let api: Api
        
    init(api: Api) {
        self.api = api
    }

    public func login(username: String, password: String) -> Single<String> {
        Single.error(ApiError(errorCode: -1, message: "Login unsuccessful"))
            .do(onSuccess: { [weak self] token in
                self?.isLoggedIn = !token.isEmpty
            })
    }
}
