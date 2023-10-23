//
//  HomeSectionTVC.swift
//  WishlistVC
//
//  Created by HASSAN on 20/10/23.
//

import UIKit
import SDWebImage
class HomeSectionTVC: UITableViewCell {

    @IBOutlet weak var movieThumbHolderView: UIView!
    
    @IBOutlet weak var movieCellContent: UIView!
    @IBOutlet weak var movieThumbIV: UIImageView!
    
    @IBOutlet weak var genreLbl: UILabel!
    
    @IBOutlet weak var filmDescLbl: UILabel!
    
    @IBOutlet weak var upVotesLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        movieCellContent.layer.cornerRadius = 15
        movieThumbHolderView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateCell(movie: MoviesArr) {
        let path =  movie.posterPath
        let test = (APIImageUrlString) + "\(path)"
        movieThumbIV.sd_setImage(with: URL(string: test), placeholderImage: UIImage(named: "noImageThumb"))
        titleLbl.text = "\(movie.commonName) (\(movie.originaLanguage))"
        //movie.originalTitle
        filmDescLbl.text = movie.overview
        movieThumbIV.setImageWithHeaders(test)
        let strArr =  movie.genresStr
       let str =  strArr.joined(separator:"-")
        genreLbl.text = str
         //delegate = self
        upVotesLbl.text = "\(movie.popularity) / 10 • \(movie.voteCount) Reviews"
        yearLbl.text = movie.date
    }
    
}
