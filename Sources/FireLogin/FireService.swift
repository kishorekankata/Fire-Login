//
//  File.swift
//  
//
//  Created by KISHORE KANKATA on 13/04/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreInternal
import FirebaseFirestoreInternalWrapper
import FirebaseFirestoreSwift

public class FireService {
    
    let db: Firestore
    public static let shared = FireService()
    
    private init() {
        db = Firestore.firestore()
    }
    
    let jsonEncoder: JSONEncoder = .init()
    let jsonDecoder: JSONDecoder = .init()
    
}

public extension FireService {
    
    func saveUserFullName(name: String, completion: @escaping ((String?)->())) {
        print(#function)
        let userProfile = FireAuthentication.shared.currentUser?.createProfileChangeRequest()
        userProfile?.displayName = name
        userProfile?.commitChanges { error in
            print(error?.localizedDescription ?? "Success")
            completion(error?.localizedDescription)
        }
    }
    
    func saveUserProfileURL(url: URL?, completion: @escaping ((String?)->())) {
        print(#function)
        guard let url = url else {
            completion("Error: URL is empty")
            return
        }
        let userProfile = FireAuthentication.shared.currentUser?.createProfileChangeRequest()
        userProfile?.photoURL = url
        userProfile?.commitChanges { error in
                print(error?.localizedDescription ?? "Success")
                completion(error?.localizedDescription)
        }
    }
    
    func saveUserInformation(userId: String, name: String, photoURL: String?, email: String) {
        print(#function)
        var userModel: UserModel = .init(id: userId,
                                         name: name,
                                         createdAt: .init(date: Date()),
                                         updatedAt: .init(date: Date()),
                                         profileImageURL: photoURL,
                                         email: email)
        if let phoneNumber = FireAuthentication.shared.currentUser?.phoneNumber {
            userModel.phoneNumber = phoneNumber
        }
        
        do {
            try self.db.collection("users").document(userModel.id!).setData(from: userModel)
            UserDefaults.standard.set(name, forKey: Constants.userFullName)
            UserDefaults.standard.set(userModel.id, forKey: Constants.userDocumentID)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateUserInformation(forUser userId: String, photoURL: String?, name: String, email: String, completion: @escaping (String?)->()) {
        print(#function)
        self.userModel(withDocumentID: userId, model: { model, error in
            var userModel: UserModel = model ?? .init()
            userModel.id = userId
            userModel.name = name
            userModel.updatedAt = .init(date: Date())
            userModel.email = email
            if let phoneNumber = FireAuthentication.shared.currentUser?.phoneNumber {
                userModel.phoneNumber = phoneNumber
            }
            if photoURL != nil {
                userModel.profileImageURL = photoURL
            }
            do {
                let existingDocument = self.db.collection(Constants.Collections.users).document(userId)
                try existingDocument.setData(from: userModel, completion: { error in
                    if error == nil {
                        UserDefaults.standard.set(name, forKey: Constants.userFullName)
                    } else {
                        print(error?.localizedDescription ?? .init())
                    }
                    completion(error?.localizedDescription)
                })
            } catch {
                print(error.localizedDescription)
                completion(error.localizedDescription)
            }
        })
        
    }
    
    func updateMobileNumber(_ phoneNumber: String? = nil, userModel: UserModel) {
        print(#function)
        var userModel = userModel
        userModel.phoneNumber = phoneNumber
        userModel.updatedAt = .init(date: Date())
        do {
            let existingDocument = self.db.collection(Constants.Collections.users).document(userModel.id)
            try existingDocument.setData(from: userModel, completion: { error in
                print(error?.localizedDescription ?? "Successfully saved Phone number for \(userModel.id ?? .init())")
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func userModel(fromCache: Bool = false, withDocumentID userDocId: String, model: @escaping (UserModel?, String?) -> ()) {
        print(#function)
        guard !userDocId.isEmpty else {
            model(nil, "Empty userId")
            return
        }
        let docRef = db.collection(Constants.Collections.users).document(userDocId)
        docRef.getDocument(source: fromCache ? .cache : .server) { docSnapShot, error in
            if let err = error {
                print("Error getting documents: \(err)")
                model(nil, "Error getting documents: \(err)")
            } else {
                do {
                    let userModel: UserModel? = try docSnapShot?.data(as: UserModel.self)
                    model(userModel, nil)
                } catch {
                    model(nil, error.localizedDescription)
                }
            }
        }
    }
    
}


public struct UserModel: Codable {
    @DocumentID var id: String!
    var name: String?
    @FirebaseFirestoreSwift.ServerTimestamp var createdAt: Timestamp?
    @FirebaseFirestoreSwift.ServerTimestamp var updatedAt: Timestamp?
    var profileImageURL: String?
    var email: String?
    var phoneNumber: String?
}
