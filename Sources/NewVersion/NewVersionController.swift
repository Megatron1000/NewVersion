//  Copyright © 2023 BridgeTech Solutions Limited. All rights reserved.

import Foundation
import OSLog
import SwiftUI
import UserDefaultsActor

@MainActor
public final class NewVersionController: ObservableObject {
            
    @Published public private(set) var versionHistory: VersionHistory?
    @Published public private(set) var unseenVersionsCount = 0
    
    public static let shared: NewVersionController = .init()

    private var newVersionManager: NewVersionManager?
    
    init() {
        
    }
    
    public func configure(with config: Config) async {
        guard newVersionManager == nil else {
            assertionFailure("Already configured")
            return
        }
        newVersionManager = await NewVersionManager(config: config, delegate: self)
        await newVersionManager?.refresh()
    }
    
    
    public func recordVersionShown() async {
        guard let newVersionManager else {
            assertionFailure("New version manager not configured")
            return
        }
        await newVersionManager.recordVersionShown()
    }
        
}

extension NewVersionController: NewVersionManagerDelegate {
    
    func versionHistoryChanged(_ versionHistory: VersionHistory?) {
        self.versionHistory = versionHistory
    }
    
    func unseenVersionsCountChanged(_ unseenVersionsCount: Int) {
        withAnimation {
            self.unseenVersionsCount = unseenVersionsCount
        }
    }
    
}
