//
//  TextFieldErrorModifier.swift
//  Grew
//
//  Created by daye on 10/17/23.
//

import SwiftUI

struct TextFieldErrorModifier: ViewModifier {
    @Binding var isError: Bool
    @FocusState var isTextFieldFocused: Bool
    
    private var textFieldStrokeColor: Color {
        if isError {
            return Color(hexCode: "F05650")
        }
        return isTextFieldFocused ? .Main : Color(hexCode: "f2f2f2")
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(textFieldStrokeColor)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hexCode: "f2f2f2"))
                    )
            )
    }
}

struct RectangleModifier: ViewModifier {
    @Binding var isError: Bool
    
    private var textFieldStrokeColor: Color {
     
        return isError ? Color(hexCode: "F05650") : Color(hexCode: "f2f2f2")
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 2)
                    .stroke(textFieldStrokeColor)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hexCode: "f2f2f2"))
                    )
            )
    }
}

struct ErrorText: View {
    var errorMessage: String
    var body: some View {
        HStack(alignment: .bottom){
            Spacer()
            Text(errorMessage)
                .font(.c2_R)
                .foregroundColor(.pink)
        }
    }
}
