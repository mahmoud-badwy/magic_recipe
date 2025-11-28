import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:serverpod/serverpod.dart';

class RecipesEndpoint extends Endpoint {
  Future<String> generateRecipe(Session session, String ingredients) async {
    final geminiApiKey = session.passwords['gemini'];
    if (geminiApiKey == null) {
      throw Exception("Gemini Api Key not found");
    }

    final gemini = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: geminiApiKey,
    );
    final prompt =
        'Generate a recipe using the following ingredients: $ingredients, always put the title '
        'of the recipe in the first line, and then the instructions. The recipe should be easy '
        'to follow and include all necessary steps. Please provide a detailed recipe.';

    final response = await gemini.generateContent([Content.text(prompt)]);

    final recipe = response.text;
    if (recipe == null) {
      return 'Failed to generate a recipe.';
    }
    return recipe;
  }
}
