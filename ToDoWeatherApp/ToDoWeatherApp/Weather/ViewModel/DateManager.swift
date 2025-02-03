import Foundation
import SwiftUI

struct DateManager {
    let date = Date.now
    
    func getCompleteDate() -> String {
        return date.formatted(date: .complete, time: .omitted)
    }
    
    func getTime() -> String {
        return date.formatted(date: .omitted, time: .shortened)
    }
}
