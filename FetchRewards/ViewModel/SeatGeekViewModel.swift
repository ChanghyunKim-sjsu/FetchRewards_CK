//
//  SeatGeekViewModel.swift
//  FetchRewards
//
//  Created by 김창현 on 5/3/21.
//

import Foundation
import UIKit.UIImage

public class SeatGeekViewModel {
    
    static private let defaultTerm = ""
    
    let eventData = Box(Array<EventVO>())
    
    init() {
        print("설마...")
        self.getData(searchFor: Self.defaultTerm)
    }
    
    func changeSearchingTerm(searchFor newTerm: String) {
        self.getData(searchFor: newTerm)
    }
    
    func getData(searchFor newTerm: String) {
        print("Getting Data")
        SeatGeekService.getDataFromSeatGeek(searchTerm: newTerm) { dataList in
            self.eventData.value = dataList
        }
    }

}
