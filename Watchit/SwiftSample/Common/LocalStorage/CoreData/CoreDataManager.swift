//
//  CoreDataManager.swift
//  Watchit
//
//  Created by HASSAN on 20/10/23.
//

import Foundation
import CoreData
import UIKit
class CoreDataManager {
    static let shared = CoreDataManager()
    var movies:[Film]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func fetchMovies(completion: ([Film]) -> () )  {
        do {
            movies = try  context.fetch(Film.fetchRequest())
            completion(movies ?? [Film]())
            
        } catch {
            print("unable to fetch movies")
        }
       
    }
    
    func toCheckExistance(_ id: Int, completion: (Bool) -> ()) {
        
        do {
            let request = Film.fetchRequest() as NSFetchRequest
            let pred = NSPredicate(format: "movieID == '\(id)'")
            //LIKE
            request.predicate = pred
           let films = try context.fetch(request)
            if films.isEmpty {
                completion(false)
            } else {
                completion(true)
            }
        } catch {
            print("unable to fetch")
            completion(false)
        }
    }
    
    
    func toAddMovie(_ movie: MoviesArr, ImageData: Data, completion: (Bool) -> ()) {
        toCheckExistance(movie.id) { isExists in
            if !isExists {
                //create object
                let newMovie = Film(context: self.context)
                newMovie.movieName = movie.commonName
                
                newMovie.movieImageurl = ImageData
                newMovie.movieDescription = movie.overview
                newMovie.movieID = Int32(movie.id)
                newMovie.movieReleaseDate = movie.date
                let strArr =  movie.genresStr
               let str =  strArr.joined(separator:"•")
                newMovie.movieGenre = str
                newMovie.movieUpvotePopularity = "\(movie.popularity) / 10 • \(movie.voteCount) Reviews"
              //  newMovie.movieImageurl = imageURL
                
                //save data
                do {
                    try self.context.save()
                    completion(true)
                } catch {
                    completion(false)
                    print("Unable to save")
                }
            } else {
                completion(false)
            }
        }

        
        //Refetch the data
      //  self.fetchMovies()
        
        
    }

    func toRemoveMovie(_ id: Int, completion: (Bool) -> ()) {
        //
        
//        let personToRemove = movies?[index] ?? Film()
//        self.context.delete(personToRemove)
//        self.context.dele
//        do {
//            try self.context.save()
//        } catch {
//            print("unable to delete")
//        }
        
        do {
            let request = Film.fetchRequest() as NSFetchRequest
            let pred = NSPredicate(format: "movieID == '\(id)'")
            request.predicate = pred
           let films = try context.fetch(request)
            if films.isEmpty {
                completion(false)
            } else {
                let personToRemove = films[0]
                self.context.delete(personToRemove)
                do {
                     try self.context.save()
                    completion(true)
                } catch {
                    completion(false)
                }
                completion(true)
            }
        } catch {
            print("unable to fetch")
            completion(false)
        }

    }

    
}
