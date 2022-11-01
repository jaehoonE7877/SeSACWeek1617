//
//  ValidationViewController.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/24.
//

import UIKit

import RxSwift
import RxCocoa

class ValidationViewController: UIViewController {


    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var stepButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    let viewModel = ValidationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        setBinding()
        //observableVSSubject()
    }
    
    private func setBinding() {
        
        let input = ValidationViewModel.Input(text: nameTextField.rx.text, tap: stepButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.text
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.validation
            .drive(stepButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
//        let validation = nameTextField.rx.text
//            .orEmpty // String
//            .map { $0.count >= 8 } // Bool
//            .asDriver(onErrorJustReturn: false)
//
//        validation
//            .drive(stepButton.rx.isEnabled, validationLabel.rx.isHidden)
//            .disposed(by: disposeBag)

        output.validation
            .drive { [weak self] value in
                guard let self = self else { return }
                let color: UIColor = value ? .systemPink : .systemMint
                self.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        output.tap //Input
            .withUnretained(self)
            .bind { vc, _ in
                vc.showAlert()
            }
            .disposed(by: disposeBag)
        
        
    }
    
    private func observableVSSubject() {
        
        // just, of, from 의 내부 구조는 이렇게 구현되어 있다
        let sampleInt = Observable<Int>.create { observer in
            observer.onNext(Int.random(in: 1...100))
            return Disposables.create()
        }
        
        sampleInt
            .subscribe { value in
            print("sampleInt : \(value)")
            }
            .disposed(by: disposeBag)
        
        sampleInt
            .subscribe { value in
            print("sampleInt : \(value)")
            }
            .disposed(by: disposeBag)
        
        sampleInt
            .subscribe { value in
            print("sampleInt : \(value)")
            }
            .disposed(by: disposeBag)
        
        let subjectInt = BehaviorSubject(value: 0)
        subjectInt.onNext(Int.random(in: 1...100))
        
        subjectInt
            .subscribe { value in
            print("subjectInt = \(value)")
            }
            .disposed(by: disposeBag)
        
        subjectInt
            .subscribe { value in
            print("subjectInt = \(value)")
            }
            .disposed(by: disposeBag)
        
        subjectInt
            .subscribe { value in
            print("subjectInt = \(value)")
            }
            .disposed(by: disposeBag)
        
        let testA = stepButton.rx.tap
            .map { "안녕하세요" }
            .asDriver(onErrorJustReturn: "")
            //.share()
        
        testA
            .drive(validationLabel.rx.text)
            //.bind(to: validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        testA
            .drive(nameTextField.rx.text)
            //.bind(to: nameTextField.rx.text)
            .disposed(by: disposeBag)
        
        testA
            .drive(stepButton.rx.title())
            //.bind(to: stepButton.rx.title())
            .disposed(by: disposeBag)
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: "하하하", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }


}
