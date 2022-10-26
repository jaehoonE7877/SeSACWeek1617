//
//  NewsViewModel.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/20.
//

import Foundation
import RxSwift
import RxCocoa

final class NewsViewModel {
    
    var pageNumber = BehaviorSubject<String>(value: "3000")
    // 내부에서 가져오는 데이터()
    var newsSample = PublishRelay<[News.NewsItem]>()
    
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
        newsSample.accept([])
    }
    
    func loadSample() {
        newsSample.accept(News.items)
    }
}
