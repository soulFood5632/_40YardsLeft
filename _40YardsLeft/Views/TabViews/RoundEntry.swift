//
//  RoundEntry.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-03-28.
//

import SwiftUI



struct RoundEntry: View {
    
    @Binding var golfer: Golfer
    @Binding var path: NavigationPath
    @State private var newCourse = false
    @State private var isCancelledRound = false
    
    var body: some View {
        
            VStack {
                Group {
                    GroupBox {
                        PickACourse(path: $path)
                    } label: {
                        Label("Choose Course", systemImage: "list.bullet.clipboard")
                    }
                    
                    HStack {
                        Text("OR")
                            .font(.title3)
                            .bold()
                    }
                    
                    GroupBox {
                        Button {
                            self.newCourse = true
                        } label: {
                            Text("Create Course")
                        }
                        .buttonStyle(.borderedProminent)
                    } label: {
                        Label("New Course", systemImage: "pencil")
                    }
                }
                .padding(.horizontal)
            }
        .navigationTitle("Course Selection")
        .navigationDestination(for: Course.self) { newCourse in
            RoundSetupView(course: newCourse,
                           golfer: self.$golfer,
                           path: self.$path)
                
        }
        .sheet(isPresented: self.$newCourse) {
            CreateCourse(showView: self.$newCourse,
                         path: self.$path)
            
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem (placement: .navigationBarLeading) {
                Button (role: .destructive) {
                    self.isCancelledRound = true
                } label: {
                    Image(systemName: "trash")
                }
                .confirmationDialog("Delete Round", isPresented: self.$isCancelledRound, actions: {
                    Button (role: .destructive) {
                        path.keepFirst()
                    } label: {
                        Text("Confirm")
                    }
                    
                    
                }, message: {
                    Text("Delete Round")
                })
            }
        }
        
    }
}

struct RoundEntry_Previews: PreviewProvider {
    @State private static var golfer = Golfer.golfer
    @State private static var path = NavigationPath()
    static var previews: some View {
        RoundEntry(golfer: self.$golfer,
                   path: self.$path)
    }
}
