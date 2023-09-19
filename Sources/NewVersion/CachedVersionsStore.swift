//  Copyright © 2023 BridgeTech Solutions Limited. All rights reserved.

import Foundation

final class CachedVersionsStore {
    
    private let defaults: UserDefaults
    private let cachedVersionsKey = "cached_version_history"
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    var cachedVersions: [Version] {
        get {
            guard let cachedVersionsData = defaults.data(forKey: cachedVersionsKey),
                  let versions = try? JSONDecoder().decode([Version].self, from: cachedVersionsData) else {
                return []
            }
            return versions
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            defaults.set(data, forKey: cachedVersionsKey)
        }
    }
    
    func contains(version: String) -> Bool {
        cachedVersions.contains(where: { $0.versionString == version })
    }
    
}
