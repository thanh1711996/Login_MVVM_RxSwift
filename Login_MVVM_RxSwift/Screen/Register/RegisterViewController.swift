//
//  RegisterViewController.swift
//  Login_MVVM_RxSwift
//
//  Created by Mac on 22/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: BaseViewController, BaseViewControllerProtocol {

    // outlet element xib
    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    // init view model
    private(set) var viewModel: RegisterViewModel!
    
    var accountData: AccountData {
        return AccountData(fullName: tfFullName.text!.trim(), phone: tfPhone.text!.trim(), email: tfEmail.text!.trim(), password: tfPassword.text!.trim())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = RegisterViewModel()
        setupViewController()
    }

    // setup ui
    func setupUI() {
        btnRegister.isEnabled = false
        btnRegister.alpha = 0.5
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
extension RegisterViewController {
    
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
                case .updateDataModel:
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
        viewModel.enableRegister.asObservable()
            .subscribe(onNext: { [unowned self] enable in
                btnRegister.isEnabled = enable
                btnRegister.alpha = enable ? 1 : 0.5
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    // handle text field
    func bindTextField() {
        tfFullName.rx.controlEvent(.editingChanged)
            .asDriver()
            .drive(onNext: { [unowned self] in
                viewModel.handleEnableSave(data: accountData)
            })
            .disposed(by: viewModel.disposeBag)
        
        tfPhone.rx.controlEvent(.editingChanged)
            .asDriver()
            .drive(onNext: { [unowned self] in
                viewModel.handleEnableSave(data: accountData)
            })
            .disposed(by: viewModel.disposeBag)
        
        tfEmail.rx.controlEvent(.editingChanged)
            .asDriver()
            .drive(onNext: { [unowned self] in
                viewModel.handleEnableSave(data: accountData)
            })
            .disposed(by: viewModel.disposeBag)
            
        tfPassword.rx.controlEvent(.editingChanged)
            .asDriver()
            .drive(onNext: { [unowned self] in
                viewModel.handleEnableSave(data: accountData)
            })
            .disposed(by: viewModel.disposeBag)
    }

    // handle button
    func bindButton() {
        btnRegister.rx.controlEvent(.touchUpInside)
            .asDriver()
            .drive(onNext: { [unowned self] in
                viewModel.handleRegister(data: accountData)
            })
            .disposed(by: viewModel.disposeBag)
        
        btnBack.rx.controlEvent(.touchUpInside)
            .asDriver()
            .drive(onNext: { [unowned self] in
                popToViewController()
            })
            .disposed(by: viewModel.disposeBag)
    }
    
}

// MARK: handle push view controller
extension RegisterViewController {
    
    func pushToHomeViewController() {
        let vc = HomeViewController()
        pushToViewController(vc)
    }
    
}
