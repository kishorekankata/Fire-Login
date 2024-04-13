//
//  File.swift
//  
//
//  Created by KISHORE KANKATA on 13/04/24.
//

import FirebaseAuth
import Firebase
import Combine
import SwiftUI

public struct FireLoginResponse {
    public var error: String?
    public var code: Int?
    
    public init(error: String? = nil, code: Int? = nil) {
        self.error = error
        self.code = code
    }
}

public struct FireLogoutResponse {
    public var error: String?
}


public class FireAuthentication {
    
    private init() {}
    
    public static let shared = FireAuthentication()
    private let fireBaseAuth = Auth.auth()
    private var verificationId: String?
    
    public var currentUser: User? {
        Auth.auth().currentUser
    }
    
    public var currentUserEmail: String {
        currentUser?.email ?? "No email found"
    }
    
    public func userStatus() -> UserState {
        guard let user = currentUser else {
            return .welcome
        }
        if !(user.isEmailVerified || !(user.phoneNumber?.isEmpty ?? true)) {
            return .emailNotVerified
        } else if user.displayName?.isEmpty ?? true {
            return .signupNotCompleted
        }
        return .loggedIn
    }
    
    public func startAuth(phoneNumber: String, completion: @escaping (Bool)->Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationId, error in
            guard let verificationId = verificationId else {
                completion(false)
                print(error?.localizedDescription ?? "no error message")
                return
            }
            self?.verificationId = verificationId
            completion(true)
        }
    }
    
    public func verifyCode(smsCode: String, completion: @escaping (Bool)->Void) {
        guard let verificationId = verificationId else {
            completion(false)
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: smsCode)
        
        currentUser?.link(with: credential, completion: { result, error in
            if error == nil {
                print("--------------Successfully linked phone with Email")
                completion(true)
            } else {
                print("-------------Failure in linking phone with Email")
                completion(false)
            }
        })
    }
    
    public func createUser(with email: String, password: String, completionHandler: @escaping  (FireLoginResponse?)->()) {
        fireBaseAuth.createUser(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(.init(error: error.localizedDescription))
            } else if let user = authDataResult?.user {
                print("Signed in as user \(user.uid), with email: \(user.email ?? "")")
                UserDefaults.standard.set(email, forKey: Constants.userEmailID)
                completionHandler(.init())
            } else {
                completionHandler(.init(error: "Something went wrong"))
            }
        }
    }
    
    public func sendVerificationLink() {
        guard let user = currentUser else {
            print("No user found to send verification link.")
            return
        }
        
        let _ = user.sendEmailVerification { error in
            guard let error = error else {
                print("user email verification sent")
                return
            }
            print(error)
            print("Some error while sending verification link")
        }
    }
    
    public func signInUser(with email: String, password: String, completionHandler: @escaping  (FireLoginResponse?)->()) {
        fireBaseAuth.signIn(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(.init(error: error.localizedDescription))
            } else if let user = authDataResult?.user {
                print("Signed in as user \(user.uid), with email: \(user.email ?? "")")
                
                UserDefaults.standard.set(email, forKey: Constants.userEmailID)
                UserDefaults.standard.set(user.uid, forKey: Constants.userDocumentID)
                UserDefaults.standard.set(user.displayName, forKey: Constants.userFullName)
                completionHandler(.init())
            } else {
                completionHandler(.init(error: "Something went wrong"))
            }
        }
    }
    
    public func logout() -> FireLogoutResponse {
        do {
            try fireBaseAuth.signOut()
            clearDefaults()
            return .init(error: nil)
        } catch {
            clearDefaults()
            return .init(error: error.localizedDescription)
        }
    }
    
    @MainActor
    public func changePassword(newPassword: String) async throws {
        try await self.currentUser?.updatePassword(to: newPassword)
    }
    
    @MainActor
    public func forgotPassword(withEmail email: String) async throws {
        try await fireBaseAuth.sendPasswordReset(withEmail: email)
    }
    
    private func clearDefaults() {
        UserDefaults.standard.set(nil, forKey: Constants.userEmailID)
        UserDefaults.standard.set(nil, forKey: Constants.userFullName)
        UserDefaults.standard.set(nil, forKey: Constants.userDocumentID)
    }
    
}
