//
//  SignUpViewController.swift
//  ChatAppDemo
//
//  Created by Admin on 14/09/2022.
//

import UIKit
import FirebaseAuth
import FirebaseCore
class SignUpViewController: UIViewController, UITextFieldDelegate {

    
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName:"person.circle")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private let emailField : UITextField = {
        let efield = UITextField()
        efield.autocapitalizationType = .none
        efield.autocorrectionType = .no
        efield.returnKeyType = .continue
        efield.layer.borderWidth = 1
        efield.layer.cornerRadius = 12
        efield.layer.borderColor = UIColor.lightGray.cgColor
        efield.placeholder = "Email"
        efield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        efield.leftViewMode = .always
        efield.backgroundColor = .white
        return efield
    }()
    private let firstNameField : UITextField = {
        let efield = UITextField()
        efield.autocapitalizationType = .none
        efield.autocorrectionType = .no
        efield.returnKeyType = .continue
        efield.layer.borderWidth = 1
        efield.layer.cornerRadius = 12
        efield.layer.borderColor = UIColor.lightGray.cgColor
        efield.placeholder = "First Name"
        efield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        efield.leftViewMode = .always
        efield.backgroundColor = .white
        return efield
    }()
    private let lastNameField : UITextField = {
        let efield = UITextField()
        efield.autocapitalizationType = .none
        efield.autocorrectionType = .no
        efield.returnKeyType = .continue
        efield.layer.borderWidth = 1
        efield.layer.cornerRadius = 12
        efield.layer.borderColor = UIColor.lightGray.cgColor
        efield.placeholder = "Last Name"
        efield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        efield.leftViewMode = .always
        efield.backgroundColor = .white
        return efield
    }()
    private let passwordField : UITextField = {
        let efield = UITextField()
        efield.autocapitalizationType = .none
        efield.autocorrectionType = .no
        efield.returnKeyType = .done
        efield.layer.borderWidth = 1
        efield.layer.cornerRadius = 12
        efield.layer.borderColor = UIColor.lightGray.cgColor
        efield.placeholder = "Password"
        efield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        efield.leftViewMode = .always
        efield.backgroundColor = .white
        efield.isSecureTextEntry = true
        return efield
    }()
    
    private let signupbutton : UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Sign up"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target:self, action: #selector(DidTappedButton))
        signupbutton.addTarget(self, action: #selector(signupButtonAction), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(signupbutton)
        
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTappedimage))
     
        imageView.addGestureRecognizer(gesture)
        

    }
    
    @objc private func didTappedimage(){
        presentPhotoActionSheet()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame =  CGRect(x: (scrollView.width-size)/2,
                                  y: 20,
                                  width: size,
                                  height: size)
        imageView.layer.cornerRadius = imageView.width/2.0
        firstNameField.frame =  CGRect(x: 30,
                                   y: imageView.bottom+10,
                                   width: scrollView.width-60,
                                   height: 52)
        lastNameField.frame =  CGRect(x: 30,
                                   y: firstNameField.bottom+5,
                                   width: scrollView.width-60,
                                   height: 52)
        emailField.frame =  CGRect(x: 30,
                                   y: lastNameField.bottom+5,
                                   width: scrollView.width-60,
                                   height: 52)
        passwordField.frame =  CGRect(x: 30,
                                   y: emailField.bottom+5,
                                   width: scrollView.width-60,
                                   height: 52)
        signupbutton.frame =  CGRect(x: 30,
                               y: passwordField.bottom+10,
                               width: scrollView.width-60,
                               height: 52)
    }
    
    @objc private func signupButtonAction(){
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()

        guard let firstName = firstNameField.text,
              let lastName = lastNameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty,
              !firstName.isEmpty,
              !lastName.isEmpty ,
              !password.isEmpty,
              password.count >= 6 else{
            alertUsersignupError()
            return
        }
        DataBaseManager.shared.userExist(with: email, completion: {[weak self]exists in
            guard let strongSelf = self else {
                return
            }
            
            guard !exists else {
                //user already exists
                strongSelf.alertUsersignupError(message: "User with this email already exists")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {authResult , error in
                
                guard let result = authResult,  error == nil else {
                print("problem creating a User email/password")
                return
                
            }
                let user = result
                print("User \(user) has been created")
                DataBaseManager.shared.InsertUser(with: ChatAppUser(firstName: firstName,
                                                                    lastName: lastName,
                                                                    emailAddress: email))
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            })
            
        })
        
        
        
    }

    
    
    func alertUsersignupError(message : String = "Please Enter all the information to create a new account"){
        let alert = UIAlertController(title: "Whoops", message: message , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func DidTappedButton(){
        let vc = SignUpViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    

   

}
extension SignUpViewController :UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            signupButtonAction()
        }
        
        
        return true
    }
        
}
extension SignUpViewController : UINavigationControllerDelegate , UIImagePickerControllerDelegate {
   
    func presentPhotoActionSheet(){
        
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How do you like to take the Profile Picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler:{[weak self] _ in
                                                    self?.openCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Select Photo",
                                            style: .default,
                                            handler:{[weak self] _ in
                                                    self?.openPhotoPicker()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        present(actionSheet, animated: true)
        
    }
    
    func openCamera(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    func openPhotoPicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true , completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true , completion: nil)
        guard let selectedImg = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.imageView.image = selectedImg
    }
    
    
}
