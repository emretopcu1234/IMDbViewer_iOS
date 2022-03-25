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
    var favoritesList: [MovieOrSerieListItemType]
    
    let appDelegate: AppDelegate
    let context: NSManagedObjectContext
    let entity: NSEntityDescription?
    let fetchRequest: NSFetchRequest<NSFetchRequestResult>
    
    private init() {
        favoritesList = [MovieOrSerieListItemType]()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "FavoriteMovieOrSerie", in: context)
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteMovieOrSerie")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                favoritesList.append(MovieOrSerieListItemType(id: data.value(forKey: "id") as! String, title: data.value(forKey: "title") as! String, image: data.value(forKey: "image") as! String))
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
            favoritesList.append(item)
        }
        catch {
            print(error)
        }
    }
    
    func removeFromFavorites(id: String) {
        do {
            let result = try context.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                if data.value(forKey: "id") as! String == id {
                    context.delete(data)
                    break
                }
            }
        }
        catch {
            print(error)
        }
        
        do {
            try context.save()
            for index in 0..<favoritesList.count {
                if favoritesList[index].id == id {
                    favoritesList.remove(at: index)
                    break
                }
            }
        }
        catch {
            print(error)
        }
    }
    
    func reorderFavorites(newList: [MovieOrSerieListItemType]) {
        do {
            let result = try context.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                context.delete(data)
            }
        }
        catch {
            print(error)
        }
        
        favoritesList.removeAll()
        for item in newList {
            let object = NSManagedObject(entity: entity!, insertInto: context)
            object.setValue(item.id, forKey: "id")
            object.setValue(item.title, forKey: "title")
            object.setValue(item.image, forKey: "image")
            do {
                try context.save()
                favoritesList.append(item)
            }
            catch {
                print(error)
            }
        }
    }
}
