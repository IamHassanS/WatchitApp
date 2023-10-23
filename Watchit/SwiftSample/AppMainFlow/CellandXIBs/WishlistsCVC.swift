//
//  WishlistsCVC.swift
//  WishlistVC
//
//  Created by HASSAN on 20/10/23.
//

import UIKit

class WishlistsCVC: UICollectionViewCell {
    @IBOutlet weak var backgroundBorderView: UIView!
    
    @IBOutlet weak var imageHolderView: UIView!
    @IBOutlet weak var forgroundContentView: UIView!
    
    @IBOutlet weak var movieIV: UIImageView!
    
    
    @IBOutlet weak var movieImageHolder: UIView!
    
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var optionsHolderView: UIView!
    
    @IBOutlet weak var genreAndLang: UILabel!
    
    @IBOutlet weak var popularityLbl: UILabel!
    
    func populatecell(_ movie: Film) {
        titleLbl.text = movie.movieName
        genreAndLang.text = "\(movie.movieGenre ?? "")\(movie.movieReleaseDate ?? "")"
        popularityLbl.text =  movie.movieUpvotePopularity
        movieIV.image = UIImage(data: movie.movieImageurl ?? Data())
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundBorderView.layer.borderColor = UIColor.gray.cgColor
        backgroundBorderView.layer.borderWidth = 0.5
        backgroundBorderView.layer.cornerRadius = 15
        
        
        forgroundContentView.layer.cornerRadius = 15
     
        imageHolderView.layer.cornerRadius = 10
        // Initialization code
    }
    
    
    
    

}
