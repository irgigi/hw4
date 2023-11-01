//
//  KeychainService.swift
//  AppDocuments


import Foundation
import KeychainSwift

final class CustomKeychainService {
    
    var keychain = KeychainSwift()
    
    
    func setPassword(_ password1: String? ,_ password2: String?, name: String?) -> Bool {
        if let pas1 = password1, let pas2 = password2, let n = name {
            if pas1 == pas2 {
                if keychain.set(pas1, forKey: n) {
                    return true
                }
            }
        }
        return false
    }
    
    func enterPassword(_ password: String?, name: String?) -> Bool {
        if let passwordGet = keychain.get(name!) {
            if password == passwordGet {
                print("вход выполнен")
                return true
            } 
        }
        return false
    }
    
    func delitePassword(name: String?) {
        guard let name = name else { return }
        if keychain.delete(name) {
            print("пароль удален")
        } else {
            print("пароль не удален")
        }
    }
}
