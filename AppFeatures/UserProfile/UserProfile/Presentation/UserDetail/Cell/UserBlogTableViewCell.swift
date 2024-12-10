//
//  UserBlockTableViewCell.swift
//  UserProfile
//
//  Created by Hung Nguyen on 10/12/2024.
//

import UIKit
import DesignSystem
import Localize

struct UserBlogCellModel {
    let blockContent: String?
    init(user: User) {
        self.blockContent = user.htmlUrl?.absoluteString
    }
}

final class UserBlogTableViewCell: UITableViewCell {
    @IBOutlet private weak var blockTitleLabel: DSLabel!
    @IBOutlet private weak var blockContentLabel: DSLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func configureUI() {
        blockTitleLabel.setStyle(DS.TitleLarge())
        blockContentLabel.setStyle(DS.BodyMedium())
        
        blockTitleLabel.text = Localize.R.string.userProfile.userBlockTitle()
    }
    
    var model: UserBlogCellModel? {
        didSet {
            blockContentLabel.text = model?.blockContent
        }
    }
}
