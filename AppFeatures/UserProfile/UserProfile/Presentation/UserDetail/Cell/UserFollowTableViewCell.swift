//
//  UserFollowTableViewCell.swift
//  UserProfile
//
//  Created by Hung Nguyen on 10/12/2024.
//

import UIKit
import DesignSystem
import Localize

/// A model representing the data for the `UserFollowTableViewCell`.
struct UserFollowCellModel {
    /// The number of users the user is following.
    let numberOfFollowing: String?
    
    /// The number of followers the user has.
    let numberOfFollower: String?
    
    /// Initializes the `UserFollowCellModel` with user data.
    ///
    /// - Parameter user: The `User` object containing follower and following count.
    init(user: User) {
        self.numberOfFollowing = String(format: "%d", user.following ?? 0)
        self.numberOfFollower = String(format: "%d", user.followers ?? 0)
    }
}

/// A custom table view cell for displaying user follow information.
final class UserFollowTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var numberOfFollowingTitleLabel: DSLabel!
    @IBOutlet private weak var numberOfFollowingLabel: DSLabel!
    @IBOutlet private weak var numberOfFollowerLabel: DSLabel!
    @IBOutlet private weak var numberOfFollowerTitleLabel: DSLabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - UI Configuration
    /// Configures the UI for the cell.
    private func configureUI() {
        // Set styles for title labels
        numberOfFollowingTitleLabel.setStyle(DS.BodyMedium())
        numberOfFollowerTitleLabel.setStyle(DS.BodyMedium())
        
        // Set styles for value labels
        numberOfFollowingLabel.setStyle(DS.BodyLarge())
        numberOfFollowerLabel.setStyle(DS.BodyLarge())
        
        // Set localized titles
        numberOfFollowingTitleLabel.text = Localize.R.string.userProfile.userFollowingTitle()
        numberOfFollowerTitleLabel.text = Localize.R.string.userProfile.userFollowerTitle()
    }
    
    // MARK: - Model Binding
    /// The model for the cell, updates the UI when set.
    var model: UserFollowCellModel? {
        didSet {
            numberOfFollowingLabel.text = model?.numberOfFollowing
            numberOfFollowerLabel.text = model?.numberOfFollower
        }
    }
}
