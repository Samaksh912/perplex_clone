import google.generativeai as genai

from config import Settings

settings = Settings()


class llmservice:
    def __init__(self):
        genai.configure(api_key=settings.GEMINI_API_KEY)
        self.model = genai.GenerativeModel("gemini-2.0-flash-exp")

    def generate_response(self, query: str, search_results: list[dict]):
        context_text = "\n\n".join([
            f"Source {i + 1} ({result['url']}):\n{result['content']}"
            # starting the sources from one instead of 0 and saying something like first the
            # resultant url then the source in the next line and all this is going through all
            # the sources
            for i, result in enumerate(search_results)  #going through each and evry source
        ])

        full_prompt = f"""
        Context from web search:
        {context_text}
        
        Query: {query}
        
        Please provide a comprehensive, detailed, well-cited accurate response using the above context.Think and reason deeply. Ensure it answers the query the user is asking.Do not use your knowledge until it is absolutely necessary
        """

        response = self.model.generate_content(full_prompt, stream=True)

        for chunk in response:
            yield chunk.text
