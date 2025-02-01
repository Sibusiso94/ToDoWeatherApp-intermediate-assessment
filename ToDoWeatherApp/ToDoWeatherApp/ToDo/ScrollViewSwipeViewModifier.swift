import SwiftUI

struct ScrollViewSwipeViewModifier: ViewModifier {
    @State private var size: CGSize = .init(width: 1, height: 1)
    
    func body(content: Content) -> some View {
        List {
            LazyVStack {
                content
            }
            .frame(minHeight: 60)
            .readSize { size in
                self.size = size
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .scrollDisabled(true)
        .listStyle(.plain)
        .frame(height: size.height)
        .contentMargins(.vertical, EdgeInsets(), for: .scrollContent)
    }
}

extension View {
    func enableScrollViewSwipeAction() -> some View {
        self.modifier(ScrollViewSwipeViewModifier())
    }
}
