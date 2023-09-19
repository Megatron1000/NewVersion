import XCTest
@testable import NewVersion

final class NewVersionControllerTests: XCTestCase {
    
    var userDefaults: UserDefaults!
    
    override func setUp() {
        userDefaults = UserDefaults(suiteName: #file)
    }
    
    @MainActor
    func testStartsWithUnseenVersionCount0() {
        let sut = sut(currentAppVersion: "1.0",
                                    isFirstLaunch: false)
        
        XCTAssertEqual(sut.unseenVersionsCount, 0)
    }
    
    @MainActor
    func testTracksSeenVersionOnInitOnFirstLaunch() {
        _ = sut(currentAppVersion: "2.0",
                                    isFirstLaunch: true)
        
        let sut2 = sut(currentAppVersion: "2.0",
                                    isFirstLaunch: false)
        
        XCTAssertEqual(sut2.unseenVersionsCount, 0)
    }
    
    @MainActor
    func testStartsWithUnseenVersionCount0OnFirstLaunch() {
        let sut = sut(currentAppVersion: "1.2",
                                    isFirstLaunch: true)
        sut.handle(versionHistory: .stub)
        
        XCTAssertEqual(sut.unseenVersionsCount, 0)
    }
    
    @MainActor
    func testUnseenVersionCount0OnFirstLaunchEvenIfCurrentVersionIsNotInList() {
        let sut = sut(currentAppVersion: "1.3",
                                    isFirstLaunch: true)
        sut.handle(versionHistory: .stub)
        
        XCTAssertEqual(sut.unseenVersionsCount, 0)
    }
    
    @MainActor
    func testUnseenVersionCount0OnFirstLaunchEvenIfCurrentVersionIsLowerThanInList() {
        let sut = sut(currentAppVersion: "1.1",
                                    isFirstLaunch: true)
        sut.handle(versionHistory: .stub)
        
        XCTAssertEqual(sut.unseenVersionsCount, 0)
    }
    
    @MainActor
    func testUnseenVersionCount1IfTheresOneUnseenVersion() {
        let sut = sut(currentAppVersion: "1.2",
                                    isFirstLaunch: false)
        sut.seenVersionsStore.insert(version: "1.1.1")
        sut.handle(versionHistory: .stub)
        
        XCTAssertEqual(sut.unseenVersionsCount, 1)
    }
    
    @MainActor
    func testUnseenVersionCount2IfWeHaveNotSeenTwo() {
        let sut = sut(currentAppVersion: "1.2",
                                    isFirstLaunch: false)
        sut.seenVersionsStore.insert(version: "1.1")
        sut.handle(versionHistory: .stub)
        
        XCTAssertEqual(sut.unseenVersionsCount, 2)
    }
    
    @MainActor
    func testUnseenVersionCount0IfTheresOneUnseenVersionButWeHaventInstalledIt() {
        let sut = sut(currentAppVersion: "1.1.1",
                                    isFirstLaunch: false)
        sut.seenVersionsStore.insert(version: "1.1.1")
        sut.handle(versionHistory: .stub)
        
        XCTAssertEqual(sut.unseenVersionsCount, 0)
    }
    
    @MainActor
    func testUnseenVersionCount1IfWeAreOnAVersionThatsNotInTheHistoryButThereAreStillVersionsWeHaveNotSeen() {
        let sut = sut(currentAppVersion: "2.1",
                                    isFirstLaunch: false)
        sut.seenVersionsStore.insert(version: "1.1.1")
        sut.handle(versionHistory: .stub)
        
        XCTAssertEqual(sut.unseenVersionsCount, 1)
    }
    
    @MainActor
    // Because we assume this must be the first launch where we're tracking this
    func testUnseenVersionCountContainAllIfWeHaveNotSeenAnythingAndItsNotTheFirstLaunch() {
        let sut = sut(currentAppVersion: "2.0",
                                    isFirstLaunch: false)
        sut.handle(versionHistory: .stub)
        
        XCTAssertEqual(sut.unseenVersionsCount, 1)
    }
    
    private func sut(currentAppVersion: String,
                     isFirstLaunch: Bool) -> NewVersionController {
        return NewVersionController(appStoreId: "NOT_IMPORTANT",
                                    currentAppVersion: currentAppVersion,
                                    isFirstLaunch: isFirstLaunch,
                                    defaults: userDefaults)
    }
    
    override func tearDown() {
        userDefaults.removePersistentDomain(forName: #file)
    }
}
