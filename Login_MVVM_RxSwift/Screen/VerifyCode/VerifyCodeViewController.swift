//
//  VerifyCodeViewController.swift
//  Login_MVVM_RxSwift
//
//  Created by PC on 24/04/2021.
//

import UIKit
import RxSwift
import RxCocoa

class VerifyCodeViewController: BaseViewController, BaseViewControllerProtocol {
    
    // outlet element xib
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    @IBOutlet weak var tfNumber1: UITextFieldModern!
    @IBOutlet weak var tfNumber2: UITextFieldModern!
    @IBOutlet weak var tfNumber3: UITextFieldModern!
    @IBOutlet weak var tfNumber4: UITextFieldModern!
    
    @IBOutlet weak var viewNumber1: UIView!
    @IBOutlet weak var viewNumber2: UIView!
    @IBOutlet weak var viewNumber3: UIView!
    @IBOutlet weak var viewNumber4: UIView!
    
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var btnCoutDown: UIButton!
    
    // init view model
    private(set) var viewModel: VerifyCodeViewModel!
    
    var texFieldFocus: UITextField!
    
    init(_ phone: String) {
        super.init(nibName: nil, bundle: nil)
        viewModel = VerifyCodeViewModel(phone)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
    }

    // setup ui
    func setupUI() {
        tfNumber1.delegate = self
        tfNumber2.delegate = self
        tfNumber3.delegate = self
        tfNumber4.delegate = self
        
        tfNumber1.delegateBackward = self
        tfNumber2.delegateBackward = self
        tfNumber3.delegateBackward = self
        tfNumber4.delegateBackward = self
        
        setBecomeFirstResponder(tfNumber1)
        
        lblTitle.text = "Thanks!\nPlease verify your\nphone number"
    }
    
    // setup MVVM
    func bindViewModel() {
        bindPhoneNumber()
        bindTimeOut()
        bindModelChange()
        bindTextField()
        bindButton()
    }
    
}

// MARK: bind data MVVM
extension VerifyCodeViewController {
    
    // handle phone number
    func bindPhoneNumber() {
        viewModel.phone.asObservable()
            .subscribe(onNext: { [unowned self] phone in
                lblPhone.text = phone
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    // handle time out
    func bindTimeOut() {
        Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
            .bind { [unowned self] _ in
                let countDown = viewModel.timeOut.value - 1
                if countDown < 0 { return }
                viewModel.setTimeOut(countDown)
                
                if countDown == 0 {
                    btnCoutDown.setTitle("Resend OTP", for: .normal)
                    btnCoutDown.setTitleColor(.systemBlue, for: .normal)
                } else {
                    UIView.transition(with: btnCoutDown, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        let time = countDown < 10 ? "0\(countDown)" : "\(countDown)"
                        btnCoutDown.setTitle("Resend code in: 00:\(time)", for: .normal)
                        btnCoutDown.setTitleColor(.black, for: .normal)
                    }, completion: nil)
                }
            }
            .disposed(by: viewModel.disposeBag)
    }
    
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
                    pushToHomeViewController()
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
    
    // handle text field
    func bindTextField() {
        tfNumber1.rx.text
            .orEmpty
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] query in
                if query.isEmpty { return }
                setBecomeFirstResponder(tfNumber2)
                viewNumber2.backgroundColor = .systemBlue
                verifyCode()
            })
            .disposed(by: viewModel.disposeBag)
        
        tfNumber2.rx.text
            .orEmpty
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] query in
                if query.isEmpty { return }
                setBecomeFirstResponder(tfNumber3)
                viewNumber3.backgroundColor = .systemBlue
                verifyCode()
            })
            .disposed(by: viewModel.disposeBag)
        
        tfNumber3.rx.text
            .orEmpty
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] query in
                if query.isEmpty { return }
                setBecomeFirstResponder(tfNumber4)
                viewNumber4.backgroundColor = .systemBlue
                verifyCode()
            })
            .disposed(by: viewModel.disposeBag)
        
        tfNumber4.rx.text
            .orEmpty
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] query in
                verifyCode()
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    // handle button
    func bindButton() {
        btnback.rx.controlEvent(.touchUpInside)
            .asDriver()
            .drive(onNext: { [unowned self] in
                popToViewController()
            })
            .disposed(by: viewModel.disposeBag)
        
        btnCoutDown.rx.controlEvent(.touchUpInside)
            .asDriver()
            .drive(onNext: { [unowned self] in
                if viewModel.timeOut.value != 0 { return }
                viewModel.setTimeOut()
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    // check count code
    func verifyCode() {
        let code = "\(tfNumber1.text!)\(tfNumber2.text!)\(tfNumber3.text!)\(tfNumber4.text!)".trim()
        if code.count < 4 { return }
        viewModel.handleVerifyCode(code: code)
    }
}

// MARK: handle push view controller
extension VerifyCodeViewController {
    
    func pushToHomeViewController() {
        let vc = HomeViewController()
        pushToViewController(vc)
    }
    
}

// MARK: handle text field
extension VerifyCodeViewController: UITextFieldDelegate, TextFieldDeleteBackward {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 10 { return true }
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 1
    }
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        if textField.text == "" { return }
        switch textField.tag {
        case 1:
            self.setBecomeFirstResponder(tfNumber2)
            break
        case 2:
            self.setBecomeFirstResponder(tfNumber3)
            break
        case 3:
            self.setBecomeFirstResponder(tfNumber4)
            break
        default:
            break
        }
    }
    
    func deleteBackward() {
        if texFieldFocus.text == "" {
            switch texFieldFocus.tag {
            case 2:
                tfNumber1.text = ""
                self.setBecomeFirstResponder(tfNumber1)
                break
            case 3:
                tfNumber2.text = ""
                self.setBecomeFirstResponder(tfNumber2)
                break
            case 4:
                tfNumber3.text = ""
                self.setBecomeFirstResponder(tfNumber3)
                break
            default:
                break
            }
        }
    }
    
    func setBecomeFirstResponder(_ textFielf: UITextField) {
        self.texFieldFocus = textFielf
        textFielf.becomeFirstResponder()
    }
}
