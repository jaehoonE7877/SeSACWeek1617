//
//  SimplePickerViewController.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class SimplePickerViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let firstPickerView = UIPickerView().then {
        $0.backgroundColor = .systemBackground
    }
    
    let secondPickerView = UIPickerView().then {
        $0.backgroundColor = .systemBackground
        $0.isHidden = false
    }
    
    let thirdPickerView = UIPickerView().then {
        $0.backgroundColor = .systemBackground
        $0.isHidden = false
    }
    
    let mainLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.text = "Example"
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setBinding()
    }
    
    private func setUI(){
        
        view.backgroundColor = .systemBackground
        
        [firstPickerView, secondPickerView, thirdPickerView, mainLabel].forEach { view.addSubview($0) }
        
        firstPickerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view)
            make.height.equalTo(150)
        }
        
        secondPickerView.snp.makeConstraints { make in
            make.top.equalTo(firstPickerView.snp.bottom).offset(20)
            make.size.equalTo(firstPickerView)
        }
        
        thirdPickerView.snp.makeConstraints { make in
            make.top.equalTo(secondPickerView.snp.bottom).offset(20)
            make.size.equalTo(firstPickerView)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(thirdPickerView.snp.bottom).offset(20)
            make.height.equalTo(44)
            make.centerX.equalTo(self.view)
        }
        
    }
    
    private func setBinding() {
        
        Observable.just(["고래밥", "칙촉", "오감자", "꼬북칩"])
            .bind(to: firstPickerView.rx.itemTitles) { _, item in
                return "\(item)"
            }
            .disposed(by: disposeBag)
        
        firstPickerView.rx.modelSelected(String.self)
            .map{ "\($0)을 선택했습니다. 야미"}
            .bind(to: mainLabel.rx.text)
            .disposed(by: disposeBag)
        
        Observable.just([1,2,3,4,5])
            .bind(to: secondPickerView.rx.itemAttributedTitles) { _, item in
               return NSAttributedString(string: "\(item)",
                                          attributes: [
                                            NSAttributedString.Key.foregroundColor: UIColor.cyan,
                                            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.double.rawValue
                                        ])
            }
            .disposed(by: disposeBag)
        
        secondPickerView.rx.modelSelected(Int.self)
            .subscribe(onNext: { value in
                print(value)
            })
            .disposed(by: disposeBag)
        
        Observable.just([UIColor.red, UIColor.green, UIColor.blue])
            .bind(to: thirdPickerView.rx.items) { _, item, _ in
                let view = UIView()
                view.backgroundColor = item
                return view
            }
            .disposed(by: disposeBag)
        
        thirdPickerView.rx.modelSelected(UIColor.self)
            .subscribe { value in
                print("UIColor - \(value)")
            }
            .disposed(by: disposeBag)
            
    }
    
}
