import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var titleInput: String
    @Binding var descriptionInput: String
//    @State var shouldShowAlert: Bool = false
    var action: () -> ()
    
    init(titleInput: Binding<String>,
         descriptionInput: Binding<String>,
         action: @escaping () -> ()) {
        self._titleInput = titleInput
        self._descriptionInput = descriptionInput
        self.action = action
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Add a Task")
                    .font(.title.bold())
                
                TextField("Title", text: $titleInput)
                    .modifier(FieldModifier())
                
                TextField("Description", text: $descriptionInput)
                    .modifier(FieldModifier(minHeight: 150))
                
                Button {
                    action()
                } label: {
                    Text("Add Task")
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .foregroundStyle(.white)
                .background(.blue.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }

                }
            }
        }
    }
}
