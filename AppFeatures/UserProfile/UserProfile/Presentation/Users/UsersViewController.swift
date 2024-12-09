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

// MARK: - PresentableListener
protocol UsersViewInput: AnyObject {
}

// MARK: - ViewController
final class UsersViewController: UIViewController, UsersViewModelOutput {
    
    weak var viewInput: UsersViewInput?
    
    var viewModel: UsersViewModelType?
    
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
extension UsersViewController {
    private func configureUI() {
        // Add here the setup for the UI
    }
    
    private func configureViewModel() {
        viewModel?.viewModelOutput = self
        viewModel?.didBecomeActive()
    }
}
