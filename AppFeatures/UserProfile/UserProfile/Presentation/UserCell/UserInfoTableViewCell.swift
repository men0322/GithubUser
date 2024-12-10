//
//  UserInfoTableViewCell.swift
//  UserProfile
//
//  Created by Hung Nguyen on 10/12/2024.
//

import UIKit
import DesignSystem
import SDWebImage

struct UserInfoViewCellModel {
    let avatarUrl: URL?
    let userName: String?
    let htmlUrlString: String?
    let htmlUrl: URL?
    let location: String?
    let isUserDetail: Bool
    let login: String?
    
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

final class UserInfoTableViewCell: UITableViewCell {

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var locationLabel: DSLabel!
    @IBOutlet private weak var locationView: UIView!
    @IBOutlet private weak var linkView: UIView!
    @IBOutlet private weak var linkTextView: UITextView!
    @IBOutlet private weak var userNameLabel: DSLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func configureUI() {
        userNameLabel.setStyle(DS.TitleLarge())
        userNameLabel.setStyle(DS.BodyLarge())
        
        avatarImageView.layer.cornerRadius = 10
    }
    
    var model: UserInfoViewCellModel? {
        didSet {
            avatarImageView.sd_setImage(with: model?.avatarUrl)
            userNameLabel.text = model?.userName
            
            linkTextView.text = model?.htmlUrl?.absoluteString
            
            linkView.isHidden = (model?.isUserDetail ?? false)
            locationView.isHidden = !(model?.isUserDetail ?? false) || (model?.location == nil)
            
            let linkString = model?.htmlUrl?.absoluteString ?? ""
            let attributedString = NSMutableAttributedString(string: linkString)
            let fullRange = NSRange(location: 0, length: attributedString.length)
            
            // Add link attribute to the full range
            attributedString.addAttribute(.link, value: linkString, range: fullRange)
            
            // Set attributes
            linkTextView.attributedText = attributedString
            linkTextView.linkTextAttributes = [
                .foregroundColor: UIColor.blue,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
            
            locationLabel.text = model?.location
        }
    }
}
