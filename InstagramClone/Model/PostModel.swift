//
//  PostModel.swift
//  InstagramClone
//
//  Created by Алибек Аблайулы on 16.10.2023.
//

import Foundation
import UIKit

struct Post {
    var created_at: String
    var imageHeight: Int
    var imageUrl: String
    var imageWight: Int
    var text: String
    
    init(_ dict: [String: Any]) {
        self.created_at = dict["created_at"] as? String ?? ""
        self.imageHeight = dict["imageHeight"] as? Int ?? 0
        self.imageUrl = dict["imageUrl"] as? String ?? ""
        self.imageWight = dict["imageWight"] as? Int ?? 0
        self.text = dict["text"] as? String ?? ""
    }
}

