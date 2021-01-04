//
//  UserViewModelTests.swift
//  MandarinUrbanDictionaryTests
//
//  Created by Joey Liu on 1/3/21.
//

import XCTest
@testable import MandarinUrbanDictionary

// swiftlint:disable all

// MARK: - UserViewModel NetworkManager Test

class UserViewModelTests: XCTestCase {
    
    func test_fetchUserStatus_vaildUUID() {
        let (sut, networkManger, storeSpy) = makeSUT()
        storeSpy.setUUID(uuid())
    
        sut.fetchUserStatus()
        XCTAssertEqual(networkManger.userID, uuid(), "UUID is incorrect")
    }
    
    func test_fetchUserStatus_deliverUserFetchSuccessfully() {
        let (sut, networkManger, _) = makeSUT()
        sut.fetchUserStatus()
        networkManger.messages[0](.success(users()[0]))
        XCTAssertEqual(sut.currentUser.value, [users()[0]], "User is incorrect")
    }

    func test_fetchUserStatusTwice_deliverUserFetchSuccessfully() {
        let (sut, networkManger, _) = makeSUT()
        
        users().enumerated().forEach { index, user in
            sut.fetchUserStatus()
            networkManger.messages[index](.success(user))
            XCTAssertEqual(sut.currentUser.value, [user], "User is incorrect")
        }
    }

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (
        sut: UserViewModel,
        networkManger: FirebaseManagerSpy,
        storeSpy: InfoStoreSpy
    ) {
        let storeSpy = InfoStoreSpy()
        let networkManger = FirebaseManagerSpy()
        let sut = UserViewModel(networkManager: networkManger, storeManger: storeSpy)
        
        trackMemoryLeaks(sut: sut, file: file, line: line)
        return (sut: sut, networkManger: networkManger, storeSpy: storeSpy)
    }
    
    private class FirebaseManagerSpy: FirebaseManager {
        typealias Message = ((UserViewModel.JoeyResult<User>) -> Void)
        var userID: String?
        private(set) var messages: [Message] = []
        
        override func retrieveUser<T>(userID: String, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable, T : Encodable {
            self.userID = userID
            messages.append(completion as! ((UserViewModel.JoeyResult<User>) -> Void))
        }
    }

    func uuid() -> String {
        return "AUIHGGYU-1263764"
    }
    
    func users() -> [User] {
        
        let user1 = User(identifier: uuid(), name: "Joey", favorites: ["I like it"], recents: ["No more", "Plz"], discoveredWords: ["No matter"], likeChallenge: 10, postChallenge: 20, viewChallenge: 30)
        
        let user2 = User(identifier: uuid(), name: "Joeyjjjjjj", favorites: ["I like it"], recents: ["No more", "Plz"], discoveredWords: ["No matter"], likeChallenge: 10, postChallenge: 20, viewChallenge: 30)
        
        return [user1, user2]
    }
        
    func userData(user: User) -> Data {
        return try! JSONEncoder().encode(user)
    }
    
    private class InfoStoreSpy: UserDefaults {
        
        private var messsages: [String: String] = [:]
        private var uidKey: String {
            return "uid"
        }
        
        func setUUID(_ uuid: String) {
            messsages[uidKey] = uuid
        }
        
        override func string(forKey defaultName: String) -> String? {
            return messsages[uidKey]
        }
    }
}

// MARK: - User ProgressBarTest

extension UserViewModelTests {
    
    func test_makeProgressBar_isNotNil() {
        let sut = UserViewModel()
        
        let likeBar = sut.getProgressBar(.like)
        
        XCTAssertNotNil(likeBar)
    }
    
    func test_makeProgressBar_wrong_output() {
        let sut = UserViewModel()
        
        let likeBar = sut.getProgressBar(.like)
        
        let challengePost = UserViewModel.Challenge.post
        
        let customPostBar = UserViewModel.ProgressBar(title: challengePost.title, color: challengePost.color)
        
        XCTAssertNotEqual(likeBar, customPostBar, "Wrong output")
    }
    
    func test_makeProgressBar_Right_output() {
        let sut = UserViewModel()
        
        let likeBar = sut.getProgressBar(.like)
        
        let challengeLike = UserViewModel.Challenge.like
        
        let customLikeBar = UserViewModel.ProgressBar(title: challengeLike.title, color: challengeLike.color)
        
        XCTAssertEqual(likeBar, customLikeBar)
    }
    
}

extension XCTestCase {
    func trackMemoryLeaks(sut: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut, "Instance is not deallocate", file: file, line: line)
        }
    }
}
