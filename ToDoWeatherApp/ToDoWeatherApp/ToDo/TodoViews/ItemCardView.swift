import SwiftUI

struct ItemCardView: View {
    @State var toggleCheckbox: Bool
    
    var taskId: String
    var title: String
    var description: String
    var itemIds: [String]
    var isCompleted: Bool
    var action: (Bool) -> Void
    
    init(taskId: String,
         title: String,
         description: String,
         itemIds: [String],
         isCompleted: Bool,
         action: @escaping (Bool) -> Void) {
        self.taskId = taskId
        self.title = title
        self.description = description
        self.itemIds = itemIds
        self.isCompleted = isCompleted
        self.action = action
        _toggleCheckbox = State(initialValue: isCompleted)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "list.bullet.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(.blue.opacity(0.5))
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
            }
            
            Spacer()
            VStack {
                if let _ = itemIds.firstIndex(where: { $0 == taskId }) {
                    Image(systemName: toggleCheckbox ? "checkmark.square.fill" : "square")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.blue)
                }
            }
            .onTapGesture {
                if let _ = itemIds.firstIndex(where: { $0 == taskId }) {
                    toggleCheckbox.toggle()
                    action(toggleCheckbox)
                }
            }
            Spacer()
                .frame(width: 8)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
