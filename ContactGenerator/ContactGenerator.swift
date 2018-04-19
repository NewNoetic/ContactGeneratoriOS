//
//  ContactGenerator.swift
//  ContactGenerator
//
//  Created by Sidhant Gandhi on 4/19/18.
//  Copyright © 2018 NewNoetic, Inc. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import Contacts

public struct BasicContact {
    public var firstName: String
    public var lastName: String
    public var email: String
    public var phone: String
}

public enum ContactGeneratorError: Error {
    case JSON
    case Data
}

public struct ContactGenerator {
    public static func generate(count: Int = 1) -> Promise<[BasicContact]> {
        return Promise { seal in
            Alamofire.request("https://randomuser.me/api").responseJSON { response in
//                print("Request: \(String(describing: response.request))")   // original url request
//                print("Response: \(String(describing: response.response))") // http url response
//                print("Result: \(response.result)")                         // response serialization result
                
                guard let json = response.result.value else {
                    seal.reject(ContactGeneratorError.JSON)
                    return
                }
                
//                print("JSON: \(json)") // serialized json response
                
                guard let jsonDictionary = json as? [String: Any] else { seal.reject(ContactGeneratorError.Data); return }
                
                guard let jsonArray = jsonDictionary["results"] as? [[String: Any]] else {
                    seal.reject(ContactGeneratorError.Data)
                    return
                }
                
                let contacts = jsonArray.compactMap({ (contactData: [String: Any]) -> BasicContact? in
                    guard let name: [String: String] = contactData["name"] as? [String: String] else { return nil }
                    guard let firstName = name["first"]?.localizedCapitalized else { return nil }
                    guard let lastName = name["last"]?.localizedCapitalized else { return nil }
                    guard let email = contactData["email"] as? String else { return nil }
                    guard let phone = contactData["phone"] as? String else { return nil }
                    
                    return BasicContact(firstName: firstName, lastName: lastName, email: email, phone: phone)
                })
                
                seal.fulfill(contacts)
            }
        }
    }
    
    public static func saveToDevice(_ contacts: [BasicContact]) {
        let deviceContacts = contacts.map { (basicContact) -> CNMutableContact in
            let contact = CNMutableContact()
            contact.givenName = basicContact.firstName
            contact.familyName = basicContact.lastName
            
            let email = CNLabeledValue(label: CNLabelHome, value: basicContact.email as NSString)
            contact.emailAddresses = [email]
            
            contact.phoneNumbers = [CNLabeledValue(
                label:CNLabelPhoneNumberMain,
                value:CNPhoneNumber(stringValue:basicContact.phone))]
            
            return contact
        }
     
        // Saving the newly created contact
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        
        deviceContacts.forEach { (c) in
            saveRequest.add(c, toContainerWithIdentifier:nil)
        }
        
        try! store.execute(saveRequest)
    }
    
    public static func deleteAllContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error: Error?) in
            guard granted else { return }
            let predicate = CNContact.predicateForContactsInContainer(withIdentifier: store.defaultContainerIdentifier())
            let deleteRequest = CNSaveRequest()
            guard let contacts = try? store.unifiedContacts(matching: predicate, keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor]) else { return }
            contacts.forEach({ (c) in
                deleteRequest.delete(c.mutableCopy() as! CNMutableContact)
            })
            
            do {
                try store.execute(deleteRequest)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
