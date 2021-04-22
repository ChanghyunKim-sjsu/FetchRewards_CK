//
//  PostData.swift
//  FetchRewards
//
//  Created by 김창현 on 4/22/21.
//

import Foundation

class PostData : NSObject, URLSessionDelegate, URLSessionDataDelegate {
    
    var session : URLSession!
    let now = NSDate()
    let formatter = DateFormatter()
    let save = UserDefaults.standard
    var setDate : String = ""
    
    // send post data
    func postDataUrl() {
        let defaultSession = URLSession(configuration: .default)
        guard let url = URL(string: "https://api.seatgeek.com/2/events?client_id=" + clientId) else { return }
        let request = URLRequest(url: url)
        let dataTask = defaultSession.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            
            guard let jsonToArray = try? JSONSerialization.jsonObject(with: data, options: []) else {
                print("json to Any Error")
                return
            }
            print(jsonToArray)
        }
        dataTask.resume()
    }
    
    
    // get current date time
    func getDate() -> String {
        self.setDate = ("\(Int64(NSDate().timeIntervalSince1970 * 1000))")
        return self.setDate
    }
    
    func getCurrentTime() -> String {
        let currentdate : NSDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        let stringDate = dateFormatter.string(from: currentdate as Date)
        return stringDate
    }
    
    // get crypto password
//    func getCrypto(password : String) -> String {
//        let pwdata = (password).data(using: String.Encoding.utf8)
//        let hashpw = pwdata?.sha256()
//        return "\(hashpw!.toHexString())"
//    }
    
    // get relative date
    func getDateFromDate(date : Int) -> String {
        let d1 = NSDate()
        let cal = NSCalendar(identifier:NSCalendar.Identifier.gregorian)
        
        let offset = NSDateComponents()
        offset.day = -date
        
        var d:NSDate? = d1
        
        d = cal!.date(byAdding: offset as DateComponents,to:d! as Date,options:[]) as NSDate?
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: d! as Date)
        return "\(components.month!). \(components.day!). \(components.year!)"
    }
    
    // get relative time
    func getDateFromTime(time: Double) -> String {
        let d1 = NSDate()
        let d2 = d1.addingTimeInterval((-time*60))
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: d2 as Date)
        
        return "\(components.month!). \(components.day!). \(components.year!)"
    }
    
    func getTimeFromTime(time : Double) -> String {
        let d1 = NSDate()
        let d2 = d1.addingTimeInterval((-time*60))
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: d2 as Date)
        
        if components.hour! >= 12 {
            if components.hour == 12 {
                return "\(components.hour!):\(components.minute!) PM"
            } else {
                return "\(components.hour!-12):\(components.minute!) PM"
            }
        } else {
            return "\(components.hour!):\(components.minute!) AM"
        }
    }
    
    func getTimeFromTime1(time : Double) -> String{
        let d1 = NSDate()
        let d2 = d1.addingTimeInterval((-time*60))
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: d2 as Date)
        //let components = calendar.components([.Year, .Month, .Day, .Hour, .Minute], fromDate: d2)
        
        if components.hour! >= 12 {
            if components.hour == 12 {
                return "\(components.hour!):\(components.minute!)"
            }else{
                return "\(components.hour!-12):\(components.minute!)"
            }
        }else{
            return "\(components.hour!):\(components.minute!)"
        }
    }
    
    // save session data
    func saveData(data:String, name : String, nickname : String, gender : String){
        do {
            let jsonData = data.data(using: String.Encoding.utf8)
            let jsonSub = try JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments) as! NSDictionary
//            save.setValue(appId, forKey: "UUID")
            
            if let val : String = jsonSub["SESS_AUTH_KEY"] as? String {
                save.setValue(val.replacingOccurrences(of: "/\\", with: "\\"), forKey: "SESS_AUTH_KEY")
            } else {
                save.setValue("", forKey: "SESS_AUTH_KEY")
            }
            
            if let val : String = jsonSub["USER_NO"] as? String {
                save.setValue(val, forKey: "SESS_NO")
            } else {
                save.setValue("", forKey: "SESS_NO")
            }
            
            if let val : String = jsonSub["NAME"] as? String {
                save.setValue(val, forKey: "NAME")
            } else {
                save.setValue("", forKey: "NAME")
            }
            
            if let val : String = jsonSub["NICKNAME"] as? String {
                save.setValue(val, forKey: "NICKNAME")
            } else {
                save.setValue("", forKey: "NICKNAME")
            }
            
            if let val : String = jsonSub["GENDER"] as? String {
                save.setValue(val, forKey: "GENDER")
            } else {
                save.setValue("", forKey: "GENDER")
            }
            save.synchronize()
            
        } catch {
            print("error")
        }
    }
    
    // delete session data
    func deleteSession(){
        save.removeObject(forKey: "SESS_AUTH_KEY")
        save.removeObject(forKey: "SESS_NO")
        save.removeObject(forKey: "UUID")
        save.removeObject(forKey: "NAME")
        save.removeObject(forKey: "NICKNAME")
        save.removeObject(forKey: "GENDER")
    }
    
    // get session key
    func getSessionKey() -> String {
        if save.value(forKey: "SESS_AUTH_KEY") == nil{
            return ""
        }else{
            return (save.value(forKey: "SESS_AUTH_KEY") as? String)!
        }
    }
    
    // get session number
    func getSessionNo() -> String {
        if save.value(forKey: "SESS_NO") == nil {
            return ""
        } else {
            return (save.value(forKey: "SESS_NO") as? String)!
        }
    }
    
    func getSavedNickname() -> String {
        if save.value(forKey: "NICKNAME") == nil {
            return ""
        } else {
            return (save.value(forKey: "NICKNAME") as? String)!
        }
    }
    
    func getSavedName() -> String {
        if save.value(forKey: "NAME") == nil {
            return ""
        } else {
            return (save.value(forKey: "NAME") as? String)!
        }
    }
    
    // convert json data to string & validate
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        if JSONSerialization.isValidJSONObject(value) {
            do {
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            } catch {
                print("error")
            }
        }
        return ""
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: emailStr)
        return result
    }
}
