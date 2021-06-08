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
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var languageColorView: UIView!
    
    func populateCellWithInfo(cellModel: GitRepository) {
        self.nameLabel.text = cellModel.name
        self.ownerLabel.text = cellModel.owner
        self.languageLabel.text = cellModel.language
        if let language = cellModel.language {
            self.languageColorView.alpha = 1
            self.languageColorView.backgroundColor = language.generateColorFromThisSeed()
        } else {
            self.languageColorView.alpha = 0
        }
        if let imageUrl = cellModel.image {
            self.repositoryImageView.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named:"user-placeholder"))
        }
    }
    
}
