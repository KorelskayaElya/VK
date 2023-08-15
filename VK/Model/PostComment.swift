//
//  PostComment.swift
//  VK
//
//  Created by Эля Корельская on 11.08.2023.
//

import UIKit

struct PostComment {
    let text: String
    let user: User
    let date: Date

    static func mockCommets() -> [PostComment] {
        let user = User(identifier: "victor.dis", username: "Виктор",
                        profilePicture: UIImage(named: "person2"),
                        status: "дизайнер")
        var comments = [PostComment]()

        let text = [
            "Очень интересно",
            "This is rad",
            "Im learning so much!"
        ]

        for comment in text {
            comments.append(
                PostComment(
                    text: comment,
                    user: user,
                    date: Date()
                )
            )
        }

        return comments
    }
}

