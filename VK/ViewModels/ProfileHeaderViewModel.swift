//
//  ProfileHeaderViewModel.swift
//  VK
//
//  Created by Эля Корельская on 02.08.2023.
//

import Foundation

struct ProfileHeaderViewModel {
    var user: User
    var followerCount: Int
    var followingCount: Int
    var isFollowing: Bool?
    var publishedPhotos: Int
}

