//
//  APIService.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/20.
//

import Foundation

import Alamofire

// 네트워크 성공 -> 값이 있고 error 없음
// 네트워크 실패 -> 값이 없고 error 있음
// 둘 다 옵셔널인 경우가 있기 때문에 swift에서 Result문법을 사용한다.

class APIService {
    
    private init() { }
    
    typealias completion = (SearchPhoto?, Int?, Error?) -> Void
    
    static func searchPhoto(query: String, completion: @escaping completion) {
        
        let url = "\(APIKey.searchURL)\(query)"
        let header: HTTPHeaders = ["Authorization": APIKey.authorization]
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: SearchPhoto.self) { response in
            
            let statusCode = response.response?.statusCode // 상태 코드 조건문 처리 해보기
            
            switch response.result {
                
            case .success(let value):
                print(value)
                
                completion(value, statusCode, nil)
                
            case .failure(let error):
                print(error)
                
                completion(nil, statusCode, error)
            }
            
            
        }
    }
    
    
}
