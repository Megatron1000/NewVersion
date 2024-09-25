//  Copyright © 2023 BridgeTech Solutions Limited. All rights reserved.

import Foundation
import UserDefaultsActor

actor SeenVersionsStore {
    
    private let defaults: UserDefaultsActor
    private let seenVersionsKey = "update_shown_for_versions"
    
    init(defaults: UserDefaultsActor = UserDefaultsActor(suite: .standard)) {
        self.defaults = defaults
    }
    
    private var seenVersions: Set<String> {
        get async {
            let arrayValue: [String] = await defaults.array(forKey: seenVersionsKey) as? Array<String> ?? []
            return Set(arrayValue)
        }

    }
    
    func mostRecentSeenVersion() async -> String? {
        await seenVersions.sorted { $0.compare($1, options: .numeric) == .orderedDescending }.first
    }
    
    func insert(version: String) async {
        var newSeenVersions = await seenVersions
        newSeenVersions.insert(version)
        await defaults.set(Array(newSeenVersions), forKey: seenVersionsKey)

    }

}
