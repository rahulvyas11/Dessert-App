import SwiftUI

struct DessertListView: View {
    @StateObject var viewModel = DessertListViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(Array(viewModel.sortedDesserts.enumerated()), id: \.element) { index, dessert in
                        if let imageUrl = dessert.image {
                            DessertTile(image: imageUrl, name: dessert.name ?? "", mealID: dessert.id ?? "")
                                .padding(.horizontal)
                                .transition(.asymmetric(insertion: .opacity.combined(with: .slide), removal: .opacity))
                                .animation(.easeInOut(duration: 0.5).delay(0.1 * Double(index)), value: viewModel.desserts)
                        } else {
                            // Handle case where URL is invalid
                            DessertTile(image: URL(string: "https://example.com/placeholder.jpg")!, name: dessert.name ?? "", mealID: dessert.id ?? "")
                                .padding(.horizontal)
                                .transition(.asymmetric(insertion: .opacity.combined(with: .slide), removal: .opacity))
                                .animation(.easeInOut(duration: 0.5).delay(0.1 * Double(index)), value: viewModel.desserts)
                        }
                    }
                }
            }
            .navigationTitle("Recipes")
            .onAppear {
                Task {
                    await viewModel.loadDessertData()
                }
            }
        }
    }
}
