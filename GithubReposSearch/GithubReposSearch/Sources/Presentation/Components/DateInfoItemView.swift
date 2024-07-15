import SwiftUI

struct DateInfoItemView: View {
    
    let title: String
    let value: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value, style: .date)
                .font(.body)
                .fontWeight(.medium)
        }
    }
}
