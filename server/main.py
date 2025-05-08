import asyncio

from fastapi import FastAPI
from starlette.websockets import WebSocket, WebSocketDisconnect
from pydantic_mod.chat_body import ChatBody
from services.llm_service import llmservice
from services.sort_source_service import SortSourceService
from services.search_service import searchservice

app = FastAPI()

search_service = searchservice()
sort_source_service = SortSourceService()
llm_service = llmservice()


# Helper to wrap sync generator for async use
async def wrap_sync_gen(sync_gen):
    for item in sync_gen:
        yield item
        await asyncio.sleep(0.01)


@app.websocket("/ws/chat")
async def websocket_endpoint_chat(websocket: WebSocket):
    print("🧪 WebSocket connection starting...")  # Entry point
    await websocket.accept()
    print("✅ WebSocket accepted.")

    try:
        await asyncio.sleep(0.1)
        print("⏳ Waiting to receive query...")
        data = await websocket.receive_json()
        print(f"📥 Received data: {data}")

        query = data.get("query")
        print(f"🔍 Received query: {query}")

        search_results = search_service.websearch(query)
        print(f"🔎 Got {len(search_results)} search results.")

        sorted_results = sort_source_service.sort_sources(query, search_results)
        print(f"✅ Sorted search results, sending to client...")
        await asyncio.sleep(0.1)
        await websocket.send_json({
            'type': 'search_results',
            'data': sorted_results
        })
        print("📤 Sent search results.")

        for chunk in llm_service.generate_response(query, sorted_results):
            print(f"📤 Sending chunk: {chunk[:100]}...")  # Only show start of chunk
            await asyncio.sleep(0.1)
            await websocket.send_json({'type': 'content', 'data': chunk})

        print("✅ Finished sending all chunks.")

    except Exception as e:
        print(f"❌ Chat error occurred: {e}")
    finally:
        await websocket.close()
        print("🔒 WebSocket closed.")



@app.websocket("/ws/factcheck")
async def websocket_endpoint_factcheck(websocket: WebSocket):
    print("🧪 Fact-check WebSocket connection starting...")
    await websocket.accept()
    print("✅ Fact-check WebSocket accepted.")

    try:
        await asyncio.sleep(0.1)
        print("⏳ Waiting to receive fact-check query...")
        data = await websocket.receive_json()
        print(f"📥 Received data: {data}")

        query = data.get("query")
        print(f"🔍 Received fact-check query: {query}")

        search_results = search_service.websearch(query)
        print(f"🔎 Retrieved {len(search_results)} search results.")

        sorted_results = sort_source_service.sort_sources(query, search_results)
        print("✅ Sorted search results, sending to client...")
        await websocket.send_json({
            'type': 'search_results',
            'data': sorted_results
        })
        print("📤 Sent fact-check search results.")

        # Add connection state checking
        async def is_connected():
            try:
                # Test connection by sending a small ping message
                await websocket.send_json({'type': 'ping'})
                return True
            except Exception:
                return False

        # Use async wrapper with connection checking
        for result in llm_service.generate_factcheck_response(query, sorted_results):
            if not await is_connected():
                print("❗ Client disconnected, stopping fact-check generation.")
                break

            print(f"📤 Sending fact-check result: {result}")
            try:
                await websocket.send_json(result)
            except WebSocketDisconnect:
                print("❌ Client disconnected during fact-check send.")
                break

        print("✅ Finished sending fact-check results.")

    except WebSocketDisconnect as e:
        print(f"❌ Client disconnected: {e.code}")
    except Exception as e:
        print(f"❌ Fact-check error: {e}")
        try:
            await websocket.send_json({
                'type': 'error',
                'data': str(e)
            })
        except:
            print("⚠️ Failed to send error to client.")
    finally:
        try:
            await websocket.close()
        except:
            print("⚠️ Error while closing fact-check socket.")
        print("🔒 Fact-check WebSocket closed.")


@app.post("/chat")
def chat_endp(body: ChatBody):
    search_results = search_service.websearch(body.query)
    sorted_results = sort_source_service.sort_sources(body.query, search_results)
    response = llm_service.generate_response(body.query, sorted_results)
    return response


@app.post("/factcheck")
def factcheck_endpoint(body: ChatBody):
    search_results = search_service.websearch(body.query)
    sorted_results = sort_source_service.sort_sources(body.query, search_results)

    # Collect the result and return as JSON response
    for result in llm_service.generate_factcheck_response(body.query, sorted_results):
        return result
