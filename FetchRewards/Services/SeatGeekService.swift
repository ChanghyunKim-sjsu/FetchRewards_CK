//
//  SeatGeekService.swift
//  FetchRewards
//
//  Created by 김창현 on 5/3/21.
//

import Foundation

//enum SeatGeekError: Error {
//  case invalidResponse
//  case noData
//  case failedRequest
//  case invalidData
//}

class SeatGeekService {
    typealias SeatGeekDataCompletion = ([EventVO]) -> ()
    
    private static var eventList: [EventVO] = {
        var list = [EventVO]()
        return list
    }()
    
    private static let clientID = "MjE3NzA0MTR8MTYxOTEzMjg5NS43Njc1NjA1"
    private static let host = "api.seatgeek.com"
    private static let path = "/2/events"
    
    static func getDataFromSeatGeek(searchTerm: String, completion: @escaping SeatGeekDataCompletion) {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = "https"
        urlBuilder.host = host
        urlBuilder.path = path
        
        print("searchTerm: \(searchTerm)")
        urlBuilder.queryItems = [
            URLQueryItem(name: "q", value: searchTerm),
            URLQueryItem(name: "client_id", value: clientID)
        ]
        
        let url = urlBuilder.url!
        print("url = \(url)")
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                  print("Failed request from seatgeek: \(error!.localizedDescription)")
                  return
                }
                
                guard let data = data else {
                  print("No data returned from seatgeek")
                  return
                }
                
                guard let response = response as? HTTPURLResponse else {
                  print("Unable to process seatgeek response")
                  return
                }
                
                guard response.statusCode == 200 else {
                  print("Failure response from seatgeek: \(response.statusCode)")
                  return
                }
                
                do {
                    let apiDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                    let entireEvent = apiDictionary["events"] as! NSArray

                    for row in entireEvent {
                        let evo = EventVO()
                        let r = row as! NSDictionary

                        if let date = r["datetime_local"] as? String {
                            evo.date = date //dateReformat(reDate: date)
                        }
                        
                        let pAry = r["performers"] as! [[String:Any]]
                        let performers = pAry[0] as NSDictionary
                        
                        if let image = performers["image"] as? String {
                            evo.thumbnail = image
                        }
                        
                        if let title = performers["name"] as? String {
                            evo.title = title
                            print("performers Name: \(title)")
                        }
                        
                        let vAry = r["venue"] as! NSDictionary
                        if let location = vAry["display_location"] as? String {
                            evo.location = location
                        }
                        self.eventList.append(evo)
                    }
                    completion(self.eventList)
                    
                } catch {
                    print("Unable to decode SeatGeekData response: \(error)")
                }
                
            }
        }.resume()
    }
}
