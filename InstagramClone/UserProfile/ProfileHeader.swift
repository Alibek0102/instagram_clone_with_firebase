//
//  ProfileHeader.swift
//  InstagramClone
//
//  Created by Алибек Аблайулы on 10.09.2023.
//

import UIKit

class ProfileHeader: UICollectionViewCell {
    
    var user: User? {
        didSet {
            guard let imageUrl = user?.profile_image else { return }
            profileImage.fetchPhoto(urlString: imageUrl)
            self.userNameLabel.text = self.user?.userName
        }
    }
    
    var gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.grid.3x3"), for: .normal)
//        button.tintColor = .black
        return button
    }()
    
    var listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    var bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let profileImage:CustomImageView = {
        let imageView = CustomImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor(hexString: "#F7F7F7")
        return imageView
    }()
    
    let countPosts: UILabel = {
        let label = UILabel()
        label.text = "12\nпосты"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let countFollowers: UILabel = {
        let label = UILabel()
        label.text = "123\nподписчики"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let countFollowings: UILabel = {
        let label = UILabel()
        label.text = "15\nподписки"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Редактировать профиль", for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hexString: "#e2e2e2").cgColor
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(UIColor(hexString: "#000"), for: .normal)
        return button
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        self.addSubview(profileImage)
        profileImage.anchor(top: self.topAnchor, paddingTop: 12, bottom: nil, paddingBottom: 0, left: self.leftAnchor, paddingLeft: 12, right: nil, paddingRight: 0, height: 80, width: 80, centerByX: nil, centerByY: nil)
        profileImage.layer.cornerRadius = 80 / 2
        setupToolbar()
        setupUserInfo()
    }
    
    func setupToolbar(){
        let stack = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        self.addSubview(stack)
        stack.anchor(
            top: nil, paddingTop: 0,
            bottom: self.bottomAnchor, paddingBottom: 0,
            left: self.leftAnchor, paddingLeft: 0,
            right: self.rightAnchor, paddingRight: 0,
            height: 60, width: 0,
            centerByX: nil, centerByY: nil
        )
    }
    
    func setupUserInfo(){
        let stack = UIStackView(arrangedSubviews: [countPosts, countFollowers, countFollowings])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
    
        self.addSubview(stack)
        stack.anchor(
            top: self.topAnchor, paddingTop: 12,
            bottom: nil, paddingBottom: 0,
            left: profileImage.rightAnchor, paddingLeft: 12,
            right: self.rightAnchor, paddingRight: -12,
            height: 50, width: 0,
            centerByX: nil,
            centerByY: nil)
        
        self.addSubview(editProfileButton)
        editProfileButton.anchor(
            top: countPosts.bottomAnchor,paddingTop: 3,
            bottom: nil,paddingBottom: 0,
            left: countPosts.leftAnchor, paddingLeft: 0,
            right: countFollowings.rightAnchor, paddingRight: 0,
            height: 34, width: 0,
            centerByX: nil, centerByY: nil)
        
        self.addSubview(userNameLabel)
        userNameLabel.anchor(
            top: editProfileButton.bottomAnchor, paddingTop: 0,
            bottom: gridButton.topAnchor, paddingBottom: 0,
            left: self.leftAnchor, paddingLeft: 15,
            right: self.rightAnchor, paddingRight: -15,
            height: 0, width: 0,
            centerByX: nil, centerByY: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
