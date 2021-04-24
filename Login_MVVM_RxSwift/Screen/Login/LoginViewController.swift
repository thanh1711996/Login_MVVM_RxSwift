//
//  LoginViewController.swift
//  Login_MVVM_RxSwift
//
//  Created by Mac on 22/04/2021.
//

import UIKit
import RxSwift
import RxCocoa
import NKVPhonePicker

class LoginViewController: BaseViewController, BaseViewControllerProtocol {
    
    // outlet element xib
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfCode: NKVPhonePickerTextField!
    
    @IBOutlet weak var btnNext: UIButton!
    
    // init view model
    private(set) var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = LoginViewModel()
        setupViewController()
    }

    // setup ui
    func setupUI() {
        setupPhonePicker()
        setupButton()
    }
    
    // setup MVVM
    func bindViewModel() {
        bindModelChange()
        bindEnableSave()
        bindTextField()
        bindButton()
    }
    
}

// MARK: setup ui
extension LoginViewController {
    
    func setupButton() {
        btnNext.isEnabled = false
        btnNext.alpha = 0.5
    }
    
    func setupPhonePicker() {
        tfPhone.delegate = self
        tfCode.phonePickerDelegate = self
        tfCode.countryPickerDelegate = self
        tfCode.delegate = self
        tfCode.favoriteCountriesLocaleIdentifiers = ["AE", "VN"]
        
        let country = Country.country(for: NKVSource(countryCode: "AE"))
        tfCode.country = country
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
                    pushToVerifyCodeViewController()
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
                btnNext.isEnabled = enable
                btnNext.alpha = enable ? 1 : 0.5
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    // handle text field
    func bindTextField() {
        tfPhone.rx.text
            .orEmpty
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] query in
                viewModel.handleEnableLogin(phone: query)
            })
            .disposed(by: viewModel.disposeBag)
    }

    // handle button
    func bindButton() {
        btnNext.rx.controlEvent(.touchUpInside)
            .asDriver()
            .drive(onNext: { [unowned self] in
                viewModel.handleLogin(phone: tfPhone.text!)
            })
            .disposed(by: viewModel.disposeBag)
    }
}

// MARK: handle event Countries
extension LoginViewController: CountriesViewControllerDelegate {
    func countriesViewControllerDidCancel(_ sender: CountriesViewController) {
        
    }
    
    func countriesViewController(_ sender: CountriesViewController, didSelectCountry country: Country) {
        print("✳️ Did select country: \(country)")
    }
}

// MARK: handle event TextField
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 10 {
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 10 { return true }
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        if count <= 15 {
            let newString = (textFieldText as NSString).replacingCharacters(in: range, with: string)
            tfPhone.text = newString.formatPhone(tfCode.country?.countryCode.count ?? 0, false)
            viewModel.handleEnableLogin(phone: tfPhone.text!)
        }
        return false
    }
}

// MARK: handle push view controller
extension LoginViewController {
    func pushToRegisterViewController() {
        let vc = RegisterViewController()
        pushToViewController(vc)
    }
    
    func pushToVerifyCodeViewController() {
        let phone = "+\(tfCode.code ?? "") \(tfPhone.text!)".trim()
        let vc = VerifyCodeViewController(phone)
        pushToViewController(vc)
    }
}
