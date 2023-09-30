//
//  LoginViewController.swift
//  InstagramClone
//
//  Created by Алибек Аблайулы on 15.09.2023.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    lazy var logoScreenView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = UIColor(hexString: "#73b7de")
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "instagramIcon")
        imageView.contentMode = .scaleAspectFill
        
        contentView.addSubview(imageView)
        imageView.anchor(
            top: nil, paddingTop: 0,
            bottom: nil, paddingBottom: 0,
            left: nil, paddingLeft: 0,
            right: nil, paddingRight: 0,
            height: 60, width: 220,
            centerByX: contentView.centerXAnchor, centerByY: contentView.centerYAnchor
        )
        
        return contentView
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        
        let firstAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.boldSystemFont(ofSize: 14),
        ]
        
        let secondAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor(hexString: "#73b7de"),
            .font: UIFont.boldSystemFont(ofSize: 14)
        ]
        
        let attributedString = NSMutableAttributedString(string: "У вас еще нет аккаунта? ", attributes: firstAttributes)
        attributedString.append(NSAttributedString(string: "Зарегистироваться", attributes: secondAttributes))
        
        button.setAttributedTitle(attributedString, for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email..."
        tf.backgroundColor = UIColor(named: "#f7f7f7")
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
        var tf = UITextField()
        tf.placeholder = "Password..."
        tf.isSecureTextEntry = true
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(named: "#f7f7f7")
        tf.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        return tf
    }()
    
    lazy var signInButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Войти", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 5
        btn.backgroundColor = UIColor(hexString: "#e2e2e2")
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return btn
    }()
    
    @objc private func handleLogin(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { data, error in
            guard let _ = data else {
                if let err = error {
                    print(err)
                }
                return
            }
             
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {
                return
            }
            
            let mainTabBarController = delegate.window?.rootViewController as! MainTabBarController
            mainTabBarController.setupTabBarControllers()
        
            self.dismiss(animated: true)
        }
    }
    
    @objc private func handleInputChange(){
        let inputValidation = emailTextField.text?.count ?? 0 > 0
        && passwordTextField.text?.count ?? 0 > 0
        
        if(inputValidation){
            signInButton.isEnabled = true
            signInButton.backgroundColor = UIColor(hexString: "#73b7de")
        } else {
            signInButton.isEnabled = false
            signInButton.backgroundColor = UIColor(hexString: "#e2e2e2")
        }
         
    }
    
    @objc func handleSignUp(){
        let signUpViewController = SignUpViewController()
        navigationController?.pushViewController(signUpViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        view.addSubview(signUpButton)
        signUpButton.anchor(
            top: nil, paddingTop: 0,
            bottom: view.bottomAnchor,
            paddingBottom: -20,
            left: view.leftAnchor, paddingLeft: 0,
            right: view.rightAnchor, paddingRight: 0,
            height: 50, width: 0,
            centerByX: nil, centerByY: nil)
        
        view.addSubview(logoScreenView)
        logoScreenView.anchor(
            top: view.topAnchor, paddingTop: 0,
            bottom: nil, paddingBottom: 0,
            left: view.leftAnchor, paddingLeft: 0,
            right: view.rightAnchor, paddingRight: 0,
            height: 200, width: 0,
            centerByX: nil, centerByY: nil
        )
        
        setupTextFields()
    }
    
    fileprivate func setupTextFields(){
        let stackView = UIStackView(arrangedSubviews: [
            emailTextField,
            passwordTextField,
            signInButton
        ])
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(
            top: logoScreenView.bottomAnchor, paddingTop: 50,
            bottom: nil, paddingBottom: 0,
            left: view.leftAnchor, paddingLeft: 40,
            right: view.rightAnchor, paddingRight: -40,
            height: 140, width: 0,
            centerByX: nil, centerByY: nil)
    }
}
