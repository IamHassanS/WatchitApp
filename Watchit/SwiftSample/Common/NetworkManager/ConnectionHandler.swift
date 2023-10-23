//
//  ConnectionHandlers.swift
//  Watchit
//
//  Created by HASSAN on 20/10/23.
//

import Foundation
import UIKit
import Alamofire

final class ConnectionHandler : NSObject {
    static let shared = ConnectionHandler()
    private let alamofireManager : Session
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var preference = UserDefaults.standard
    let strDeviceType = "1"
    let strDeviceToken = "20591310"
    
    override init() {
        print("Singleton initialized")
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 300 // seconds
        configuration.timeoutIntervalForResource = 500
        alamofireManager = Session.init(configuration: configuration,
                                        serverTrustManager: .none)//Alamofire.SessionManager(configuration: configuration)
    }
    func getRequest(for api : APIEnums,
                    params : Parameters) -> APIResponseProtocol{
        if api.method == .get {
            return self.getRequest(forAPI: APIUrl + api.rawValue,
                                   params: params,
                                   CacheAttribute: api.cacheAttribute ? api : .none)
        } else {
            return self.postRequest(forAPI: APIUrl + api.rawValue,
                                    params: params)
        }
    }
    
    func networkChecker(with StartTime:Date,
                        EndTime: Date,
                        ContentData: Data?) {
        
        let dataInByte = ContentData?.count
        
        if let dataInByte = dataInByte {
            
            // Standard Values
            let standardMinContentSize : Float = 3
            let standardKbps : Float = 2
            
            // Kb Conversion
            let dataInKb : Float = Float(dataInByte / 1000)
            
            // Time Interval Calculation
            let milSec  = EndTime.timeIntervalSince(StartTime)
            let duration = String(format: "%.01f", milSec)
            let dur: Float = Float(duration) ?? 0
            
            // Kbps Calculation
            let Kbps = dataInKb / dur
            
            if dataInKb > standardMinContentSize {
                if Kbps < standardKbps {
                    print("å:::: Low Network Kbps : \(Kbps)")
                    //   self.appDelegate.createToastMessage("LOW NETWORK")
                } else {
                    print("å:::: Normal NetWork Kbps : \(Kbps)")
                }
            } else {
                print("å:::: Small Content : \(Kbps)")
            }
            
        }
    }
    
    func postRequest(forAPI api: String, params: JSON) -> APIResponseProtocol {
        let responseHandler = APIResponseHandler()
        var parameters = params
        let startTime = Date()
        
      //  parameters["token"] = LocalStorage.shared.getString(key: .accessToken)
        
        //        parameters["user_type"] = Global_UserType
        //        parameters["device_id"] = strDeviceToken
        //        parameters["device_type"] = strDeviceType
        alamofireManager.request(api,
                                 method: .post,
                                 parameters: parameters,
                                 encoding: URLEncoding.default,
                                 headers: nil)
        .responseJSON { (response) in
            print("Å api : ",response.request?.url ?? ("\(api)\(parameters)"))
            
            let endTime = Date()
            
            self.networkChecker(with: startTime, EndTime: endTime, ContentData: response.data)
            
            guard response.response?.statusCode != 401 else{//Unauthorized
                if response.request?.url?.description.contains(APIUrl) ?? false{
                    //self.doLogoutActions()
                }
                return
            }
            
            guard response.response?.statusCode != 503 else { // Web Under Maintenance
                //self.webServiceUnderMaintenance()
                return
            }
            switch response.result{
            case .success(let value):
                let json = value as! JSON
                let error = json.string("error")
                guard error.isEmpty else{
                    if error == "user_not_found"
                        && response.request?.url?.description.contains(APIUrl) ?? false{
                        //self.doLogoutActions()
                    }
                    return
                }
                if json.isSuccess
                    || !api.contains(APIUrl)
                    || response.response?.statusCode == 200{
                    
                    responseHandler.handleSuccess(value: value,data: response.data ?? Data())
                }else{
                    responseHandler.handleFailure(value: json.status_message)
                }
            case .failure(let error):
                if error._code == 13 {
                    responseHandler.handleFailure(value: "No internet connection.".localizedCapitalized)
                } else {
                    responseHandler.handleFailure(value: error.localizedDescription)
                }
            }
        }
        
        
        return responseHandler
    }
    
    func getRequest(forAPI api: String,
                    params: JSON,
                    CacheAttribute: APIEnums) -> APIResponseProtocol {
        let responseHandler = APIResponseHandler()
        var parameters = params
        let startTime = Date()
        
    
        var header = [String: String]()
        //HTTPHeaders = [.authorization(bearerToken: LocalStorage.shared.getString(key: .accessToken))]
           
            header["Accept"] = "application/json"
            header["Authorization"] = LocalStorage.shared.getString(key: .accessToken)
        
        alamofireManager.request(api,
                                 method: .get,
                                 parameters: parameters,
                                 encoding: URLEncoding.default,
                                 headers: HTTPHeaders(header))
        .responseJSON { (response) in
            print("Å api : ",response.request?.url ?? ("\(api)\(params)"))
            let endTime = Date()
            
            self.networkChecker(with: startTime, EndTime: endTime, ContentData: response.data)
            
            guard response.response?.statusCode != 503 else {
                //  Shared.instance.removeLoaderInWindow()
                return
            }
            guard response.response?.statusCode != 401 else{//Unauthorized
                if response.request?.url?.description.contains(APIUrl) ?? false{
                    //self.doLogoutActions()
                }
                return
            }
            switch response.result {
            case .success(let value):
                let json = value as! JSON
                
                let error = json.string("error")
                guard error.isEmpty else{
                    if error == "user_not_found"
                        && response.request?.url?.description.contains(APIUrl) ?? false{
                        // self.doLogoutActions()
                    }
                    return
                }
                if json.isSuccess
                    || !api.contains(APIUrl)
                    || response.response?.statusCode == 200 {
                    
                    responseHandler.handleSuccess(value: value,data: response.data ?? Data())
                }else{
                    responseHandler.handleFailure(value: json.status_message)
                }
            case .failure(let error):
                if error._code == 13 {
                    responseHandler.handleFailure(value: "No internet connection.".localizedCapitalized)
                } else if error._code == 500 {
                    responseHandler.handleFailure(value: "")
                } else {
                    responseHandler.handleFailure(value: error.localizedDescription)
                }
            }
        }
        
        
        return responseHandler
    }
    func uploadRequest(for api : APIEnums,
                       params : Parameters,
                       data:Data, imageName:String = "image")-> APIResponseProtocol {
        let startTime = Date()
        let responseHandler = APIResponseHandler()
        var param = params
        param["token"] = LocalStorage.shared.getString(key: .accessToken)
        
        
        
        //uberSupport.showProgressInWindow(showAnimation: true)
        print(params)
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            let fileName = String(Date().timeIntervalSince1970 * 1000) + "Image.jpg"
            if data != Data(){
                multipartFormData.append(data, withName: imageName, fileName: fileName, mimeType: "image/jpeg")
            }
        }, to: "\(APIUrl)\(api.rawValue)").response { results in
            
            let endTime = Date()
            
            self.networkChecker(with: startTime, EndTime: endTime, ContentData: results.data)
            
            switch results.result{
                
            case .success(let anyData):
                print("Succesfully uploaded")
                print(results.request?.url as Any)
                if let err = results.error{
                    responseHandler.handleFailure(value: err.localizedDescription)
                    //                                       self.appDelegate.createToastMessage(err.localizedDescription, bgColor: .black, textColor: .white)
                    return
                }
                if let data = anyData,
                   let json = JSON(data){
                    if json.status_code == 1{
                        
                        responseHandler.handleSuccess(value: json, data: data)
                    }else{
                        //                                           self.appDelegate.createToastMessage(json.status_message,
                        //                                                                               bgColor: .black,
                        //                                                                               textColor: .white)
                        responseHandler.handleFailure(value: json.status_message)
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                //                               self.appDelegate.createToastMessage(error.localizedDescription, bgColor: .black, textColor: .white)
                if error._code == 13 {
                    responseHandler.handleFailure(value: "No internet connection.".localizedCapitalized)
                } else {
                    responseHandler.handleFailure(value: error.localizedDescription)
                }
            }
        }
        
        
        return responseHandler
    }
    
    
    
    
}
    
    
    

