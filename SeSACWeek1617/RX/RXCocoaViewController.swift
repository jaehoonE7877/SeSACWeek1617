//
//  RXCocoaViewController.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/24.
//

import UIKit
import RxCocoa
import RxSwift

final class RXCocoaViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var simpleLabel: UILabel!
    @IBOutlet weak var simpleSwitch: UISwitch!
    
    @IBOutlet weak var signName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    var nickname = Observable.just("Jack")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nickname
            .bind(to: nicknameLabel.rx.text)
            .disposed(by: disposeBag)
            
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.nickname = "HELLO"
//        }
        
        setTableView()
        setPickerView()
        setSwitch()
        setSign()
        setOperator()
    }
    // viewcontroller deinit 되면, 알아서 disposed도 동작한다.
    // 또는 DisposeBad() 객체를 새롭게 넣어주거나, nil을 할당. => 예외 케이스!(rootVC에 Infinite 시퀀스)
    deinit {
        print("RxCocoaExampleViewController")
    }
    
    
    private func setTableView() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // 데이터
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])
        // 데이터를 전달 받고 Cell에 넣어줌
        items
        .bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        // model, item => data를 가지고 올 건가? indexPath를 가지고 올 것인가
        // bind subscribe에서 onNext만 가지고 있기 때문에 error, completed이벤트는 없다.
        tableView.rx.modelSelected(String.self)
            .map{ data in
                "\(data)를 클릭했습니다."
            }
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    private func setPickerView() {
        
        let items = Observable.just([
                "영화",
                "애니메이션",
                "드라마",
                "기타"
            ])
     
        items
            .bind(to: pickerView.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        //[String] 에러문구 잘 읽어보기!
        pickerView.rx.modelSelected(String.self)
            .map { $0.description }
            .bind(to: simpleLabel.rx.text )
//            .subscribe(onNext: { value in
//                print(value)
//            })
            .disposed(by: disposeBag)
        
    }
    
    private func setSwitch(){
        Observable.of(false)    // just? of? 차이는 뭘까?
            .bind(to: simpleSwitch.rx.isOn)
            .disposed(by: disposeBag)
    }
    
    private func setSign() {
        
        //ex 텍1(observable), 텍2(Observable) > 레이블(Observer, bind)
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            return "name은 \(value1)이고, email은 \(value2)입니다"
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
        
        // textfield 데이터 유효성 검증
        signName.rx.text.orEmpty  // React -> String? -> String -> 데이터의 Stream
            .map { $0.count < 4 } // Int
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmail.rx.text.orEmpty // email 데이터 유효성 검증
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton.rx.tap
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.showAlert()
            }
            .disposed(by: disposeBag)
    }
    
    private func setOperator() {
        
        //네트워크를 했을 때 실패하면 몇 번을 다시 시도할지 이렇게 사용
        Observable.repeatElement("Jack") //  Infinite Observable Sequence
            .take(5) // Finite Observable Sequence
            .subscribe { value in
                print("reapeat - \(value)")
            } onError: { error in
                print("repeat - \(error)")
            } onCompleted: {
                print("repeat completed")
            } onDisposed: {
                print("repeat disposed")
            }
            .disposed(by: disposeBag)
        
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval - \(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.disposeBag = DisposeBag() // 한번에 (Observable들)리소스 정리
//        }
        
        
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        let itemsB = [2.3, 2.0, 1.3]
        
        Observable.just(itemsA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.of(itemsA, itemsB)
            .subscribe { value in
                print("of - \(value)")
            } onError: { error in
                print("of - \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)
        
        Observable.from(itemsA)
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)
    }
    
    private func showAlert(){
        let alert = UIAlertController(title: "하하하", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
}
