//
//  AddButtonView.swift
//  Blocky
//
//  Created by Wonil Lee on 8/10/23.
//

import SwiftUI

struct AddButtonView: View {
    @EnvironmentObject var blockModel: BlockModel
    var color: Color
    var colorExpressionInLowerCase: String
    var shapeExpressionInLowerCase: String
    var entityVariety: EntityVariety
    var varietyIndex: Int {
        entityVariety.rawValue
    }

    var body: some View {
        Button {
            // add blocks
            blockModel.increaseBuffer(of: entityVariety, inAmountOf: Int(pow(2.0, Double(blockModel.comboCounterArray[varietyIndex]))))
            // manage counter
            blockModel.increaseComboCounter(of: entityVariety, inAmountOf: 1)
            blockModel.increaseEternalCounter(of: entityVariety, inAmountOf: 1)
            let eternalCounterAtTappedTimePoint = blockModel.eternalCounterArray[varietyIndex]
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if blockModel.eternalCounterArray[varietyIndex] == eternalCounterAtTappedTimePoint {
                    blockModel.resetComboCounter(of: entityVariety)
                    print("Reset", colorExpressionInLowerCase, "combo counter.", separator: " ")
                }
            }
        } label: {
            Text("ADD \(Int(pow(2.0, Double(blockModel.comboCounterArray[varietyIndex])))) " + colorExpressionInLowerCase.uppercased() + " " + shapeExpressionInLowerCase.uppercased() + (blockModel.comboCounterArray[varietyIndex] == 0 ? "" : "S"))
        }
        .frame(height: 70)
        .tint(color)
        .opacity(0.9)
        .padding()
    }
}

#Preview {
    AddButtonView(color: .red, colorExpressionInLowerCase: "red", shapeExpressionInLowerCase: "block", entityVariety: .redBlock)
        .environmentObject(BlockModel())
}
