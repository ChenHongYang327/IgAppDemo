//
//  ProfileTabsCollectionReusableView.swift
//  IgTest
//
//  Created by 陳鋐洋 on 2021/10/12.
//

import UIKit

class ProfileTabsCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ProfileTabsCollectionReusableView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
