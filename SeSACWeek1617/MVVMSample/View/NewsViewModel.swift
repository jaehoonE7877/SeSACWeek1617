//
//  NewsViewModel.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/20.
//

import Foundation
import RxSwift

final class NewsViewModel {
    
    var pageNumber = BehaviorSubject(value: "3000")
    
    var newsSample = PublishSubject<[News.NewsItem]>()
    
}

extension NewsViewModel {
    
    func changePageNumberFormat(_ text: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let text = text.replacingOccurrences(of: ",", with: "")
        guard let numberText = Int(text) else { return }
        let result = formatter.string(for: numberText)!
        pageNumber.onNext(result)
    }
    
    func resetSample() {
        newsSample.onNext([])
    }
    
    func loadSample() {
        newsSample.onNext(News.items)
    }
}
