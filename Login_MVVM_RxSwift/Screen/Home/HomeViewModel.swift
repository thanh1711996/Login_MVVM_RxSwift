//
//  HomeViewModel.swift
//  Login_MVVM_RxSwift
//
//  Created by Mac on 22/04/2021.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel {
    
    // init DisposeBag
    let disposeBag: DisposeBag
    
    // event model change
    var accountData = BehaviorRelay<AccountData>(value: AccountData())
    
    // event model change
    var modelChange = BehaviorRelay<BaseViewModelChange>(value: .none)
    
    // fetch time load data
    var fetchDataTime = [0.5, 1, 1.5]
    
    // init
    init(_ data: AccountData) {
        disposeBag = DisposeBag()
        accountData.accept(data)
    }
    
    // handle event logout
    func handleLogout() {
        modelChange.accept(.loaderStart)
        
        let time = fetchDataTime.randomElement() ?? 1
        DispatchQueue.main.asyncAfter(deadline: .now() + time) { [unowned self] in
            modelChange.accept(.loaderEnd)
        }
    }
}
