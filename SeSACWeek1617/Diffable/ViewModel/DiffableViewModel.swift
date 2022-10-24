//
//  DiffableViewModel.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/20.
//

import Foundation

final class DiffableViewModel {
    
    // 서버요청(API Request)
    // 응답이 온
    var photoList: CObservable<SearchPhoto> = CObservable(SearchPhoto(total: 0, totalPages: 0, results: []))
    
    func requestSearchPhoto(query: String) {
        APIService.searchPhoto(query: query) { photo, statusCode, error in
            guard let photo = photo else { return }
            self.photoList.value = photo
        }
    }
    
}

