//
//  ContentView.swift
//  WeSplit
//
//  Created by Ryan Bitner on 7/20/21.
//

import SwiftUI

struct LargeBlueFont: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func fontStyleBlue() -> some View {
        self.modifier(LargeBlueFont())
    }
}


struct ContentView: View {
    
    @State private var checkAmount = ""
    @State private var numberOfPeople = ""
    @State private var tipPercentage = 2
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson: Double {
        var peopleCount = Double(numberOfPeople) ?? 0
        peopleCount += 2
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var grandTotal: Double {
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        
        return grandTotal
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                    
                    TextField("Number of People", text: $numberOfPeople)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("How much Tip do you want to leave?")) {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Amount per person")) {
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
                
                Section(header: Text("Grand Total")) {
                    Text("$\(grandTotal, specifier: "%.2f")")
                        .background(tipPercentage == 4 ? Color.red : Color.white)
                }
            }
            .navigationBarTitle("We Split")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPad (8th generation)")
            ContentView()
                .previewDevice("iPhone 12")
        }
    }
}
