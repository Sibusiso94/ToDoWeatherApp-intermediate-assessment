import SwiftUI

struct FieldModifier: ViewModifier {
    var minHeight: CGFloat = 50
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .frame(minHeight: minHeight)
            .background(RoundedRectangle(cornerRadius: 8).stroke().opacity(0.5))
            .padding()
    }
}
