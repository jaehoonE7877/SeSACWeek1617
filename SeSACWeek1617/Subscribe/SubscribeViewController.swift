//
//  SubscribeViewController.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/26.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import RxDataSources

class SubscribeViewController: UIViewController {

    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>(configureCell: { dataSource, tableView, indexPath, item in
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = "\(item)"
        return cell
        
    })
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setBinding()
        testRxAlamofire()
        testRxDataSource()
    }
    
    private func testRxDataSource() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].model
        }
        
        Observable.just([
            SectionModel(model: "title", items: [1, 2, 3]),
            SectionModel(model: "title1", items: [1, 2, 3]),
            SectionModel(model: "title2", items: [1, 2, 3])
            ])
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
                
    }
    
    //viewmodel에 작성
    private func testRxAlamofire() {
        // Success Error => Single
        let url = APIKey.searchURL + "apple"
        request(.get, url, headers: ["Authorization": APIKey.authorization])
            .data()
            .decode(type: SearchPhoto.self, decoder: JSONDecoder())
            .subscribe { value in
                print(value)
            }
            .disposed(by: disposeBag)
    }
    
    private func setBinding() {
        
        
        Observable.of(1,2,3,4,5,6,7,8,9,10)
            .skip(3) // 앞에서 3개의 이벤트는 무시하겠다.
            .debug()
            .filter { $0 % 2 == 0 }
            .map { $0 * 2 }
            .subscribe { value in
                print(value)
            }
            .disposed(by: disposeBag)

        
        
        let sample = button.rx.tap
        
        // 1.
        sample
            .subscribe { [weak self]_ in
                self?.label.text = "안녕반가워"
            }
            .disposed(by: disposeBag)
        // 2.
        button.rx.tap
            .withUnretained(self)
            .subscribe { vc, _ in
                DispatchQueue.main.async {
                    vc.label.text = "안녕 반가워"
                }
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
        //5. 정적인 data를 보내줄땐 operator의 data stream을 조작
        button
            .rx
            .tap
            //.debug() // print는 rx에서 해줄 수 있지 않기 때문에 lldb를 사용하지 않고 디버그라는 요소를 통해서 확인할 수 있다.
            .map{"갓녕 반가워"}
            //.debug()
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
