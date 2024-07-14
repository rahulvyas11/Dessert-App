import SwiftUI

struct DessertListView: View {
    @StateObject var viewModel = DessertListViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(Array(viewModel.desserts.sorted { $0.strMeal ?? "" < $1.strMeal ?? "" }.enumerated()), id: \.element.idMeal) { index, dessert in
                        DessertTile(image: dessert.strMealThumb ?? URL(fileURLWithPath: ""), name: dessert.strMeal ?? "", mealID: dessert.idMeal ?? "")
                            .padding(.horizontal)
                            .transition(.asymmetric(insertion: .opacity.combined(with: .slide), removal: .opacity))
                            .animation(.easeInOut(duration: 0.5).delay(0.1 * Double(index)), value: viewModel.desserts)
                    }
                }
            }
            .navigationTitle("Recipes")
            .task {
                await viewModel.loadDessertData()
            }
        }
    }
}

struct DessertListView_Previews: PreviewProvider {
    static var previews: some View {
        DessertListView()
    }
}
