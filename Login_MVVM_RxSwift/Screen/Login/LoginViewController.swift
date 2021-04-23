//
//  LoginViewController.swift
//  Login_MVVM_RxSwift
//
//  Created by Mac on 22/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController, BaseViewControllerProtocol {
    
    // outlet element xib
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    
    // init view model
    private(set) var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = LoginViewModel()
        setupViewController()
    }

    // setup ui
    func setupUI() {
        btnLogin.isEnabled = false
        btnLogin.alpha = 0.5
    }
    
    // setup MVVM
    func bindViewModel() {
        bindModelChange()
        bindEnableSave()
        bindTextField()
        bindButton()
    }
    
}

// MARK: bind data MVVM
extension LoginViewController {
    
    // handle model change
    func bindModelChange() {
        viewModel.modelChange.asObservable()
            .subscribe(onNext: { [unowned self] type in
                switch type {
                case .loaderStart:
                    showLoading()
                    break
                case .loaderEnd:
                    hideLoading()
                    break
                case .updateDataModel(let data):
                    if let data = data as? AccountData {
                        pushToHomeViewController(data)
                    }
                    break
                case .error(let message):
                    showAlert(message: message)
                    break
                default:
                    break
                }
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    // handle enable button save
    func bindEnableSave() {
        viewModel.enableLogin.asObservable()
            .subscribe(onNext: { [unowned self] enable in
                btnLogin.isEnabled = enable
                btnLogin.alpha = enable ? 1 : 0.5
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    // handle text field
    func bindTextField() {
        tfUserName.rx.controlEvent(.editingChanged)
            .asDriver()
            .drive(onNext: { [unowned self] in
                viewModel.handleEnableSave(userName: tfUserName.text!, password: tfPassword.text!)
            })
            .disposed(by: viewModel.disposeBag)
            
        tfPassword.rx.controlEvent(.editingChanged)
            .asDriver()
            .drive(onNext: { [unowned self] in
                viewModel.handleEnableSave(userName: tfUserName.text!, password: tfPassword.text!)
            })
            .disposed(by: viewModel.disposeBag)
    }

    // handle button
    func bindButton() {
        btnLogin.rx.controlEvent(.touchUpInside)
            .asDriver()
            .drive(onNext: { [unowned self] in
                viewModel.handleLogin(userName: tfUserName.text!, password: tfPassword.text!)
            })
            .disposed(by: viewModel.disposeBag)
        
        btnRegister.rx.controlEvent(.touchUpInside)
            .asDriver()
            .drive(onNext: { [unowned self] in
                pushToRegisterViewController()
            })
            .disposed(by: viewModel.disposeBag)
    }
}

// MARK: handle push view controller
extension LoginViewController {
    func pushToRegisterViewController() {
        let vc = RegisterViewController()
        pushToViewController(vc)
    }
    
    func pushToHomeViewController(_ data: AccountData) {
        let vc = HomeViewController(data)
        pushToViewController(vc)
    }
}
