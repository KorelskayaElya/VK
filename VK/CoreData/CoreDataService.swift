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
    
    init() {
        reloadPosts()
        addPostPhotoToImageCache()
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
    func addPost(username: String, status: String, profilePicture: Data?,text: String, image: Data?) {
        let post = PostEntity(context: persistentContainer.viewContext)
        post.textPost = text
        post.username = username
        if var profilePicture = profilePicture {
            post.profilePicture = profilePicture
        }
        post.status = status
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
    /// добавить пост в кэш
    func addPostPhotoToImageCache() {
        for post in posts {
            if let imageData = post.imagePost {
                if let image = UIImage(data: imageData) {
                    let imageWidth = UIScreen.main.bounds.width - 100
                    let imageHeight = imageWidth*(image.size.height/image.size.width)
                    let imageSize = CGSize(width: imageWidth, height: imageHeight)
                    ImagesManager.shared.cacheImage(imageData: imageData, imageSize: imageSize, completion: {
                        (cachedImage) in
                        // ...
                    })
                }
            }
        }
    }
    
    
    

}

