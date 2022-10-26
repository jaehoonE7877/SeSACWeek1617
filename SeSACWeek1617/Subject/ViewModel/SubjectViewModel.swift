//
//  SubjectViewModel.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/25.
//

import Foundation
import RxSwift
import RxCocoa

struct Contact {
    var name: String
    var age: Int
    var phoneNumber: String
}

class SubjectViewModel {
    
    var contactData = [
        Contact(name: "Jack", age: 21, phoneNumber: "01012341234"),
        Contact(name: "Hue", age: 19, phoneNumber: "01023452345"),
        Contact(name: "Bro", age: 20, phoneNumber: "01034563456")
    ]
    
    var list = PublishRelay<[Contact]>()
    
    func fetchContact() {
        list.accept(contactData)
    }
    
    func resetContact() {
        list.accept([])
    }
    
    func addContact() {
        let new = Contact(name: "고래밥", age: Int.random(in: 10...50), phoneNumber: "01022225555")
        contactData.append(new)
        list.accept(contactData)
    }
    
    func fliterContact(query: String) {
        
        let result = query != "" ? contactData.filter{ $0.name.contains(query)} : contactData
        list.accept(result)

    }
}


