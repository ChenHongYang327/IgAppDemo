//
//  DatabaseManager.swift
//  IgTest
//
//  Created by 陳鋐洋 on 2021/10/10.
//

import FirebaseDatabase

public class DatabaseManager{
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    ///Check if username or email is availible
    /// - Parameters
    ///   - email: String representing email
    ///   - username: String represinting username
    public func canCreateNewUser(with email: String, username: String, completion: @escaping(Result<String, Error>)->Void){
        
        completion(.success("success!"))
    }
    
    ///Inserts new userdata to database
    /// - Parameters
    ///   - email: String representing email
    ///   - username: String represinting username
    ///   - completion: Async callback for result if database entry succeded
    public func insertNewUser(with email: String, username: String, completion: @escaping(Result<String, Error>)->Void){
        
        database.child(email.safeDatabaseKey()).setValue(["username": username]) { error, reference in
            if error == nil {
                // success
                completion(.success(reference.url))
                return
            }else {
                // failed
                completion(.failure(error!))
                return
            }
        }
        
    }
    
    
}
