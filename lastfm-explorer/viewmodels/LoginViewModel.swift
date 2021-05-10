//
//  LoginViewModel.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 09/05/2021.
//

import RxSwift

// Incomplete functionality for now

public protocol LoginViewModelInputs {
    func didTapLogin(username: String, password: String)
}

public protocol LoginViewModelOutputs {
    var loginSuccessful: ReplaySubject<Bool> { get }
}

public protocol LoginViewModelType {
    var inputs: LoginViewModelInputs { get }
    var outputs: LoginViewModelOutputs { get }
}

public final class LoginViewModel: LoginViewModelType, LoginViewModelInputs, LoginViewModelOutputs {
    private let authRepository: AuthRepository
    private let disposeBag = DisposeBag()
    
    private var didTapLoginProperty = PublishSubject<(username: String, password: String)>()
    public func didTapLogin(username: String, password: String) {
        didTapLoginProperty.onNext((username, password))
    }

    public let loginSuccessful = ReplaySubject<Bool>.create(bufferSize: 1)
        
    public var inputs: LoginViewModelInputs {
        return self
    }
    
    public var outputs: LoginViewModelOutputs {
        return self
    }
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
        
        let loginObservable = didTapLoginProperty
            .flatMap { (username, password) in
                authRepository.login(username: username, password: password)
            }
            .asObservable()
            .share()
        
        loginObservable
            .map { !$0.isEmpty }
            .subscribe(loginSuccessful)
            .disposed(by: disposeBag)
    }
}
