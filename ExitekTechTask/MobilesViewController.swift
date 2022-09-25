//
//  ViewController.swift
//  ExitekTechTask
//
//  Created by User on 9/20/22.
//

import RealmSwift
import UIKit

final class MobilesViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var showAllPhonesButton: UIButton!
    @IBOutlet private weak var findByEmeiButton: UIButton!
    @IBOutlet private weak var checkPhoneButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!
    
    @IBOutlet private weak var modelTextField: UITextField!
    @IBOutlet private weak var imeiTextField: UITextField!
    
    
    private func setupButtons(){
        
        showAllPhonesButton.layer.cornerRadius = 13
        findByEmeiButton.layer.cornerRadius = 13
        checkPhoneButton.layer.cornerRadius = 13
        saveButton.layer.cornerRadius = 13
        deleteButton.layer.cornerRadius = 13
        
        showAllPhonesButton.backgroundColor = #colorLiteral(red: 0.6784313725, green: 0.8675484657, blue: 0.7702565789, alpha: 1)
        findByEmeiButton.backgroundColor = #colorLiteral(red: 0.6784313725, green: 0.8675484657, blue: 0.7702565789, alpha: 1)
        checkPhoneButton.backgroundColor = #colorLiteral(red: 0.6784313725, green: 0.8675484657, blue: 0.7702565789, alpha: 1)
        saveButton.backgroundColor = #colorLiteral(red: 0.6784313725, green: 0.8675484657, blue: 0.7702565789, alpha: 1)
        deleteButton.backgroundColor = #colorLiteral(red: 0.6784313725, green: 0.8675484657, blue: 0.7702565789, alpha: 1)
        
    }
    
    // MARK: Properties
    
    private let realm = try! Realm()
    private let protocolManager = ProtocolFuncsManager()
    
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
    }
    
    private func setupAlert(_ titleMessage: String, _ actionTitle: String){
        let alert = UIAlertController(title: titleMessage, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    // MARK: Lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imeiTextField.delegate = self
        modelTextField.delegate = self
        
        userNotificationCenter.delegate = self
        setupButtons()
    }
    
    // MARK: Actions
    
    @IBAction private func didTappedShowAllPhonesButton(_ sender: UIButton) {
        
        setupAlert("Phones in DB: \(protocolManager.getAll())", "OK")
        
    }
    
    @IBAction private func didTappedFindByEmeiButton(_ sender: UIButton) {
        guard imeiTextField.hasText,
              !realm.isEmpty
        else { return }
        let phone = MobilObject()
        
        phone.model = modelTextField.text!
        phone.imei = imeiTextField.text!
        
        setupAlert("Phone with this IMEI: \(protocolManager.findByImei(phone.imei)?.model ?? "not found")", "OK")
        
//        modelTextField.text = ""
//        imeiTextField.text = ""
        
    }
    
    @IBAction private func didTappedCheckPhoneButton(_ sender: UIButton) {
        guard modelTextField.hasText,
              imeiTextField.hasText,
              !realm.isEmpty
        else { return }
        
        let phone = MobilObject()
        
        phone.model = modelTextField.text!
        phone.imei = imeiTextField.text!
        
        setupAlert("Product is exist: \(protocolManager.exists(phone))","OK")
        
//        modelTextField.text = ""
//        imeiTextField.text = ""
    }
    
    @IBAction private func didTappedSaveButton(_ sender: UIButton) {
        
        guard modelTextField.hasText,
              imeiTextField.hasText
        else { return }
        
        guard imeiTextField.text! != realm.object(ofType: MobilObject.self, forPrimaryKey: imeiTextField.text)?.imei
        else { return setupAlert("This product already exist in DB", "OK") }
        
            do {
                let phone = MobilObject()

                phone.model = modelTextField.text!
                phone.imei = imeiTextField.text!
                
                try protocolManager.save(phone)
            } catch let error as NSError {
                print("MYLOG: " + error.localizedDescription)
            }
        
//        modelTextField.text = ""
//        imeiTextField.text = ""

    }
    
    @IBAction private func didTappedDeleteButton(_ sender: UIButton) {
        
        guard modelTextField.hasText,
              imeiTextField.hasText
        else { return }
        
        guard imeiTextField.text! == realm.object(ofType: MobilObject.self, forPrimaryKey: imeiTextField.text)?.imei
        else { return setupAlert("This product not exist in DB", "OK") }
        
            do {
                let phone = MobilObject()

                phone.model = modelTextField.text!
                phone.imei = imeiTextField.text!
              
                try protocolManager.delete(phone)
            } catch let error as NSError {
                print("MYLOG: " + error.localizedDescription)
            }
        
//        modelTextField.text = ""
//        imeiTextField.text = ""
    }
}

// MARK: NotificationDelegate

extension MobilesViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .badge, .sound])
    }
}

extension MobilesViewController: UITextFieldDelegate {
    
}
