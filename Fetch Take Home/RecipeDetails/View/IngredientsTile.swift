import SwiftUI

//displays the ingredients and measurements for each recipe
struct IngredientsView: View {
    var ingredientMeasurementPairs: [(ingredient: String, measurement: String)]
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(Array(ingredientMeasurementPairs.enumerated()), id: \.0) { index, pair in
                    IngredientsTile(ingredientName: pair.ingredient, measurement: pair.measurement)
                }
            }
            .padding()
        }
    }
}

struct IngredientsTile: View {
    var ingredientName: String
    var measurement: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(ingredientName)
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
                
            Text(measurement)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
        }
        .frame(maxWidth: .infinity, minHeight: 80)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct IngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsView(ingredientMeasurementPairs: [(ingredient: "Ingredient", measurement: "0 lbs")])
    }
}
