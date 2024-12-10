//
//  
//  UsersViewController.swift
//  UserProfile
//
//  Created by Hung Nguyen on 09/12/2024.
//
//

import UIKit
import RxCocoa
import RxSwift
import Common
import RxDataSources
import RswiftResources
import Localize

// MARK: - ViewInput
protocol UsersViewInput: AnyObject {
    var loadMoreTrigger: PublishRelay<Void> { get }
    var refreshTrigger: PublishRelay<Void> { get }
    var openUserDetailTrigger: PublishRelay<String> { get }
}

// MARK: - ViewController
final class UsersViewController: UIViewController, UsersViewModelOutput {
    
    weak var viewInput: UsersViewInput?
    var viewModel: UsersViewModelType?
    
    // ViewModel output
    let cellModels = BehaviorRelay<[UserInfoViewCellModel]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    // Private variable
    private let disposeBag = DisposeBag()
    
    typealias Section = SectionModel<String, UserInfoViewCellModel>
    typealias DataSource = RxTableViewSectionedReloadDataSource<Section>
    private lazy var dataSource = initDataSource()
    
    // Outlets
    @IBOutlet private weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configTableView()
        configureViewModel()
        configureInput()
    }
}

// MARK: - Configure
extension UsersViewController {
    private func configureUI() {
        // Add here the setup for the UI
        title = Localize.R.string.userProfile.usersNavigationTitle()
    }
    
    private func configureViewModel() {
        viewModel?.viewModelOutput = self
        viewModel?.didBecomeActive()
    }
    
    private func configureInput() {
        guard let input = viewInput else { return }
        tableView
            .rx.reachedBottom
            .filter { [weak self] in
                
                guard let self = self else { return false }
                return !self.isLoading.value
            }
            .bind(to: input.loadMoreTrigger)
            .disposed(by: disposeBag)
        
        refreshControl.rx
            .controlEvent(.valueChanged)
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.beginRefreshing()
                self.viewInput?.refreshTrigger.accept(())
            })
            .disposed(by: disposeBag)
        
        tableView
            .rx.modelSelected(UserInfoViewCellModel.self)
            .subscribeNext { [weak self] model in
                guard let self,
                let login = model.login else { return }
                self.viewInput?.openUserDetailTrigger.accept(login)
            }
            .disposed(by: disposeBag)
    }
    
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
    private func configTableView() {
        tableView.register(R.nib.userInfoTableViewCell)
        tableView.refreshControl = refreshControl
        
        cellModels
            .asDriver(onErrorJustReturn: [])
            .map { [Section(model: "", items: $0)] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
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
