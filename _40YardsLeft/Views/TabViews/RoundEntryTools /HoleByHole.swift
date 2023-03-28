//
//  HoleByHole.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-28.
//

import SwiftUI

struct HoleByHole: View {
    @Binding var round: Round
    let holeNumber: Int
    let tee: Tee
    
    @State private var shotList = [Shot]()
    
    var body: some View {
        let hole = round.tee.holeData[holeNumber - 1]
        VStack {
            Text("Hole \(holeNumber)")
                .bold()
                .font(.title)
            
            HStack {
                Text("Par \(hole.par)")
                
                Divider()
                
                Text("\(hole.yardage.yardage)")
                //TODO: fix this to a dependency on the settings if this application.
            }
            
            GroupBox {
                List {
//                    ForEach(shotList) { shot in
//                        HStack {
//                            Text("\(shot.startPosition) -> \(shot.endPosition)")
//                        }
//                    }
                    //TODO: make editable list in the style of the new item with a green plus. It should include the option for drag and drops
                }
            } label: {
                Label("Shot Entry", systemImage: "figure.golf")
            }
        }
        .onAppear {
            let startPosition = Position(lie: .tee,
                                         yardage: hole.yardage)
            //TODO: Imploment the autofill function here
        }
    }
}

//struct HoleByHole_Previews: PreviewProvider {
//    static var previews: some View {
//        HoleByHole()
//    }
//}
