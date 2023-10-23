
import Foundation
import Alamofire

enum APIEnums : String{
    
    case Details
    case AddFavourite = "Add Favourite"
    case FavouriteTV = "Favourite TV"
    
      case trendingAllList = "trending/all/day"
  case trendingShows = "discover/tv"
        //"trending/tv/day"
    case trendingMovie = "discover/movie"
            //"trending/movie/day"
    case movieGenre = "genre/movie/list"
    case tvShowsGenre = "genre/tv/list"
    case none
    
}

//discover/movie
//https://api.themoviedb.org/3/trending/tv/day?language=en-US
//https://api.themoviedb.org/3/trending/all/day?language=en-US
//https://api.themoviedb.org/3/genre/tv/list?language=en
//https://api.themoviedb.org/3/trending/movie/day?language=en-US
//https://api.themoviedb.org/3/genre/movie/list?language=en

extension APIEnums{//Return method for API
    var method : HTTPMethod{
        switch self {
        case .FavouriteTV:
            return .post
        default:
            return .get
        }
    }

    var cacheAttribute: Bool{
        switch self {
        case  .trendingMovie, .trendingShows, .trendingAllList, .movieGenre, .tvShowsGenre, .AddFavourite, .Details:
            return true
        default:
            return false
        }
    }
}
