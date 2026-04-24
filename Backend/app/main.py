import fastapi
from dotenv import load_dotenv

load_dotenv()

app = fastapi.FastAPI()


@app.get("/")
def root():
    return {"message": "Backend is working!"}
    
@app.post("/test")
async def test_endpoint(request: fastapi.Request):
    data = await request.json()
    print("Полученные данные:", data)
    return {"status": "ok", "received": data}
