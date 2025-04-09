from typing import List
from sentence_transformers import SentenceTransformer
import numpy as np


#here is the sorting of the sources obtained according to the similarities which is calculated through the embedding model and the dot product
#if dot product is 1 then they are similar if 0 then they are not similar and between the two values marks more or less similarities
#embedding is being done through sentence transformer an open source website
#the process is such that the query is converted to a matrix of any number of dimension 3d 40d 300d whatever and the query and the search result are put on the graph with there tails touching now the angle they make with each other is calculated through the dot product
class SortSourceService:
    def __init__(self):
        self.embedding_model = SentenceTransformer("all-miniLM-L6-v2")

    def sort_sources(self, query: str, search_results: List[dict]):
        try:
            relevant_docs = []
            query_embedding = self.embedding_model.encode(query)

            for res in search_results:
                res_embedding = self.embedding_model.encode(res["content"])

                similarity = float(
                    np.dot(query_embedding, res_embedding)
                    / (np.linalg.norm(query_embedding) * np.linalg.norm(res_embedding))
                )

                res["relevance_score"] = similarity

                if similarity > 0.3:
                    relevant_docs.append(res)

            return sorted(
                relevant_docs, key=lambda x: x["relevance_score"], reverse=True
            )
        except Exception as e:
            print(e)
