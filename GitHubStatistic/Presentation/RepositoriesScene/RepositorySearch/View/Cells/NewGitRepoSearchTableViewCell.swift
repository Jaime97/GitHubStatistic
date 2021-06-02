//
//  NewGitRepoSearchTableViewCell.swift
//  GitHubStatistic
//
//  Created by Jaime Alcántara on 07/05/2021.
//

import UIKit
import Kingfisher

class NewGitRepoSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var repositoryImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ownerLabel: UILabel!
    
    @IBOutlet weak var numberOfCommitsLabel: UILabel!
    
    func populateCellWithInfo(cellModel: GitRepository) {
        self.nameLabel.text = cellModel.name
        self.numberOfCommitsLabel.text = String(0)
        self.ownerLabel.text = cellModel.owner
        if let imageUrl = cellModel.image {
            self.repositoryImageView.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named:"user-placeholder"))
        }
    }
    
}
