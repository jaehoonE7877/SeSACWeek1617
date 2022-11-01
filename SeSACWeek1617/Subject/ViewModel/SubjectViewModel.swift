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

class SubjectViewModel: ViewModelType {
    
    struct Input{
        let addTap: ControlEvent<Void>
        let resetTap: ControlEvent<Void>
        let newTap: ControlEvent<Void>
        let searchText: ControlProperty<String?>
    }
    
    struct OutPut {
        let addTap: ControlEvent<Void>
        let resetTap: ControlEvent<Void>
        let newTap: ControlEvent<Void>
        let list: Driver<[Contact]>
        let searchText: Observable<String>
    }
    
    func transform(input: Input) -> OutPut {
        
        let list = list.asDriver(onErrorJustReturn: [])
        
        let text = input.searchText.orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) //디바운스 -> 사용자가 입력하고 멈춘 시점에서 1초 뒤에 검색시작
            .distinctUntilChanged()
        
        return OutPut(addTap: input.addTap, resetTap: input.resetTap, newTap: input.newTap, list: list, searchText: text)
    }
    
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


