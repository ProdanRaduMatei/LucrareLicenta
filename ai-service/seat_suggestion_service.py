from flask import Flask, request, jsonify
import random

app = Flask(__name__)

@app.route("/suggest", methods=["POST"])
def suggest_seats():
    data = request.get_json()
    user_email = data.get("userEmail")
    storey_name = data.get("storeyName")
    date = data.get("date")

    seats = data.get("seats", [])
    booked = set((b["row"], b["col"]) for b in data.get("bookedSeats", []))

    available = [s for s in seats if (s["row"], s["col"]) not in booked]

    ranked = sorted(available, key=lambda x: random.random())[:3]
    suggestions = [{"row": s["row"], "col": s["col"], "score": round(random.uniform(70, 99), 1)} for s in ranked]

    return jsonify({"suggestions": suggestions})

if __name__ == "__main__":
    app.run(port=5001)