//
//  ViewController.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 05/04/2021.
//

import UIKit
import RxCocoa
import RxGesture
import RxSwift

class RepositorySearchViewController: BaseViewController {

    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    @IBOutlet weak var searchViewTopToViewCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchViewTopToViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var noPreviousSearchLabel: UILabel!
    
    var viewModel: RepositorySearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBindings()
    }

    private func setupBindings() {
        
        self.searchView.rx.swipeGesture([.up, .down]).when(.ended).map { gesture in
            gesture.direction == .up
        }.asObservable()
        .bind(to: self.viewModel.searchViewGesture)
        .disposed(by: self.disposeBag)
        
        self.viewModel.searchViewIsUp.drive { isViewUp in
            self.changeSearchViewPosition(up: isViewUp)
        }.disposed(by: self.disposeBag)
        
        self.searchCollectionView.rx
            .setDelegate(self)
            .disposed(by:self.disposeBag)
        
        self.viewModel.previousSearchCells.drive(self.searchCollectionView.rx.items(cellIdentifier: "RecentRepositoryCell", cellType: RecentRepositoryCell.self)) { i, cellModel, cell in
            cell.repositoryName.text = cellModel.name
            cell.numberOfCommits.text = String(cellModel.numberOfCommits)
        }.disposed(by: self.disposeBag)

        
    }
    
    private func changeSearchViewPosition(up:Bool) {
        if(up){
            self.searchViewTopToViewCenterConstraint.isActive = false
            self.searchViewTopToViewTopConstraint.isActive = true
        } else {
            self.searchViewTopToViewTopConstraint.isActive = false
            self.searchViewTopToViewCenterConstraint.isActive = true
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    
}

extension RepositorySearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.bounds.width
            let cellWidth = (width - 30) / 2
        return CGSize(width: cellWidth, height: cellWidth * 1.2)
        }
}

