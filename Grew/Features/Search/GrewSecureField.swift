//
//  GrewSecureField.swift
//  Grew
//
//  Created by 김종찬 on 10/13/23.
//

import SwiftUI

struct GrewSecureField: View {
    @Binding var text: String
    /// 잘못된 입력값 여부
    @Binding var isWrongText: Bool
    /// Textfield 비활성화 여부
    @Binding var isTextfieldDisabled: Bool
    @FocusState var isTextFieldFocused: Bool
    
    let placeholderText: String
    
    private var textFieldStrokeColor: Color {
        if isWrongText {
            return Color(hexCode: "F05650")
        }
        return isTextFieldFocused ? Color.grewMainColor : Color(hexCode: "f2f2f2")
    }
    
    var body: some View {
        HStack {
            HStack {
                SecureField(placeholderText, text: $text)
                    .submitLabel(.search)
                    .focused($isTextFieldFocused)
                    .font(.b2_R)
                    .disabled(isTextfieldDisabled)
                
                if !text.isEmpty {
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color.grewMainColor)
                    }
                    .padding(.trailing, 5)
                }
            }
            .frame(height: 44)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(textFieldStrokeColor)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(isTextfieldDisabled ? Color(hexCode: "D4D4D4"): Color(hexCode: "f2f2f2"))
                    )
            )
        }
    }
}

#Preview {
    GrewSecureField(
        text: .constant(""),
        isWrongText: .constant(true),
        isTextfieldDisabled: .constant(true),
        isTextFieldFocused: FocusState(),
        placeholderText: "검색어를 입력하세요."
    )
}
