//
//  ProfileHeaderViewModel.swift
//  VK
//
//  Created by Эля Корельская on 02.08.2023.
//

import Foundation

struct ProfileHeaderViewModel {
    let user: User
    let followerCount: Int
    let followingCount: Int
    let isFollowing: Bool?
    let publishedPhotos: Int
}

