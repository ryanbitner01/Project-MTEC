//
//  ContentView.swift
//  Habbits
//
//  Created by Ryan Bitner on 8/17/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var habbits = Habbits()
    @State private var isShowingAddHabbit = false
    
    var body: some View {
        NavigationView {
            List(habbits.activities) {activity in
                VStack(alignment: .leading) {
                    Text("\(activity.name)")
                        .font(.title2)
                    Text("\(activity.description)")
                        .font(.body)
                }
            }
            .navigationBarTitle("Habbits")
            .navigationBarItems(trailing:
                Button(action: {
                    isShowingAddHabbit = true
                    
                }, label: {
                    Image(systemName: "plus")
                })
            )
        }
        .sheet(isPresented: $isShowingAddHabbit, content: {
            AddHabbitView(habbit: self.habbits)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
