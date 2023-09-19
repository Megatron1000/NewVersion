//
//  Copyright © 2023 BridgeTech Solutions Limited. All rights reserved.

import SwiftUI
import Combine
import OSLog

@available(iOS 15.0, *)
public struct NewVersionView: View {
    
    let currentVersionViewed: (() -> (Void))?
    
    @EnvironmentObject var newVersionController: NewVersionController
    
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
        .navigationBarTitle("What's New")
        .navigationViewStyle(StackNavigationViewStyle())
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
        .onDisappear() {
            newVersionController.recordVersionShown()
            currentVersionViewed?()
        }
    }
}


@available(iOS 15.0, *)
private struct VersionView: View {
    
    @EnvironmentObject var newVersionController: NewVersionController
    
    let version: Version
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(version.versionString)
                    .font(.headline)
                if (newVersionController.isNew(version: version)) {
                    Text("NEW")
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
            Text(version.releaseNotes)
                .font(.callout)
        }
    }
}


@available(iOS 15.0, *)
struct NewVersionView_Previews: PreviewProvider {
        
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
                NewVersionView() {}
            }
        }
        .environmentObject(newVersionController)
    }
}