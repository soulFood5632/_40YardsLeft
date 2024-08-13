//
//  SpinningCircle.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-05-01.
//

import SwiftUI

struct SpinningCircle: View {

  @State private var isSpinning = false
  let isLoading: Bool
  private let iconName = "circle.hexagongrid"

  var body: some View {
    Image(systemName: iconName)
      .scaleEffect(isLoading ? 1 : 0)
      .rotationEffect(isSpinning ? .degrees(360) : .zero)
      .animation(
        .linear(duration: 2.1).repeatForever(autoreverses: false),
        value: self.isSpinning
      )
      .animation(.spring(dampingFraction: 0.8), value: self.isLoading)
      .onAppear {
        self.isSpinning = true
      }
      .font(.title)
      .onDisappear {
        self.isSpinning = false
      }
  }
}

struct RingView: View {
  @State var isSpinning: Bool = false
  private let radius: CGFloat = 20
  private let lineWidth: CGFloat = 3
  private let trimSpace: CGFloat = 0.05
  private let speed: TimeInterval = 1.5
  
  
  
  var body: some View {
    ZStack {
      Circle()
        .trim(from: 0.0, to: 1.0 - trimSpace * 3)
        .stroke(style: .init(lineWidth: self.lineWidth))
        .frame(height: radius * 2)
        .rotationEffect(isSpinning ? .degrees(360) : .zero)
        .animation(
          .linear(duration: self.speed * 0.75).repeatForever(autoreverses: false),
          value: self.isSpinning
        )
        
      
      Circle()
        .trim(from: 0.0, to: 1.0 - trimSpace * 2)
        .rotation(.radians(.pi))
        .stroke(style: .init(lineWidth: self.lineWidth))
        .frame(height: radius * 2 - self.lineWidth * 3)
        .rotationEffect(isSpinning ? .degrees(360) : .zero)
        .animation(
          .linear(duration: self.speed * 1.5).repeatForever(autoreverses: false),
          value: self.isSpinning
        )
        
      
      Circle()
        .trim(from: 0.0, to: 1.0 - trimSpace)
        .rotation(.radians(.pi))
        .stroke(style: .init(lineWidth: self.lineWidth))
        .frame(height: radius * 2 - self.lineWidth * 6)
        .rotationEffect(isSpinning ? .degrees(360) : .zero)
        .animation(
          .linear(duration: self.speed * 1.25).repeatForever(autoreverses: false),
          value: self.isSpinning
        )
        
        
      
    }
    
    
    .onAppear {
      self.isSpinning = true
    }
    .onDisappear {
      self.isSpinning = false
    }
    
    
  }
}

struct SpinningCircle_Previews: PreviewProvider {
  static var previews: some View {
    HStack {
      SpinningCircle(isLoading: true)
      RingView()
    }
  }
}
