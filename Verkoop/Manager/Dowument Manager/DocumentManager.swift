//
//  DocumentManager.swift
//  DainikBhaskar2.0
//
//  Created by Vijay's Macbook  on 05/05/17.
//  Copyright © 2017 Dainik Bhaskar. All rights reserved.
//

class DocumentManager {
    
    static let sharedManager : DocumentManager = {
        let instance = DocumentManager()
        return instance
    }()
    
    func saveData(data:Data, name:String) -> Bool {
        let docsurl = try! FileManager.default.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(kAppName)
        do {
            try FileManager.default.createDirectory(at: docsurl, withIntermediateDirectories: false, attributes: nil)
        } catch  {
            Console.log("Already Created/ OR Creation Failed")
        }
        
        let myurl = docsurl.appendingPathComponent(name)
        do {
            try data.write(to: myurl)
            return true
        } catch  {
            
        }
        return false
    }
    
    func readData(name:String) -> Data? {
        let docsurl = try! FileManager.default.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(kAppName)
        let myurl = docsurl.appendingPathComponent(name)
        do {
            let data = try Data(contentsOf: myurl)
            return data
        } catch let error {
           Console.log(error.localizedDescription)
        }
        return nil
    }
    
    func clearFilesWithName(name:String) {
        let docsurl = try! FileManager.default.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        do {
            let fileNames = try FileManager.default.contentsOfDirectory(atPath: docsurl.path)
            for fileName in fileNames {
                if (fileName.hasSuffix(name)) {
                   try FileManager.default.removeItem(at: docsurl.appendingPathComponent(fileName))
                }
            }
        } catch let error {
            Console.log(error.localizedDescription)
        }
    }
    
    func saveAppDataCache(completion:@escaping (Bool) -> ()) {
        let docsurl = try! FileManager.default.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(kAppName)
        do {
            try FileManager.default.createDirectory(at: docsurl, withIntermediateDirectories: false, attributes: nil)
        } catch let error {
            Console.log(error.localizedDescription)
        }
        
        let myurl = docsurl.appendingPathComponent("states.json")
        if let statesJSONUrl = Bundle.main.url(forResource: "states", withExtension: ".json") {
            do {
                let data = try Data(contentsOf: statesJSONUrl )
                if let _ = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                    try data.write(to: myurl)
                    completion(true)
                }
            } catch  {
                completion(false)
            }
        }
    }
    
    func getCountryList() -> [[String: Any]] {
        if let statesJSONUrl = Bundle.main.url(forResource: "CountryCodes", withExtension: ".json") {
            do {
                let data = try Data(contentsOf: statesJSONUrl )
                if let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] {
                    return responseDict
                }
            } catch let error {
                Console.log(error.localizedDescription)
            }
        }
        return [[:]]
    }
}
