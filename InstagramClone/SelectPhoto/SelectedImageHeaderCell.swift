//
//  SelectedImageHeaderCell.swift
//  InstagramClone
//
//  Created by Алибек Аблайулы on 27.09.2023.
//

import UIKit

class SelectedImageHeaderCell: UICollectionViewCell {
    
    let selectImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hexString: "#f7f7f7")
        addSubview(selectImage)
        self.clipsToBounds = true
        selectImage.anchor(
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
