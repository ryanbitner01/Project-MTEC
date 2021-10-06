//
//  ContentView.swift
//  Animation
//
//  Created by Ryan Bitner on 7/28/21.
//

import SwiftUI

struct CornerRotatedModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor).clipped()
    }
}

struct ContentView: View {
    
    @State private var isShowingRed = false
    
    
    
    var body: some View {
        VStack {
            Button("Tap Me") {
                withAnimation {
                    self.isShowingRed.toggle()
                }
            }
            
            if isShowingRed {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(active: CornerRotatedModifier(amount: -90, anchor: .topLeading),
                  identity: CornerRotatedModifier(amount: 0, anchor: .topLeading)
        )
    }
}
