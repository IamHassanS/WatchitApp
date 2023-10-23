

import UIKit

protocol PopOverVCDelegate: AnyObject {
    func didTapRow(_ index: Int, _ isExist: Bool)
}


class PopOverVC: UIViewController {
    
    
    @IBOutlet weak var contentTable: UITableView!
    var delegate: PopOverVCDelegate?
    var strArr = [String]()
    var isExist = Bool()
    var isFromWishlist = Bool()
    var isFromHome = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        toLOadData()
        
       let isLoggedin = LocalStorage.shared.getBool(key: LocalStorage.LocalValue.isUserLoggedin)
        
        if isLoggedin {
            strArr = ["", "Logout"]
        } else {
            strArr = ["", "Login"]
        }
        
  
        
        if isExist {
            strArr[0] = "Remove from watchList"
        } else {
            strArr[0] = "Add to WatchList"
        }
        
     
        
        if isFromWishlist {
            strArr.remove(at: 1)
        }
        
        if isFromHome {
            strArr.remove(at: 0)
        }
        
        // Do any additional setup after loading the view.
    }
    
    func toLOadData() {
        contentTable.delegate = self
        contentTable.dataSource = self
        contentTable.reloadData()
    }
    
    //MARK:- initWithStory
    class func initWithStory(preferredFrame size : CGSize,on host : UIView) -> PopOverVC{
        let infoWindow: PopOverVC  = UIStoryboard(name: "AppMainFlow", bundle: nil).instantiateViewController(withIdentifier: "PopOverVC") as! PopOverVC
          
        infoWindow.preferredContentSize = size
        infoWindow.modalPresentationStyle = .popover
        let popover: UIPopoverPresentationController = infoWindow.popoverPresentationController!
        popover.delegate = infoWindow
        popover.sourceView = host
       // popover.backgroundColor = UIColor(hex: "ECF2FB")
        popover.permittedArrowDirections = UIPopoverArrowDirection.up
        
        
        return infoWindow
    }

    
}
extension PopOverVC : UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
}
extension UIViewController{
    func showPopOver(on host : UIView){
        let infoWindow = PopOverVC
            .initWithStory(preferredFrame: CGSize(width: self.view.frame.width,
                                                  height: 100),
                           on: host)
        infoWindow.modalPresentationStyle = .fullScreen
        self.present(infoWindow, animated: true) {
            infoWindow.toLOadData()
        }
    }
}




extension PopOverVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: InfoTVC = tableView.dequeueReusableCell(withIdentifier: "InfoTVC", for: indexPath) as! InfoTVC
        cell.titleLbl.text = strArr[indexPath.row]
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.delegate?.didTapRow(indexPath.row, self.isExist)
        }

    }
    
    
}


class InfoTVC: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
