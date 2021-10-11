//
//  SettingsViewController.swift
//  IgTest
//
//  Created by 陳鋐洋 on 2021/10/11.
//

import UIKit

struct SettingCellModel {
    let title: String
    let handler: (() -> Void)
}

/// View Controller to show user settings
final class SettingsViewController: UIViewController {
    
    private var data = [[SettingCellModel]]()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurModels()

        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        
    }
    
    private func configurModels(){
        let section = [
            SettingCellModel(title: "Log Out", handler: { [weak self] in
                self?.didTapLogout()
            })
        ]
        data.append(section)
    }

    private func didTapLogout(){
        
        let actionAlert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        actionAlert.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionAlert.addAction(UIAlertAction(title: "Log Out",
                                            style: .destructive,
                                            handler: { _ in
            AuthManager.shared.logOut { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        // present log in
                        let logVC = LoginViewController()
                        logVC.modalPresentationStyle = .fullScreen
                        self.present(logVC, animated: true) {
                            // 要確保回主頁
                            self.navigationController?.popViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                        return
                    case .failure(_):
                        // error occured
                        fatalError("Could not log out user")
                        return
                    }
                }
            }
        }))
        
        actionAlert.popoverPresentationController?.sourceView = tableView
        actionAlert.popoverPresentationController?.sourceRect = tableView.bounds
        
        present(actionAlert, animated: true)
    }
    
    
}
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Handle cell selection
        data[indexPath.section][indexPath.row].handler()
        
    }
    
}
