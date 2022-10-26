//
//  SubjectViewController.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/25.
//

import UIKit
import RxSwift
import RxCocoa

class SubjectViewController: UIViewController {
    
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newButton: UIBarButtonItem!
    
    let publish = PublishSubject<Int>() // 초기 값이 없는 빈 상태
    let behavior = BehaviorSubject(value: 100) //초기값 필수
    let replay = ReplaySubject<Int>.create(bufferSize: 3) //bufferSize에 작성이 된 event 만큼 메모리에서 event를 가지고 있다가, subscribe한 후 한 번에 이벤트를 전달
    let async = AsyncSubject<Int>()
    
    let viewModel = SubjectViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        
    }
    
    private func setTableView() {
                
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
        
        viewModel.list.bind(to: tableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self)) { (row, element, cell) in
            cell.textLabel?.text = "\(element.name): \(element.age)세 (\(element.phoneNumber))"
            
        }
        .disposed(by: disposeBag)
        
        addButton.rx.tap
            .withUnretained(self)
//            .bind(to: { vc, _ in
//                vc.viewModel.fetchContact()
//            })
            .bind { vc, _ in
                vc.viewModel.fetchContact()
            }
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .withUnretained(self)
            .bind { vc, _ in
                vc.viewModel.resetContact()
            }
            .disposed(by: disposeBag)
        
        newButton.rx.tap
            .withUnretained(self)
            .subscribe { vc, _ in
                vc.viewModel.addContact()
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .withUnretained(self)
        //디바운스 -> 사용자가 입력하고 멈춘 시점에서 1초 뒤에 검색시작
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            //.distinctUntilChanged()
            .subscribe { vc, value in
                print("======\(value)")
                vc.viewModel.fliterContact(query: value)
            }
            .disposed(by: disposeBag)
    }
    
}

extension SubjectViewController {
    
//    private func asyncSubject() {
//        
//        async.onNext(300)
//        async.onNext(400)
//        async.onNext(500)
//        
//        async
//            .subscribe { value in
//                print("async - \(value)")
//            } onError: { error in
//                print("async - \(error)")
//            } onCompleted: {
//                print("async - onCompleted")
//            } onDisposed: {
//                print("async - onDisposed")
//            }
//            .disposed(by: disposeBag)
//        
//        async.onNext(3)
//        async.onNext(4)
//        
//        async.onCompleted()
//        
//        async.onNext(6)
//    }
//    
//    private func replaySubject() {
//        // 네이버에서 최근검색어 10개만 나올 때, 미리 값을 넣고 싶은데 그 값들이 여러 개일 때
//        // BufferSize가 1000개라고 가정
//        // 배열, 이미지 -> 메모리에 많은 부하를 줄 수 있다.
//
//        replay.onNext(100)
//        replay.onNext(200)
//        replay.onNext(300)
//        replay.onNext(400)
//        replay.onNext(500)
//        
//        replay
//            .subscribe { value in
//                print("replay - \(value)")
//            } onError: { error in
//                print("replay - \(error)")
//            } onCompleted: {
//                print("replay - onCompleted")
//            } onDisposed: {
//                print("replay - onDisposed")
//            }
//            .disposed(by: disposeBag)
//        
//        replay.onNext(3)
//        replay.onNext(4)
//        
//        replay.onCompleted()
//        
//        replay.onNext(6)
//    }
//    
//    private func behaviorSubject() {
//        //구독 전에 가장 최근 값을 같이 emit
////        behavior.onNext(1)
////        behavior.onNext(2)
//        
//        behavior
//            .subscribe { value in
//                print("behavior - \(value)")
//            } onError: { error in
//                print("behavior - \(error)")
//            } onCompleted: {
//                print("behavior - onCompleted")
//            } onDisposed: {
//                print("behavior - onDisposed")
//            }
//            .disposed(by: disposeBag)
//        
//        behavior.onNext(3)
//        behavior.onNext(4)
//        
//        behavior.onCompleted()
//        
//        behavior.onNext(6)
//    }
//    
//    private func publishSubject() {
//        // 초기값이 없는 빈 상태, subscribe 전 /error/completed noti 이후 이벤트 무시
//        // subscribe 후에 대한 이벤트는 다 처리
//        
//        publish.onNext(1)
//        publish.onNext(2)
//        
//        publish
//            .subscribe { value in
//                print("publish - \(value)")
//            } onError: { error in
//                print("publish - \(error)")
//            } onCompleted: {
//                print("publish - onCompleted")
//            } onDisposed: {
//                print("publish - onDisposed")
//            }
//            .disposed(by: disposeBag)
//        
//        publish.onNext(3)
//        publish.onNext(4)
//        
//        publish.onCompleted()
//        
//        publish.onNext(6)
//        
//    }
}
