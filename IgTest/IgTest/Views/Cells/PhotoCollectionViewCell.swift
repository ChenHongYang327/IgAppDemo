//
//  PhotoCollectionViewCell.swift
//  IgTest
//
//  Created by 陳鋐洋 on 2021/10/12.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionViewCell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(photoImageView)
        contentView.clipsToBounds = true
        
        accessibilityLabel = "User post image"
        accessibilityHint = "Double-tap to open post"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: UserPost){
        let thumbnailURL = model.thumbnailImage
        
        Common.shard.fetchImage(with: thumbnailURL, imageView: photoImageView) { result in
            switch result {
            case .success(_):
                return
            case .failure(_):
                return
            }
        }
    }
    
    public func configure(debug imageName: String){
        photoImageView.image = UIImage(named: imageName)
    }
    
    
}
