//  Copyright © 2023 BridgeTech Solutions Limited. All rights reserved.

import SwiftUI
import UserDefaultsActor

@available(iOS 15.0, tvOS 15.0, *)
public struct WhatsNewSettingsCell: View {
        
    @EnvironmentObject var newVersionController: NewVersionController
    
    public let image: Image?
    public let currentVersionViewed: (() -> (Void))?
    
    public init(image: Image? = Image(systemName: "gift"),
                currentVersionViewed: (() -> Void)?) {
        self.image = image
        self.currentVersionViewed = currentVersionViewed
    }
    
    public var body: some View {
        NavigationLink {
            NewVersionView(currentVersionViewed: currentVersionViewed)
        } label: {
            HStack {
                if let image {
                    image
                }
                Text("What's New", bundle: .module)
                Spacer()
                BadgeView()
            }
        }
    }
}


@available(iOS 15.0, tvOS 15.0, *)
struct WhatsNewSettingsCell_Previews: PreviewProvider {
        
    static let newVersionController: NewVersionController = {
        let versionHistoryController = NewVersionController()
        Task {
            let config = Config(
                appStoreId: "com.bridgetech.Jigsaw",
                currentAppVersion: "1.3",
                isFirstLaunch: false,
                defaults: UserDefaultsActor(suite: .custom(UUID().uuidString)))
                                
            await versionHistoryController.configure(with: config)
        }
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


