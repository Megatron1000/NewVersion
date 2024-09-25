//  Copyright © 2023 BridgeTech Solutions Limited. All rights reserved.

import Foundation
import UserDefaultsActor

actor CachedVersionsStore {
    
    private let defaults: UserDefaultsActor
    private let cachedVersionsKey = "cached_version_history"
    
    init(defaults: UserDefaultsActor = UserDefaultsActor(suite: .standard)) {
        self.defaults = defaults
    }
    
    var cachedVersions: [Version] {
        get async {
            guard let cachedVersionsData = await defaults.data(forKey: cachedVersionsKey),
                  let versions = try? JSONDecoder().decode([Version].self, from: cachedVersionsData) else {
                return []
            }
            return versions
        }
    }
    
    func updateCachedVersions(with versions: [Version]) async throws {
        let data = try JSONEncoder().encode(versions)
        await defaults.set(data, forKey: cachedVersionsKey)
    }
    
    func contains(version: String) async -> Bool {
        await cachedVersions.contains(where: { $0.versionString == version })
    }
    
}
