//
//  CourseFilter.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-09.
//

import SwiftUI

struct Filters {
    var country: Country
    var province: Province
    //TODO: add more filters as needed here
    
    init() {
        //TODO: add get current province and country. It should default to current location.
        self.country = .Canada
        self.province = .BC
    }
}

struct CourseFilter: View {
    
    @Binding var filter: Filters
    
    
    
    var body: some View {
        HStack {
            Text("Country:")
                .bold()
            Picker(selection: $filter.country) {
                ForEach(Country.allCases) { country in
                    Text(country.rawValue)
                }
            } label: {
                Text("Choose a Country")
            }
        }
        //TODO: come up with more filters here and maybe make this a little more modular
        //TODO: think about a struct which handles all of the filtering
    }
}



struct CourseFilter_Previews:
PreviewProvider {
    
    @State private static var filter = Filters()
    static var previews: some View {
        CourseFilter(filter: self.$filter)
    }
}
