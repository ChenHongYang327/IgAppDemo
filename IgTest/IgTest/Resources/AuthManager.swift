//
//  AuthManager.swift
//  IgTest
//
//  Created by 陳鋐洋 on 2021/10/10.
//

import Foundation
import FirebaseAuth

public class AuthManager{
    static let shared = AuthManager()
    
    public func registerNewUser(userName: String, email: String , password: String, completion: @escaping(Result<String,Error>)->Void){
        /*
         - Check if email is available
         - Check if username is available
         - Create account
         - Insert account to database
         */
        DatabaseManager.shared.canCreateNewUser(with: email, username: userName) { result in
            switch result{
            case .success(_):
                /*
                 - Create account
                 - Insert account to database
                 */
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    guard error == nil, result != nil else {
                        // Firebase auth could not create account
                        completion(.failure(error!))
                        return
                    }
                }
                // Insert into database
                DatabaseManager.shared.insertNewUser(with: email, username: userName) { inserted in
                    switch inserted{
                    case .success(let resultStr):
                        completion(.success(resultStr))
                        return
                    case .failure(let error):
                        completion(.failure(error))
                        return
                    }
                }
                
                return
            case .failure(let error):
                // either auth could not create account
                completion(.failure(error))
                return
            }
        }
        
        
    }
    
    public func loginUser(username: String?, email: String? , password: String, completion: @escaping(Result<String,Error>)->Void){
        
        if let email = email {
            // email login
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let authResult = authResult{
                    completion(.success(authResult.description))
                    return
                }
            }
            
        }
        else if let username = username {
            // username login
            print(username)
        }
    }
    
    /// Attempt to log out firebase user
    public func logOut(completion: (Result<String,Error>) -> Void){
        do {
            try Auth.auth().signOut()
            completion(.success("log out success!"))
            return
        } catch let error {
            print(error.localizedDescription)
            completion(.failure(error))
            return
        }
    }
    
}
