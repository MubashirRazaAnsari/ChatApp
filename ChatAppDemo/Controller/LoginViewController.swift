//
//  LoginViewController.swift
//  ChatAppDemo
//
//  Created by Admin on 14/09/2022.
//

import UIKit
import FirebaseAuth
class LoginViewController: UIViewController, UITextFieldDelegate {
    
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFill
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
    
    private let loginbutton : UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
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
        title = "Login"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target:self, action: #selector(DidTappedButton))
        loginbutton.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginbutton)
        
        
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame =  CGRect(x: (scrollView.width-size)/2,
                                  y: 20,
                                  width: size,
                                  height: size)
        
        emailField.frame =  CGRect(x: 30,
                                   y: imageView.bottom+5,
                                   width: scrollView.width-60,
                                   height: 52)
        passwordField.frame =  CGRect(x: 30,
                                   y: emailField.bottom+5,
                                   width: scrollView.width-60,
                                   height: 52)
        loginbutton.frame =  CGRect(x: 30,
                               y: passwordField.bottom+10,
                               width: scrollView.width-60,
                               height: 52)
    }
    
    @objc private func loginButtonAction(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text ,
              let password = passwordField.text ,
              !email.isEmpty,
              !password.isEmpty,
              password.count >= 6 else{
            alertUserLoginError()
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult , error in
            guard let strongSelf = self else {
                return
            }
            
            
            guard let result = authResult,  error == nil else {
                print("problem logging-in User email/password")
                return
                
            }
            let user = result
            print("User \(user) has been Logged in")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
        
    }
    
    func alertUserLoginError(){
        let alert = UIAlertController(title: "Whoops", message: "Please Enter all the information", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func DidTappedButton(){
        let vc = SignUpViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    

   

}
extension LoginViewController :UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            loginButtonAction()
        }
        
        
        return true
    }
        
}
    
    

