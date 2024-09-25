//
//  Config.swift
//  NewVersion
//
//  Created by Mark Bridges on 25/09/2024.
//

import UserDefaultsActor

public struct Config: Sendable {
    
    let appStoreId: String
    let currentAppVersion: String
    let isFirstLaunch: Bool
    let defaults: UserDefaultsActor
    
}
