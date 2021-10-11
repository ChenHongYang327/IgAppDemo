//
//  StorageManager.swift
//  IgTest
//
//  Created by 陳鋐洋 on 2021/10/10.
//


import FirebaseStorage
import SwiftUI


public class StorageManager{
    
    static let shared = StorageManager()
    
    private let bucket = Storage.storage().reference()
    
    public enum IGStorageError: Error{
        case failedToDownload
    }
    
    
    public func uploadUserPost(model: UserPost, completion: @escaping(Result<URL,Error>)->Void){
        
    }
    
    public func downloadImage(with reference: String, completion: @escaping(Result<URL,Error>)->Void){
        bucket.child(reference).downloadURL { url, error in
            guard let url = url, error == nil else{
                completion(.failure(IGStorageError.failedToDownload))
                return
            }
            completion(.success(url))
        }
    }
    
}

public enum UserPostType{
    case photo, video
}

public struct UserPost{
    let postType: UserPostType
}
