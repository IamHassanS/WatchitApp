class HomeViewModal: BaseViewModel {
    
    
    func getHomeData(params: JSON, type: listTypes, _ result : @escaping (Result<Movies,Error>) -> Void) {
        
        var api : APIEnums {
            switch type {
                
            case .all:
                return .trendingAllList
            case .movies:
                return .trendingMovie
            case .tvshows:
                return .trendingShows
      
          
            }
        }
        
        
        ConnectionHandler.shared.getRequest(for: api, params: params)
            .responseDecode(to: Movies.self, { (json) in
                result(.success(json))
                dump(json)
            }).responseFailure({ (error) in
                print(error.description)
                //SceneDelegate.createToastMessage(<#T##self: SceneDelegate##SceneDelegate#>)
            })
    }
    
    
    func getgenreData(params: JSON, type: listTypes, _ result : @escaping (Result<GenreArr,Error>) -> Void) {
        
        var api : APIEnums {
            switch type {
                
            case .all:
                return .movieGenre
            case .movies:
                return .movieGenre
            case .tvshows:
                return .tvShowsGenre
            }
        }

        
        ConnectionHandler.shared.getRequest(for: api, params: params)
            .responseDecode(to: GenreArr.self, { (json) in
                result(.success(json))
                dump(json)
            }).responseFailure({ (error) in
                print(error.description)
                //SceneDelegate.createToastMessage(<#T##self: SceneDelegate##SceneDelegate#>)
            })
    }
    
}
