//
//  NewsViewController.swift
//  SeSACWeek1617
//
//  Created by Seo Jae Hoon on 2022/10/20.
//

import UIKit
final class NewsViewController: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!
    
    private var viewModel = NewsViewModel()
    
    private typealias CellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, News.NewsItem>
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, News.NewsItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, News.NewsItem>
    
    private var dataSource: DataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierachy()
        // 순서 생각해보기 -> DataSource가 먼저 선언되어야 함
        configureDataSource()
        setBinding()
        
        configureViews()
    }
    
    private func setBinding() {
        
        viewModel.pageNumber.bind { value in
            self.numberTextField.text = value
        }
        
        viewModel.newsSample.bind { item in
            var snapshot = Snapshot()
            snapshot.appendSections([0])
            snapshot.appendItems(item)
            self.dataSource.apply(snapshot)
        }
    }
    
    private func configureViews() {
        numberTextField.addTarget(self, action: #selector(numberTextFieldChanged), for: .editingChanged)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        loadButton.addTarget(self, action: #selector(loadButtonTapped), for: .touchUpInside)
    }
    // 사용자의 액션에 따른 데이터 변경 지점
    @objc func numberTextFieldChanged() {
        guard let text = self.numberTextField.text else { return }
        viewModel.changePageNumberFormat(text)
    }
    
    @objc func resetButtonTapped() {
        viewModel.resetSample()
    }

    @objc func loadButtonTapped() {
        viewModel.loadSample()
    }
        
}

extension NewsViewController {
    // 코드베이스 addSubView, init, snapkit은 여기 들어감
    private func configureHierachy() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .lightGray
    }
    
    private func configureDataSource() {
        
        let cellRegisteration = CellRegistration { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.title
            
            content.secondaryText = itemIdentifier.body
            cell.contentConfiguration = content
        }
        
        self.dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
        
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        return layout
    }
}
