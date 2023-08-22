//
//  CoreDataService.swift
//  VK
//
//  Created by Эля Корельская on 22.08.2023.
//

import CoreData
import UIKit

class CoreDataService {
    static let shared = CoreDataService()
    var user = User(identifier: "annaux_designer",
               username: "Анна Мищенко",
               profilePicture: UIImage(named:"header1"),
               status: "дизайнер",
               gender: "Женский",
               birthday: "01.02.1997",
               city: "Москва",
               hobby: "футбол",
               school:"Дизайнер",
               university: "школа 134",
               work: "Московский")
    
    init() {
        reloadPosts()
    }
    var posts: [Entity] = []
   // lazy var context: NSManagedObjectContext = self.persistentContainer.viewContext
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Post")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
       // container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    func saveContext() {
//        if postExists(postModel: post) == true {
//           // AlertManager.showAlert(on: ProfileViewController, with: "Post already saved", message: "")
//            print("post already save")
//        } else {
//            persistentContainer.performBackgroundTask { context in
//                let post = PostEntity(context: context)
//                post.textPost = post.textPost
//                post.imagePost = post.imagePost
//                guard context.hasChanges else { return }
//                do {
//                    try context.save()
//                } catch let error as NSError {
//                    print("Unresolved error \(error), \(error.userInfo)")
//                }
//           }
//        }
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
//    func postExists(postModel: Post) -> Bool {
//        let postFetch: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
//        postFetch.predicate = NSPredicate(format: "textPost contains[c] %@ AND imagePost contains[c]", postModel.textPost, postModel.imagePost ?? "")
//        var isExist = false
//        do {
//            let results = try context.fetch(postFetch) as [NSManagedObject]
//            if results.count > 0 {
//                isExist = true
//            } else {
//                isExist = false
//            }
//        } catch {
//            print("error \(error.localizedDescription)")
//        }
//        return isExist
//    }

    /// перезагрузить
    func reloadPosts() {
        let fetchRequest = Entity.fetchRequest()
        posts = (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
    }
    /// создание поста
    func addPost(text: String, image: Data?) {
        let post = Entity(context: persistentContainer.viewContext)
        post.textPost = text
        post.username = user.username
        post.profilePicture = user.profilePicture?.pngData()
        post.status = user.status
        post.imagePost = image
        post.dateCreated = String.date(with: Date())
        saveContext()
        reloadPosts()
    }
    /// удалить пост
    func deletePost(post: Entity) {
        persistentContainer.viewContext.delete(post)
        saveContext()
        reloadPosts()
    }
//    func getContextByText(textPost: String) -> [Post]{
//        let postFetch: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
//        postFetch.predicate = NSPredicate(format: "textPost contains[c] %@", textPost)
//        var savedPostsData: [Post] = []
//        do {
//            let savedPosts = try context.fetch(postFetch)
//            for data in savedPosts as [NSManagedObject] {
//                savedPostsData.append(.init(
//                    textPost: data.value(forKey: "textPost") as! String,
//                    status: data.value(forKey: "status") as! String,
//                    profilePicture: data.value(forKey: "profilePicture") as! String,
//                    username: data.value(forKey: "username") as! String,
//                    imagePost: data.value(forKey: "imagePost") as! String,
//                    dateCreated: data.value(forKey: "dateCreated") as! String
//                ))
//            }
//        } catch {
//            print("error \(error.localizedDescription)")
//        }
//        return savedPostsData
//    }
    
    
    

}

