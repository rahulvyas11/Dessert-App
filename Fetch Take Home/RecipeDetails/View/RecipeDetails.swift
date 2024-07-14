import SwiftUI

struct RecipeDetails: View {
    var mealId: String
    @StateObject var recipeDetailsViewModel = RecipeDetailsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                if let recipe = recipeDetailsViewModel.recipe {
                    // Thumbnail Image
                    AsyncImage(url: URL(string: recipe.strMealThumb ?? "")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 300)
                                .background(Color.gray.opacity(0.3))
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .background(Color.gray.opacity(0.3))
                                .clipped()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .background(Color.gray.opacity(0.3))
                        @unknown default:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .background(Color.gray.opacity(0.3))
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        // Title
                        Text(recipe.strMeal ?? "Recipe Details")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.vertical)
                        
            
                        // Ingredients Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Ingredients")
                                .font(.headline)
                            IngredientsView(ingredientMeasurementPairs: recipe.ingredientMeasurePairs())
                        }
                        
                        // Instructions Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Instructions")
                                .font(.headline)
                            InstructionsView(instructions: recipe.strInstructions ?? "")
                        }
                    }
                    .padding()
                } else {
                    ProgressView()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(recipeDetailsViewModel.recipe?.strMeal ?? "Recipe Details")
                    .lineLimit(1)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        
        }
        .task {
            await recipeDetailsViewModel.loadRecipeDetails(mealID: mealId)
        }
    }
}

struct RecipeDetails_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetails(mealId: "52893")
    }
}
