//
//  Common.swift
//  IgTest
//
//  Created by 陳鋐洋 on 2021/10/12.
//

import Foundation
import UIKit

class Common {
    
    static let shard = Common()
    
//    public func fetchImage(with url: URL, completion: @escaping (Result<UIImage,Error>)->Void){
//        URLSession.shared.dataTask(with: url) { data, reponce, error in
//            guard let data = data else {
//                completion(.failure(error!))
//                return
//            }
//            completion(.success(UIImage(data: data)!))
//
//        }.resume()
//    }
    
    public func fetchImage(with url: URL, imageView: UIImageView, completion: @escaping (Result<String,Error>)->Void){
        URLSession.shared.dataTask(with: url) { data, reponce, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(.failure(error!))
                    return
                }
                imageView.image = UIImage(data: data)
                completion(.success("success"))
            }
        }.resume()
    }
    
    
}
