//
//  DiffableViewModel.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/20.
//

import Foundation
import RxSwift

enum SearchError: Error {
    case noPhoto
    case serverError
}

final class DiffableViewModel {
    
    // 서버요청(API Request)
    // 응답이 온
//    var photoList: CObservable<SearchPhoto> = CObservable(SearchPhoto(total: 0, totalPages: 0, results: []))
    var photoList = PublishSubject<SearchPhoto>()
    
    // 실패할 수 있는 가능성이 있는 서버통신
    func requestSearchPhoto(query: String) {
        APIService.searchPhoto(query: query) { [weak self] photo, statusCode, error in
            
            guard let statusCode = statusCode, statusCode == 200 else {
                self?.photoList.onError(SearchError.serverError)
                return
            }
            
            guard let photo = photo else {
                self?.photoList.onError(SearchError.noPhoto)
                return
            }
            self?.photoList.onNext(photo)
        }
    }
    
}

