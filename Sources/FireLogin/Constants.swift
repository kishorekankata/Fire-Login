//
//  File.swift
//  
//
//  Created by KISHORE KANKATA on 13/04/24.
//

import Foundation

public enum Constants {
    static let userDocumentID = "userId"
    static let userEmailID = "emailID"
    static let userFullName = "userFullName"
    
    enum Storage {
        static let profilePicturesFolder = "profile pictures"
        static let postsFolder = "posts"
    }
    
    enum Collections {
        static let users = "users"
    }
}

enum AppConstants {
    enum CompressionQuality {
        static let profilePicture: Float = 0.2
    }
}
