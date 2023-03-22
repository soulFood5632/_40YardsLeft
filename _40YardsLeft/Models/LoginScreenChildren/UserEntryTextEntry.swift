//
//  UserEntryTextEntry.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-14.
//

import SwiftUI

struct UserEntryTextEntry: View {
    @Binding var textVal: String
    let view: any View
    
    var body: some View {
        TextField(text: $textVal) {
            view
        }
    }
}

struct UserEntryTextEntry_Previews: PreviewProvider {
    static var previews: some View {
        UserEntryTextEntry()
    }
}
