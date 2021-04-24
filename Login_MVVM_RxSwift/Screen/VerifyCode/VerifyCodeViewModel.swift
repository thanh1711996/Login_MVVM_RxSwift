//
//  VerifyCodeViewModel.swift
//  Login_MVVM_RxSwift
//
//  Created by PC on 24/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

class VerifyCodeViewModel {
    
    // init DisposeBag
    let disposeBag: DisposeBag
    
    // event enable button register
    var enableRegister = BehaviorRelay<Bool>(value: false)
    
    // event model change
    var modelChange = BehaviorRelay<BaseViewModelChange>(value: .none)
    
    // fetch time load data
    var fetchDataTime = [0.5, 1, 1.5]
    
    // init
    init() {
        disposeBag = DisposeBag()
    }
    
    // check enable button register
    func handleEnableSave(data: AccountData) {
        let enable = !data.fullName.trim().isEmpty && !data.phone.trim().isEmpty && !data.email.trim().isEmpty && !data.password.trim().isEmpty
        enableRegister.accept(enable)
    }
    
    // check data local register
    func handleRegister(data: AccountData) {
        modelChange.accept(.loaderStart)
        
        let time = fetchDataTime.randomElement() ?? 1
        DispatchQueue.main.asyncAfter(deadline: .now() + time) { [unowned self] in
            modelChange.accept(.loaderEnd)
                        
            if let _ = DataManager.shared().getInfoAccountData(data: data) {
                modelChange.accept(.error(message: "Account already exists"))
            } else {
                DataManager.shared().saveAccountData(data: data)
                modelChange.accept(.updateDataModel(data: data))
            }
        }
    }
}
