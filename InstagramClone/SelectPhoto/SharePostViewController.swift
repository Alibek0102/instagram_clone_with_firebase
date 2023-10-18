//
//  SharePostViewController.swift
//  InstagramClone
//
//  Created by Алибек Аблайулы on 28.09.2023.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class SharePhotoViewController: UIViewController {
    
    var dbRef: DatabaseReference!
    let storage = Storage.storage()
    
    var selectedImage: UIImage? {
        didSet {
            imageView.image = selectedImage
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .red
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.showsVerticalScrollIndicator = false
        tv.bounces = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#f3f3f3")
        dbRef = Database.database().reference()
        setupNavigationButtons()
        setupAreaForTyping()
    }
    
    private func setupNavigationButtons(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Поделиться", style: .plain, target: self, action: #selector(sharePost))
    }
    
    @objc private func sharePost(){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let image = imageView.image else { return }
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
        guard let text = textView.text, text.count > 5 else { return }
        
        let randomId = UUID().uuidString
        let storageRef = self.storage.reference().child("postimages/\(randomId)")
        navigationItem.rightBarButtonItem?.isEnabled = false
                
        storageRef.putData(uploadData) { metadata, err in
            guard let _ = metadata else {
                if(err != nil){
                    return
                }
                return
            }
            storageRef.downloadURL { url, urlErr in
                guard let url = url else {
                    if(urlErr != nil){
                        return
                    }
                    return
                }
                
                let sendUrl = url.absoluteString
                let autoId = UUID().uuidString
                let values: [String : Any] = [
                    "imageUrl": sendUrl,
                    "text": text,
                    "created_at": Date().timeIntervalSince1970,
                    "imageHeight": self.imageView.frame.height,
                    "imageWight": self.imageView.frame.width,
                ] as [String: Any]
                
                self.dbRef.child("posts").child(userId).child(autoId).updateChildValues(values) { err, databaseReference in
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.dismiss(animated: true)
                }
            }
        }
        
    }
    
    private func setupAreaForTyping(){
        let viewForTyping = UIView()
        viewForTyping.backgroundColor = .white
        view.addSubview(viewForTyping)
        
        viewForTyping.anchor(
            top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0,
            bottom: nil, paddingBottom: 0,
            left: view.leftAnchor, paddingLeft: 0,
            right: view.rightAnchor, paddingRight: 0,
            height: 100, width: 0,
            centerByX: nil, centerByY: nil
        )
        
        viewForTyping.addSubview(imageView)
        imageView.anchor(
            top: viewForTyping.topAnchor, paddingTop: 8,
            bottom: viewForTyping.bottomAnchor, paddingBottom: -8,
            left: viewForTyping.leftAnchor, paddingLeft: 8,
            right: nil, paddingRight: 0,
            height: 0, width: 90,
            centerByX: nil, centerByY: nil
        )
        
        viewForTyping.addSubview(textView)
        textView.anchor(
            top: viewForTyping.topAnchor, paddingTop: 0,
            bottom: viewForTyping.bottomAnchor, paddingBottom: 0,
            left: imageView.rightAnchor, paddingLeft: 8,
            right: viewForTyping.rightAnchor, paddingRight: -8,
            height: 0, width: 0,
            centerByX: nil, centerByY: nil
        )
    }
    
}
