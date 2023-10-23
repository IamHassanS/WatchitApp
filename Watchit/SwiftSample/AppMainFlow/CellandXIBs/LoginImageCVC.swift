//
//  LoginImageCVC.swift
//  Watchit
//
//  Created by HASSAN on 13/10/23.
//

import UIKit

class LoginImageCVC: UICollectionViewCell {
    
    @IBOutlet weak var contentHolderView: UIView!
    
    @IBOutlet weak var imageHolderVIew: UIView!
    
    @IBOutlet weak var imageIV: UIImageView!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var gradientView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.gradientView.layer.insertSublayer(self.gradient, at: 0)
        
       // self.layer.insertSublayer(self.gradient, at: .max)
        

    }
    
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            }
        }
    }
    
    //Gradient to add in the cell
    private lazy var gradient: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.cgColor,UIColor.init(hex: "#00004d").withAlphaComponent(0.5).cgColor]
        //[UIColor.black.cgColor, UIColor.orange.cgColor]
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = self.bounds
        return gradientLayer
    }()
    override func prepareForReuse() {
      //  self.gradientView.layer.insertSublayer(self.gradient, at: 0)
    }

}
