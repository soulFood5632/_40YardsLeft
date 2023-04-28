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
    @Binding var golfer: Golfer
    var body: some View {
        NavigationStack {
            Text(course.name)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            
            Divider()
            
            Text(course.location.addressLine1)
            
            Text("\(course.location.city), \(course.location.province.rawValue), \(course.location.country.rawValue)")
        

            RoundPrepView(round: self.$round, course: self.$course, golfer: self.$golfer)
            .padding()
            
        }
        
    }
}

struct RoundSetupView_Previews: PreviewProvider {
    @State private static var round: Round?
    @State private static var course = Course.example1
    @State private static var golfer = Golfer.golfer
    static var previews: some View {
        RoundSetupView(course: self.$course, round: self.$round, golfer: self.$golfer)
    }
}
