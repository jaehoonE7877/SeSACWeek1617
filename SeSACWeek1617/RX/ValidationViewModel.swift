//
//  ValidationViewModel.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/27.
//

import Foundation
import RxSwift
import RxRelay

final class ValidationViewModel {
    
    let validText = BehaviorRelay(value: "닉네임은 최소 8글자 이상 필요해요")
    
}
