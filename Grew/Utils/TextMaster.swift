//
//  TextMaster.swift
//  Grew
//
//  Created by jager_yoo on 10/19/23.
//

import SwiftUI

struct TextMaster: View {
    
    @Binding var text: String
    @State private var dynamicHeight: CGFloat
    
    let isFocused: FocusState<Bool>.Binding
    let minLine: Int
    let maxLine: Int
    let font: UIFont
    let becomeFirstResponder: Bool
    
    init(
        text: Binding<String>,
        isFocused: FocusState<Bool>.Binding,
        minLine: Int = 1,
        maxLine: Int,
        fontSize: CGFloat,
        becomeFirstResponder: Bool = false)
    {
        _text = text
        self.isFocused = isFocused
        self.minLine = minLine
        self.maxLine = maxLine
        self.becomeFirstResponder = becomeFirstResponder
        
        let font = UIFont.systemFont(ofSize: fontSize)
        self.font = font
        _dynamicHeight = State(initialValue: font.lineHeight * CGFloat(minLine) + 16)
    }
    
    var body: some View {
        UITextViewRepresentable(
            text: $text,
            dynamicHeight: $dynamicHeight,
            isFocused: isFocused,
            minLine: minLine,
            maxLine: maxLine,
            font: font,
            becomeFirstResponder: becomeFirstResponder)
        .frame(height: dynamicHeight)
        .focused(isFocused)
    }
}

fileprivate struct UITextViewRepresentable: UIViewRepresentable {
    
    @Binding var text: String
    @Binding var dynamicHeight: CGFloat
    
    let isFocused: FocusState<Bool>.Binding
    let minLine: Int
    let maxLine: Int
    let font: UIFont
    let becomeFirstResponder: Bool
    
    func makeUIView(context: UIViewRepresentableContext<UITextViewRepresentable>) -> UITextView {
        let textView = UITextView(frame: .zero)
        textView.delegate = context.coordinator
        textView.font = font
        textView.backgroundColor = .clear
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.isScrollEnabled = false
        textView.bounces = false
        
        if becomeFirstResponder {
            textView.becomeFirstResponder()
        }
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<UITextViewRepresentable>) {
        guard uiView.text == self.text else {
            uiView.text = self.text
            return
        }
    }
    
    func makeCoordinator() -> UITextViewRepresentable.Coordinator {
        Coordinator(
            text: $text,
            isFocused: isFocused,
            dynamicHeight: $dynamicHeight,
            minHeight: font.lineHeight * CGFloat(minLine) + 16,
            maxHeight: font.lineHeight * CGFloat(maxLine + (maxLine > minLine ? 1 : .zero)) + 16)
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        
        @Binding var text: String
        @Binding var dynamicHeight: CGFloat
        
        let isFocused: FocusState<Bool>.Binding
        let minHeight: CGFloat
        let maxHeight: CGFloat
        
        init(
            text: Binding<String>,
            isFocused: FocusState<Bool>.Binding,
            dynamicHeight: Binding<CGFloat>,
            minHeight: CGFloat,
            maxHeight: CGFloat)
        {
            _text = text
            self.isFocused = isFocused
            _dynamicHeight = dynamicHeight
            self.minHeight = minHeight
            self.maxHeight = maxHeight
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            isFocused.wrappedValue = true
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            isFocused.wrappedValue = false
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.text = textView.text ?? ""
            
            if text.isEmpty {
                dynamicHeight = minHeight
                textView.isScrollEnabled = false
                return
            }
            
            let newSize = textView.sizeThatFits(.init(width: textView.frame.width, height: .greatestFiniteMagnitude))
            
            if newSize.height < maxHeight, textView.isScrollEnabled {
                textView.isScrollEnabled = false
            } else if newSize.height > maxHeight, !textView.isScrollEnabled {
                textView.isScrollEnabled = true
                textView.flashScrollIndicators()
            }
            
            guard newSize.height > minHeight, newSize.height < maxHeight else { return }
            dynamicHeight = newSize.height
        }
    }
}
