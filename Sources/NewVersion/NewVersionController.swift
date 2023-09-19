//  Copyright © 2023 BridgeTech Solutions Limited. All rights reserved.

import Foundation
import OSLog
import SwiftUI

public final class NewVersionController: ObservableObject {
    
    private let versionHistoryService: VersionHistoryService
    
    @MainActor
    @Published public private(set) var versionHistory: VersionHistory?
    
    @MainActor
    @Published public private(set) var unseenVersionsCount = 0
                
    private let appStoreId: String
    private let currentAppVersion: String
    private let isFirstLaunch: Bool
    let seenVersionsStore: SeenVersionsStore
    
    public init(appStoreId: String,
                currentAppVersion: String,
                isFirstLaunch: Bool,
                defaults: UserDefaults = .standard) {
        self.appStoreId = appStoreId
        self.currentAppVersion = currentAppVersion
        self.isFirstLaunch = isFirstLaunch
        self.seenVersionsStore = .init(defaults: defaults)
        self.versionHistoryService = .init(defaults: defaults)
        
        // It's the first launch so there's nothing new
        if isFirstLaunch {
            self.seenVersionsStore.insert(version: currentAppVersion)
        }
    }
    
    public func refresh() async {
        do {
            let versionHistory = try await versionHistoryService.getVersionHistory(for: appStoreId,
                                                               currentVersion: currentAppVersion)
            await handle(versionHistory: versionHistory)
        }
        catch {
            Logger.standard.error("Failed to get version history: \(String(describing: error))")
        }
    }
    
    @MainActor
    func handle(versionHistory: VersionHistory) {
        self.versionHistory = versionHistory
        
        if isFirstLaunch {
            unseenVersionsCount = 0
            return
        }

        // If we've got nothing in here and it's not the first launch this must
        // be the first time the app's launched with NewVersion integrated. So assume there's one unseen version
        guard let lastSeenVersion = seenVersionsStore.mostRecentSeenVersion else {
            withAnimation {
                self.unseenVersionsCount = 1
            }
            return
        }
        
        let unseenVersionsCount = versionHistory.versionsCount(from: lastSeenVersion, to: currentAppVersion)
        
        withAnimation {
            self.unseenVersionsCount = unseenVersionsCount
        }
    }
    
    func isNew(version: Version) -> Bool {
        guard let lastSeenVersion = seenVersionsStore.mostRecentSeenVersion else {
            return version.versionString == currentAppVersion
        }
        
        switch version.versionString.compare(lastSeenVersion, options: .numeric) {
        case .orderedDescending:
            return true
            
        default:
            return false
        }
    }
    
    @MainActor
    func recordVersionShown() {
        self.seenVersionsStore.insert(version: currentAppVersion)
        self.unseenVersionsCount = 0
    }
    
}
