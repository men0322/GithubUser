# GithubUser# MVVM + Clean architecture with [RxSwift](https://github.com/ReactiveX/RxSwift)

### Installation

Dependencies in this project are provided via Cocoapods. Please install all dependecies with

`
pod install
`

#### Module
UserProfile: Provide github features

Common: Provide you with commons

DesignSystem: Provide Font, text, style, Colors...

Localize: Provide localization


## High level overview

#### Domain 


The `Domain` is basically what is your App about and what it can do (Entities, UseCase etc.) **It does not depend on UIKit or any persistence framework**, and it doesn't have implementations apart from entities

#### Data

The `Data` is a concrete implementation of the `Domain` in a specific platform like iOS. It does hide all implementation details. For example Database implementation whether it is CoreData, Realm, SQLite etc.

#### Presentation
`Presentation` is responsible for delivering information to the user and handling user input. It can be implemented with any delivery pattern e.g (MVVM, MVC, MVP). This is the place for your `UIView`s and `UIViewController`s. As you will see from the example app, `ViewControllers` are completely independent of the `Platform`.  The only responsibility of a view controller is to "bind" the UI to the Domain to make things happen. In fact, in the current example we are using the same view controller for Realm and CoreData.
 
To enforce modularity, `Domain`, `Data` and `Presentation` are separate targets in the App, which allows us to take advantage of the `internal` access layer in Swift to prevent exposing of types that we don't want to expose.

### TESTING:
Using `Qick` and `Nimble`
Using SwiftMockGeneratorForXcode to genera Mock
