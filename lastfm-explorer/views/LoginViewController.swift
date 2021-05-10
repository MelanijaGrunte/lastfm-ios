//
//  LoginViewController.swift
//  lastfm-explorer
//
//  Created by Melānija Grunte on 09/05/2021.
//

import Anchorage
import RxSwift
import RxGesture

public class LoginViewController: BaseViewController {
    static func instantiate(viewModel: LoginViewModelType) -> LoginViewController {
        let vc = LoginViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    public var viewModel: LoginViewModelType!
        
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.darkerBackground
        return view
    }()
    
    private let usernameInput: UITextField = {
        let field = UITextField()
        field.placeholder = "Username/E-mail"
        field.tintColor = Colors.text
        field.textColor = Colors.text
        field.backgroundColor = Colors.background
        return field
    }()
    
    private let passwordInput: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.tintColor = Colors.text
        field.textColor = Colors.text
        field.backgroundColor = Colors.background
        field.isSecureTextEntry = true
        return field
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Confirm", for: .normal)
        button.backgroundColor = Colors.background
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = Colors.background
        return button
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutViews()
        bindBehavior()
        bindViewModel()
    }
    
    private func layoutViews() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        view.addSubview(container) {
            $0.widthAnchor == $1.widthAnchor / 1.2
            $0.centerAnchors == $1.centerAnchors
        }
        
        container.addSubview(usernameInput) {
            $0.topAnchor == $1.topAnchor + 30
            $0.centerXAnchor == $1.centerXAnchor
            $0.widthAnchor == $1.widthAnchor - 44
            $0.heightAnchor == 30
        }
        
        container.addSubview(passwordInput) {
            $0.topAnchor == usernameInput.bottomAnchor + 10
            $0.horizontalAnchors == usernameInput.horizontalAnchors
            $0.heightAnchor == usernameInput.heightAnchor
        }
        
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        
        container.addSubview(stackView) {
            $0.topAnchor == passwordInput.bottomAnchor + 10
            $0.bottomAnchor == $1.bottomAnchor - 30
            $0.horizontalAnchors == usernameInput.horizontalAnchors
            $0.heightAnchor == 40
        }
        
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(confirmButton)
    }
    
    private func bindBehavior() {
        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: {})
            }, onError: justPrintError)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let emailInput = self.usernameInput.text ?? ""
                let passwordInput = self.passwordInput.text ?? ""
                self.viewModel.inputs.didTapLogin(username: emailInput, password: passwordInput)
            }, onError: justPrintError)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel.outputs.loginSuccessful
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: {})
            }, onError: justPrintError)
            .disposed(by: disposeBag)
    }
}
