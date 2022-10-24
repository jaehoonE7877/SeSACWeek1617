//
//  SimpleNumberViewController.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/24.
//

import UIKit

import RxSwift
import RxCocoa

final class SimpleNumberViewController: UIViewController {
    
    //let disposeBag = DisposeBag()
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBinding()
        
    }
    
    private func setBinding() {
        
        let disposeBag = DisposeBag()
        
//        Observable.combineLatest(firstTextField.rx.text.orEmpty, secondTextField.rx.text.orEmpty, thirdTextField.rx.text.orEmpty) { value1, value2, value3 -> Int in
//            return (Int(value1) ?? 0) + (Int(value2) ?? 0) + (Int(value3) ?? 0)
//        }
//        .map { $0.discription }
//        .bind(to: resultLabel.rx.text)
//        .disposed(by: disposeBag)
        
    }

    
}
