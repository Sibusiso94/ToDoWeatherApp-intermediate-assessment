import SwiftUI

struct ItemCardView: View {
    @State var toggleCheckbox: Bool
    
    var title: String
    var description: String
    var isCompleted: Bool
    var action: (Bool) -> Void
    
    init(title: String,
         description: String,
         isCompleted: Bool,
         action: @escaping (Bool) -> Void) {
        self.title = title
        self.description = description
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
                Image(systemName: toggleCheckbox ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.blue)
            }
            .onTapGesture {
                toggleCheckbox.toggle()
                action(toggleCheckbox)
            }
            Spacer()
                .frame(width: 8)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
