//
//  VerifyCodeViewController.swift
//  Login_MVVM_RxSwift
//
//  Created by PC on 24/04/2021.
//

import UIKit

class VerifyCodeViewController: BaseViewController, BaseViewControllerProtocol {
    
    // outlet element xib
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    
    @IBOutlet weak var tfNumber1: UITextFieldModern!
    @IBOutlet weak var tfNumber2: UITextFieldModern!
    @IBOutlet weak var tfNumber3: UITextFieldModern!
    @IBOutlet weak var tfNumber4: UITextFieldModern!
    
    // init view model
    private(set) var viewModel: VerifyCodeViewModel!
    
    var texFieldFocus: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = VerifyCodeViewModel()
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
        tfNumber3.delegateBackward = self
        
        texFieldFocus = tfNumber1
        
        lblTitle.text = "Thamks!\nPlease verify your\nphone number"
    }
    
    // setup MVVM
    func bindViewModel() {
        bindModelChange()
    }
    
}

// MARK: bind data MVVM
extension VerifyCodeViewController {
    
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
                case .error(let message):
                    showAlert(message: message)
                    break
                default:
                    break
                }
            })
            .disposed(by: viewModel.disposeBag)
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
extension VerifyCodeViewController: UITextFieldDelegate, textFieldDeleteBackward {
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
