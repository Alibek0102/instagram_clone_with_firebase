//
//  ProfileViewController.swift
//  InstagramClone
//
//  Created by Алибек Аблайулы on 02.09.2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let headerId = "headerId"
    let cellId = "cellId"
    let reference = Database.database().reference()
    
    var allPosts = [Post]()
    
    var user: User?
    
    init(){
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(hexString: "#f7f7f7")
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        navigationItem.title = "Профиль"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "door.right.hand.open")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(signOut))
        collectionView.register(ProfilePostPhotoCell.self, forCellWithReuseIdentifier: cellId)
        fetchData()
        fetchPosts()
    }
    
    @objc func signOut(){
        let alert = UIAlertController(title: "Выход с аккаунт!", message: "Точно хотите выйти с аккаунта?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { action in
            do {
                try Auth.auth().signOut()
                let vc = LoginViewController()
                let navVC = UINavigationController(rootViewController: vc)
                self.present(navVC, animated: true)
            } catch let err {
                print(err)
            }
        }))

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 3 - 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ProfilePostPhotoCell
        cell.post = allPosts[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! ProfileHeader
        header.user = self.user
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func fetchData(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        reference.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? NSDictionary else { return }
            self.user = User(dictionary as! [String : Any])
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func fetchPosts(){
        guard let uuid = Auth.auth().currentUser?.uid else { return }
        let dbRef = reference.child("/posts").child(uuid)
        
        dbRef.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let post = Post(dictionary)
            self.allPosts.append(post)
            self.collectionView.reloadData()
        }
    }
}

struct User {
    var userName: String
    var profile_image: String
    
    init(_ data: [String : Any] ){
        self.userName = data["userName"] as? String ?? ""
        self.profile_image = data["profile_image"] as? String ?? ""
    }
}

struct Post {
    var created_at: String
    var imageHeight: Int
    var imageUrl: String
    var imageWight: Int
    var text: String
    
    init(_ dict: [String: Any]) {
        self.created_at = dict["created_at"] as? String ?? ""
        self.imageHeight = dict["imageHeight"] as? Int ?? 0
        self.imageUrl = dict["imageUrl"] as? String ?? ""
        self.imageWight = dict["imageWight"] as? Int ?? 0
        self.text = dict["text"] as? String ?? ""
    }
}




