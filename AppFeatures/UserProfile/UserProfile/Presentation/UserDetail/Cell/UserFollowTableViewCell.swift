//
//  UserFollowTableViewCell.swift
//  UserProfile
//
//  Created by Hung Nguyen on 10/12/2024.
//

import UIKit
import DesignSystem
import Localize

struct UserFollowCellModel {
    let numberOfFollowing: String?
    let numberOfFollower: String?
    
    init(user: User) {
        self.numberOfFollowing = String(format: "%d", user.following ?? 0)
        self.numberOfFollower = String(format: "%d", user.followers ?? 0)
    }
}

final class UserFollowTableViewCell: UITableViewCell {

    @IBOutlet private weak var numberOfFollowingTitleLabel: DSLabel!
    @IBOutlet private weak var numberOfFollowingLabel: DSLabel!
    @IBOutlet private weak var numberOfFollowerLabel: DSLabel!
    @IBOutlet private weak var numberOfFollowerTitleLabel: DSLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func configureUI() {
        numberOfFollowingTitleLabel.setStyle(DS.BodyMedium())
        numberOfFollowerTitleLabel.setStyle(DS.BodyMedium())
        
        numberOfFollowingLabel.setStyle(DS.BodyLarge())
        numberOfFollowerLabel.setStyle(DS.BodyLarge())
        
        numberOfFollowingTitleLabel.text = Localize.R.string.userProfile.userFollowingTitle()
        numberOfFollowerTitleLabel.text = Localize.R.string.userProfile.userFollowerTitle()
    }
    
    var model: UserFollowCellModel? {
        didSet {
            numberOfFollowingLabel.text = model?.numberOfFollowing
            numberOfFollowerLabel.text = model?.numberOfFollower
        }
    }
    
}
