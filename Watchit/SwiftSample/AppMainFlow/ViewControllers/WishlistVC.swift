//
//  ViewController.swift
//  WishlistVC
//
//  Created by HASSAN on 20/10/23.
//

import UIKit



    
    


class WishListVC: BaseViewController {
    @IBOutlet var wishlistView: WishListVIew!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    class func initWithStory() -> WishListVC {
        let wishList : WishListVC = UIStoryboard.AppMainFlow.instantiateViewController()
        return wishList
    }
    

    
    


}

