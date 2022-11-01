//
//  ValidationViewModel.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/27.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype OutPut
    
    func transform(input: Input) -> OutPut
}

final class ValidationViewModel: ViewModelType {
    
    let validText = BehaviorRelay(value: "닉네임은 최소 8글자 이상 필요해요")
    
    struct Input {
        let text: ControlProperty<String?> //nameTextField.rx.text
        let tap: ControlEvent<Void> //stepButton.rx.tap
    }
    
    struct OutPut {
        let validation: Driver<Bool>
        let tap: ControlEvent<Void>
        let text: Driver<String>
    }
    
    func transform(input: Input) -> OutPut {
        let valid = input.text
            .orEmpty
            .map{ $0.count >= 8 }
            .asDriver(onErrorJustReturn: false)
        
        let text = validText.asDriver()
            
        return OutPut(validation: valid, tap: input.tap, text: text)
    }
}
