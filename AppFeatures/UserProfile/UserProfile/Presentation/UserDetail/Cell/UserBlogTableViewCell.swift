//
//  UserBlogTableViewCell.swift
//  UserProfile
//
//  Created by Hung Nguyen on 10/12/2024.
//

import UIKit
import DesignSystem
import Localize

/// A model representing the data for the `UserBlogTableViewCell`.
struct UserBlogCellModel {
    /// The blog content or URL of the user.
    let blockContent: String?
    
    /// Initializes the `UserBlogCellModel` with user data.
    ///
    /// - Parameter user: The `User` object containing the blog content or URL.
    init(user: User) {
        self.blockContent = user.htmlUrl?.absoluteString
    }
}

/// A custom table view cell for displaying user blog information.
final class UserBlogTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var blockTitleLabel: DSLabel!
    @IBOutlet private weak var blockContentLabel: DSLabel!
    
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
        // Set styles for the labels
        blockTitleLabel.setStyle(DS.TitleLarge())
        blockContentLabel.setStyle(DS.BodyMedium())
        
        // Set localized title
        blockTitleLabel.text = Localize.R.string.userProfile.userBlockTitle()
    }
    
    // MARK: - Model Binding
    /// The model for the cell, updates the UI when set.
    var model: UserBlogCellModel? {
        didSet {
            blockContentLabel.text = model?.blockContent
        }
    }
}
