import Foundation




class Alllist {
    var all = Movies()
    var movies = Movies()
    var tvShows = Movies()
}


class Movies : Codable {
    var page: Int
    var results : [MoviesArr]
    var totalPages : Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = container.safeDecodeValue(forKey: .page)
        self.results = try container.decodeIfPresent([MoviesArr].self, forKey: .results) ?? [MoviesArr]()
        self.totalPages = container.safeDecodeValue(forKey: .totalPages)
        
    }
    init() {
        page = Int()
        results = [MoviesArr]()
        totalPages = Int()
    }
    
}

class MoviesArr: Codable {

    let id: Int
    let originalTitle : String
    let originaLanguage : String
    let overview: String
    let posterPath: String
    let title: String
    let voteCount: Int
    let popularity: Float
    let genreIDs : [Int]
    let releaseDate : String
    let firstAirDate : String
    let date: String
    var name: String
    var commonName : String
    var genresStr : [String]
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case title
        case voteCount = "vote_count"
        case popularity = "vote_average"
        case genreIDs = "genre_ids"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case name
        case originaLanguage = "original_language"
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
        self.originalTitle = container.safeDecodeValue(forKey: .originalTitle)
        self.overview = container.safeDecodeValue(forKey: .overview)
        self.posterPath = container.safeDecodeValue(forKey: .posterPath)
        self.title = container.safeDecodeValue(forKey: .title)
        self.voteCount = container.safeDecodeValue(forKey: .voteCount)
        self.popularity = container.safeDecodeValue(forKey: .popularity)
        self.genreIDs = try container.decodeIfPresent([Int].self, forKey: .genreIDs) ?? [Int]()
        self.releaseDate = container.safeDecodeValue(forKey: .releaseDate)
        self.firstAirDate = container.safeDecodeValue(forKey: .firstAirDate)
        self.name = container.safeDecodeValue(forKey: .name)
        self.date = releaseDate == "" ? firstAirDate :  releaseDate
        self.commonName = title == "" ? name : title
        self.genresStr = [String]()
        originaLanguage = container.safeDecodeValue(forKey: .originaLanguage)
    }
    
    init() {
        self.id = 0
        self.originalTitle = ""
        self.overview = ""
        self.posterPath = ""
        self.title = ""
        self.voteCount = 0
        self.popularity = Float()
        self.genreIDs = [Int]()
        self.releaseDate = ""
        self.firstAirDate = ""
        self.date  = ""
        self.commonName = ""
        self.name = ""
        self.genresStr = [String]()
        self.originaLanguage = ""
    }
}

 

class GenreArr: Codable {
    let genres : [Genre]
  
    enum CodingKeys: String, CodingKey {
        case genres
     
       
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.genres = try container.decodeIfPresent([Genre].self, forKey: .genres) ?? [Genre]()
        
    }
    init() {
        genres = [Genre]()
    }
}

class Genre : Codable {
    var id: Int
    var name : String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
       
    }
    
    required init(from decoder : Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = container.safeDecodeValue(forKey: .id)
    
        self.name = container.safeDecodeValue(forKey: .name)
        
    }
    init() {
        id = Int()
        name = String()
    }
    
}
