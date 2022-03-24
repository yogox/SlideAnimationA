//
//  ContentView.swift
//  SlideAnimationA
//
//  Created by yogox on 2022/03/24.
//

import SwiftUI

enum ViewEnum : Int, CaseIterable {
    case viewA = 0
    case viewB
    case viewC
    case viewD
    case viewE

    mutating func prev() {
        self = offset(-1)
    }

    mutating func next() {
        self = offset(1)
    }
    
    func offset(_ n:Int) -> ViewEnum {
        let a = Self.allCases.count
        let viewNumber = (self.rawValue + (n % a) + a) % a
        return ViewEnum(rawValue: viewNumber)!
    }
}

struct ViewA: View {
    var body: some View {
        Rectangle()
            .fill(.red)
            .overlay(Text("View A")
                .font(.system(size: 30))
                .foregroundColor(.white)
            )
    }
}

struct ViewB: View {
    var body: some View {
        Rectangle()
            .fill(.green)
            .overlay(Text("View B")
                .font(.system(size: 30))
                .foregroundColor(.white)
            )
    }
}

struct ViewC: View {
    var body: some View {
        Rectangle()
            .fill(.blue)
            .overlay(Text("View C")
                .font(.system(size: 30))
                .foregroundColor(.white)
            )
    }
}

struct ViewD: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.yellow)
            .overlay(Text("View D")
                .font(.system(size: 30))
                .foregroundColor(.white)
            )
    }
}

struct ViewE: View {
    var body: some View {
        Rectangle()
            .fill(.cyan)
            .overlay(Text("View E")
                .font(.system(size: 30, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
            )
    }
}

struct SlideModifierA: ViewModifier {
    let show: Bool
    let edge: Edge

    func body(content: Content) -> some View {
        content
            .animation(.linear, value: show)
            .transition(.asymmetric(
                insertion: .move(edge: edge == .leading ? .trailing : .leading),
                removal: .move(edge: edge)
            ))
    }
}

struct ContentView: View {
    @State private var selection: ViewEnum = .viewA
    @State private var swipingEdge: Edge = .leading
    @State private var showAnimation: Bool = false

    func next() {
        withAnimation(.linear) {
            selection.next()
            
            showAnimation = true
            swipingEdge = .trailing
        }
        showAnimation = false
    }
    
    func prev() {
        withAnimation(.linear) {
            selection.prev()
            
            showAnimation = true
            swipingEdge = .leading
        }
        showAnimation = false
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let squareLength = CGFloat.minimum(width, height)
            
            VStack {
                Spacer()
                
                Group {
                    switch selection {
                    case .viewA:
                        ViewA()
                            .modifier(SlideModifierA(show: showAnimation, edge: swipingEdge))
                    case .viewB :
                        ViewB()
                            .modifier(SlideModifierA(show: showAnimation, edge: swipingEdge))
                    case .viewC :
                        ViewC()
                            .modifier(SlideModifierA(show: showAnimation, edge: swipingEdge))
                    case .viewD:
                        ViewD()
                            .modifier(SlideModifierA(show: showAnimation, edge: swipingEdge))
                    case .viewE:
                        ViewE()
                            .modifier(SlideModifierA(show: showAnimation, edge: swipingEdge))
                    }
                    
                }
                .frame(width: squareLength, height: squareLength)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        prev()
                    }) {
                        Image(systemName: "arrow.left.square.fill")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                    
                    Spacer()

                    Button(action: {
                        next()
                    }) {
                        Image(systemName: "arrow.right.square.fill")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                    }
                    
                    Spacer()
                }
                .foregroundColor(Color.black)
                
                Spacer()
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}


