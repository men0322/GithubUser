//
//  UserInfoTableViewCell.swift
//  UserProfile
//
//  Created by Hung Nguyen on 10/12/2024.
//

import UIKit
import DesignSystem
import SDWebImage
import Common

/// A model representing the data for the `UserInfoTableViewCell`.
struct UserInfoViewCellModel {
    /// URL for the user's avatar image.
    let avatarUrl: URL?
    
    /// The user's username.
    let userName: String?
    
    /// String representation of the user's profile URL.
    let htmlUrlString: String?
    
    /// URL object for the user's profile.
    let htmlUrl: URL?
    
    /// The user's location.
    let location: String?
    
    /// Indicates whether the cell is for a detailed user view.
    let isUserDetail: Bool
    
    /// The user's login identifier.
    let login: String?
    
    /// Initializes the `UserInfoViewCellModel` with a user object and whether it's for detailed view.
    ///
    /// - Parameters:
    ///   - isUserDetail: A flag to indicate if the cell is for detailed user view.
    ///   - user: The `User` object containing the user's data.
    init(
        isUserDetail: Bool = false,
        user: User
    ) {
        self.avatarUrl = user.avatarUrl
        self.userName = user.login
        self.htmlUrlString = user.htmlUrlString
        self.htmlUrl = user.htmlUrl
        self.location = user.location
        self.isUserDetail = isUserDetail
        self.login = user.login
    }
}

/// A custom table view cell for displaying user information.
final class UserInfoTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var locationLabel: DSLabel!
    @IBOutlet private weak var locationView: UIView!
    @IBOutlet private weak var linkView: UIView!
    @IBOutlet private weak var linkTextView: UITextView!
    @IBOutlet private weak var userNameLabel: DSLabel!
    @IBOutlet private weak var customBackgroundView: UIView!
    @IBOutlet private weak var shadowBackgroundView: UIView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Configuration
    /// Configures the UI for the cell.
    private func configureUI() {
        // Set styles for labels
        userNameLabel.setStyle(DS.TitleLarge())
        locationLabel.setStyle(DS.BodyLarge())
        
        // Style the avatar image
        avatarImageView.layer.cornerRadius = 40
        avatarImageView.clipsToBounds = true
        
        // Style the background views
        customBackgroundView.layer.cornerRadius = 8
        shadowBackgroundView.layer.cornerRadius = 8
        shadowBackgroundView.setShadowStyle(.shadow4)
    }
    
    // MARK: - Model Binding
    /// The model for the cell, updates the UI when set.
    var model: UserInfoViewCellModel? {
        didSet {
            // Set the avatar image
            avatarImageView.sd_setImage(with: model?.avatarUrl)
            
            // Set the username
            userNameLabel.text = model?.userName
            
            // Configure the link view
            linkTextView.text = model?.htmlUrl?.absoluteString
            linkView.isHidden = (model?.isUserDetail ?? false)
            
            // Configure the location view
            locationView.isHidden = !(model?.isUserDetail ?? false) || (model?.location == nil)
            
            // Add link attributes to the linkTextView
            let linkString = model?.htmlUrl?.absoluteString ?? ""
            let attributedString = NSMutableAttributedString(string: linkString)
            let fullRange = NSRange(location: 0, length: attributedString.length)
            attributedString.addAttribute(.link, value: linkString, range: fullRange)
            
            // Configure link text view attributes
            linkTextView.attributedText = attributedString
            linkTextView.linkTextAttributes = [
                .foregroundColor: UIColor.blue,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            
            // Set the location label
            locationLabel.text = model?.location
        }
    }
}
