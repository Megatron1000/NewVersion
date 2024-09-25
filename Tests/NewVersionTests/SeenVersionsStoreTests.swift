//
//  Created by Mark Bridges on 17/09/2023.
//

import XCTest
import UserDefaultsActor
@testable import NewVersion

final class SeenVersionsStoreTests: XCTestCase {
    
    var userDefaults: UserDefaultsActor!
    
    override func setUp() {
        userDefaults = UserDefaultsActor(suite: .custom(UUID().uuidString))
    }
    
    override func tearDown() async throws {
        await userDefaults.removePersistentDomain(forName: #file)
    }
    
    func testMostRecentVersionReturnsTheMostRecentVersion() async {
        let seenVersionsStore = SeenVersionsStore(defaults: userDefaults)
        await seenVersionsStore.insert(version: "1.0")
        await seenVersionsStore.insert(version: "1.1")
        await seenVersionsStore.insert(version: "1.1.1")

        let mostRecentVersion = await seenVersionsStore.mostRecentSeenVersion()
        
        XCTAssertEqual(mostRecentVersion, "1.1.1")
    }
    
    func testMostRecentVersionReturnsTheMostRecentVersionIfAddedInDifferentOrder() async {
        let seenVersionsStore = SeenVersionsStore(defaults: userDefaults)
        await seenVersionsStore.insert(version: "1.1.1")
        await seenVersionsStore.insert(version: "1.1")
        await seenVersionsStore.insert(version: "1.0")
        
        let mostRecentVersion = await seenVersionsStore.mostRecentSeenVersion()

        XCTAssertEqual(mostRecentVersion, "1.1.1")
    }
    

}

