//
//  ContentView.swift
//  UnicCoversion
//
//  Created by Ryan Bitner on 7/21/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var amount = ""
    @State private var outputUnit = 1
    @State private var inputUnit = 0
    
    var output: Double {
        let amount = Double(amount) ?? 0
        let minutes = getMinutes(amount, unit: inputUnit)
        let convertedMinutes = convert(minutes)
        return convertedMinutes
    }
        
    let units = ["Minutes", "Hours", "Days"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Enter Amount", text: $amount)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Input Unit")) {
                    Picker("Choose unit", selection: $inputUnit) {
                        ForEach(0 ..< units.count) {
                            Text("\(units[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Output Unit")) {
                    Picker("Choose Unit", selection: $outputUnit) {
                        ForEach(0 ..< units.count) {
                            Text("\(units[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Coverted Amount")) {
                    Text("\(output, specifier: "%.2f") \(units[outputUnit])")
                }
            }
            .navigationTitle("Unit Converter")
        }
    }
    
    func getMinutes(_ double:Double, unit: Int) -> Double{
        switch unit {
        case 0:
            return double
            // Minutes to minutes
        case 1:
            return double * 60
            // Hours to minutes
        case 2:
            return double * 60 * 24
            // Days to minutes
        default:
            return 0
        }
    }
    
    
    func convert(_ minutes: Double) -> Double {
        switch outputUnit {
        case 0:
            return minutes
        case 1:
            return minutes/60
        case 2:
            return minutes/60/24
        default:
            return 0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .previewDevice("iPhone 12")
        }
    }
}
