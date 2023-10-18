//
//  PhotoCell.swift
//  InstagramClone
//
//  Created by Алибек Аблайулы on 11.10.2023.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            guard let urlString = post?.imageUrl else { return }
            postImageView.fetchPhoto(urlString: urlString)
        }
    }
    
    let postImageView: CustomImageView = {
        let imgView = CustomImageView()
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    let userPhoto: CustomImageView = {
        let imgView = CustomImageView()
        imgView.backgroundColor = .red
        imgView.layer.cornerRadius = 40/2
        return imgView
    }()
    
    let userFullname: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Alibek Yessetov"
        return label
    }()
    
    let buttonForShowOptionOfPost: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "ellipsis")
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "heart")
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "message")
        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeaderCellElements()
        setupFooterCellElements()
    }
    
    
    private func setupHeaderCellElements(){
        
        addSubview(userPhoto)
        userPhoto.anchor(
            top: topAnchor, paddingTop: 10,
            bottom: nil, paddingBottom: 0,
            left: leftAnchor, paddingLeft: 14,
            right: nil, paddingRight: 0,
            height: 40, width: 40,
            centerByX: nil, centerByY: nil
        )
        
        addSubview(postImageView)
        postImageView.anchor(
            top: userPhoto.bottomAnchor, paddingTop: 10,
            bottom: nil, paddingBottom: 0,
            left: leftAnchor, paddingLeft: 0,
            right: rightAnchor, paddingRight: 0,
            height: 0, width: 0,
            centerByX: nil, centerByY: nil
        )
        
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        addSubview(userFullname)
        userFullname.anchor(
            top: topAnchor, paddingTop: 10,
            bottom: postImageView.topAnchor, paddingBottom: -10,
            left: userPhoto.rightAnchor, paddingLeft: 10,
            right: rightAnchor, paddingRight: 0,
            height: 0, width: 0,
            centerByX: nil, centerByY: nil
        )
        
        addSubview(buttonForShowOptionOfPost)
        buttonForShowOptionOfPost.anchor(
            top: topAnchor, paddingTop: 10,
            bottom: postImageView.topAnchor, paddingBottom: -10,
            left: nil, paddingLeft: 0,
            right: rightAnchor, paddingRight: -14,
            height: 0, width: 50,
            centerByX: nil, centerByY: nil
        )
        
    }
    
    private func setupFooterCellElements(){
        let stack = UIStackView(arrangedSubviews: [likeButton, commentButton])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
         
        addSubview(stack)
        stack.anchor(
            top: postImageView.bottomAnchor, paddingTop: 0,
            bottom: nil, paddingBottom: 0,
            left: leftAnchor, paddingLeft: 14,
            right: nil, paddingRight: 0,
            height: 50, width: 75,
            centerByX: nil, centerByY: nil
        )
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
