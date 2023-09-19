//
//  Created by Mark Bridges on 17/09/2023.
//

import XCTest
@testable import NewVersion

final class SeenVersionsStoreTests: XCTestCase {
    
    var userDefaults: UserDefaults!
    
    override func setUp() {
        userDefaults = UserDefaults(suiteName: #file)
    }
    
    func testMostRecentVersionReturnsTheMostRecentVersion() {
        let seenVersionsStore = SeenVersionsStore(defaults: userDefaults)
        seenVersionsStore.insert(version: "1.0")
        seenVersionsStore.insert(version: "1.1")
        seenVersionsStore.insert(version: "1.1.1")

        XCTAssertEqual(seenVersionsStore.mostRecentSeenVersion, "1.1.1")
    }
    
    func testMostRecentVersionReturnsTheMostRecentVersionIfAddedInDifferentOrder() {
        let seenVersionsStore = SeenVersionsStore(defaults: userDefaults)
        seenVersionsStore.insert(version: "1.1.1")
        seenVersionsStore.insert(version: "1.1")
        seenVersionsStore.insert(version: "1.0")

        XCTAssertEqual(seenVersionsStore.mostRecentSeenVersion, "1.1.1")
    }
    
    override func tearDown() {
        userDefaults.removePersistentDomain(forName: #file)
    }
}

