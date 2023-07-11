//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by CHENGTAO on 7/8/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ViewsAndModifiers()
    }
}

struct ViewsAndModifiers: View {
    var body: some View {
        CustomContainers()
    }
}

struct BehindTheMainSwfitUIView: View {
    var body: some View {
        Text("Hello World!")
            .padding()
        // for SwiftUI developers, there is nothing behind our view.
            .background(.red)
        // use frame() to solve background color can't full the entire background
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.cyan)
    }
}

struct WhyModifierOrderMatters: View {
    var body: some View {
        Button("Hello World") {
            // using Xcode to run App, you will see it print: "ModifiedContent<ModifiedContent<ModifiedContent<Button<Text>, _PaddingLayout>, _BackgroundStyleModifier<Color>>, _FrameLayout>"
            print(type(of: self.body))
            
        }
        // == "ModifiedContent<ModifiedContent<ModifiedContent<Button<Text>, _PaddingLayout>, _BackgroundStyleModifier<Color>>, _FrameLayout>"
        .padding()
        .background(.red)
        .frame(width: 200, height: 200)
//        .padding()
//        .background(.blue)
//        .padding()
//        .background(.green)
//        .padding(20)
//        .background(.white)
    }
}

//struct WhyUseSomeView: View {
//    var body: some View {
//        // nocode
//    }
//}

struct ConditionalModifiers: View {
    @State private var changeTextColor = false
    var body: some View {
        Button ("Tap to change Color") {
            changeTextColor.toggle()
        }
        .foregroundStyle(changeTextColor ? .cyan : .orange)
        .frame(width: 200, height: 200)
        .background(.gray)
    }
}

struct ViewsAsProperites: View {
    let motto1 = Text("Draco dormiens")
    let motto2 = Text("nunquam titillandus")
    var motto3: some View {
        Text("Hello World")
    }
    var usingStackToHoldMoreElements: some View {
        VStack {
            Text("Text 1")
            Text("Text 2")
        }
    }
    var usingGroupToHoldMoreElements: some View {
        Group {
            Text("Text 1")
            Text("Text 2")
        }
    }
    @ViewBuilder var usingViewBuilderToHoldMoreElements: some View {
        Text("Lumos")
        Text("Obliviate")
    }
    var body: some View {
        VStack {
            // Creating views as properties can be helpful to keep your body code clearer – not only does it help avoid repetition, but it can also get more complex code out of the body property.
            motto1
                .foregroundColor(.cyan)
            motto2
                .foregroundColor(.orange)
            motto3
            usingStackToHoldMoreElements
                .foregroundColor(.brown)
            usingGroupToHoldMoreElements
                .foregroundColor(.indigo)
            usingViewBuilderToHoldMoreElements
                .foregroundColor(.mint)
        }
        .font(.largeTitle)
    }
}

struct ViewComposition: View {
    var body: some View {
        // as I split each part of this project into different struct, this is called view composition
        // Like this:
        ViewsAsProperites()
        WhyModifierOrderMatters()
    }
}


struct CustomModifiers: View {
    
    var body: some View {
        Text("This is my custom text")
//            .modifier(Title())
            .watermarked(with: "Hello Here", color: .cyan)
    }
}

// Way one to making custom modifier
struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

// Way two to making custom modifier
struct Watermark: ViewModifier {
    // This is only way to add stored var in modifier
    var text: String
    var color: Color
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomLeading) {
            content
            Text(text)
                .font(.caption)
                .foregroundStyle(.orange)
                .padding(5)
                .background(color)
        }
    }
}

extension View {
    func watermarked(with text: String, color: Color) -> some View {
        modifier(Watermark(text: text, color: color))
    }
}

struct CustomContainers: View {
    var body: some View {
        GridStack(rows: 4, columns: 4) { row, col in
            // If we do not use HStack, we can use @ViewBuilder. See line between 178-179
            HStack {
                Image(systemName: "\(row * 4 + col).circle")
                Text("R\(row) C\(col)")
            }
        }
    }
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
//    @ViewBuilder let content: (Int, Int) -> Content
    
    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) {row in
                HStack {
                    ForEach(0..<columns, id: \.self) { col in
                        content(row, col)
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
