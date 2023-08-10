//
//  ImmersiveView.swift
//  Blocky
//
//  Created by Wonil Lee on 8/9/23.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    @EnvironmentObject var blockModel: BlockModel
    
    var body: some View {
        // similar with makeUIView
        RealityView { content in
            if let floorEntity = blockModel.entityArray[EntityVariety.floor.rawValue] {
                content.add(floorEntity)
            }
        }
        // similar with updateUIView; runs closure whenever the state of its RealityView changes
        update: { content in
            guard blockModel.loadingIsDone else {
                print("ImmersiveView | RealityView | update | loadingIsDone-guard fail.")
                return
            }
            
            if blockModel.entityArray.contains(nil) || blockModel.initialTranslationArray.contains(nil) {
                print("ImmersiveView | RealityView | update | Entity-nil-guard fail.")
                return
            }
            
            for i in 0..<movableVarietyCount {
                if blockModel.bufferArray[i] > 0 {
                    let removedBuffer = blockModel.bufferArray[i]
                    blockModel.resetBuffer(of: EntityVariety.init(rawValue: i)!)
                    for _ in 0..<removedBuffer {
                        let clonedEntity = blockModel.entityArray[i]!.clone(recursive: true)
                        clonedEntity.transform.translation = blockModel.initialTranslationArray[i]! + blockModel.getRandomHorizontalTranslationFactor()
                        content.add(clonedEntity)
                        blockModel.clonedEntityArray.append(clonedEntity)
                    }
                }
            }
            
            if blockModel.resetTrigger {
                blockModel.turnOffResetTrigger()
                for _ in (0..<blockModel.clonedEntityArray.count).reversed() {
                    content.remove(blockModel.clonedEntityArray.popLast()!)
                }
            }
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
