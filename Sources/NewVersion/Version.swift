//  Copyright © 2023 BridgeTech Solutions Limited. All rights reserved.

import Foundation

public struct Version: Codable, Identifiable, Sendable {
    public var id: String {
        versionString
    }
    let releaseDate: Date
    let releaseNotes: String?
    let versionString: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        releaseDate = try container.decode(Date.self, forKey: .releaseDate)
        releaseNotes = try container.decodeIfPresent(String.self, forKey: .releaseNotes)
        let versionString = try container.decode(String.self, forKey: .versionString)
        
        /// For some reason these can have commas in them sometimes
        self.versionString = versionString.replacingOccurrences(of: ",", with: ".")
    }
    
    init(releaseDate: Date, releaseNotes: String?, versionString: String) {
        self.releaseDate = releaseDate
        self.releaseNotes = releaseNotes
        self.versionString = versionString
    }
}
