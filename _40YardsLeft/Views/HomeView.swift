//
//  HomeView.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-24.
//

import SwiftUI

//TODO: think about navigation stack advantages
//TODO: navigation titles?


struct HomeView: View {
    @State var golfer: Golfer
    @Binding var path: NavigationPath
    
    
    var body: some View {
        
        VStack {
            
            GroupBox {
                VStack {
                    GolferView(golfer: golfer)
                    
                    HotStreak(golfer: golfer)
                        .font(.headline)
                }
                
            } label: {
                Label("Welcome Back \(golfer.name)", systemImage: "hand.wave.fill")
                    .bold()
                    .font(.largeTitle)
                
            }
            
            GroupBox {
                //TODO: stat dashboard
                
                NavigationLink(value: ScreenState.stats) {
                    
                    Label("Analyze", systemImage: "chart.bar")
                        .bold()
                        .font(.title2)
                    
                }
                .buttonStyle(.bordered)
            }
            
            GroupBox {
                //TODO: add things here
                
                Button {
                    self.path.append(ScreenState.play)
                } label: {
                    
                    Label("Play", systemImage: "figure.golf")
                        .bold()
                        .font(.title2)
                }
                .buttonStyle(.borderedProminent)
                

            }
            
            
            
            GroupBox {
                
                ScrollView {
                    RoundViewList(golfer: self.$golfer, path: self.$path)
                        .disabled(true)
                }
                
                NavigationLink(value: ScreenState.history) {
                    Label("View History", systemImage: "book")
                        .bold()
                        .font(.title2)
                }
                
            }
            
        }
        .padding()
        .toolbar {
            ToolbarItem (placement: .navigationBarLeading) {
                NavigationMenu(golfer:
                                $golfer, navStack: $path)
                
            }
            
        }
        .navigationDestination(for: ScreenState.self) { newState in
            
            switch newState {
                
            case .history:
                RoundView(golfer: self.$golfer, path: self.$path)
                    .toolbar {
                        ToolbarItem (placement: .navigationBarTrailing) {
                            GoHome(path: $path)
                        }
                    }
            case .play:
                RoundEntry(golfer: self.$golfer, path: self.$path) 
            case .stats:
                StatView(path: self.$path, golfer: self.golfer)
                    .toolbar {
                        ToolbarItem (placement: .navigationBarTrailing) {
                            GoHome(path: $path)
                        }
                    }
                
                
            }
            
 
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem (placement: .navigationBarTrailing) {
                //TODO: add settings here.
            }
        }
        .navigationDestination(for: [Round].self) { roundList in
            StatAnalysisView(rounds: roundList)
        }
        
        
        
    }
    
    
}

enum ScreenState {
    case play
    case history
    case stats
}

extension Date {
    static func getCurrentYear() -> Int {
        return getYearFromDate(.now)
        //TODO: Imploment this method
    }
    
    
    
    static func getYearFromDate(_ date: Date) -> Int {
        return 2023
    }
}

struct HomeView_Previews: PreviewProvider {
    @State static private var golfer = Golfer.golfer
    @State private static var path = NavigationPath()
    static var previews: some View {
        NavigationStack (path: $path) {
            HomeView(golfer: Self.golfer, path: self.$path)
                .preferredColorScheme(.dark)
        }
    }
}
