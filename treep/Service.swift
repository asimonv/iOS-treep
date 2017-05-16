//
//  Service.swift
//  treep
//
//  Created by Andre Simon on 12/21/16.
//  Copyright © 2016 Andre Simon. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import SwiftyJSON

class Service {
    
    var settings: Settings!
    
    init() {
        self.settings = Settings()
    }
    
    func getKey(callback: @escaping (String) -> ()){
        
        var keyValue: String?
        
        Alamofire.request(self.settings.recieveKey)
            .responseJSON{ response in switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                
                let response = JSON as! NSDictionary
                
                //example if there is an id
                let data = response.object(forKey: "Data") as! NSDictionary
                keyValue = data.object(forKey: "key") as? String
                self.saveCoreDataEntity(entityType: "Key", name: keyValue!)
                
                callback(keyValue!)
                
            case .failure(let error):
                print("Request failed with error: \(error)")
                
                }
        }
        
    }
    
    func loadKey(_ data:NSDictionary) -> String{
        
        var key = ""
        let keyData = data["Data"] as! NSDictionary
        
        key = keyData["key"]! as! String
        
        
        return key
    }
    
    
    func getCoreDataEntityName(entityName: String) -> String{
        var result = ""
        
        //let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        
        //var results:NSArray = context.executeFetchRequest(request, error: nil)! as NSArray
        do{
            let results = try context.fetch(request) as NSArray
            
            if(results.count > 0){
                
                if(entityName == "Key"){
                    result = (results.firstObject as! Key).name
                }
                
            }
            
            
            return result
            
        }
            
        catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
            
            return error.localizedDescription
        }
        
    }
    
    func saveCoreDataEntity(entityType: String, name: String){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if(entityType == "Key"){
            let en = NSEntityDescription.entity(forEntityName: "Key", in: context)!
            
            let key = Key(entity: en, insertInto: context)
            key.name = name
        }
    
        do{
            try context.save()
        }
            
        catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    /*func endorseTeacher(teacherName: String, sigla: String, userKey: String, callback:@escaping (JSON)->()){
        
        
        let headers = [
            "cache-control": "no-cache",
            "postman-token": "e1ade2cc-9f01-075e-a732-8e7a620bc4db"
        ]
        
        let v = teacherName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        print(v)
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://ccomparte.cl/treep/api/1/endorse_teacher?user_key=\(userKey)&teacher_name=\(v)&sigla=\(sigla)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                print(JSON(data: data!))
            }
        })
        
        dataTask.resume()
    }*/
    
    func submitAction(url: String, parameters: Dictionary<String, Any>, callback: @escaping(_ response: JSON) -> ()) {
        
        //create the url with NSURL
        let url = URL(string: url)
        
        //create the session object
        let session = URLSession.shared
        
        //now create the NSMutableRequest object using the url object
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        //HTTP Headers
        request.addValue("application/json;  charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            let json = JSON(data: data!)
            callback(json)
        })
        
        task.resume()
    }
    
    
}
