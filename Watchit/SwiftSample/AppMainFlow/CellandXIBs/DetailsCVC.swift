//
//  DetailsCVC.swift
//  Watchit
//
//  Created by HASSAN on 20/10/21.

//

import UIKit



class DetailsCVC: UICollectionViewCell {
    
    @IBOutlet weak var movieIV: UIImageView!
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var movieDesc: UILabel!
    
    @IBOutlet weak var VoteAndPopularity: UILabel!
    
    @IBOutlet weak var releaseDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        movieIV.setSpecificCornersForLeft(cornerRadius: 10)

    }
    
    func populatecell(_ movie: MoviesArr) {
        titleLbl.text = movie.title
         let strArr =  movie.genresStr
        let str =  strArr.joined(separator:"-")
        movieDesc.text = str
        VoteAndPopularity.text = "\(movie.popularity) / 10 • \(movie.voteCount) Reviews"
        let path =  movie.posterPath
        let test = (APIImageUrlString) + "\(path)"
        movieIV.sd_setImage(with: URL(string: test), placeholderImage: UIImage(named: "noImageThumb"))
       // movieIV.setImageWithHeaders(test)
        releaseDate.text = movie.date
    }
    

    
    
  
}
