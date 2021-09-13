//
//  GitRepoSearchViewModelTests.swift
//  GitHubStatisticTests
//
//  Created by Jaime Alcántara on 02/09/2021.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
import RxBlocking
@testable import GitHubStatistic

class GitRepoSearchViewModelTests: XCTestCase {
    
    var viewModel: GitRepoSearchViewModelProtocol!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var mockGetRecentRepositoriesUseCase: GetRecentRepositoriesUseCaseProtocol!
    var mockSaveRecentRepositoryUseCase: SaveRecentRepositoryUseCaseProtocol!
    var mockSearchRepositoriesUseCase: SearchRepositoriesUseCaseProtocol!
    
    var exampleRepoList:[GitRepository] = [
        GitRepository(image: "https://fakeimage.com", url: "https://github.com/owner1/repoExample1", name: "Repo Example 1", owner: "Owner 1", language: "swift"),
        GitRepository(image: "https://fakeimage.com", url: "https://github.com/owner2/repoExample2", name: "Repo Example 2", owner: "Owner 2", language: "kotlin"),
        GitRepository(image: "https://fakeimage.com", url: "https://github.com/owner3/VeryLongNameForARepo", name: "Very long name for a repo", owner: "Owner 1", language: "java"),
        GitRepository(image: "https://fakeimage.com", url: "https://github.com/VeryLongOwnerName/repoExample4", name: "Repo Example 4", owner: "Very long owner name", language: "javascript")]
    
    var exampleRepoListByOwner:[GitRepository] = [
        GitRepository(image: "https://fakeimage.com", url: "https://github.com/owner1/repoExample1", name: "Repo Example 1", owner: "Owner 1", language: "swift"),
        GitRepository(image: "https://fakeimage.com", url: "https://github.com/owner3/VeryLongNameForARepo", name: "Very long name for a repo", owner: "Owner 1", language: "java")]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.mockGetRecentRepositoriesUseCase = MockGetRecentRepositoriesUseCase()
        self.mockSaveRecentRepositoryUseCase = MockSaveRecentRepositoryUseCase()
        self.mockSearchRepositoriesUseCase = MockSearchRepositoriesUseCase()
        self.viewModel = GitRepoSearchViewModel(getRecentRepositoriesUseCase: self.mockGetRecentRepositoriesUseCase, searchRepositoriesUseCase: self.mockSearchRepositoriesUseCase, saveRecentRepositoryUseCase: self.mockSaveRecentRepositoryUseCase, logger: OSLogger.init(category: .testing))
        
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.mockGetRecentRepositoriesUseCase = nil
        self.mockSaveRecentRepositoryUseCase = nil
        self.mockSearchRepositoriesUseCase = nil
        self.viewModel = nil
        self.scheduler = nil
        self.disposeBag = nil
        super.tearDown()
    }

    func testPreviousSearchResults() throws {
        
        (self.mockGetRecentRepositoriesUseCase as! MockGetRecentRepositoriesUseCase).repositoryList = self.scheduler.createColdObservable([.next(10, self.exampleRepoList)]).asObservable()
        
        // Reinit the viewModel for it to take the updated list at start
        self.viewModel = GitRepoSearchViewModel(getRecentRepositoriesUseCase: self.mockGetRecentRepositoriesUseCase, searchRepositoriesUseCase: self.mockSearchRepositoriesUseCase, saveRecentRepositoryUseCase: self.mockSaveRecentRepositoryUseCase, logger: OSLogger.init(category: .testing))
        
        let previouSearchResults = self.scheduler.createObserver([GitRepository].self)
        
        self.viewModel.previousSearchesModels
            .drive(previouSearchResults)
            .disposed(by:self.disposeBag)
        
        self.scheduler.start()

        XCTAssertEqual(previouSearchResults.events, [.next(10, self.exampleRepoList)])
        
    }
    
    func testPreviousSearchResultsEmpty() throws {
        
        let gitRepositoryList:[GitRepository] = [GitRepository]()
        (self.mockGetRecentRepositoriesUseCase as! MockGetRecentRepositoriesUseCase).repositoryList = self.scheduler.createColdObservable([.next(10, gitRepositoryList)]).asObservable()
        
        // Reinit the viewModel for it to take the updated list at start
        self.viewModel = GitRepoSearchViewModel(getRecentRepositoriesUseCase: self.mockGetRecentRepositoriesUseCase, searchRepositoriesUseCase: self.mockSearchRepositoriesUseCase, saveRecentRepositoryUseCase: self.mockSaveRecentRepositoryUseCase, logger: OSLogger.init(category: .testing))
        
        let previouSearchResults = self.scheduler.createObserver([GitRepository].self)
        
        self.viewModel.previousSearchesModels
            .drive(previouSearchResults)
            .disposed(by:self.disposeBag)
        
        self.scheduler.start()
        XCTAssertEqual(previouSearchResults.events, [.next(10, [GitRepository]())])
        
    }
    
    func testSearchResultsSuccess() throws {
        
        let searchResults = self.scheduler.createObserver([GitRepository].self)
        
        self.viewModel.newSearchResultModels
            .drive(searchResults)
            .disposed(by:self.disposeBag)
        
        
        let successListResponse: GitRepositoryListResult = .success(self.exampleRepoList)
        let successListByOwnerResponse: GitRepositoryListResult = .success(self.exampleRepoListByOwner)

        (self.mockSearchRepositoriesUseCase as! MockSearchRepositoriesUseCase).repositoryList = self.scheduler.createColdObservable([.next(10, successListResponse), .next(48, successListResponse), .next(75, successListByOwnerResponse)]).asObservable()
        
        self.scheduler.createColdObservable([.next(10, "firstSearch"),
                                        .next(40, "secondSearch"),
                                        .next(70, "thirdSearch")])
            .bind(to: self.viewModel.searchText)
            .disposed(by: self.disposeBag)
        
        self.scheduler.createColdObservable([.next(8, false),
                                        .next(50, true)])
            .bind(to: self.viewModel.isSearchByName)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()

        XCTAssertEqual(searchResults.events, [.next(20, self.exampleRepoList), .next(58, self.exampleRepoList), .next(85, self.exampleRepoListByOwner)])
        
    }
    
    func testSearchResultsSuccessWithEmptyCase() throws {
        
        let searchResults = self.scheduler.createObserver([GitRepository].self)
        
        let showList = self.scheduler.createObserver(Bool.self)
        
        self.viewModel.newSearchResultModels
            .drive(searchResults)
            .disposed(by:self.disposeBag)
        
        self.viewModel.showSearchResults
            .drive(showList)
            .disposed(by:self.disposeBag)
        
        
        let successListResponse: GitRepositoryListResult = .success(self.exampleRepoList)
        let emptyListResponse: GitRepositoryListResult = .success([GitRepository]())

        (self.mockSearchRepositoriesUseCase as! MockSearchRepositoriesUseCase).repositoryList = self.scheduler.createColdObservable([.next(10, successListResponse), .next(48, emptyListResponse), .next(75, successListResponse)]).asObservable()
        
        self.scheduler.createColdObservable([.next(10, "firstSearch"),
                                        .next(40, "secondSearch"),
                                        .next(70, "thirdSearch")])
            .bind(to: self.viewModel.searchText)
            .disposed(by: self.disposeBag)
        
        self.scheduler.createColdObservable([.next(8, false),
                                        .next(50, true)])
            .bind(to: self.viewModel.isSearchByName)
            .disposed(by: self.disposeBag)
        
        self.scheduler.start()

        XCTAssertEqual(searchResults.events, [.next(20, self.exampleRepoList), .next(58, [GitRepository]()), .next(85, self.exampleRepoList)])
        XCTAssertEqual(showList.events, [.next(20, true), .next(58, false), .next(85,true)])
        
    }

}
