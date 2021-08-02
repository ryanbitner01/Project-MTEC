//
//  AstronautView.swift
//  Moonshot
//
//  Created by Ryan Bitner on 8/2/21.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    let missions: [Mission]
    
    var body: some View {
        GeometryReader {geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                    Text(self.astronaut.description)
                        .padding()
                    ForEach(self.missions) {mission in
                        HStack {
                            Image(mission.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.primary, lineWidth: 1))
                            Text(mission.displayName)
                                .font(.headline)
                            Text(mission.formattedLaunchDate)
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
    
    init(astronaut: Astronaut) {
        let missions: [Mission] = Bundle.main.decode("missions.json")
        self.astronaut = astronaut
        
        let includedMissions = missions.compactMap({mission -> Mission? in
            for crew in mission.crew {
                return (crew.name == astronaut.id ? mission: nil)
            }
            return nil
        })
        
        self.missions = includedMissions
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        AstronautView(astronaut: astronauts[0])
    }
}
