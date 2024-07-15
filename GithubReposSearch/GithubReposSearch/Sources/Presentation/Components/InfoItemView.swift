import SwiftUI

struct InfoItemView: View {
    
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
    }
}
