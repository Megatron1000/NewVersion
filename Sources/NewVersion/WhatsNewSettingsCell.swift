//  Copyright © 2023 BridgeTech Solutions Limited. All rights reserved.

import SwiftUI

@available(iOS 15.0, *)
public struct WhatsNewSettingsCell: View {
        
    @EnvironmentObject var newVersionController: NewVersionController
    
    public let currentVersionViewed: (() -> (Void))?
    
    public var body: some View {
        NavigationLink {
            NewVersionView(currentVersionViewed: currentVersionViewed)
        } label: {
            HStack {
                Text("What's New")
                Spacer()
                BadgeView()
            }
        }
    }
}


@available(iOS 15.0, *)
struct WhatsNewSettingsCell_Previews: PreviewProvider {
        
    static let newVersionController: NewVersionController = {
        let versionHistoryController = NewVersionController(appStoreId: "Your ID",
                                                            currentAppVersion: "1.1",
                                                            isFirstLaunch: false)
        versionHistoryController.handle(versionHistory: VersionHistory.stub)
        return versionHistoryController
    }()
        
    static var previews: some View {
        Group {
            NavigationView {
                Form {
                    WhatsNewSettingsCell {
                        
                    }
                }
            }
        }
        .environmentObject(newVersionController)
    }
}


