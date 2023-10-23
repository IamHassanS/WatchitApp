import Foundation


class BaseViewModel : NSObject{
    lazy var connectionHandler : ConnectionHandler? = {
        return ConnectionHandler()
    }()
    
    override init() {
        super.init()
    }
    

    
}
