//
//  HomeViewController.swift
//  IgTest
//
//  Created by 陳鋐洋 on 2021/10/8.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        handleNotAuthenticated()
    }
    
    private func handleNotAuthenticated(){
        // check Auth Status
        if Auth.auth().currentUser == nil {
            // show login
            let logVC = LoginViewController()
            logVC.modalPresentationStyle = .fullScreen
            present(logVC, animated: false, completion: nil)
            
        }
    }



}
