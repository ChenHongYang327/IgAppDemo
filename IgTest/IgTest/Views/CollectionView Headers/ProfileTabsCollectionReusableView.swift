//
//  ProfileTabsCollectionReusableView.swift
//  IgTest
//
//  Created by 陳鋐洋 on 2021/10/12.
//

import UIKit

protocol ProfileTabsCollectionReusableViewDelegate: AnyObject {
    func didTapGridButtonTab()
    func didTapTaggedButtonTab()
}

class ProfileTabsCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "ProfileTabsCollectionReusableView"
    
    public weak var delegate: ProfileTabsCollectionReusableViewDelegate?
    
    struct Constenrs {
        static let padding: CGFloat = 8
    }
    
    private let gridButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = .systemBlue
        button.setBackgroundImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        return button
    }()
    
    private let taggedButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.tintColor = .lightGray
        button.setBackgroundImage(UIImage(systemName: "tag"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        addSubview(gridButton)
        addSubview(taggedButton)
        
        gridButton.addTarget(self, action: #selector(didTapGridButton), for: .touchUpInside)
        taggedButton.addTarget(self, action: #selector(didTapTaggedButton), for: .touchUpInside)
    }
    
    @objc func didTapGridButton(){
        gridButton.tintColor = .systemBlue
        taggedButton.tintColor = .lightGray
        delegate?.didTapGridButtonTab()
    }
    
    @objc func didTapTaggedButton(){
        taggedButton.tintColor = .systemBlue
        gridButton.tintColor = .lightGray
        delegate?.didTapTaggedButtonTab()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = height - (Constenrs.padding * 2)
        let gridButtonX = ((width/2)-size)/2
        
        gridButton.frame = CGRect(x: gridButtonX,
                                  y: Constenrs.padding,
                                  width: size,
                                  height: size)
        taggedButton.frame = CGRect(x: gridButtonX + (width/2),
                                  y: Constenrs.padding,
                                  width: size,
                                  height: size)
        
    }
    
}
