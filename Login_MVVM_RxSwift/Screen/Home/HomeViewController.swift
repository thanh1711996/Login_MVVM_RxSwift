//
//  HomeViewController.swift
//  Login_MVVM_RxSwift
//
//  Created by Mac on 22/04/2021.
//

import UIKit

class HomeViewController: BaseViewController, BaseViewControllerProtocol {

    // outlet element xib
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var btnLogout: UIButton!
    
    // init view model
    private(set) var viewModel: HomeViewModel!
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel = HomeViewModel()
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
        
    }
    
    // setup MVVM
    func bindViewModel() {
        bindData()
        bindModelChange()
        bindButton()
    }
    
}

// MARK: bind data MVVM
extension HomeViewController {
    
    // show data account
    func bindData() {
        viewModel.accountData.asObservable()
            .subscribe(onNext: { [unowned self] data in
                lblFullName.text = "Full Name: \(data.fullName)"
                lblPhone.text = "Phone: \(data.phone)"
                lblEmail.text = "Email: \(data.email)"
            })
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
                    popToRootViewController()
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
    
    // handle button
    func bindButton() {
        btnLogout.rx.controlEvent(.touchUpInside)
            .asDriver()
            .drive(onNext: { [unowned self] in
                showAlertLogut()
            })
            .disposed(by: viewModel.disposeBag)
    }
    
}

// MARK: handle alert
extension HomeViewController {
    func showAlertLogut() {
        showAlert(title: "Logout", message: "Do you want to logout?", saveCallBack: { [unowned self] in
            viewModel.handleLogout()
        }, closeCallBack: {})
    }
}
