//
//  Post.swift
//  VK
//
//  Created by Эля Корельская on 11.08.2023.
//

import UIKit

struct Post {
    let uuid = UUID().uuidString
    let user: User
    let textPost: String
    var imagePost: UIImage? = nil

    var isLikedByCurrentUser = false
    mutating func toggleLike() {
        isLikedByCurrentUser.toggle()
    }
    var isSavedByCurrentUser = false
    mutating func toggleSave() {
        isSavedByCurrentUser.toggle()
    }
    var isShowingComments: Bool = false
    
    var comments: [PostComment] = []
}
