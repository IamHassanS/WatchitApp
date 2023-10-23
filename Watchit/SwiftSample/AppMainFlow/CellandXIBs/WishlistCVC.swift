//
//  WishlistCVC.swift
//  CoreDataDemo
//
//  Created by HASSAN on 20/10/23.
//

import UIKit
import SDWebImage
import Alamofire
protocol WishlistCVCDelegate: AnyObject {
    func didOptionsTapped(_ index: Int)
}

class WishlistCVC: UICollectionViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imageHolderView: UIView!
    
    @IBOutlet weak var yearAndTimeLbl: UILabel!
    @IBOutlet weak var optionsView: UIView!
    @IBOutlet weak var movieIV: UIImageView!
    
    @IBOutlet weak var titleHolderView: UIView!
    var delegate: WishlistCVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageHolderView.elevate(2)
        imageHolderView.setSpecificCornersForTop(cornerRadius: 10)
        titleHolderView.setSpecificCornersForBottom(cornerRadius: 10)
        // Initialization code
    }
    
    func populateCell(movie: MoviesArr) {

        nameLbl.text = movie.commonName
        //movie.originalTitle
         //delegate = self
        yearAndTimeLbl.text = "\(movie.popularity) / 10"

        // Use SDWebImage to load the image with the custom headers
        let path =  movie.posterPath
        let test = (APIImageUrlString) + "\(path)"
        movieIV.sd_setImage(with: URL(string: test), placeholderImage: UIImage(named: "noImageThumb"))
        
        //From url session
//        self.fetchImage(from: test) { data in
//            if data == nil {
//               // self.movieIV.image
//            } else {
//                self.movieIV.image =
//                UIImage(data: data!)
//            }
//
//        }
    }
    
    
    func fetchImage(from urlString: String, completionHandler: @escaping (_ data: Data?) -> ()) {
        
        let urlstr: URL = URL(string: urlString)!
        var request = URLRequest(url: urlstr)
          request.httpMethod = "GET"
          request.setValue("Accept", forHTTPHeaderField: "application/json")
          request.setValue("Authorization", forHTTPHeaderField: LocalStorage.shared.getString(key: .accessToken))

        let session = URLSession.shared

        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error fetching the image! 😢")
                completionHandler(nil)
            } else {
                completionHandler(data)
            }
        }

        dataTask.resume()
    }
    
}
