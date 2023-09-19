//  Copyright © 2023 BridgeTech Solutions Limited. All rights reserved.

import SwiftUI

struct HiddenModifier: ViewModifier{
    var isHidden: Bool
    
    func body(content: Content) -> some View {
        if isHidden{
            content
                .hidden()
        }
        else{
            content
        }
    }
}

extension View{
    func hiddenIf(_ isHidden: Bool) -> some View{
        return self.modifier(HiddenModifier(isHidden: isHidden))
    }
}
