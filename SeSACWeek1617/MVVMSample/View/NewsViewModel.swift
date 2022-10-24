//
//  NewsViewModel.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/20.
//

import Foundation

final class NewsViewModel {
    
    var pageNumber: CObservable<String> = CObservable("3000")
    
    var newsSample: CObservable<[News.NewsItem]> = CObservable(News.items)
    
}

extension NewsViewModel {
    
    func changePageNumberFormat(_ text: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let text = text.replacingOccurrences(of: ",", with: "")
        guard let numberText = Int(text) else { return }
        let result = formatter.string(for: numberText)!
        pageNumber.value = result
    }
    
    func resetSample() {
        newsSample.value = []
    }
    
    func loadSample() {
        newsSample.value = News.items
    }
}
