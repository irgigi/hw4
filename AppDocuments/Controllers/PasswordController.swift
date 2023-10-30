//
//  PasswordController.swift
//  AppDocuments


import UIKit
import KeychainSwift

class PasswordController: UIViewController {
    
    let keychain = KeychainSwift()
    
    var currentButtonState: ButtonState = .enterPassword
    
    var initialPassword: String?
    
    //MARK: - свойства
    
    lazy var nameField: UITextField = {
        let text = UITextField()
        
        text.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        text.textColor = UIColor.black
        text.placeholder = "ваше имя"
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        text.layer.cornerRadius = 12
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.black.cgColor
        text.layer.backgroundColor = UIColor.white.cgColor
        //text.addTarget(self, action: #selector(fields), for: .editingChanged)
        text.translatesAutoresizingMaskIntoConstraints = false

        return text
    }()
    
    
    lazy var passwordField: UITextField = {
        let text = UITextField()
        
        text.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        text.textColor = UIColor.black
        text.placeholder = "не менее 4 символов"
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        text.layer.cornerRadius = 12
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.black.cgColor
        text.layer.backgroundColor = UIColor.white.cgColor
        //text.addTarget(self, action: #selector(fields), for: .editingChanged)
        text.translatesAutoresizingMaskIntoConstraints = false

        return text
    }()
    
    lazy var repeatPasswordField: UITextField = {
        let text = UITextField()
        
        text.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        text.textColor = UIColor.black
        text.placeholder = "повторите пароль"
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        text.layer.cornerRadius = 12
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.black.cgColor
        text.layer.backgroundColor = UIColor.white.cgColor
        //text.addTarget(self, action: #selector(fields), for: .editingChanged)
        text.translatesAutoresizingMaskIntoConstraints = false

        return text
    }()
    
    lazy var passwordButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.borderWidth = 0.5
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return(button)
    }()
    
    //MARK:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBrown
        view.addSubview(passwordField)
        view.addSubview(passwordButton)
        view.addSubview(nameField)
        buttonState(currentButtonState)
        elementConstraint()
    }
    
    //MARK: - methods
    
    @objc func buttonAction() {
        switch currentButtonState {
        case .createPassword:
            if let name = nameField.text {
                if let password = passwordField.text, password.count >= 4 {
                    
                    if let password2 = repeatPasswordField.text {
                        if password2 == password {
                            initialPassword = password
                            keychain.set(password, forKey: name)
                            repeatPasswordField.removeFromSuperview()
                            currentButtonState = .enterPassword
                        }
                    } else {
                        print("пароли не совпадают")
                    }
                }
            } else {
                print("пароль должен быть более 4 символов")
            }
        case .enterPassword:
            if let name = nameField.text {
                
                if let password = passwordField.text {
                    //Keychain
                    if let password = keychain.get(name) {
                        print("вход выполнен")
                        passwordField.text = ""
                        tabbarCreate()
                    } else {
                        print("такого пароля нет")
                        currentButtonState = .createPassword
                        extraConstraint()
                        passwordField.text = ""
                    }
                }
            }
        }
        buttonState(currentButtonState)
    }
    
    func buttonState(_ state: ButtonState) {
        switch state {
        case .createPassword:
            passwordButton.setTitle("Создайте пароль", for: .normal)
        case .enterPassword:
            passwordButton.setTitle("Введите пароль", for: .normal)
        }
    }
    
    func tabbarCreate() {
        let tabBarController = UITabBarController()
        let docViewController = DocViewController()
        let settingController = SettingsViewController()
        tabBarController.viewControllers = [docViewController, settingController]
        docViewController.tabBarItem = UITabBarItem(title: "список", image: UIImage(systemName: "folder.badge.plus"), tag: 0)
        settingController.tabBarItem = UITabBarItem(title: "настройки", image: UIImage(systemName: "gearshape.fill"), tag: 1)
        if let navigationController = self.navigationController {
            navigationController.pushViewController(tabBarController, animated: true)
            //navigationController.setNavigationBarHidden(true, animated: false)
        } else {
            print("ошибка входа")
        }
    }
    
    //MARK: -
    
    func extraConstraint() {
        
        view.addSubview(repeatPasswordField)
        
        NSLayoutConstraint.activate([
            
            repeatPasswordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            repeatPasswordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            repeatPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 10),
            repeatPasswordField.bottomAnchor.constraint(equalTo: passwordButton.topAnchor, constant: -10),
            repeatPasswordField.heightAnchor.constraint(equalToConstant: 40),
        
        ])
    }
    
    func elementConstraint() {
        
        NSLayoutConstraint.activate([
            
            nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameField.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            nameField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //passwordField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            passwordField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 20),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            //passwordField.widthAnchor.constraint(equalToConstant: 100),
            passwordField.heightAnchor.constraint(equalToConstant: 40),
            
            
            passwordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 60),
            passwordButton.heightAnchor.constraint(equalToConstant: 50),
            passwordButton.widthAnchor.constraint(equalToConstant: 150)
            
        ])
    }
}
