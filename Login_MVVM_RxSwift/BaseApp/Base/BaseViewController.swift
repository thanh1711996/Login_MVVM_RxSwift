//
//  BaseViewController.swift
//  Login_MVVM_RxSwift
//
//  Created by Mac on 22/04/2021.
//

import Foundation
import UIKit

// protocol
protocol BaseViewControllerProtocol {
    func setupUI()
    func bindViewModel()
}

// setup MVVM
extension BaseViewControllerProtocol where Self: UIViewController {
    func setupViewController() {
        setupUI()
        bindViewModel()
    }
}

public class BaseViewController: UIViewController {
    var loading: UIView?
    
    override public func viewDidLayoutSubviews() {
        self.loading?.center = self.view.center
    }
    
}

// MARK: loading view
extension BaseViewController {
    public func showLoading() {
        let viewIndicator = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        viewIndicator.backgroundColor = .black
        viewIndicator.cornerRadius = 8
        viewIndicator.center = view.center
        
        let ai = UIActivityIndicatorView.init(style: .medium)
        ai.color = .white
        ai.startAnimating()
        ai.center = viewIndicator.center
        
        viewIndicator.attachView(ai)
        
        DispatchQueue.main.async { [weak self] in
            self?.view.addSubview(viewIndicator)
        }
        
        loading = viewIndicator
    }
    
    public func hideLoading() {
        DispatchQueue.main.async {
            self.loading?.removeFromSuperview()
            self.loading = nil
        }
    }
}

// MARK: alert message
extension BaseViewController {
    func showAlert(title: String = "", message: String,
                   style: UIAlertController.Style = .alert,
                   saveCallBack: (() -> Void)? = nil,
                   closeCallBack: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
        if let saveCallBack = saveCallBack {
            let action = UIAlertAction(title: "OK", style: .default, handler: { _ in saveCallBack() })
            alert.addAction(action)
        }
        
        if let closeCallBack = closeCallBack {
            let action = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in closeCallBack() })
            alert.addAction(action)
        }
        
        present(alert, animated: true, completion: nil)
        
        if saveCallBack == nil && closeCallBack == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}

// MARK: navigation
extension BaseViewController {
    func pushToViewController(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func popToViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func popToRootViewController() {
        navigationController?.popToRootViewController(animated: true)
    }
}
