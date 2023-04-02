//
//  CourseHoleByHole.swift
//  _40YardsLeft
//
//  Created by Logan Underwood on 2023-04-01.
//

import SwiftUI

struct TeeBuffer {
    var rating: Double = 70.3
    var slope: Int = 125
    var name = ""
    var holeData = [HoleData]()
    
    static func formulateTee(from buffer: TeeBuffer) throws -> Tee {
        return try Tee(rating: buffer.rating, slope: buffer.slope, holeData: buffer.holeData, name: buffer.name)
    }
}



struct CourseHoleByHole: View {
    @State var buffer = TeeBuffer()
    
    @Binding var course: Course
    
    @State private var numberOfHoles = 18
    
    private let holeOptions = [9, 18]
    
    @State private var isAlert: (Bool, String?) = (false, nil)
    
    var body: some View {
        VStack {
            ScrollView {
                GroupBox {
                    VStack {
                        
                        TextField("Tee Name", text: self.$buffer.name)
                            .textFieldStyle(.roundedBorder)
                        
                        TextField("Slope", value: self.$buffer.slope, formatter: .wholeNumber)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                        
                        
                        TextField("Rating", value: self.$buffer.rating, formatter: .decimal(numOfDigits: 1))
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                        
                    }
                } label: {
                    Text("General Data")
                }
                
                
                GroupBox {
                    if buffer.holeData.isEmpty {
                        
                        Text("Number of Holes")
                            .font(.headline)
                            .padding(.top, 2)
                        
                        Picker(selection: self.$numberOfHoles) {
                            ForEach(holeOptions) { value in
                                Text("\(value)")
                            }
                        } label: {
                            Text("Holes")
                        }
                        .pickerStyle(.segmented)
                        
                        
                        Button {
                            
                            withAnimation {
                                self.addHoles(self.numberOfHoles)
                            }
                            
                            
                        } label: {
                            Label("Confirm", systemImage: "checkmark")
                        }
                        
                    } else {
                        HoleDefiner(holeDataList: self.$buffer.holeData)
                        
                    }
                } label: {
                    Text("Hole Information")
                }
            }
            
            Button {
                do {
                    self.course.addTee(try TeeBuffer.formulateTee(from: self.buffer))
                } catch {
                    self.isAlert = (true, error.localizedDescription)
                }
            } label: {
                Label("Add Tee", systemImage: "plus.circle")
            }
        }
        
        

        

        
    }
}

extension CourseHoleByHole {
    
    

    
    private func addHoles(_ number: Int) {
        for _ in 1...number {
            self.buffer.holeData.append(.averageHole)
        }
        
        print(self.buffer.holeData)
    }
}

extension Int: Identifiable {
    public var id: Self { self }
}

struct CourseHoleByHole_Previews: PreviewProvider {
    @State private static var course = Course.example1
    static var previews: some View {
        CourseHoleByHole(course: $course)
    }
}
