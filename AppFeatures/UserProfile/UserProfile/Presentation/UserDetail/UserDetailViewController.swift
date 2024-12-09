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

// MARK: - PresentableListener
protocol UserDetailViewInput: AnyObject {
}

// MARK: - ViewController
final class UserDetailViewController: UIViewController, UserDetailViewModelOutput {
    
    weak var viewInput: UserDetailViewInput?
    
    var viewModel: UserDetailViewModelType?
    
    // Private variable
    private let disposeBag = DisposeBag()
    
    // Outlets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureViewModel()
    }
}

// MARK: - Configure
extension UserDetailViewController {
    private func configureUI() {
        // Add here the setup for the UI
    }
    
    private func configureViewModel() {
        viewModel?.viewModelOutput = self
        viewModel?.didBecomeActive()
    }
}
