//
//  HomeViewController.swift
//  WishlistVC
//
//  Created by HASSAN on 20/10/23.
//

import UIKit

enum listTypes {
    case all
    case movies
    case tvshows
    
}

class HomeVC: BaseViewController {
    
    @IBOutlet var homeView: HomeView!
    var allList = Alllist()
    let homeViewModal = HomeViewModal()
    var generes = [Genre]()
    var tvGenre = [Genre]()
    
    override func viewDidLoad() {
        self.homeView.homeVC = self
        self.toFetchData(page: 1, listType: listTypes.all)

    }
    

    
    class func initWithStory() -> HomeVC {
        let homeVC : HomeVC = UIStoryboard.AppMainFlow.instantiateViewController()
        return homeVC
    }
    
    func toFetchData(page: Int, listType: listTypes) {
        var param = [String: Any]()
        param["page"] = page
        param["include_adult"] = false
        param["include_video"] = false
        param["language"] = "en-US"
        param["sort_by"] = "popularity.desc"
        self.toGetExploreData(param, page, listType){ isSuccess in
            if isSuccess {
                let connectivity =  LocalStorage.shared.getString(key: .connectivity)
                  if connectivity == "No Connection" {
                      self.homeView.toSetPageType(.notconnected)
                  } else if !self.homeView.isloading{
                      self.homeView.toSetPageType(.connected)
                  }
            } else {
              //  self.sceneDelegate?.createToastMessage("unable to fetch data", isFromWishList: true)
            }
        }
        
    }
    
    
    func toGetExploreData(_ param: [String: Any]? = [String: Any](), _ page: Int = 1, _ type: listTypes, completion: @escaping (Bool) -> ()) {
        
        self.homeView.isloading = true
       // Shared.instance.showLoaderInWindow()
        var param: JSON = param ?? [String: Any]()

        if param.isEmpty {
        }

        homeViewModal.getHomeData(params: param, type: type, { (result) in
            switch result {

            case .success(let responseDict):
                self.homeView.isloading = false
                if type == .all {
                    completion(true)
                }
              
                switch type {
                case .all:
                    self.allList.all = responseDict
                    self.homeView.allList.all = responseDict
                    self.allList.all.results =  responseDict.results
                    self.homeView.toLoadCollectionData()
                    dump(responseDict)
                   // self.toFetchData(page: 1, listType: .movies)
                case .movies:
                    self.allList.movies = responseDict
                    self.homeView.allList.movies = responseDict
                    self.allList.movies.results = responseDict.results
                    self.togetGenreData([String: Any](), 1, .movies)
                    dump(responseDict)
                case .tvshows:
                    self.homeView.allList.tvShows = responseDict
                    self.allList.tvShows.results = responseDict.results
                    self.togetGenreData([String: Any](), 1, .tvshows)
                   
                    dump(responseDict)
           
                }
       
             
             
                
            //
                
            case .failure(let error):
                completion(false)
              //  Shared.instance.removeLoader(in: self.view)
                print("\(error.localizedDescription)")
            }
        })
    }
    func togetGenreData(_ param: [String: Any]? = [String: Any](), _ page: Int = 1, _ type: listTypes) {
    
      //  Shared.instance.sh
        var param: JSON = param ?? [String: Any]()

        if param.isEmpty {
          
            param["language"] = "en"
        }

        homeViewModal.getgenreData(params: param, type: type,  { (result) in
            switch result {
            case .success(let responseDict):
                switch type {
                    
                case .all:
                    break
                case .movies:
                    self.generes = responseDict.genres
                    self.homeView.allList.movies.results.forEach { movie in
                        movie.genreIDs.forEach { indiVidualgenre in
                            self.generes.forEach { wholeGenre in
                                if indiVidualgenre == wholeGenre.id {
                                    movie.genresStr.append(wholeGenre.name)
                                }
                            }
                        }
                    }
                    self.togetGenreData([String: Any](), 1, .tvshows)
                   
                case .tvshows:
                    self.tvGenre = responseDict.genres
                    self.homeView.allList.tvShows.results.forEach { movie in
                        movie.genreIDs.forEach { indiVidualgenre in
                            self.generes.forEach { wholeGenre in
                                if indiVidualgenre == wholeGenre.id {
                                    movie.genresStr.append(wholeGenre.name)
                                }
                            }
                        }
                    }
                   
                }
                self.homeView.toLoadData()
                self.homeView.isLoadingMorePages = false
                
                
               
            case .failure(let error):
                print("\(error.localizedDescription)")
                self.homeView.isLoadingMorePages = false
            }
        })
    }
}
