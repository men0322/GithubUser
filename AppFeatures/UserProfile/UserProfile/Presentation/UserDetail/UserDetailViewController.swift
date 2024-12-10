//
//
//  UserDetailViewController.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//
//

import UIKit
import RxCocoa
import RxSwift
import Common
import Localize
import RxDataSources

// MARK: - ViewInput
protocol UserDetailViewInput: AnyObject {
}

// MARK: - ViewController
final class UserDetailViewController: UIViewController, UserDetailViewModelOutput {
    
    weak var viewInput: UserDetailViewInput?
    var viewModel: UserDetailViewModelType?
    let cellTypes = BehaviorRelay<[UserDetailCellType]>(value: [])
    
    // Private variable
    private let disposeBag = DisposeBag()
    
    typealias Section = SectionModel<String, UserDetailCellType>
    typealias DataSource = RxTableViewSectionedReloadDataSource<Section>
    private lazy var dataSource = initDataSource()
    
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configTableView()
        configureViewModel()
    }
}

// MARK: - Configure
extension UserDetailViewController {
    private func configureUI() {
        // Add here the setup for the UI
        title = Localize.R.string.userProfile.userNavigationTitle()
    }
    
    private func configureViewModel() {
        viewModel?.viewModelOutput = self
        viewModel?.didBecomeActive()
    }
}

// MARK: - Configure TableView
extension UserDetailViewController {
    private func configTableView() {
        tableView.register(R.nib.userInfoTableViewCell)
        tableView.register(R.nib.userFollowTableViewCell)
        tableView.register(R.nib.userBlogTableViewCell)
        
        cellTypes
            .asDriver(onErrorJustReturn: [])
            .map { [Section(model: "", items: $0)] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    func initDataSource() -> RxTableViewSectionedReloadDataSource<Section> {
        return RxTableViewSectionedReloadDataSource<Section>(
            configureCell: { (_, tableView, indexPath, cellType) -> UITableViewCell in
                
                switch cellType {
                case let .info(model):
                    let cell: UserInfoTableViewCell? = tableView.dequeueReusableCell(
                        withIdentifier: R.reuseIdentifier.userInfoTableViewCell,
                        for: indexPath
                    )
                    
                    cell?.model = model
                    return cell ?? UITableViewCell()
                case let .follow(model):
                    let cell: UserFollowTableViewCell? = tableView.dequeueReusableCell(
                        withIdentifier: R.reuseIdentifier.userFollowTableViewCell,
                        for: indexPath
                    )
                    
                    cell?.model = model
                    return cell ?? UITableViewCell()
                case let .blog(model):
                    let cell: UserBlogTableViewCell? = tableView.dequeueReusableCell(
                        withIdentifier: R.reuseIdentifier.userBlogTableViewCell,
                        for: indexPath
                    )
                    
                    cell?.model = model
                    return cell ?? UITableViewCell()
                }
        })
    }
}
