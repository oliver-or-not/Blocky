//
//  BlockModel.swift
//  Blocky
//
//  Created by Wonil Lee on 8/10/23.
//

import Foundation
import RealityKit
import RealityKitContent

final class BlockModel: ObservableObject {
    // *** index of array represents EntityVariety's rawValue
    
    // counter that never be reset
    @Published private(set) var eternalCounterArray = Array(repeating: 0, count: movableVarietyCount)
    
    // counts combo
    // becomes 0 when typical time passes without pressing the button again
    // 'add (...)' button adds (2 ^ combo counter) blocks for every tap
    @Published private(set) var comboCounterArray = Array(repeating: 0, count: movableVarietyCount)
    
    // num of blocks to be added in scene
    @Published private(set) var bufferArray = Array(repeating: 0, count: movableVarietyCount)
    
    @Published private(set) var loadingIsDone = false
    
    @Published private(set) var resetTrigger = false
    
    private(set) var entityArray: [Entity?] = Array(repeating: nil, count: entityVarietyCount) // count floor
    
    var clonedEntityArray: [Entity] = []
    
    private(set) var initialTranslationArray: [SIMD3<Float>?] = Array(repeating: nil, count: movableVarietyCount)
    
    init() {
        // Add the initial RealityKit content
        Task {
            let immersiveEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle)
            
            // block setting
            for i in 0..<movableVarietyCount {
                entityArray[i] = await immersiveEntity?.findEntity(named: entityNameArray[i])
                initialTranslationArray[i] = await entityArray[i]?.transform.translation
                await entityArray[i]?.components.set(InputTargetComponent())
                await entityArray[i]?.generateCollisionShapes(recursive: true)
                await entityArray[i]?.components.set(PhysicsBodyComponent(mode: .dynamic))
//                await entityArray[i]?.components.set(PhysicsMotionComponent())
            }
            
            // floor setting
            entityArray[EntityVariety.floor.rawValue] = await immersiveEntity?.findEntity(named: entityNameArray[EntityVariety.floor.rawValue])
            await entityArray[EntityVariety.floor.rawValue]?.generateCollisionShapes(recursive: true)
            await entityArray[EntityVariety.floor.rawValue]?.components.set(PhysicsBodyComponent(mode: .static))
                        
            loadingIsDone = true
            
        }
    }
    
    func increaseEternalCounter(of variety: EntityVariety, inAmountOf n: Int) {
        eternalCounterArray[variety.rawValue] += n
    }

    func increaseComboCounter(of variety: EntityVariety, inAmountOf n: Int) {
        comboCounterArray[variety.rawValue] += n
    }
    
    func resetComboCounter(of variety: EntityVariety) {
        comboCounterArray[variety.rawValue] = 0
    }

    func increaseBuffer(of variety: EntityVariety, inAmountOf n: Int) {
        bufferArray[variety.rawValue] += n
    }
    
    func resetBuffer(of variety: EntityVariety) {
        bufferArray[variety.rawValue] = 0
    }
    
    func getRandomHorizontalTranslationFactor() -> SIMD3<Float> {
        let x = Float.random(in: -0.15...0.15)
        let y: Float = 0.0
        let z = Float.random(in: -0.15...0.15)
        return SIMD3<Float>(x: x, y: y, z: z)
    }
    
    func turnOnResetTrigger() {
        resetTrigger = true
    }
    
    func turnOffResetTrigger() {
        resetTrigger = false
    }
}

