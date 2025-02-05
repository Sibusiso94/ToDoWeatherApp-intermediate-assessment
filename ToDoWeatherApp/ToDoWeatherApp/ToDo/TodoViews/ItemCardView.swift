import SwiftUI

struct ItemCardView: View {
    @State var toggleCheckbox: Bool
    
    var item: ToDoItem
    var itemIds: [String]
    var action: (Bool) -> Void
    
    init(item: ToDoItem,
         itemIds: [String],
         action: @escaping (Bool) -> Void) {
        self.item = item
        self.itemIds = itemIds
        self.action = action
        _toggleCheckbox = State(initialValue: item.isCompleted)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "list.bullet.circle")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundStyle(.blue.opacity(0.5))
            
            VStack(alignment: .leading) {
                Text(item.todoTitle)
                    .font(.headline)
                    .lineLimit(1)
                Text(item.todoDescription)
                    .font(.caption)
                    .lineLimit(3)
                    .minimumScaleFactor(0.5)
            }
            
            Spacer()
            VStack {
                if let _ = itemIds.firstIndex(where: { $0 == item.id }) {
                    //try colours instead
                    Image(systemName: item.isCompleted ? "checkmark.square.fill" : "square")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(.blue)
                }
            }
            .onTapGesture {
                if let _ = itemIds.firstIndex(where: { $0 == item.id }) {
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
