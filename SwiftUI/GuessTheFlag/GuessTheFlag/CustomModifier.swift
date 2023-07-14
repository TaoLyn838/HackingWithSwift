//
//  CustomModifier.swift
//  GuessTheFlag
//
//  Created by CHENGTAO on 7/12/23.
//

import SwiftUI

struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundStyle(.cyan)
    }
}

extension View {
    func titleModifier() -> some View {
        modifier(TitleModifier())
    }
}
