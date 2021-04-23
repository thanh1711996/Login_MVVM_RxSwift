//
//  BaseViewModelChange.swift
//  Login_MVVM_RxSwift
//
//  Created by Mac on 22/04/2021.
//

import Foundation

// event model change
enum BaseViewModelChange {
    case loaderStart
    case loaderEnd
    case updateDataModel(data: Any)
    case error(message: String)
    case none
}
