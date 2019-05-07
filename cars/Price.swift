//
//  Price.swift
//  cars
//
//  Created by Shravan on 12/11/19.
//  Copyright © 2019 Shravan. All rights reserved.
//

import Foundation

class Price {
    var year:String
    var price: String
    
    init?(year:String, price:String){
        self.year = year
        self.price = price
    }
}
