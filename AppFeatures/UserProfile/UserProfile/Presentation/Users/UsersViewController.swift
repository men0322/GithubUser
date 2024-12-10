//
//  UsersViewController.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//

import UIKit
import RxCocoa
import RxSwift
import Common
import RxDataSources
import RswiftResources
import Localize

// MARK: - ViewInput
/// Protocol for handling user inputs in the UsersViewController.
protocol UsersViewInput: AnyObject {
    /// Trigger for loading more users.
    var loadMoreTrigger: PublishRelay<Void> { get }
    /// Trigger for refreshing the user list.
    var refreshTrigger: PublishRelay<Void> { get }
    /// Trigger for opening the user detail view.
    var openUserDetailTrigger: PublishRelay<String> { get }
}

// MARK: - ViewController
/// ViewController for displaying a list of users.
final class UsersViewController: UIViewController, UsersViewModelOutput {
    
    // MARK: - Properties
    /// View input interface to communicate with the ViewModel.
    weak var viewInput: UsersViewInput?
    
    /// The ViewModel for the UsersViewController.
    var viewModel: UsersViewModelType?
    
    /// Relay for cell models to populate the table view.
    let cellModels = BehaviorRelay<[UserInfoViewCellModel]>(value: [])
    
    /// Relay to indicate loading state.
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    /// Dispose bag for managing subscriptions.
    private let disposeBag = DisposeBag()
    
    /// Section and DataSource type aliases for the table view.
    typealias Section = SectionModel<String, UserInfoViewCellModel>
    typealias DataSource = RxTableViewSectionedReloadDataSource<Section>
    
    /// DataSource for the table view.
    private lazy var dataSource = initDataSource()
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configTableView()
        configureViewModel()
        configureInput()
    }
}

// MARK: - Configure UI and Input
extension UsersViewController {
    /// Configures the UI of the ViewController.
    private func configureUI() {
        title = Localize.R.string.userProfile.usersNavigationTitle()
    }
    
    /// Configures the ViewModel by setting the output and activating it.
    private func configureViewModel() {
        viewModel?.viewModelOutput = self
        viewModel?.didBecomeActive()
    }
    
    /// Configures input triggers for loading more, refreshing, and selecting a user.
    private func configureInput() {
        guard let input = viewInput else { return }
        
        // Load more when reaching the bottom of the table view.
        tableView
            .rx.reachedBottom
            .filter { [weak self] in
                guard let self = self else { return false }
                return !self.isLoading.value
            }
            .bind(to: input.loadMoreTrigger)
            .disposed(by: disposeBag)
        
        // Refresh the list when the refresh control is triggered.
        refreshControl.rx
            .controlEvent(.valueChanged)
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.beginRefreshing()
                self.viewInput?.refreshTrigger.accept(())
            })
            .disposed(by: disposeBag)
        
        // Open user detail when a user is selected.
        tableView
            .rx.modelSelected(UserInfoViewCellModel.self)
            .subscribeNext { [weak self] model in
                guard let self,
                      let login = model.login else { return }
                self.viewInput?.openUserDetailTrigger.accept(login)
            }
            .disposed(by: disposeBag)
    }
    
    /// Ends the refreshing animation after a short delay.
    private func beginRefreshing() {
        Observable<Int>.timer(.milliseconds(500), scheduler: MainScheduler.instance)
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Configure TableView
extension UsersViewController {
    /// Configures the table view and its data binding.
    private func configTableView() {
        // Register table view cells.
        tableView.register(R.nib.userInfoTableViewCell)
        tableView.refreshControl = refreshControl
        
        // Bind cell models to the table view.
        cellModels
            .asDriver(onErrorJustReturn: [])
            .map { [Section(model: "", items: $0)] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    /// Initializes the table view data source.
    ///
    /// - Returns: A configured `RxTableViewSectionedReloadDataSource`.
    func initDataSource() -> RxTableViewSectionedReloadDataSource<Section> {
        return RxTableViewSectionedReloadDataSource<Section>(
            configureCell: { (_, tableView, indexPath, model) -> UITableViewCell in
                let cell: UserInfoTableViewCell? = tableView.dequeueReusableCell(
                    withIdentifier: R.reuseIdentifier.userInfoTableViewCell,
                    for: indexPath
                )
                
                cell?.model = model
                return cell ?? UITableViewCell()
        })
    }
}
