from fastapi import FastAPI
import joblib
import pandas as pd

app = FastAPI()

# Load the model at startup
model = joblib.load("models/model.pkl")

@app.post("/predict")
def predict(data: dict):
    df = pd.DataFrame([data])
    prediction = model.predict(df)
    return {"prediction": prediction.tolist()}
