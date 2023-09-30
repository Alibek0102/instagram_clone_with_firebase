//
//  MainTabBarController.swift
//  InstagramClone
//
//  Created by Алибек Аблайулы on 02.09.2023.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if let index = index, index == 1{
            let layout = UICollectionViewFlowLayout()
            let vc = SelectPhotoViewController(collectionViewLayout: layout)
            let navVC = UINavigationController(rootViewController: vc)
            navVC.navigationBar.scrollEdgeAppearance = navVC.navigationBar.standardAppearance
            present(navVC, animated: true)
            return false
        }
        return true
    }
    
    private func setupViewControllers(){
        
        if (Auth.auth().currentUser?.uid) == nil {
            DispatchQueue.main.async {
                let vc = LoginViewController()
                let loginNavController = UINavigationController(rootViewController: vc)
                self.present(loginNavController, animated: true) {
                    loginNavController.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
                }
            }
            return
        }
        
        setupTabBarControllers()
    }
    
    private func getNavVC(vc: UIViewController, selectedImage: String, image: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.image = UIImage(systemName: image)
        navController.tabBarItem.selectedImage = UIImage(systemName: selectedImage)
        navController.navigationBar.scrollEdgeAppearance = navController.navigationBar.standardAppearance
        return navController
    }
    
    func setupTabBarControllers(){
        let postsVC = PostsViewController()
        let navPostsController = getNavVC(vc: postsVC, selectedImage: "photo.fill", image: "photo")
        
        let selectPhoto = UIViewController()
        let navSelectPhoto = getNavVC(vc: selectPhoto, selectedImage: "plus.app.fill", image: "plus.app")
        
        let profileVC = ProfileViewController()
        let navProfileController = getNavVC(vc: profileVC, selectedImage: "person.crop.circle", image: "person.crop.circle.fill")
        
        viewControllers = [navPostsController, navSelectPhoto, navProfileController]
        self.tabBar.tintColor = UIColor.black
        self.tabBar.unselectedItemTintColor = UIColor.gray
    }
}
