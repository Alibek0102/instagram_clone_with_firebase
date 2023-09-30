//
//  ProfilePostPhotoCell.swift
//  InstagramClone
//
//  Created by Алибек Аблайулы on 30.09.2023.
//

import UIKit

class ProfilePostPhotoCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            let urlString = post?.imageUrl as? String ?? ""
            imgView.fetchPhoto(urlString: urlString)
        }
    }
    
    fileprivate var imgView: CustomImageView = {
        let imgView = CustomImageView()
        imgView.backgroundColor = UIColor(hexString: "#f2f2f2")
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imgView)
        imgView.anchor(
            top: self.topAnchor, paddingTop: 0,
            bottom: self.bottomAnchor, paddingBottom: 0,
            left: self.leftAnchor, paddingLeft: 0,
            right: self.rightAnchor, paddingRight: 0,
            height: 0, width: 0,
            centerByX: nil, centerByY: nil
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
