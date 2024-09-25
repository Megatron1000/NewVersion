//
//  Copyright © 2023 BridgeTech Solutions Limited. All rights reserved.

import SwiftUI
import Combine
import OSLog
import UserDefaultsActor

@available(iOS 15.0, tvOS 15.0, *)
public struct NewVersionView: View {
    
    public let currentVersionViewed: (() -> (Void))?
    
    @EnvironmentObject var newVersionController: NewVersionController
    
    public init(currentVersionViewed: (() -> Void)?) {
        self.currentVersionViewed = currentVersionViewed
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                if let versions = newVersionController.versionHistory?.versions {
                    ForEach(versions) { version in
                        VersionView(version: version)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(Text("What's New", bundle: .module))
        .navigationViewStyle(StackNavigationViewStyle())
        #if !os(tvOS)
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        #endif
        .onDisappear() {
            currentVersionViewed?()
            Task {
                await newVersionController.recordVersionShown()
            }
        }
    }
}


@available(iOS 15.0, tvOS 15.0, *)
private struct VersionView: View {
    
    @EnvironmentObject var newVersionController: NewVersionController
    
    let version: Version
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(version.versionString)
                    .font(.headline)
                if (newVersionController.versionHistory?.isNew(version: version) ?? false) {
                    Text("NEW", bundle: .module)
                        .font(.caption)
                        .bold()
                        .padding(EdgeInsets(top: 2,
                                            leading: 5,
                                            bottom: 2, trailing: 5))
                        .foregroundColor(.white)
                        .background(
                            Capsule()
                                .fill(Color.red)
                        )
                }
                Spacer()
                Text(version.releaseDate.formatted(date: .abbreviated,
                                                   time: .omitted))
                .foregroundColor(Color(UIColor.secondaryLabel))
            }
            if let releaseNotes = version.releaseNotes {
                Text(releaseNotes)
                    .font(.callout)
                    .padding([.bottom])
            }
            Divider()
        }
    }
}


@available(iOS 15.0, tvOS 15.0, *)
struct NewVersionView_Previews: PreviewProvider {
        
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
                NewVersionView() {}
            }
            NavigationView {
                NewVersionView() {}
            }
            .environment(\.locale, Locale(identifier: "fr"))
        }
        .environmentObject(newVersionController)
    }
}
