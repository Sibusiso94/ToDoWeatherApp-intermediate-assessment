import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var titleInput: String
    @Binding var descriptionInput: String
    var isEditing: Bool
    var action: () -> ()
    
    init(titleInput: Binding<String>,
         descriptionInput: Binding<String>,
         isEditing: Bool = false,
         action: @escaping () -> ()) {
        self._titleInput = titleInput
        self._descriptionInput = descriptionInput
        self.isEditing = isEditing
        self.action = action
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField(NSLocalizedString("TextField_Input_Title_Text", comment: ""), text: $titleInput)
                    .modifier(FieldModifier())
                
                TextField(NSLocalizedString("TextField_Input_Description_Text", comment: ""), text: $descriptionInput)
                    .modifier(FieldModifier(minHeight: 150))
                
                Button {
                    action()
                } label: {
                    Text(isEditing ? NSLocalizedString("Edit_Task_Button_Text", comment: "") : NSLocalizedString("Add_Task_Button_Text", comment: ""))
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .foregroundStyle(.white)
                .background(.blue.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding()
            }
            .navigationTitle(isEditing ? NSLocalizedString("Edit_Task_Title_Text", comment: "") : NSLocalizedString("Add_Task_Title_Text", comment: ""))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text(NSLocalizedString("Close_Button_Text", comment: ""))
                    }

                }
            }
        }
    }
}
