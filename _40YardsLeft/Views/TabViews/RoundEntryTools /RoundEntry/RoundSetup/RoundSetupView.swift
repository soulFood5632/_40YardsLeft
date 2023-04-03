//
//  RoundSetupView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-02.
//

import SwiftUI

struct RoundSetupView: View {
    
    @Binding var course: Course
    @Binding var round: Round?
    var body: some View {
        NavigationStack {
            Text(course.name)
                .font(.title)
                .bold()
            
            Divider()
            
            Text(course.location.addressLine1)
            
            Text("\(course.location.city), \(course.location.province.rawValue)")
            
            Text(course.location.country.rawValue)
                .font(.title3)
            
            GroupBox {
                
                RoundPrepView(round: self.$round, course: self.$course)
            } label: {
                Label("Prepare Round", systemImage: "slider.horizontal.3")
            }
            .padding()
            .navigationTitle("Round Preperation")
        }
    }
}

struct RoundSetupView_Previews: PreviewProvider {
    @State private static var round: Round?
    @State private static var course = Course.example1
    static var previews: some View {
        RoundSetupView(course: self.$course, round: self.$round)
    }
}
