//
//  Triangle.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-24.
//

import Foundation
import SwiftUI

/// A square which is centered in such a way that fills the recatangle with the most possible side length while it remains a square.
///
/// - The sidelength will be given by the minumum height and width. 
struct CenteredSquare: Shape {
    func path(in rect: CGRect) -> Path {
        let sideLength = min(rect.height, rect.width)
        let bottomLeft = CGPoint(x: rect.midX - sideLength / 2, y: rect.midY + sideLength / 2)
        let bottomRight = CGPoint(x: rect.midX + sideLength / 2, y: rect.midY + sideLength / 2)
        
        let topLeft = CGPoint(x: rect.midX - sideLength / 2, y: rect.midY - sideLength / 2)
        let topRight = CGPoint(x: rect.midX + sideLength / 2, y: rect.midY - sideLength / 2)
        
        var path = Path()
        
        path.addLines([bottomLeft, bottomRight, topRight, topLeft])
        path.closeSubpath()
        
        return path
    }
    
}

struct CenteredSquare_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CenteredSquare()
                .stroke(lineWidth: 6)
                .padding()
            CenteredSquare()
                .fill(.cyan)
                .padding()
        }
    }
}
