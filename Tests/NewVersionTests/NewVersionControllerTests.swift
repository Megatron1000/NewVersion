import XCTest
import UserDefaultsActor
@testable import NewVersion

final class NewVersionControllerTests: XCTestCase {
    
    var userDefaults: UserDefaultsActor!
    
    override func setUp() {
        super.setUp()
        userDefaults = UserDefaultsActor(suite: .custom(UUID().uuidString))
    }
    
    override func tearDown() async throws {
        await userDefaults.removePersistentDomain(forName: #file)
        try await super.tearDown()
    }
    
    func testStartsWithUnseenVersionCount0() async {
        let sut = await sut(currentAppVersion: "1.0",
                                    isFirstLaunch: false)
        
        let unseenVersionsCount = await sut.unseenVersionsCount
        XCTAssertEqual(unseenVersionsCount, 0)
    }
    
    func testTracksSeenVersionOnInitOnFirstLaunch() async {
        _ = await sut(currentAppVersion: "2.0",
                                    isFirstLaunch: true)
        
        let sut2 = await sut(currentAppVersion: "2.0",
                                    isFirstLaunch: false)
        
        let unseenVersionsCount = await sut2.unseenVersionsCount
        
        XCTAssertEqual(unseenVersionsCount, 0)
    }
    
    func testStartsWithUnseenVersionCount0OnFirstLaunch() async {
        let sut = await sut(currentAppVersion: "1.2",
                                    isFirstLaunch: true)
        await sut.handle(versionHistory: .stub)
        let unseenVersionsCount = await sut.unseenVersionsCount
        
        XCTAssertEqual(unseenVersionsCount, 0)
    }
    
    func testUnseenVersionCount0OnFirstLaunchEvenIfCurrentVersionIsNotInList() async {
        let sut = await sut(currentAppVersion: "1.3",
                                    isFirstLaunch: true)
        await sut.handle(versionHistory: .stub)
        
        let unseenVersionsCount = await sut.unseenVersionsCount
        
        XCTAssertEqual(unseenVersionsCount, 0)
    }
    
    func testUnseenVersionCount0OnFirstLaunchEvenIfCurrentVersionIsLowerThanInList() async {
        let sut = await sut(currentAppVersion: "1.1",
                                    isFirstLaunch: true)
        await sut.handle(versionHistory: .stub)
        
        let unseenVersionsCount = await sut.unseenVersionsCount
        
        XCTAssertEqual(unseenVersionsCount, 0)
    }
    
    func testUnseenVersionCount1IfTheresOneUnseenVersion() async  {
        let sut = await sut(currentAppVersion: "1.2",
                                    isFirstLaunch: false)
        await sut.seenVersionsStore.insert(version: "1.1.1")
        await sut.handle(versionHistory: .stub)
        
        let unseenVersionsCount = await sut.unseenVersionsCount
        
        XCTAssertEqual(unseenVersionsCount, 1)
    }
    
    func testUnseenVersionCount2IfWeHaveNotSeenTwo() async {
        let sut = await sut(currentAppVersion: "1.2",
                                    isFirstLaunch: false)
        await sut.seenVersionsStore.insert(version: "1.1")
        await sut.handle(versionHistory: .stub)
        
        let unseenVersionsCount = await sut.unseenVersionsCount
        
        XCTAssertEqual(unseenVersionsCount, 2)
    }
    
    func testUnseenVersionCount0IfTheresOneUnseenVersionButWeHaventInstalledIt() async {
        let sut = await sut(currentAppVersion: "1.1.1",
                                    isFirstLaunch: false)
        await sut.seenVersionsStore.insert(version: "1.1.1")
        await sut.handle(versionHistory: .stub)
        
        let unseenVersionsCount = await sut.unseenVersionsCount
        
        XCTAssertEqual(unseenVersionsCount, 0)
    }
    
    func testUnseenVersionCount1IfWeAreOnAVersionThatsNotInTheHistoryButThereAreStillVersionsWeHaveNotSeen() async {
        let sut = await sut(currentAppVersion: "2.1",
                                    isFirstLaunch: false)
        await sut.seenVersionsStore.insert(version: "1.1.1")
        await sut.handle(versionHistory: .stub)
        
        let unseenVersionsCount = await sut.unseenVersionsCount
        
        XCTAssertEqual(unseenVersionsCount, 1)
    }
    
    // Because we assume this must be the first launch where we're tracking this
    func testUnseenVersionCountContainAllIfWeHaveNotSeenAnythingAndItsNotTheFirstLaunch() async {
        let sut = await sut(currentAppVersion: "2.0",
                                    isFirstLaunch: false)
        await sut.handle(versionHistory: .stub)
        
        let unseenVersionsCount = await sut.unseenVersionsCount
        
        XCTAssertEqual(unseenVersionsCount, 1)
    }
    
    // MARK: SUT
    
    private func sut(currentAppVersion: String,
                     isFirstLaunch: Bool) async -> NewVersionManager {
        
        let config = Config(appStoreId: "NOT_IMPORTANT",
                            currentAppVersion: currentAppVersion,
                            isFirstLaunch: isFirstLaunch,
                            defaults: userDefaults)
        
        return await NewVersionManager(config: config, delegate: nil)
    }
    
}
