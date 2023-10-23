//
//  MapFilterVC.swift
//  Watchit
//
//  Created by HASSAN on 20/10/21.
//

import UIKit
import Reachability


protocol MapFilterVCDelegate: AnyObject {
    func toPassFilteredCategoryID(_ id: String)
}

protocol ToPassMapFilters: AnyObject {
    func topassFilterParams(stayFilterDict: [String: Any])
}

class DetailsVC: BaseViewController {

    @IBOutlet var mapFilterView: DetailsView!
    var homeListDictArray = [MoviesArr]()
    var movDetail = MoviesArr()
    var isSingleSelection = false
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setNeedsStatusBarAppearanceUpdate()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    class func initWithStory() -> DetailsVC {
        let detailsVC : DetailsVC = UIStoryboard.AppMainFlow.instantiateViewController()
        return detailsVC
    }
    


}
