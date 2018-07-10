//
//  AppManager.swift
//  jitensha
//
//  Created by Benjamin Chris on 12/13/17.
//  Copyright © 2017 crossover. All rights reserved.
//

import Foundation

class AppManager {
    static let shared = AppManager()
    var token: String?
    
    func saveTokenToPersistStore() {
        UserDefaults.standard.set(true, forKey: "token_saved")
        UserDefaults.standard.set(self.token, forKey: "token")
        UserDefaults.standard.synchronize()
    }
    
    func tokenSavedInPersistStore() -> Bool {
        return UserDefaults.standard.bool(forKey: "token_saved")
    }
    
    func fetchTokenFromPersistStore() {
        self.token = UserDefaults.standard.string(forKey: "token")
    }
    
    func signout() {
        token = nil
        UserDefaults.standard.removeObject(forKey: "token_saved")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.synchronize()
    }
}
