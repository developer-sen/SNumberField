//
//  SNumericField.swift
//  SNumericField
//
//  Created by Sanju Maduwantha on 2024-04-30.
//

import SwiftUI

public struct SNumberField: View {
    
    @Binding var numericValue: Double
    @State private var labelValue: String = ""
    @State private var fieldValue: String = ""
    // Styles
    @State var textAlignment: Alignment
    @State var hideDecimalPoints: Bool
    @State var grouping: Bool
    @State var labelPrefix: String
    // Behaviours
    @FocusState private var isFocused: Bool
    
    public init(numericValue: Binding<Double>, 
         textAlignment: Alignment = .trailing,
         hideDecimalPoints: Bool = false,
         grouping: Bool = true,
         labelPrefix: String = "$") {
        self._numericValue = numericValue
        self.textAlignment = textAlignment
        self.hideDecimalPoints = hideDecimalPoints
        self.grouping = grouping
        self.labelPrefix = labelPrefix
    }
    
    public var body: some View {
        ZStack(alignment: .center, content: {
            Text(labelValue)
                .frame(maxWidth: .infinity, alignment: textAlignment)
                .frame(maxHeight: .infinity)
            TextField("", text: $fieldValue)
                .keyboardType(.numberPad)
                .focused($isFocused)
                .opacity(0.0)
                .onChange(of: fieldValue, perform: { _ in
                    setNumericValue()
                    setLabelValueBasedOnNumericValue()
                })
        })
        .background(content: {
            Color.white
        })
        .onTapGesture {
            self.isFocused = true
        }
        .onAppear(perform: {
            setFieldValueBasedOnNumericValue()
        })
    }
    
    private func convertToDecimal(_ inputString: String) -> Double {
        guard inputString.isEmpty == false else {
            return 0
        }
        if inputString.count == 1 {
            return Double("0.0\(inputString)")!
        } else if inputString.count == 2 {
            return Double("0.\(inputString)")!
        } else {
            let index = inputString.index(inputString.endIndex, offsetBy: -2)
            let integerPart = inputString[..<index]
            let decimalPart = inputString[index...]
            return Double("\(integerPart).\(decimalPart)")!
        }
    }
    
    private func convertToNonDecimal(_ inputString: String) -> Double {
        return Double(inputString)!
    }
    
    private func setFieldValueBasedOnNumericValue() {
        let string = String(format: "%.2f", numericValue)
        fieldValue = string.replacingOccurrences(of: ".", with: "")
    }
    
    private func setNumericValue() {
        let value = self.fieldValue
        let decimalValue = hideDecimalPoints ? convertToNonDecimal(value) :convertToDecimal(value)
        numericValue = decimalValue
    }
    
    private func setLabelValueBasedOnNumericValue() {
        let numericValue = self.numericValue
        let nsFormatter = NumberFormatter()
        nsFormatter.numberStyle = .decimal
        nsFormatter.groupingSeparator = grouping ? ",": ""
        nsFormatter.positivePrefix = self.labelPrefix
        nsFormatter.minimumFractionDigits = hideDecimalPoints ? 0:2
        nsFormatter.maximumFractionDigits = hideDecimalPoints ? 0:2
        let labelValue = nsFormatter.string(from: NSNumber(value: numericValue))
        self.labelValue = labelValue ?? ""
    }
}

#Preview {
    SNumberField(numericValue: .constant(10))
}
