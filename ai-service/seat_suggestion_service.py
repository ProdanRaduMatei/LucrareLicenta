from flask import Flask, request, jsonify
import joblib
import numpy as np
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

model = joblib.load("seat_model.pkl")

@app.route("/suggest", methods=["POST"])
def suggest():
    data = request.get_json()
    seats = data["seats"]
    features = []
    seat_map = []

    for seat in seats:
        row = seat["row"]
        col = seat["col"]
        seat_type = seat.get("seatType", 0)
        avg_bookings = seat.get("avgBookings", 0.5)

        features.append([row, col, seat_type, avg_bookings])
        seat_map.append((row, col))

    probs = model.predict_proba(features)[:, 1]
    scored = list(zip(seat_map, probs))
    scored.sort(key=lambda x: x[1], reverse=True)

    top = scored[:3]
    suggestions = [
        {"row": row, "col": col, "score": round(score * 100, 1)}
        for (row, col), score in top
    ]

    return jsonify({"suggestions": suggestions})

if __name__ == "__main__":
    app.run(port=5001)