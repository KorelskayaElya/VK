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
        reloadPhoto()
    }
    var posts: [PostEntity] = []
    var photos: [PhotoEntity] = []
    lazy var context: NSManagedObjectContext = self.persistentContainer.viewContext
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Post")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    /// перезагрузить
    func reloadPosts() {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:"dateCreated", ascending: false)]
        do {
            let filteredPosts = try persistentContainer.viewContext.fetch(fetchRequest)
            posts = filteredPosts
        } catch {
            print("Error filtering posts: \(error.localizedDescription)")
            posts = []
        }
    }
    /// перезагрузить фотографии
    func reloadPhoto() {
        let fetchRequest = PhotoEntity.fetchRequest()
        photos = (try? persistentContainer.viewContext.fetch(fetchRequest)) ?? []
    }
    /// добвление изображения
    func addPhoto(image: Data?) {
        let photo = PhotoEntity(context: persistentContainer.viewContext)
        photo.photo = image
        saveContext()
        reloadPhoto()
    }
    /// создание поста
    func addPost(text: String, image: Data?) {
        let post = PostEntity(context: persistentContainer.viewContext)
        post.textPost = text
        post.username = user.username
        if var profilePicture = user.profilePicture {
            let profilePictureJPEG = profilePicture.jpegData(compressionQuality: 0.1)
            post.profilePicture = profilePictureJPEG
        }
        post.status = user.status
        post.imagePost = image
        post.dateCreated = Date()
        saveContext()
        reloadPosts()
    }
    /// удалить пост
    func deletePost(post: PostEntity) {
        persistentContainer.viewContext.delete(post)
        saveContext()
        reloadPosts()
    }
    /// фильтрация по тексту
    func filterPostsBy(text: String) -> [PostEntity] {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "textPost contains[c] %@", text)
        
        do {
            let filteredPosts = try persistentContainer.viewContext.fetch(fetchRequest)
            return filteredPosts
        } catch {
            print("Error filtering posts: \(error.localizedDescription)")
            return []
        }
    }
    /// лайкать пост
    func getLikedPosts() -> [PostEntity] {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isLikedByCurrentUser == true")
        do {
            let filteredPosts = try persistentContainer.viewContext.fetch(fetchRequest)
            return filteredPosts
        } catch {
            print("Error filtering posts: \(error.localizedDescription)")
            return []
        }
    }
    /// добавлять закладки
    func getSavedPosts() -> [PostEntity] {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isSavedByCurrentUser == true")
        do {
            let filteredPosts = try persistentContainer.viewContext.fetch(fetchRequest)
            return filteredPosts
        } catch {
            print("Error filtering posts: \(error.localizedDescription)")
            return []
        }
    }
    
    
    

}

