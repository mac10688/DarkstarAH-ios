//
//  DarkstarDb.swift
//  DarkstarAuctionHouse
//
//  Created by Matthew Cooper on 9/19/17.
//  Copyright © 2017 Darkstar. All rights reserved.
//

import Foundation
import SQLite

let fileManager = FileManager.default

let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
let fullDbPath = "\(path)/darkstar.sqlite3"

func doesDatabaseExist() -> Bool {
    return fileManager.fileExists(atPath: fullDbPath)
}

func deleteDatabase() {
    do {
        if(doesDatabaseExist()) {
            try fileManager.removeItem(atPath: fullDbPath)
            print("Just removed existing database")
        }
    }
    catch _ as NSError {
        print("Unable to delete db")
    }
}

func getDatabaseConnection() -> Connection? {
    
    do {
        print("Try to open the database")
        let db = try Connection(fullDbPath)
        print("Database opened")
        return db
    } catch let error as NSError {
        print(error.description)
        return nil
    }
}


let weapons = Table("Weapons")
let itemid = Expression<Int64>("itemid")
let name = Expression<String>("name")

let armors = Table("Armors")

func createDatabase() {
    if(!doesDatabaseExist()) {
        if let db = getDatabaseConnection() {
            do {
                try db.run(weapons.create { t in
                    t.column(itemid, primaryKey: true)
                    t.column(name)
                })
                
                try db.run(armors.create { t in
                    t.column(itemid, primaryKey: true)
                    t.column(name)
                })
            } catch let error as NSError {
                print("Unable to create database because of error")
                print(error.description)
            }
            
            print ("Just created schema")
        }
    }
}

func clearTable(table: Table) {
    if let db = getDatabaseConnection() {
        do {
            try db.run(table.delete())
        } catch let error as NSError {
            print(error.description)
        }
    }
}

func insertWeaponItem(weapon: WeaponItem) {
    if let db = getDatabaseConnection() {
        do {
            let insert = weapons.insert(itemid <- Int64(weapon.itemid), name <- weapon.name)
            try db.run(insert)
        } catch let error as NSError {
            print("Unable to insert weapon item")
            print(error.description)
        }
    }
}

func insertArmorItem(armor: ArmorItem) {
    if let db = getDatabaseConnection() {
        do {
            let insert = armors.insert(itemid <- Int64(armor.itemid), name <- armor.name)
            try db.run(insert)
        } catch let error as NSError {
            print("Unable to insert armor item")
            print(error.description)
        }
    }
}
