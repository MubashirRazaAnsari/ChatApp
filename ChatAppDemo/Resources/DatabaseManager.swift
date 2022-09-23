//
//  DatabaseManager.swift
//  ChatAppDemo
//
//  Created by Admin on 24/09/2022.
//

import Foundation
import FirebaseDatabase

final class DataBaseManager {
    
    static let shared = DataBaseManager()
    
    private let database = Database.database().reference()
    
    
}

extension DataBaseManager{
    
    ///Email Verification to check if the email already exist or not
    
    public func userExist(with email:String,completion: @escaping ((Bool) -> Void)){
        
        database.child(email).observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.value as? String != nil else {
            completion(false)
            return
        }
        completion(true)
        })
    }
    
    
    
    ///Insert New User Into DataBase
    
    public func InsertUser(with user: ChatAppUser){
        database.child(user.emailAddress).setValue([
            "first_Name": user.firstName,
            "last_Name" : user.lastName
        ])
    }
    
    
}
struct ChatAppUser {
    let firstName : String
    let lastName : String
    let emailAddress : String
//    let profilePicture : String
}
