//
//  File.swift
//  
//
//  Created by KISHORE KANKATA on 13/04/24.
//

import Foundation
import FirebaseStorage
import UIKit

public class FireStorage {
    
    private let storage: Storage
    public static let shared = FireStorage()
    
    private init() {
        storage = Storage.storage()
    }
    
    public func saveProfilePicture(image: UIImage, completion: @escaping (String?) -> ()) {
        guard let uid = FireAuthentication.shared.currentUser?.uid else {
            completion(nil)
            return
        }
        let ref = storage.reference(withPath: (Constants.Storage.profilePicturesFolder)).child("\(uid)_profile.jpeg")
        guard let imageData = image.jpegData(compressionQuality: CGFloat(AppConstants.CompressionQuality.profilePicture)) else {
            completion(nil)
            return
        }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                print("Failed to push image to Storage: \(err)")
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    print("Failed to retrieve downloadURL: \(err)")
                    completion(nil)
                    return
                }
                
                print("Successfully stored image with url: \(url?.absoluteString ?? "")")
                completion(url?.absoluteString)
            }
        }
    }
    
}
