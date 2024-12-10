//
//  UserDetailViewController.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import UIKit
import RxCocoa
import RxSwift
import Common
import Localize
import RxDataSources

// MARK: - ViewInput
/// Protocol for the view input, used to handle updates from the ViewModel.
protocol UserDetailViewInput: AnyObject {}

// MARK: - ViewController
/// The ViewController responsible for displaying user details.
final class UserDetailViewController: UIViewController, UserDetailViewModelOutput {
    
    // MARK: - Properties
    /// Reference to the view input protocol.
    weak var viewInput: UserDetailViewInput?
    
    /// ViewModel for the User Detail screen.
    var viewModel: UserDetailViewModelType?
    
    /// Observable relay for the cell types to be displayed in the table view.
    let cellTypes = BehaviorRelay<[UserDetailCellType]>(value: [])
    
    /// Dispose bag for managing subscriptions.
    private let disposeBag = DisposeBag()
    
    /// Alias for the section in the table view.
    typealias Section = SectionModel<String, UserDetailCellType>
    
    /// Alias for the RxDataSource.
    typealias DataSource = RxTableViewSectionedReloadDataSource<Section>
    
    /// DataSource for the table view.
    private lazy var dataSource = initDataSource()
    
    // MARK: - Outlets
    /// TableView for displaying user details.
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configTableView()
        configureViewModel()
    }
}

// MARK: - Configure
extension UserDetailViewController {
    /// Configures the UI of the view controller.
    private func configureUI() {
        title = Localize.R.string.userProfile.userNavigationTitle()
    }
    
    /// Configures the ViewModel by setting its output and triggering its lifecycle.
    private func configureViewModel() {
        viewModel?.viewModelOutput = self
        viewModel?.didBecomeActive()
    }
}

// MARK: - Configure TableView
extension UserDetailViewController {
    /// Configures the table view and its bindings.
    private func configTableView() {
        // Register cells for the table view.
        tableView.register(R.nib.userInfoTableViewCell)
        tableView.register(R.nib.userFollowTableViewCell)
        tableView.register(R.nib.userBlogTableViewCell)
        
        // Bind cell types to the table view data source.
        cellTypes
            .asDriver(onErrorJustReturn: [])
            .map { [Section(model: "", items: $0)] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    /// Initializes the data source for the table view.
    ///
    /// - Returns: Configured `RxTableViewSectionedReloadDataSource`.
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
