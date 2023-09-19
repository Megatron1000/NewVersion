//  Copyright © 2023 BridgeTech Solutions Limited. All rights reserved.

import Foundation

struct Version: Codable, Identifiable {
    var id: String {
        versionString
    }
    let releaseDate: Date
    let releaseNotes: String
    let versionString: String
}
