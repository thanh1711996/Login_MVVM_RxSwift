//
//  LoginViewModel.swift
//  Login_MVVM_RxSwift
//
//  Created by Mac on 22/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    // init DisposeBag
    let disposeBag: DisposeBag
    
    // event enable button login
    var enableLogin = BehaviorRelay<Bool>(value: false)
    
    // event model change
    var modelChange = BehaviorRelay<BaseViewModelChange>(value: .none)
    
    // fetch time load data
    var fetchDataTime = [0.5, 1, 1.5]
    
    // init
    init() {
        disposeBag = DisposeBag()
    }
    
    // check enable button login
    func handleEnableSave(userName: String, password: String) {
        let enable = !userName.trim().isEmpty && !password.trim().isEmpty
        enableLogin.accept(enable)
    }
    
    // check data local login
    func handleLogin(userName: String, password: String) {
        modelChange.accept(.loaderStart)
        
        let time = fetchDataTime.randomElement() ?? 1
        DispatchQueue.main.asyncAfter(deadline: .now() + time) { [unowned self] in
            modelChange.accept(.loaderEnd)
            
            let account = AccountData(fullName: "", phone: userName, email: userName, password: password)
            
            if let data = DataManager.shared().getAccountData(data: account) {
                modelChange.accept(.updateDataModel(data: data))
            } else {
                modelChange.accept(.error(message: "Incorrect username or password"))
            }
        }
    }
}
