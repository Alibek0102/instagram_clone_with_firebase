//
//  PostsViewController.swift
//  InstagramClone
//
//  Created by Алибек Аблайулы on 02.09.2023.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class PostsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let postId: String = "postId"
    let postHeaderId: String = "postHeaderId"
    let postFooterId: String = "postFooterId"
    let reference = Database.database().reference()
    var posts = [Post]()
    
    
    init(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#f7f7f7")
        navigationController?.tabBarController?.tabBar.scrollEdgeAppearance = navigationController?.tabBarController?.tabBar.standardAppearance
        setupNavBarController()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: postId)
        allPostsFromDatabase()
    }
    
    private func setupNavBarController(){
        let image = UIImage(named: "instagramBlackLogo")
        let imgView = UIImageView()
        imgView.image = image
        imgView.contentMode = .scaleAspectFit
        navigationItem.titleView = imgView
        
        let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "camera")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PostsViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postId, for: indexPath) as! PhotoCell
        cell.post = posts[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = view.frame.width
        return CGSize(width: size, height: size + 50 + 80 + 120)
    }
    
}

extension PostsViewController {
    private func allPostsFromDatabase(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        reference.child("/posts").child(uid).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let post = Post(dictionary)
            self.posts.append(post)
            self.collectionView.reloadData()
        }
    }
}


