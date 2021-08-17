//
//  AddHabbit.swift
//  Habbits
//
//  Created by Ryan Bitner on 8/17/21.
//

import SwiftUI

struct AddHabbitView: View {
    @ObservedObject var habbit: Habbits
    @State private var title: String = ""
    @State private var description: String = ""
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
            }
            .navigationBarTitle("Add Habbit")
            .navigationBarItems(trailing:
                Button(action:{
                    save()
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save")
                }
                )
            )
        }
    }
    
    func save() {
        let activity = Activity(id: UUID(), name: self.title, description: self.description)
        habbit.activities.append(activity)
        
    }
}

struct AddHabbit_Previews: PreviewProvider {
    static var previews: some View {
        AddHabbitView(habbit: Habbits())
    }
}
