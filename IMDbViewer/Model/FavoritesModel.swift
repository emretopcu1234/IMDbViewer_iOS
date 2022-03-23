//
//  FavoritesModel.swift
//  IMDbViewer
//
//  Created by Emre Topçu on 16.03.2022.
//

import Foundation
import CoreData
import UIKit

class FavoritesModel {
    
    static let shared = FavoritesModel()
    var favoritesDelegate: FavoritesDelegate?
    var favoritesList: [String: MovieOrSerieListItemType]
    
    let appDelegate: AppDelegate
    let context: NSManagedObjectContext
    let entity: NSEntityDescription?
    
    private init() {
        favoritesList = [String: MovieOrSerieListItemType]()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "UserFavorites", in: context)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserFavorites")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                favoritesList[data.value(forKey: "id") as! String] = MovieOrSerieListItemType(id: data.value(forKey: "id") as! String, title: data.value(forKey: "title") as! String, image: data.value(forKey: "image") as! String)
            }
        }
        catch {
            print(error)
        }
    }
    
    func getFavoritesList() {
        favoritesDelegate?.onFavoritesListReceived(favoritesList: favoritesList)
    }
    
    func addToFavorites(item: MovieOrSerieListItemType) {
        let object = NSManagedObject(entity: entity!, insertInto: context)
        object.setValue(item.id, forKey: "id")
        object.setValue(item.title, forKey: "title")
        object.setValue(item.image, forKey: "image")
        do {
            try context.save()
        }
        catch {
            print(error)
        }
    }
    
    func removeFromFavorites(id: String) {
        
    }
}

// TODO LIST:
// remove kısmı da halledilecek.
// view controller'a delegate ozelligi eklenecek. sonra da ikisi arasinda haberlesme saglanacak.
