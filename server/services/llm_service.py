import re
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
            for i, result in enumerate(search_results)
        ])

        full_prompt = f"""
Context from web search:
{context_text}

Query: {query}

Please provide a comprehensive, detailed, well-cited accurate response using the above context. Think and reason deeply. Ensure it answers the query the user is asking. Do not use your knowledge until it is absolutely necessary.
"""
        response = self.model.generate_content(full_prompt, stream=True)

        for chunk in response:
            yield chunk.text

    def generate_factcheck_response(self, query: str, search_results: list[dict]):
        context_text = "\n\n".join([
            f"Source {i + 1} ({result['url']}):\n{result['content']}"
            for i, result in enumerate(search_results)
        ])

        full_prompt = f"""
Context from web search:
{context_text}

Claim to Fact Check: {query}

Task: Determine whether the claim above is TRUE, FALSE, or UNCERTAIN. 
Please follow these guidelines:

1. Base your reasoning ONLY on the information provided in the sources.
2. Cite your evidence clearly using "Source 1", "Source 2", etc.
3. Do not assume anything that is not explicitly supported by the sources.
4. If the evidence is inconclusive or contradictory, conclude with "UNCERTAIN".

Respond in the following format:

Verdict: [TRUE / FALSE / UNCERTAIN]

Percentage: Give the Percentage stating how much true the claim is

Reasoning:
[Detailed explanation citing relevant sources]
"""

        response_text = ""
        response = self.model.generate_content(full_prompt, stream=True)
        for chunk in response:
            response_text += chunk.text

        # Parse fields using regex
        verdict_match = re.search(r"Verdict:\s*(TRUE|FALSE|UNCERTAIN)", response_text, re.IGNORECASE)
        percentage_match = re.search(r"Percentage:\s*([0-9]{1,3})", response_text)
        reasoning_match = re.search(r"Reasoning:\s*(.*)", response_text, re.IGNORECASE | re.DOTALL)

        result = {
            "verdict": verdict_match.group(1).upper() if verdict_match else "UNCERTAIN",
            "percentage": int(percentage_match.group(1)) if percentage_match else 50,
            "reasoning": reasoning_match.group(1).strip() if reasoning_match else "No reasoning found."
        }

        yield {
            "type": "factcheck_result",
            "data": result
        }
