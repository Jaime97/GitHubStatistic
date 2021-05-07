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
import BetterSegmentedControl

class RepositorySearchViewController: BaseViewController {

    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var newSearchView: UIView!
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    
    @IBOutlet weak var searchViewTopToViewCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchViewTopToViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var noPreviousSearchLabel: UILabel!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var searchButtonBottomToViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchResultTableView: UITableView!
    
    
    @IBOutlet weak var searchTypeSegmentedControl: BetterSegmentedControl! {
        didSet {
            self.searchTypeSegmentedControl.segments = LabelSegment.segments(withTitles: [NSLocalizedString("repository", comment: ""), NSLocalizedString("owner", comment: "")],
                                                                             normalTextColor: .appColor(.TopBackgroundColor),
                                                                             selectedTextColor: .black)
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            self.searchTextField.tintColor = UIColor.gray
            self.searchTextField.setIcon(UIImage(named: "search_simple")!)
            self.searchTextField.attributedPlaceholder = NSAttributedString(string:NSLocalizedString("search_repo_here", comment: ""),
                                                                            attributes:[NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            self.searchTextField.delegate = self
        }
     }
    
    @IBOutlet weak var blackCoverView: UIView!
    
    var viewModel: RepositorySearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBindings()
    }

    private func setupBindings() {
        
        self.searchCollectionView.rx
            .setDelegate(self)
            .disposed(by:self.disposeBag)
        
        self.searchButton.rx.tap
            .bind(to: self.viewModel.searchButtonTap)
            .disposed(by: self.disposeBag)
        
        self.searchView.rx.swipeGesture([.up, .down]).when(.ended).map { gesture in
            gesture.direction == .up
        }.asObservable()
        .bind(to: self.viewModel.searchViewSwipeGesture)
        .disposed(by: self.disposeBag)
        
        self.viewModel.searchViewIsUp.drive { isViewUp in
            self.changeSearchViewPosition(up: isViewUp)
        }.disposed(by: self.disposeBag)
        
        self.viewModel.showSearchButton.drive { showSearchButton in
            self.showSearchButton(visibility: showSearchButton)
        }.disposed(by: self.disposeBag)
        
        self.viewModel.hidePreviousSearchInterface.drive { hideSearchView in
            self.changeSearchViewVisibility(visibility: !hideSearchView)
        }.disposed(by: self.disposeBag)
        
        self.viewModel.showNewSearchInterface.drive { showNewSearchView in
            self.changeNewSearchViewVisibility(visibility: showNewSearchView)
        }.disposed(by: self.disposeBag)
        
        self.viewModel.previousSearchCells.drive(self.searchCollectionView.rx.items(cellIdentifier: "RecentRepositoryCell", cellType: RecentRepositoryCell.self)) { i, cellModel, cell in
            cell.repositoryName.text = cellModel.name
            cell.numberOfCommits.text = String(cellModel.numberOfCommits)
        }.disposed(by: self.disposeBag)

    }
    
    private func showSearchButton(visibility:Bool) {
        self.searchButtonBottomToViewBottomConstraint.constant = visibility ? 50 : -200
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn) {
            self.view.layoutIfNeeded()
        }
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
            self.blackCoverView.alpha = up ? 1.0 : 0.0
            self.view.layoutIfNeeded()
        }
    }
    
    private func changeSearchViewVisibility(visibility:Bool) {
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveLinear) {
            self.searchView.alpha = visibility ? 1.0 : 0.0
            self.searchButton.alpha = visibility ? 1.0 : 0.0
        }
    }
    
    private func changeNewSearchViewVisibility(visibility:Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
            self.newSearchView.alpha = visibility ? 1.0 : 0.0
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

