const { onRequest } = require("firebase-functions/v2/https");
const { GoogleGenAI } = require("@google/genai");
require("dotenv").config();

const ai = new GoogleGenAI({
  apiKey: process.env.GEMINI_API_KEY,
});

exports.generateListing = onRequest(
  {
    region: "us-central1",
    cors: true,
  },
  async (req, res) => {
    try {
      // Only allow POST requests
      if (req.method !== "POST") {
        return res.status(405).json({
          error: "Only POST requests are allowed.",
        });
      }

      // Check Gemini API key
      if (!process.env.GEMINI_API_KEY) {
        return res.status(500).json({
          error: "Gemini API key is not configured.",
        });
      }

      // Get data from Flutter
      const { images, language } = req.body;

      // Check images
      if (!Array.isArray(images) || images.length === 0) {
        return res.status(400).json({
          error: "At least one product image is required.",
        });
      }

      // Maximum 3 images
      if (images.length > 3) {
        return res.status(400).json({
          error: "You can upload up to 3 images.",
        });
      }

      // Validate every image
      for (let i = 0; i < images.length; i++) {
        const image = images[i];

        if (
          !image ||
          typeof image.base64 !== "string" ||
          image.base64.length === 0
        ) {
          return res.status(400).json({
            error: `Image ${i + 1} is missing or invalid.`,
          });
        }

        if (
          typeof image.mimeType !== "string" ||
          image.mimeType.length === 0
        ) {
          return res.status(400).json({
            error: `Image ${i + 1} is missing mimeType.`,
          });
        }
      }

      const selectedLanguage =
        typeof language === "string" &&
        language.trim().length > 0
          ? language.trim()
          : "English + Urdu";

      // Prompt for Gemini
      const prompt = `
You are SellAI, an AI e-commerce assistant for Pakistani online sellers.

Analyze ALL provided product images together.

The images may show the same product from different angles.
Use all visible information across the images to understand the product accurately.

Create a marketplace-ready product listing.

Return ONLY valid JSON in this exact structure:

{
  "title": "short product title",
  "description": "professional product description",
  "category": "appropriate product category",
  "suggestedPrice": "estimated price in PKR",
  "features": [
    "feature 1",
    "feature 2",
    "feature 3",
    "feature 4"
  ],
  "tags": [
    "tag1",
    "tag2",
    "tag3",
    "tag4",
    "tag5"
  ],
  "urduTitle": "Urdu product title",
  "urduDescription": "Urdu product description"
}

Rules:

- Analyze ALL provided images together.
- Use information visible in any of the images.
- The images may show different angles of the same product.
- Identify the product as accurately as possible.
- Do not invent specifications that cannot be identified from the images.
- Do not invent brand names or model numbers unless clearly visible.
- Do not invent dimensions, materials, features or technical specifications.
- The title should be short, clear and suitable for marketplaces such as Daraz.
- The description should be concise, professional and sales-friendly.
- Category should be a simple marketplace category.
- Examples:
  Electronics
  Fashion
  Home & Kitchen
  Beauty
  Mobile Accessories
  Shoes
  Watches
  Bags
  Accessories
- Suggested price must be a realistic estimated selling price in Pakistani Rupees.
- Return the price as a number followed by "PKR".
- Example: "4500 PKR".
- If the exact product/model cannot be identified, give a reasonable estimate based only on what is visible.
- Do not make medical claims.
- Do not make guaranteed-result claims.
- Do not make misleading claims.
- Use natural Pakistani Urdu for the Urdu fields.
- Requested listing language: ${selectedLanguage}
- Return ONLY JSON.
- Do not use markdown.
- Do not use code fences.
`;

      // Convert all images into Gemini image parts
      const imageParts = images.map((image) => ({
        inlineData: {
          mimeType: image.mimeType,
          data: image.base64,
        },
      }));

      // Send prompt + all images to Gemini
      const response = await ai.models.generateContent({
        model: "gemini-3.6-flash",
        contents: [
          {
            role: "user",
            parts: [
              {
                text: prompt,
              },
              ...imageParts,
            ],
          },
        ],
      });

      // Check Gemini response
      if (!response || !response.text) {
        return res.status(500).json({
          error: "Gemini returned an empty response.",
        });
      }

      let text = response.text.trim();

      // Remove markdown code fences if Gemini adds them
      text = text
        .replace(/^```json\s*/i, "")
        .replace(/^```\s*/i, "")
        .replace(/\s*```$/i, "")
        .trim();

      // Parse Gemini JSON
      let listing;

      try {
        listing = JSON.parse(text);
      } catch (error) {
        console.error("Gemini JSON parse error:", error);
        console.error("Gemini response:", text);

        return res.status(500).json({
          error: "AI returned an invalid listing format.",
        });
      }

      // Make sure listing is an object
      if (
        !listing ||
        typeof listing !== "object" ||
        Array.isArray(listing)
      ) {
        return res.status(500).json({
          error: "Invalid listing generated by AI.",
        });
      }

      // Make sure all expected fields exist
      listing.title =
        listing.title?.toString() || "Untitled Product";

      listing.description =
        listing.description?.toString() ||
        "No description generated.";

      listing.category =
        listing.category?.toString() || "Other";

      listing.suggestedPrice =
        listing.suggestedPrice?.toString() ||
        "Price unavailable";

      listing.features = Array.isArray(listing.features)
        ? listing.features
        : [];

      listing.tags = Array.isArray(listing.tags)
        ? listing.tags
        : [];

      listing.urduTitle =
        listing.urduTitle?.toString() || "";

      listing.urduDescription =
        listing.urduDescription?.toString() || "";

      // Send listing back to Flutter
      return res.status(200).json(listing);
    } catch (error) {
      console.error("generateListing error:", error);

      return res.status(500).json({
        error: "Failed to generate product listing.",
        details: error.message,
      });
    }
  }
);