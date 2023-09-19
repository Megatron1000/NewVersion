//  Copyright © 2023 BridgeTech Solutions Limited. All rights reserved.

import Foundation
import OSLog

struct VersionHistory {
    
    let versions: [Version]
    
    var currentVersion: Version? {
        return versions.first
    }
    
    var previousVersions: [Version] {
        return Array(versions.dropFirst())
    }
    
    init(versions: [Version]) {
        self.versions = versions.sorted { $0.versionString.compare($1.versionString, options: .numeric) == .orderedDescending }
    }
    
    func versionsCount(from lastSeenVersion: String, to currentVersion: String) -> Int {
        let versionsNewerThanLastSeenVersionNotNewerThanCurrent = versions.filter { version in
            let notNewerThanCurrent: Bool
            switch version.versionString.compare(currentVersion, options: .numeric) {
            case .orderedDescending:
                notNewerThanCurrent = false
                
            default:
                notNewerThanCurrent = true
            }
            
            let newerThanLastSeen: Bool
            switch version.versionString.compare(lastSeenVersion, options: .numeric) {
            case .orderedDescending:
                newerThanLastSeen = true
                
            default:
                newerThanLastSeen = false
            }
            
            return notNewerThanCurrent && newerThanLastSeen
        }
        
        return versionsNewerThanLastSeenVersionNotNewerThanCurrent.count
    }
    

    
}

extension VersionHistory {
    
    static var stub: VersionHistory = VersionHistory(versions: [Version(releaseDate: Date(),
                                                                        releaseNotes: "It's new", 
                                                                        versionString: "1.2"),
                                                                Version(releaseDate: Date().addingTimeInterval(-1),
                                                                        releaseNotes: "It's not so new", 
                                                                        versionString: "1.1.1"),
                                                                Version(releaseDate: Date().addingTimeInterval(-1),
                                                                        releaseNotes: "It's old",
                                                                        versionString: "1.1"),
                                                                Version(releaseDate: Date().addingTimeInterval(-1),
                                                                        releaseNotes: "First release",
                                                                        versionString: "1.0"),
    ])
    
}
