//
//  File.swift
//  
//
//  Created by Apple on 19/08/2023.
//

import Foundation
import SwiftUI
import Debugger

public struct DebugDataView_Previews: PreviewProvider {
    public static var previews: some View {
        NetworkDebugModule(
            input: NetworkDebugModule.preview
        ).view()
            .environmentObject(NetworkDebugConnectionViewModel(debugger: .liveValue))
            
    }
}
