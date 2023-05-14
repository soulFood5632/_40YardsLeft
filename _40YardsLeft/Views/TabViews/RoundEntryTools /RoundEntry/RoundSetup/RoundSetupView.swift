//
//  RoundSetupView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-02.
//

import SwiftUI

struct RoundSetupView: View {
    
    
    @State var course: Course
    
    @Binding var golfer: Golfer
    @Binding var path: NavigationPath
    
    var body: some View {
        let _ = Self._printChanges()
        
        VStack {
            Text(course.name)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            
            Divider()
            
            Text(course.location.addressLine1)
            
            Text("\(course.location.city), \(course.location.province.rawValue), \(course.location.country.rawValue)")
            
            
            RoundPrepView(course: self.$course, golfer: self.$golfer, path: self.$path)
                .padding()
        }
        .navigationDestination(for: Round.self) { newRound in
            
            HoleByHole(golfer: self.$golfer, round: newRound, path: self.$path, holeNumber: 1)
                
        }
        
        
            
        
        
    }
}

struct RoundSetupView_Previews: PreviewProvider {
    @State private static var round: Round?
    @State private static var course = Course.example1
    @State private static var golfer = Golfer.golfer
    @State private static var path = NavigationPath()
    static var previews: some View {
        RoundSetupView(course: self.course, golfer: self.$golfer, path: self.$path)
    }
}
