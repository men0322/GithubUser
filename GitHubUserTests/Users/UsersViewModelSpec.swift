//
//  UsersViewModelSpec.swift
//  GitHubUserTests
//
//  Created by Hung Nguyen on 10/12/2024.
//

import Foundation
import RxSwift
import RxCocoa
import Quick
import Nimble
import ObjectMapper

@testable import UserProfile

final class UsersViewModelSpec: QuickSpec {
    
    override func spec() {
        var sut: UsersViewModel!
        var mockInput: MockUsersViewInput!
        var mockRouter: MockUsersRouter!
        var mockOutput: MockUsersViewModelOutput!
        var mockUserRepository: MockUserRepository!
        let stubUsers = Mapper<User>().mapArray(JSONString: stubUsersJson) ?? []
        let stubCellModels = stubUsers.map {
            UserInfoViewCellModel(isUserDetail: false, user: $0)
        }

        beforeEach {
            mockInput = MockUsersViewInput()
            mockRouter = MockUsersRouter()
            
            mockOutput = MockUsersViewModelOutput()
            mockOutput.stubbedCellModels = BehaviorRelay<[UserInfoViewCellModel]>(value: stubCellModels)
            mockOutput.stubbedIsLoading = BehaviorRelay<Bool>(value: false)
            
            mockUserRepository = MockUserRepository()
            mockUserRepository.stubbedGetUsersResult = .just((DataType.local, stubUsers))
            
            let getUsersUseCase = GetUsersUseCase(userRepository: mockUserRepository)
            
            sut = UsersViewModel(getUsersUseCase: getUsersUseCase)
            
            sut.viewModelOutput = mockOutput
            
            mockOutput.stubbedViewInput = sut
            
            sut.router = mockRouter
            
            sut.didBecomeActive()
        }
        
        describe("ViewModel is becomeactive") {
            context("Then view model will be setup") {
                it("Should view input will be setup") {
                    expect(mockOutput.viewInput).toNot(beNil())
                }
            }
        }
        
        describe("Loading users data") {
            context("Data will return success") {
                it("Data will send to cellmodes output will call") {
                    expect(mockOutput.invokedCellModelsGetter) == true
                }
                
                it("cellmodes output have 3 users") {
                    expect(mockOutput.cellModels.value.count) == 3
                }
            }
            
            context("Data with remote type") {
                beforeEach {
                    mockOutput.stubbedCellModels = BehaviorRelay<[UserInfoViewCellModel]>(value: [])
                    mockUserRepository.stubbedGetUsersResult = .just((DataType.remote, stubUsers + stubUsers))
                    sut.didBecomeActive()
                }
                it("Data will send to cellmodes output will call") {
                    expect(mockOutput.invokedCellModelsGetter) == true
                }
                
                it("cellmodes output have 6 users") {
                    expect(mockOutput.cellModels.value.count) == 6
                }
            }
        }
        
        context("When user loadmore Trigger Data will update") {
            beforeEach {
         
                mockOutput.stubbedCellModels = BehaviorRelay<[UserInfoViewCellModel]>(value: [])
                mockUserRepository.stubbedGetUsersResult = .just((DataType.remote, stubUsers))
                sut.didBecomeActive()
                sut.loadMoreTrigger.accept(())
            }
            it("cellmodes output have 9 users") {
                expect(mockOutput.cellModels.value.count) == 9
            }
        }
        
        context("When user refresh Trigger Data will update") {
            beforeEach {
         
                mockOutput.stubbedCellModels = BehaviorRelay<[UserInfoViewCellModel]>(value: [])
                sut.didBecomeActive()
                sut.refreshTrigger.accept(())
            }
            it("cellmodes output have 3 users") {
                expect(mockOutput.cellModels.value.count) == 3
            }
        }
        
        context("When user open user detail Trigger") {
            beforeEach {
        
                sut.openUserDetailTrigger.accept("loginValue")
            }
            it("router will called") {
                expect(mockRouter.invokedOpenUserDetail) == true
            }
            
            it("Loging date is loginValue") {
                expect(mockRouter.invokedOpenUserDetailParameters?.0) == "loginValue"
            }
        }
    }
}


let stubUsersJson = """
[
  {
    "login": "mojombo",
    "id": 1,
    "node_id": "MDQ6VXNlcjE=",
    "avatar_url": "https://avatars.githubusercontent.com/u/1?v=4",
    "gravatar_id": "",
    "url": "https://api.github.com/users/mojombo",
    "html_url": "https://github.com/mojombo",
    "followers_url": "https://api.github.com/users/mojombo/followers",
    "following_url": "https://api.github.com/users/mojombo/following{/other_user}",
    "gists_url": "https://api.github.com/users/mojombo/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/mojombo/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/mojombo/subscriptions",
    "organizations_url": "https://api.github.com/users/mojombo/orgs",
    "repos_url": "https://api.github.com/users/mojombo/repos",
    "events_url": "https://api.github.com/users/mojombo/events{/privacy}",
    "received_events_url": "https://api.github.com/users/mojombo/received_events",
    "type": "User",
    "user_view_type": "public",
    "site_admin": false
  },
  {
    "login": "defunkt",
    "id": 2,
    "node_id": "MDQ6VXNlcjI=",
    "avatar_url": "https://avatars.githubusercontent.com/u/2?v=4",
    "gravatar_id": "",
    "url": "https://api.github.com/users/defunkt",
    "html_url": "https://github.com/defunkt",
    "followers_url": "https://api.github.com/users/defunkt/followers",
    "following_url": "https://api.github.com/users/defunkt/following{/other_user}",
    "gists_url": "https://api.github.com/users/defunkt/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/defunkt/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/defunkt/subscriptions",
    "organizations_url": "https://api.github.com/users/defunkt/orgs",
    "repos_url": "https://api.github.com/users/defunkt/repos",
    "events_url": "https://api.github.com/users/defunkt/events{/privacy}",
    "received_events_url": "https://api.github.com/users/defunkt/received_events",
    "type": "User",
    "user_view_type": "public",
    "site_admin": false
  },
  {
    "login": "pjhyett",
    "id": 3,
    "node_id": "MDQ6VXNlcjM=",
    "avatar_url": "https://avatars.githubusercontent.com/u/3?v=4",
    "gravatar_id": "",
    "url": "https://api.github.com/users/pjhyett",
    "html_url": "https://github.com/pjhyett",
    "followers_url": "https://api.github.com/users/pjhyett/followers",
    "following_url": "https://api.github.com/users/pjhyett/following{/other_user}",
    "gists_url": "https://api.github.com/users/pjhyett/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/pjhyett/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/pjhyett/subscriptions",
    "organizations_url": "https://api.github.com/users/pjhyett/orgs",
    "repos_url": "https://api.github.com/users/pjhyett/repos",
    "events_url": "https://api.github.com/users/pjhyett/events{/privacy}",
    "received_events_url": "https://api.github.com/users/pjhyett/received_events",
    "type": "User",
    "user_view_type": "public",
    "site_admin": false
  }
]
"""
