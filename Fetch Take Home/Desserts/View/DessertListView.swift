import SwiftUI


/// A view that displays a list of desserts fetched from the API.
struct DessertListView: View {
    @StateObject var viewModel = DessertListViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // Iterates over the sorted list of desserts and displays each as a DessertTile.
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
