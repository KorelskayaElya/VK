//
//  Post.swift
//  VK
//
//  Created by Эля Корельская on 11.08.2023.
//

import UIKit

struct Post {
    let user: User
    let textPost: String
    var imagePost: UIImage? = nil

    var isLikedByCurrentUser = false
}