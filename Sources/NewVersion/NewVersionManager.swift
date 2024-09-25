//
//  NewVersionManager.swift
//  NewVersion
//
//  Created by Mark Bridges on 25/09/2024.
//

import Foundation
import OSLog
import UserDefaultsActor

@MainActor
protocol NewVersionManagerDelegate: AnyObject {
    func versionHistoryChanged(_ versionHistory: VersionHistory?) async
    func unseenVersionsCountChanged(_ unseenVersionsCount: Int) async
}

actor NewVersionManager {
        
    private(set) var versionHistory: VersionHistory? {
        didSet {
            guard let unwrappedDelegate = delegate else { return }
            Task {
                await unwrappedDelegate.versionHistoryChanged(versionHistory)
            }
        }
    }
    private(set) var unseenVersionsCount = 0 {
        didSet {
            guard let unwrappedDelegate = delegate else { return }
            Task {
                await unwrappedDelegate.unseenVersionsCountChanged(unseenVersionsCount)
            }
        }
    }
    
    private let versionHistoryService: VersionHistoryService
    let seenVersionsStore: SeenVersionsStore
    private let config: Config
    private weak var delegate: NewVersionManagerDelegate?
    
    init(config: Config, delegate: NewVersionManagerDelegate?) async {
        self.config = config
        self.seenVersionsStore = .init(defaults: config.defaults)
        self.versionHistoryService = .init(defaults: config.defaults)
        
        // It's the first launch so there's nothing new
        if config.isFirstLaunch {
            await self.seenVersionsStore.insert(version: config.currentAppVersion)
        }
    }
    
    func refresh() async {
        do {
            let versions = try await versionHistoryService.getVersions(for: config.appStoreId,
                                                                                   currentVersion: config.currentAppVersion)
            await handle(versions: versions)
        }
        catch {
            Logger.standard.error("Failed to get version history: \(String(describing: error))")
        }
    }
    
    func handle(versions: [Version]) async {
        let versionHistory = VersionHistory(versions: versions,
                                            currentAppVersion: config.currentAppVersion,
                                            mostRecentSeenVersion: await seenVersionsStore.mostRecentSeenVersion())
        
        await handle(versionHistory: versionHistory)
    }
    
    func handle(versionHistory: VersionHistory) async {
        self.versionHistory = versionHistory
        
        if config.isFirstLaunch {
            unseenVersionsCount = 0
            return
        }
        
        // If we've got nothing in here and it's not the first launch this must
        // be the first time the app's launched with NewVersion integrated. So assume there's one unseen version
        guard let lastSeenVersion = await seenVersionsStore.mostRecentSeenVersion() else {
            unseenVersionsCount = 1
            return
        }
        
        let unseenVersionsCount = versionHistory.versionsCount(from: lastSeenVersion, to: config.currentAppVersion)
        
        self.unseenVersionsCount = unseenVersionsCount
    }
    
    func recordVersionShown() async {
        await self.seenVersionsStore.insert(version: config.currentAppVersion)
        self.unseenVersionsCount = 0
        
        guard let currentVersionHistory = versionHistory else {
            return
        }
        
        self.versionHistory = VersionHistory(versions: currentVersionHistory.versions,
                                            currentAppVersion: config.currentAppVersion,
                                            mostRecentSeenVersion: await seenVersionsStore.mostRecentSeenVersion())
    }
    
}
