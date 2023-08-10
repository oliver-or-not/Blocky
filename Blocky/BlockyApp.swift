//
//  BlockyApp.swift
//  Blocky
//
//  Created by Wonil Lee on 8/9/23.
//

import SwiftUI

@main
struct BlockyApp: App {
    
    @StateObject var blockModel = BlockModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(blockModel)
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
                .environmentObject(blockModel)
        }
    }
}
