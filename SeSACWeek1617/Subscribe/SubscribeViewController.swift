//
//  SubscribeViewController.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/26.
//

import UIKit
import RxSwift
import RxCocoa

class SubscribeViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var label: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBinding()
        
        
    }
    
    private func setBinding() {
        
        // 1.
        button.rx.tap
            .subscribe { [weak self]_ in
                self?.label.text = "안녕반가워"
            }
            .disposed(by: disposeBag)
        // 2.
        button.rx.tap
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        // 3. ui -> 메인 스레드에서
        // 네트워크 통신이나 파일 다운로드 등 백그라운드 작업에 대해서?
        button.rx.tap
            .observe(on: MainScheduler.instance) // 이후 구독하는 요소에 대해서 메인 스레드 처리 (DispatchQueue main)
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.label.text = "안녕 반가워"
            }
            .disposed(by: disposeBag)
        //4. bind -> 무조건 메인 쓰레드에서 작동 : subscribe, mainScheduler, error X
        button.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.label.text = "반녕 안가워"
            }
            .disposed(by: disposeBag)
        //5. 정적인 data를 보내줄땐 operator의 data 스트림을 조작
        button
            .rx
            .tap
            .map{"갓녕 반가워"}
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        //6. driver traits: bind의 특성과 동일 -> 메인스레드 + 에러이벤트 x ++++ 스트림이 공유될 수 있다!(리소스 낭비를 방지, share())
        button
            .rx
            .tap
            .map { "갓녕 드라이버" }
            .asDriver(onErrorJustReturn: "")
            .drive(label.rx.text)
            .disposed(by: disposeBag)
    }

    
}
