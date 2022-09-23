//
//  MobilObject.swift
//  ExitekTechTask
//
//  Created by User on 9/20/22.
//
//

import Foundation
import RealmSwift

final class MobilObject: Object {
    
    @objc dynamic var imei: String = ""
    @objc dynamic var model: String = ""
    
    override static func primaryKey() -> String? {
          return "imei"
    }
    
}

