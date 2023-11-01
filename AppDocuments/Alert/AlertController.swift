//
//  AlertController.swift
//  AppDocuments


import UIKit

class AlertController: UIAlertController {
    var yesAction: (() -> Void)?
    var noAction: (() -> Void)?
    
    func setup() {
        title = "Ошибка входа"
        message = "Создать пароль?"
        
        let actionYes = UIAlertAction(title: "Да", style: .default) { _ in
            self.yesAction?()
        }
        
        let actionNo = UIAlertAction(title: "Нет", style: .cancel) { _ in
            self.noAction?()
        }
        
        addAction(actionYes)
        addAction(actionNo)
    }
}
