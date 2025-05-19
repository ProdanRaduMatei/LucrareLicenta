import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestClassifier
import joblib

# Generate synthetic dataset
np.random.seed(42)
data = pd.DataFrame({
    'row': np.random.randint(1, 26, 500),
    'col': np.random.randint(1, 26, 500),
    'seat_type': np.random.choice([0, 1, 2], 500),  # 0=normal, 1=premium, 2=quiet
    'avg_bookings': np.random.uniform(0, 1, 500),
    'label': np.random.choice([0, 1], 500)  # 1=preferred, 0=not preferred
})

X = data[['row', 'col', 'seat_type', 'avg_bookings']]
y = data['label']

model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X, y)

joblib.dump(model, 'seat_model.pkl')
print("✅ Model trained and saved.")