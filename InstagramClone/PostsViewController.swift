//
//  PostsViewController.swift
//  InstagramClone
//
//  Created by Алибек Аблайулы on 02.09.2023.
//

import UIKit

class PostsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#f7f7f7")
        navigationController?.tabBarController?.tabBar.scrollEdgeAppearance = navigationController?.tabBarController?.tabBar.standardAppearance
        navigationItem.title = "Главная"
    }
}
