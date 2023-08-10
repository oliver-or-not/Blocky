//
//  ContentView.swift
//  Blocky
//
//  Created by Wonil Lee on 8/9/23.
//

import Combine
import RealityKit
import RealityKitContent
import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var blockModel: BlockModel
    
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {
        VStack(spacing: 0) {
            
            Toggle(showImmersiveSpace ? "Return Home" : "Show ImmersiveSpace", isOn: $showImmersiveSpace)
                .toggleStyle(.button)
                .padding(.top, 50)
            
            if immersiveSpaceIsShown {
                Spacer()
                Button {
                    print("Reset scene.")
                    blockModel.turnOnResetTrigger()
                } label: {
                    Text("Reset")
                }
                .frame(height: 70)
                .tint(.gray)
                .opacity(0.9)
                .padding()
                
                Spacer()
                    .frame(height: 105)
                
                Text("Total count of added entities: \(blockModel.clonedEntityArray.count)")
                
                Spacer()
                    .frame(height: 105)
                
                HStack(spacing: 0) {
                    AddButtonView(color: .red, colorExpressionInLowerCase: "red", shapeExpressionInLowerCase: "block", entityVariety: .redBlock)
                        .environmentObject(blockModel)
                    
                    AddButtonView(color: .green, colorExpressionInLowerCase: "green", shapeExpressionInLowerCase: "block", entityVariety: .greenBlock)
                        .environmentObject(blockModel)
                    
                    AddButtonView(color: .blue, colorExpressionInLowerCase: "blue", shapeExpressionInLowerCase: "block", entityVariety: .blueBlock)
                        .environmentObject(blockModel)
                }
                
                Spacer()
            }
        }
        .padding()
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                // when showImmersiveSpace becomes true
                if newValue {
                    switch await openImmersiveSpace(id: "ImmersiveSpace") {
                    case .opened:
                        immersiveSpaceIsShown = true
                    case .error, .userCancelled:
                        fallthrough
                    @unknown default:
                        immersiveSpaceIsShown = false
                        showImmersiveSpace = false
                    }
                }
                // when showImmersiveSpace becomes false
                else if immersiveSpaceIsShown {
                    await dismissImmersiveSpace()
                    immersiveSpaceIsShown = false
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
