import SwiftUI

struct SwipeActionButton: View {
    var deleteAction: () -> Void
    var editAction: () -> Void
    
    var body: some View {
        HStack {
            Button("Delete", systemImage: "trash") {
                deleteAction()
            }
            .tint(.red)
            Button("Edit", systemImage: "square.and.pencil") {
                editAction()
            }
            .tint(.yellow)
        }
    }
}
