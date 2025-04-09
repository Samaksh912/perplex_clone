import asyncio

from fastapi import FastAPI
from starlette.websockets import WebSocket

from pydantic_mod.chat_body import ChatBody
from services.llm_service import llmservice
from services.sort_source_service import SortSourceService
from services.search_service import searchservice

app = FastAPI()

search_service = searchservice()
sort_source_service = SortSourceService()
llm_service = llmservice()


#chat websocket for realtime results like chatgpt
@app.websocket("/ws/chat")
async def websocket_endpoint_chat(websocket: WebSocket):
    await websocket.accept()

    try:
        await asyncio.sleep(0.1)
        data = await websocket.receive_json()
        query = data.get("query")
        search_results = search_service.websearch(query)  #for searching web for services
        sorted_results = sort_source_service.sort_sources(query, search_results)
        await asyncio.sleep(0.1)
        await websocket.send_json({
            'type': 'search_results',
            'data': sorted_results
        })

        for chunk in llm_service.generate_response(query, sorted_results):
            await asyncio.sleep(0.1)
            await websocket.send_json({'type': 'content', 'data': chunk})

    except:
        print("unexpected errror")
    finally:
        await websocket.close()


@app.post("/chat")
def chat_endp(body: ChatBody):
    search_results = search_service.websearch(body.query)  #for searching web for services
    sorted_results = sort_source_service.sort_sources(body.query, search_results)
    response = llm_service.generate_response(body.query, sorted_results)
    return response
