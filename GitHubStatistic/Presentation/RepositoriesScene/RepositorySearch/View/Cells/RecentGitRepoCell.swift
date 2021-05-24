//
//  RecentGitRepoCell.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 03/05/2021.
//

import Foundation
import UIKit
import Kingfisher

class RecentGitRepoCell : UICollectionViewCell {
    
    @IBOutlet weak var repositoryImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberOfCommitsLabel: UILabel!
    
    func populateCellWithInfo(cellModel: GitRepository) {
        self.nameLabel.text = cellModel.name
        self.numberOfCommitsLabel.text = String(cellModel.numberOfCommits ?? 0)
        if let imageUrl = cellModel.image {
            self.repositoryImageView.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named:"user-placeholder"))
        }
    }
    
}
