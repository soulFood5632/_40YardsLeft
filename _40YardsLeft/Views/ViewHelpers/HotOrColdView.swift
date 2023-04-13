//
//  HotOrColdView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-13.
//

import SwiftUI


/// A view which shows a fire or ice icon based on the provided isHot value
struct HotOrColdView: View {
    let isHot: Bool
    
    var body: some View {
        if isHot {
            Image(systemName: "flame")
                .foregroundColor(.red)
        } else {
            Image(systemName: "snowflake")
                .foregroundColor(.blue)
        }
    }
}

struct HotOrColdView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HotOrColdView(isHot: true)
            HotOrColdView(isHot: false)
        }
    }
}
