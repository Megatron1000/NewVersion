//  Copyright © 2023 BridgeTech Solutions Limited. All rights reserved.

import Foundation
import OSLog
import UserDefaultsActor

actor VersionHistoryService {
    
    private struct Response: Decodable {
        let versionHistory: [Version]
    }
    
    private let session = URLSession.shared
    private let cachedVersionsStore: CachedVersionsStore
    
    init(defaults: UserDefaultsActor = UserDefaultsActor(suite: .standard)) {
        self.cachedVersionsStore = CachedVersionsStore(defaults: defaults)
    }
    
    func getVersions(for appID: String, currentVersion: String?) async throws -> [Version] {
        
        if let currentVersion,
           await cachedVersionsStore.contains(version: currentVersion) {
            Logger.standard.debug("Using cached version history as it already contains the current version")
            return await cachedVersionsStore.cachedVersions
        }
        
        guard let endpoint: URL = URL(string: "https://apps.apple.com/app/id\(appID)") else {
            throw URLError(.badURL)
        }
        
        Logger.standard.debug("Looking up version history for \(appID)")
        
        var request = URLRequest(url: endpoint)
        request.setValue("143445-2,20", forHTTPHeaderField: "X-Apple-Store-Front")
        request.setValue("apple-originating-system", forHTTPHeaderField: "MZStore")
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let versionHistoryResponse = try decoder.decode(Response.self, from: data)
        
        Logger.standard.debug("Received version history info: \(String(describing: versionHistoryResponse))")
                
        try await cachedVersionsStore.updateCachedVersions(with: versionHistoryResponse.versionHistory)
        
        return versionHistoryResponse.versionHistory
    }
    
}
