//
//  ViewController.swift
//  InstagramClone
//
//  Created by Алибек Аблайулы on 31.08.2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ref: DatabaseReference!
    let storage = Storage.storage()
    
    private lazy var addPhotoButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setImage(UIImage(named: "addImage"), for: .normal)
        bt.addTarget(self, action: #selector(setImageHandler), for: .touchUpInside)
        return bt
    }()
    
    @objc func setImageHandler(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        DispatchQueue.main.async {
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage = info[.originalImage] as! UIImage
        addPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width / 2
        addPhotoButton.layer.masksToBounds = true
        dismiss(animated: true , completion: nil)
    }
    
    private lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email..."
        tf.backgroundColor = UIColor(red: 26, green: 26, blue: 26, alpha: 0.1)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        return tf
    }()
    
    private lazy var userNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username..."
        tf.backgroundColor = UIColor(red: 26, green: 26, blue: 26, alpha: 0.1)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        return tf
    }()
    
    private lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password..."
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(red: 26, green: 26, blue: 26, alpha: 0.1)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        return tf
    }()
    
    private lazy var signUpButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("Sign Up", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        bt.backgroundColor = .lightGray
        bt.layer.cornerRadius = 5
        bt.isEnabled = false
        
        bt.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return bt
    }()
    
    lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        
        let firstAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.boldSystemFont(ofSize: 14),
        ]
        
        let secondAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor(hexString: "#73b7de"),
            .font: UIFont.boldSystemFont(ofSize: 14)
        ]
        
        let attributedString = NSMutableAttributedString(string: "Есть аккаунт? ", attributes: firstAttributes)
        attributedString.append(NSAttributedString(string: "Вход", attributes: secondAttributes))
        
        button.setAttributedTitle(attributedString, for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSignIn(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text, email.count > 8 else { return }
        guard let userName = userNameTextField.text, userName.count > 3 else { return }
        guard let password = passwordTextField.text, password.count > 8 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { data, error in
            guard let data = data else {
                if let error = error {
                    print("Error &", error)
                }
                return
            }
            
            let randomInt = Int.random(in: 1..<100000)
            let storageReference = self.storage.reference().child("profile_images/\(randomInt).jpg")
            guard let image = self.addPhotoButton.imageView?.image else { return }
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
            
            storageReference.putData(uploadData) { metadata, error in
                if error != nil {
                    print("error upload data")
                    return
                }
                
                storageReference.downloadURL { url, error in
                    if error != nil {
                        print("error")
                        return
                    }
                    
                    let urlOfPhoto = url?.absoluteString
                    let uid = data.user.uid
                    let userValue = [
                        "userName": userName,
                        "profile_image": urlOfPhoto
                    ]
                    let value = [uid: userValue]
                    self.ref.child("users").updateChildValues(value, withCompletionBlock: { error, ref in
                        if error != nil {
                            print("error")
                            return
                        }
                        
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else {
                            return
                        }
                        
                        let mainTabBarController = delegate.window?.rootViewController as! MainTabBarController
                        mainTabBarController.setupTabBarControllers()
                        self.dismiss(animated: true)
                    })
                }
            }
        }
    }
    
    @objc func handleInputChange() {
        let isInputValid =
        emailTextField.text?.count ?? 0 > 0
        && userNameTextField.text?.count ?? 0 > 0
        && passwordTextField.text?.count ?? 0 > 0
        
        if isInputValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .systemBlue
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = .lightGray
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#f7f7f7")
        ref = Database.database().reference()
        self.setConstraints()
        self.stackOfTextField()
        
        
        view.addSubview(signInButton)
        signInButton.anchor(
            top: nil, paddingTop: 0,
            bottom: view.bottomAnchor,
            paddingBottom: -20,
            left: view.leftAnchor, paddingLeft: 0,
            right: view.rightAnchor, paddingRight: 0,
            height: 50, width: 0,
            centerByX: nil, centerByY: nil)
    }
    
    private func setConstraints(){
        view.addSubview(addPhotoButton)
        
        addPhotoButton.anchor(
            top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 40,
            bottom: nil, paddingBottom: 0,
            left: nil, paddingLeft: 0,
            right: nil, paddingRight: 0,
            height: 140,
            width: 140,
            centerByX: view.centerXAnchor,
            centerByY: nil
        )
    }
    
    private func stackOfTextField(){
        let stack = UIStackView(arrangedSubviews:
            [
                emailTextField,
                userNameTextField,
                passwordTextField,
                signUpButton
            ]
        )
        
        view.addSubview(stack)
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 10
        
        stack.anchor(
            top: addPhotoButton.bottomAnchor, paddingTop: 40,
            bottom: nil, paddingBottom: 0,
            left: view.leftAnchor, paddingLeft: 40,
            right: view.rightAnchor,
            paddingRight: -40,
            height: 200,
            width: 0,
            centerByX: nil,
            centerByY: nil
        )
    }
}

extension UIView {
    func anchor(
        top: NSLayoutYAxisAnchor?,
        paddingTop: CGFloat,
        bottom: NSLayoutYAxisAnchor?,
        paddingBottom: CGFloat,
        left: NSLayoutXAxisAnchor?,
        paddingLeft: CGFloat,
        right: NSLayoutXAxisAnchor?,
        paddingRight: CGFloat,
        height: CGFloat,
        width: CGFloat,
        centerByX: NSLayoutXAxisAnchor?,
        centerByY: NSLayoutYAxisAnchor?
    ){
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let centerX = centerByX {
            self.centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        
        if let centerY = centerByY {
            self.centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
}

