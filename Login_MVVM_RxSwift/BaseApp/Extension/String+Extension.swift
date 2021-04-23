//
//  String+Extension.swift
//  Login_MVVM_RxSwift
//
//  Created by Mac on 22/04/2021.
//

import Foundation

extension String {
    
    // remove spaceing
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
