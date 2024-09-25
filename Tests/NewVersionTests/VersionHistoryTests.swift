//
//  File.swift
//  
//
//  Created by Mark Bridges on 17/09/2023.
//

import XCTest
@testable import NewVersion

final class VersionHistoryTests: XCTestCase {
    
    func testVersionHistoryIsAlwaysSortedMostRecentFirst() {
        let versionHistoryStub = VersionHistory.stub
        let versionHistoryReversed = VersionHistory(versions: versionHistoryStub.versions.reversed(), currentAppVersion: "1.4")
        
        XCTAssertEqual(versionHistoryStub.versions.first?.versionString, versionHistoryReversed.versions.first?.versionString)
        XCTAssertEqual(versionHistoryStub.versions.first?.versionString, "1.2")
    }
}
