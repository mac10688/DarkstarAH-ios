//
//  WeaponItem.swift
//  DarkstarAuctionHouse
//
//  Created by Matthew Cooper on 9/18/17.
//  Copyright © 2017 Darkstar. All rights reserved.
//

import Foundation

struct WeaponItem {
    var itemid : Int
    var name : String
}

extension WeaponItem {
    init(json: [String:Any]) {
        self.itemid = json["itemid"] as! Int
        self.name = json["name"] as! String
    }
}

struct ArmorItem {
    var itemid : Int
    var name : String
}

extension ArmorItem {
    init(json: [String:Any]) {
        self.itemid = json["itemid"] as! Int
        self.name = json["name"] as! String
    }
}
