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
    
    public init(appStoreId: String,
                currentAppVersion: String,
                isFirstLaunch: Bool,
                defaults: UserDefaultsActor =
                UserDefaultsActor(suite: .standard)) {
        self.appStoreId = appStoreId
        self.currentAppVersion = currentAppVersion
        self.isFirstLaunch = isFirstLaunch
        self.defaults = defaults
    }
    
    
}
