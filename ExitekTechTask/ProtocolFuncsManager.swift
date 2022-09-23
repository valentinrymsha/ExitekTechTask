//
//  ProtocolFuncsManager.swift
//  ExitekTechTask
//
//  Created by Valentin Rimsha on 22.09.22.
//

import UIKit
import RealmSwift

final class ProtocolFuncsManager: MobileStorage {

//    private let realm = try! Realm()
    private let realm = try! Realm()
    
    func getAll() -> Set<MobilObject> {
        
        return Set(realm.objects(MobilObject.self))
    }
    
    func findByImei(_ imei: String) -> MobilObject? {
        
        return realm.object(ofType: MobilObject.self, forPrimaryKey: imei)
    }
    
    func save(_ mobile: MobilObject) throws {
        
        guard realm.object(ofType: MobilObject.self, forPrimaryKey: mobile.imei) == nil else { return }
        do {
            
            try realm.write {
                realm.add(mobile)
            }
            realm.refresh()
        } catch let error as NSError {
            print("MYLOG: " + error.localizedDescription)
        }
        
        PushNotification.pushNote("You saved mobil with model \(mobile.model)", 1)
    }
    
    func delete(_ product: MobilObject) throws {
        
        do {
            try realm.write {
                realm.delete(realm.objects(MobilObject.self).filter("imei=%@",product.imei))
            }
            realm.refresh()
        } catch let error as NSError {
            print("MYLOG: " + error.localizedDescription)
        }
        PushNotification.pushNote("You deleted product with model \(product.model)", 1)
    }
    
    func exists(_ product: MobilObject) -> Bool {
        return realm.object(ofType: MobilObject.self, forPrimaryKey: product.imei) != nil
    }
}

protocol MobileStorage {
    
    func getAll() -> Set<MobilObject>
    func findByImei(_ imei: String) -> MobilObject?
    func save(_ mobile: MobilObject) throws 
    func delete(_ product: MobilObject) throws
    func exists(_ product: MobilObject) -> Bool
    
}
