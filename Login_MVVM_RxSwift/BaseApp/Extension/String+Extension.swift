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
    
    // format phone number
    func formatPhone(_ code: Int = 2, _ isPlus: Bool = true) -> String {
        let cleanPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var x = ""
        if isPlus {
            x = "+"
            for _ in 0 ..< code {
                x.append("X")
            }
            x.append(" ")
        }
        let mask = x + "XXX XXX XXXX"

        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}
