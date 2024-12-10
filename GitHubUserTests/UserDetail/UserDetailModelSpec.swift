//
//  UserDetailModelSpec.swift
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

final class UserDetailModelSpec: QuickSpec {
    
    override func spec() {
        var sut: UserDetailViewModel!
        var mockOutput: MockUserDetailOutput!
        var mockUserRepository: MockUserRepository!
        let stubUser = Mapper<User>().map(JSONString: stubUserJson)

        let login = "LoginMock"
        
        beforeEach {
            mockOutput = MockUserDetailOutput()
            mockOutput.stubbedCellTypes = BehaviorRelay<[UserDetailCellType]>(value: [])

            
            mockUserRepository = MockUserRepository()
            mockUserRepository.stubbedGetUserResult = .just(stubUser)
            
            let getUsersUseCase = GetUserDetailUseCase(userRepository: mockUserRepository)
            
            sut = UserDetailViewModel(getUserDetailUseCase: getUsersUseCase, login: login)
            
            sut.viewModelOutput = mockOutput
            
            mockOutput.stubbedViewInput = sut

            
            sut.didBecomeActive()
        }
        
        describe("ViewModel is becomeactive") {
            context("Then view model will be setup") {
                it("Should view input will be setup") {
                    expect(mockOutput.viewInput).toNot(beNil())
                }
            }
        }
        
        describe("Call user detail ") {
            context("success") {
                it("output cell type should update") {
                    expect(mockOutput.invokedCellTypesGetter) == true
                }
            }
        }
    }
}


let stubUserJson = """
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
  }
"""
