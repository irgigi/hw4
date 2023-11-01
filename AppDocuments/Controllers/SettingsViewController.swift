//
//  SettingsViewController.swift
//  AppDocuments

import UIKit
import KeychainSwift

final class SettingsViewController: UIViewController {
    
    let passwordController = PasswordController()
    
    let key = CustomKeychainService()
    
    let sortingSwitch = UISwitch()
    
    var getName = Service.shared.nameInField

    
    let settingOptions = ["Сортировка", "Поменять пароль"]
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        sortingSwitch.isOn = true
        setupLoyout()
        
        
    }
    
    
    @objc func sortingSwitchChanched(_ sender: UISwitch) {
        Service.sortingEnabled = sender.isOn
    }
    
    
    
    func setupLoyout() {
        view.addSubview(tableView)
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),

        ])
        
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = settingOptions[indexPath.row]
        if indexPath.row == 0 {
            Service.sortingEnabled = sortingSwitch.isOn
            sortingSwitch.addTarget(self, action: #selector(sortingSwitchChanched(_:)), for: .valueChanged)
            cell.accessoryView = sortingSwitch
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {

            passwordController.currentButtonState = .createPassword
            passwordController.nameField.text = getName
            passwordController.nameField.isUserInteractionEnabled = false
            passwordController.isEditing = false
            passwordController.nameField.backgroundColor = .lightGray
            self.present(passwordController, animated: true, completion: nil)
            key.delitePassword(name: getName)
        }
    }
}
