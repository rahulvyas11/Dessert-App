import SwiftUI

struct DessertTile: View {
    var image: URL
    var name: String
    var mealID: String
    
    var body: some View {
        NavigationLink(destination: RecipeDetails(mealId: mealID)) {
            HStack(spacing: 15) {
                AsyncImage(url: image) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 100, height: 100)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(10)
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(10)
                    @unknown default:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(10)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("Tap to view details")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 10)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .accessibilityIdentifier("DessertTile_\(mealID)")
        .buttonStyle(PlainButtonStyle())
    }
}
