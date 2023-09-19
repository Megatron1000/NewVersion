//  Copyright © 2023 BridgeTech Solutions Limited. All rights reserved.

import Foundation

final class SeenVersionsStore {
    
    private let defaults: UserDefaults
    private let seenVersionsKey = "update_shown_for_versions"
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    private var seenVersions: Set<String> {
        get {
            let arrayValue: [String] = defaults.value(forKey: seenVersionsKey) as? Array<String> ?? []
            return Set(arrayValue)
        }
        set {
            defaults.set(Array(newValue), forKey: seenVersionsKey)
        }
    }
    
    var mostRecentSeenVersion: String? {
        seenVersions.sorted { $0.compare($1, options: .numeric) == .orderedDescending }.first
    }
    
    func insert(version: String) {
        seenVersions.insert(version)
    }

}
