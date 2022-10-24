//
//  SimpleCollectionViewController.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/18.
//

import UIKit

struct UserModel: Hashable {
    let id = UUID().uuidString
    let firstName: String
    let lastName: String
    let age: Int
    
}

class SimpleCollectionViewController: UICollectionViewController {

    //var list = ["닭곰탕", "삼계탕", "들기름김", "삼분카레", "콘소메 치킨"]
    var user = [
        UserModel(firstName: "뽀", lastName: "로로", age: 8),
        UserModel(firstName: "김", lastName: "밥천국", age: 10),
        UserModel(firstName: "해리", lastName: "포터", age: 33),
        UserModel(firstName: "도라", lastName: "에몰", age: 4)
        ]
    
    
    // CellRegistration -> contentConfiguration 적용(cellForItemAt함수 전에 선언해야됨!!!)
    // -> 메서드 안에서 사용하면 오류 발생한다, register 코드와 유사한 역할
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, UserModel>!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, UserModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = createLayout()
        
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            var content =  UIListContentConfiguration.valueCell() //cell.defaultContentConfiguration()
            
            content.text = "\(itemIdentifier.firstName)\(itemIdentifier.lastName)"
            content.textProperties.color = .red
            
            content.secondaryText = "\(itemIdentifier.age)살입니다."
            content.textToSecondaryTextVerticalPadding = 16
            content.prefersSideBySideTextAndSecondaryText = false
            content.secondaryTextProperties.color = .tintColor
            content.secondaryTextProperties.font = .systemFont(ofSize: 14)
            
            content.image = itemIdentifier.age < 9 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star")
            
            content.imageProperties.tintColor = .black
            
            cell.contentConfiguration = content
            
            var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
            backgroundConfiguration.backgroundColor = .lightGray
            backgroundConfiguration.cornerRadius = 8
            backgroundConfiguration.strokeColor = .systemPink
            backgroundConfiguration.strokeWidth = 2
            
            cell.backgroundConfiguration = backgroundConfiguration
            
            
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, UserModel>()
        snapshot.appendSections([0])
        snapshot.appendItems(user)
        dataSource.apply(snapshot)
    }
}
extension SimpleCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        // 14+ 컬렉션뷰를 테이블뷰 스타일처럼 사용 가능 (List Configuration)
        // .sidebar -> IPad에서 사용
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false
        configuration.backgroundColor = .brown
        // compositionalLayout.list -> 어떤 listConfig을 사용할지
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
     
}
