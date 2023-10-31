//
//  KeychainService.swift
//  AppDocuments


import Foundation
import KeychainSwift

final class CustomKeychainService {
    
    var keychain = KeychainSwift()
    
    
    func setPassword(_ password1: String? ,_ password2: String?, name: String?) {
        guard let password1 = password1 else { return }
        guard let password2 = password2 else { return }
        guard let name = name else { return }
        if password1 == password2 {
            keychain.set(password1, forKey: name)
        }
    }
    
    func createPassword(_ password: String?, name: String?) {
        guard let password = password else { return }
        guard let name = name else { return }
        if let passwordGet = keychain.get(name) {
            if password == passwordGet {
                print("вход выполнен")
            }
        }

    }
}
