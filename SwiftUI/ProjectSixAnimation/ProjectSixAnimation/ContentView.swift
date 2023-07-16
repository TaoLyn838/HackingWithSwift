//
//  ContentView.swift
//  ProjectSixAnimation
//
//  Created by CHENGTAO on 7/14/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CustomTransitionsUsingViewModifier()
    }
}

struct CreatingImplicitAnimations: View {
    @State private var animationAmount = 1.0
    var body: some View {
        Button("Tap me") {
            animationAmount += 1
        }
        .padding(50)
        .background(.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .scaleEffect(animationAmount)
        .blur(radius: (animationAmount - 1) * 3)
        .animation(.default, value: animationAmount)
    }
}

struct CustomizingAnimations: View {
        @State private var animationAmount = 1.0
        var body: some View {
            Button("Tap me") {
//                animationAmount += 1
//                if animationAmount > 2 {
//                    animationAmount = 1
//                }
            }
            .padding(50)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
//            .animation(.interpolatingSpring(stiffness: 50, damping: 1), value: animationAmount)
            .overlay (
                Circle()
                    .stroke(.red)
                    .scaleEffect(animationAmount)
                    .opacity(2 - animationAmount)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: false), value: animationAmount)
            )
            .onAppear {
                animationAmount = 2
            }
    }
}

struct AnimationBindings: View {
    @State private var animationAmount = 1.0
    var body: some View {
        print(animationAmount)
        return VStack {
            Stepper("Scale amount", value: $animationAmount.animation(.easeInOut(duration: 1)), in: 1...10)
            
            Spacer()
            
            Button("Tap me") {
                animationAmount += 1
            }
            .padding(50)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(animationAmount)
        }
    }
}

struct CreatingExplicitAnimations: View {
    @State private var animationAmount = 0.0

    var body: some View {
        Button("Tap me") {
            withAnimation {
                animationAmount += 360
            }
        }
        .padding(50)
        .background(.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
    }
}

struct ControllingAnimationStack: View {
    @State private var enabled = false

    var body: some View {
        Button("Tap me") {
            enabled.toggle()
        }
        .frame(width: 200, height: 200)
        .background(enabled ? .blue : .red)
        .animation(nil, value: enabled)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
        .animation(.interpolatingSpring(stiffness: 10, damping: 1), value: enabled)
    }
}

struct AnimatingGestures: View {
    let letters = Array("Hello, SwiftUI")
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
//        return VStack {
//            LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                .frame(width: 300, height: 200)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .offset(dragAmount)
//                .gesture(
//                    DragGesture()
//                        .onChanged { dragAmount = $0.translation }
//                        .onEnded{ _ in
//                            withAnimation {
//                                dragAmount = .zero
//                            }
//                        }
//                )
//        }
        HStack(spacing: 0) {
            ForEach(0..<letters.count, id: \.self) { num in
                Text(String(letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(enabled ? .blue : .red)
                    .offset(dragAmount)
                    .animation(.default.delay(Double(num) / 20), value: dragAmount)
            }
        }
        .gesture(
            DragGesture()
                .onChanged {dragAmount = $0.translation }
                .onEnded { _ in
                    dragAmount = .zero
                    enabled.toggle()
                }
        )
    }
}

struct ShowingAndHidingViewsWithTransitions: View {
    @State private var isShowingRed = false
    var body: some View {
        VStack {
            Button("Tap me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
        }
    }
}

struct CustomTransitionsUsingViewModifier: View {
    @State private var isShowingRed = false
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .frame(width: 200, height: 200)
            
            if isShowingRed {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }.onTapGesture {
            withAnimation {
                isShowingRed.toggle()
            }
        }
    }
}

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(active: CornerRotateModifier(amount: -90, anchor: .topLeading), identity: CornerRotateModifier(amount: 0, anchor: .topLeading))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
