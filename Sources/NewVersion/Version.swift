//  Copyright © 2023 BridgeTech Solutions Limited. All rights reserved.

import Foundation

public struct Version: Codable, Identifiable {
    public var id: String {
        versionString
    }
    let releaseDate: Date
    let releaseNotes: String?
    let versionString: String
}
