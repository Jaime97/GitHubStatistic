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
    
    @IBOutlet weak var searchResultsLabel: UILabel!
    
    @IBOutlet weak var searchButtonBottomToViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchResultTableView: UITableView! {
        didSet {
            self.searchResultTableView.register(UINib(nibName: "NewRepositorySearchTableViewCell", bundle: nil), forCellReuseIdentifier: "NewRepositorySearchTableViewCell");
        }
    }
    
    
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
    
    var viewModel: RepositorySearchViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBindings()
    }

    private func setupBindings() {
        
        self.searchCollectionView.rx
            .setDelegate(self)
            .disposed(by:self.disposeBag)
        
        // Input bindings
        
        self.viewModel.searchViewIsUp.drive { isViewUp in
            self.changeSearchViewPosition(up: isViewUp)
            self.changeViewVisibility(view: self.blackCoverView, visibility: isViewUp, duration: 0.4, delay: 0, options: .curveEaseIn)
        }.disposed(by: self.disposeBag)
        
        self.viewModel.showSearchButton.drive { showSearchButton in
            self.showSearchButton(visibility: showSearchButton)
        }.disposed(by: self.disposeBag)
        
        self.viewModel.hidePreviousSearchInterface.drive { hideSearchView in
            self.changeViewVisibility(view: self.searchView, visibility: !hideSearchView, duration: 0.3, delay: 0.2, options: .curveLinear)
            self.changeViewVisibility(view: self.searchButton, visibility: !hideSearchView, duration: 0.3, delay: 0.2, options: .curveLinear)
        }.disposed(by: self.disposeBag)
        
        self.viewModel.showNewSearchInterface.drive { showNewSearchView in
            self.changeViewVisibility(view: self.newSearchView, visibility: showNewSearchView, duration: 0.3, delay: 0, options: .curveLinear)
        }.disposed(by: self.disposeBag)
        
        self.viewModel.showSearchResults.drive { showSearchResults in
            self.changeViewVisibility(view: self.searchResultsLabel, visibility: showSearchResults, duration: 0.3, delay: 0.2, options: .curveLinear)
            self.changeViewVisibility(view: self.searchResultTableView, visibility: showSearchResults, duration: 0.3, delay: 0.2, options: .curveLinear)
        }.disposed(by: self.disposeBag)
        
        self.viewModel.previousSearchModels.drive(self.searchCollectionView.rx.items(cellIdentifier: "RecentRepositoryCell", cellType: RecentRepositoryCell.self)) { i, cellModel, cell in
            cell.nameLabel.text = cellModel.name
            cell.numberOfCommitsLabel.text = String(cellModel.numberOfCommits)
        }.disposed(by: self.disposeBag)
        
        // Prevent issue with RxSwift bind (https://github.com/ReactiveX/RxSwift/issues/675)
        self.searchResultTableView.delegate = nil
        self.searchResultTableView.dataSource = nil

        self.viewModel.newSearchResultModels.drive(self.searchResultTableView.rx.items(cellIdentifier: "NewRepositorySearchTableViewCell", cellType: NewRepositorySearchTableViewCell.self)) { i, cellModel, cell in
            cell.nameLabel.text = cellModel.name
            cell.numberOfCommitsLabel.text = String(cellModel.numberOfCommits)
            cell.ownerLabel.text = cellModel.owner
        }.disposed(by: self.disposeBag)
        
        // Output bindings
        
        self.searchButton.rx.tap
            .bind(to: self.viewModel.searchButtonTap)
            .disposed(by: self.disposeBag)
        
        self.searchView.rx.swipeGesture([.up, .down]).when(.ended).map { gesture in
            gesture.direction == .up
        }.asObservable()
        .bind(to: self.viewModel.searchViewSwipeGesture)
        .disposed(by: self.disposeBag)
        
        self.searchTypeSegmentedControl.rx.index.map{$0 == 0}
            .bind(to: self.viewModel.isSearchByName)
            .disposed(by: self.disposeBag)
        
        self.searchTextField.rx.text
            .bind(to: viewModel.searchText)
            .disposed(by: self.disposeBag)

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
            self.view.layoutIfNeeded()
        }
    }
    
    private func changeViewVisibility(view:UIView, visibility:Bool, duration: TimeInterval , delay: TimeInterval, options: UIView.AnimationOptions) {
        UIView.animate(withDuration: duration, delay: delay, options: options) {
            view.alpha = visibility ? 1.0 : 0.0
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

