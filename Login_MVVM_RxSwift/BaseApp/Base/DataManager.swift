//
//  DataManager.swift
//  Login_MVVM_RxSwift
//
//  Created by Mac on 22/04/2021.
//

import Foundation

// key data
enum Key: String {
    case accounts
    case fullName
    case phone
    case email
    case password
}

// data
struct AccountData {
    var fullName: String = ""
    var phone: String = ""
    var email: String = ""
    var password: String = ""
    
    var dictionary: [String: Any] {
        var dictionary: [String: Any] = [:]

        dictionary[Key.fullName.rawValue] = fullName
        dictionary[Key.phone.rawValue] = phone
        dictionary[Key.email.rawValue] = email
        dictionary[Key.password.rawValue] = password
        
        return dictionary
    }
    
}

class DataManager {
    
    // singleton
    private static var sharedDataManager: DataManager = {
        let dataManager = DataManager()
        return dataManager
    }()
    
    // share instance
    class func shared() -> DataManager {
        return sharedDataManager
    }
    
    // init
    private init() {}
    
    // check account login from database
    func getAccountData(data: AccountData) -> AccountData? {
        return getAccountDatas().first(where: { ($0.phone == data.phone || $0.email == data.email) &&
                                        $0.password == data.password })
    }
    
    // get info account from database
    func getInfoAccountData(data: AccountData) -> AccountData? {
        return getAccountDatas().first(where: { ($0.phone == data.phone || $0.email == data.email) })
    }
    
    // open list account from database
    func getAccountDatas() -> [AccountData] {
        let datas = UserDefaults.standard.array(forKey: Key.accounts.rawValue) as? [[String:Any]] ?? []
        
        let accounts = datas.compactMap { (dic) -> AccountData? in
            if let fullName = dic[Key.fullName.rawValue] as? String,
               let phone = dic[Key.phone.rawValue] as? String,
               let email = dic[Key.email.rawValue] as? String,
               let password = dic[Key.password.rawValue] as? String {
                return AccountData(fullName: fullName, phone: phone, email: email, password: password)
            }
            return nil
        }
        
        return accounts
    }
    
    // insert database
    func saveAccountData(data: AccountData) {
        var accounts = UserDefaults.standard.array(forKey: Key.accounts.rawValue) as? [[String:Any]] ?? []
        accounts.append(data.dictionary)
        UserDefaults.standard.set(accounts, forKey: Key.accounts.rawValue)
        UserDefaults.standard.synchronize()
    }
}
