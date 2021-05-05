//
//  SeatGeekData.swift
//  FetchRewards
//
//  Created by 김창현 on 5/2/21.
//

import Foundation

struct SeatGeekData: Decodable {
    
    let observation: [Observation]
    let performers: [Observation.Performers]
    
    
    struct Observation: Decodable {
        let datetime_local: String
        
        let performers: Performers
        struct Performers: Decodable {
            let image: String
            let name: String
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case observation = "events"
        case performers = "performers"
    }
    
    var eventTitle: String {
        return performers[0].name
    }

}
