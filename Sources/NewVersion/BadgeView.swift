//  Copyright © 2023 BridgeTech Solutions Limited. All rights reserved.

import SwiftUI

public struct BadgeView: View {
    
    @EnvironmentObject var newVersionController: NewVersionController
    
    public var body: some View {
        Text("\(newVersionController.unseenVersionsCount)")
            .font(.caption)
            .monospacedDigit()
            .bold()
            .padding(EdgeInsets(top: 2,
                                leading: 5,
                                bottom: 2, trailing: 5))
            .foregroundColor(.white)
            .background(
                Capsule()
                    .fill(Color.red)
            )
            .hiddenIf(newVersionController.unseenVersionsCount == 0)
    }
    
}
