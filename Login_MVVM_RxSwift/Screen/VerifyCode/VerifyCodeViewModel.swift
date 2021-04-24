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
    
    // phone number verify
    var phone = BehaviorRelay<String>(value: "")
    
    // time out verify code
    var timeOut = BehaviorRelay<Int>(value: 60)
    
    // event model change
    var modelChange = BehaviorRelay<BaseViewModelChange>(value: .none)
    
    // fetch time load data
    var fetchDataTime = [0.5, 1, 1.5]
    
    // init
    init(_ phone: String) {
        disposeBag = DisposeBag()
        self.phone.accept(phone)
    }
    
    // rchange timne out
    func setTimeOut(_ timeOut: Int = 60) {
        self.timeOut.accept(timeOut)
    }
    
    // check code verify
    func handleVerifyCode(code: String) {
        modelChange.accept(.loaderStart)
        
        let time = fetchDataTime.randomElement() ?? 1
        DispatchQueue.main.asyncAfter(deadline: .now() + time) { [unowned self] in
            modelChange.accept(.loaderEnd)
                
            if code == "0110" {
                modelChange.accept(.updateDataModel(data: nil))
            } else {
                modelChange.accept(.error(message: "Code is incorrect"))
            }
        }
    }
}
