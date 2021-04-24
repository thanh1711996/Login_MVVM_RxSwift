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
    func handleEnableLogin(phone: String) {
        enableLogin.accept(phone.trim().count > 9)
    }
    
    // check data local login
    func handleLogin(phone: String) {
        modelChange.accept(.loaderStart)
        
        let time = fetchDataTime.randomElement() ?? 1
        DispatchQueue.main.asyncAfter(deadline: .now() + time) { [unowned self] in
            modelChange.accept(.loaderEnd)
        }
    }
}
