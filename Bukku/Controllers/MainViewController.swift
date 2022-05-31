//
//  MainViewController.swift
//  Minimum
//
//  Created by 김응철 on 2022/05/27.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    // MARK: - Properties
    let mainLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 38.0, weight: .heavy)
        label.textColor = .getBlack()
        label.text = "당신의 목표는"
        
        return label
    }()
    
    let goalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 38.0, weight: .thin)
        label.textColor = .getBlack()
        label.text = "하루에 한 페이지!"
        
        return label
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        
        return view
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .getBlack()
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration.init(pointSize: 40.0), forImageIn: .normal)
        button.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MainCollectionViewCell.self,
                                forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    @objc func didTapSearchButton() {
        let nav = UINavigationController(rootViewController: SearchViewController())
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }

    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .getGray()
        
        [ mainLabel, goalLabel, searchButton, lineView, collectionView ]
            .forEach { view.addSubview($0) }
        
        mainLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        goalLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(searchButton.snp.leading).offset(4)
        }
        
        searchButton.snp.makeConstraints { make in
            make.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        lineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(goalLabel.snp.bottom).offset(24)
            make.height.equalTo(0.5)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, _ -> NSCollectionLayoutSection in
            return self.createMainSection()
        }
    }
    
    func createMainSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        return section
    }
}

// MARK: - CollectionView
extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MainCollectionViewCell.identifier,
            for: indexPath
        ) as? MainCollectionViewCell else { return UICollectionViewCell() }
        cell.setupUI()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
}
