//
//  DiffableCollectionViewController.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/19.
//

import UIKit

import Kingfisher

final class DiffableCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var viewModel = DiffableViewModel()
    
    // Int -> Section에 대한 정보 , String -> 들어가는 모델의 타입<Jacsim>
    private var dataSource: UICollectionViewDiffableDataSource<Int, SearchResult>!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        searchBar.delegate = self
        
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
        setBinding()
        
    }
    
    private func setBinding() {
        
        viewModel.photoList.bind { photo in
            //Initial(스냅샷)
            //어떤 섹션Int에 어떤 데이터<String>를 넣을 지 정하는 곳
            var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResult>()
            snapshot.appendSections([0])
            snapshot.appendItems(photo.results)
            self.dataSource.apply(snapshot)
            
        }
        
    }

}

extension DiffableCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // list에 추가하는게 아니라 datasource의 snapshot의 itemidentifier를 사용해서 db에 추가할 수 있다!
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        let alert = UIAlertController(title: "\(item.urls.regular)", message: "클릭", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
}


extension DiffableCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
    
    private func configureDataSource() {
        
        let cellRegisteration = UICollectionView.CellRegistration<UICollectionViewListCell,SearchResult>(handler: { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = "\(itemIdentifier.likes)"
            
            //String >> URL >> Data >> Image
            DispatchQueue.global().async {
                let url = URL(string: itemIdentifier.urls.thumb)!
                let data = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    content.image = UIImage(data: data!)
                    cell.contentConfiguration = content
                }
                
            }
            
            
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.strokeWidth = 2
            background.strokeColor = .systemPink
            cell.backgroundConfiguration = background
            
        })
        
        //collectionView.dataSource = self와 같은 맥락 => numberOfItemsInSection, cellForItemAt 메서드를 대신함
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
        
    }
    
}

extension DiffableCollectionViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        viewModel.requestSearchPhoto(query: query)
    }
    
}
