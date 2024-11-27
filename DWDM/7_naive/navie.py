import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import GaussianNB
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics import accuracy_score, confusion_matrix, classification_report
import seaborn as sns
import matplotlib.pyplot as plt

# Step 1: Load the dataset
data = pd.read_csv('C:/Study/SEM5/Data Warehouse and Data Mining/Codes/Ass_9/product.csv')  # Replace with your CSV file path
# Keep only the necessary columns
data = data[['rating', 'review']]

# Step 2: Convert ratings to binary classification
# Assuming 5 = Positive (1) and 1 = Negative (0)
data['rating'] = data['rating'].apply(lambda x: 1 if x == 5 else 0)

# Step 3: Feature Extraction (Transforming Text Data)
# Convert text reviews to numerical vectors using TF-IDF
tfidf = TfidfVectorizer(stop_words='english', max_features=1000)  # Adjust max_features as needed
X = tfidf.fit_transform(data['review']).toarray()
y = data['rating']

# Step 4: Train-Test Split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

# Step 5: Model Training
model = GaussianNB()  # Naive Bayes model
model.fit(X_train, y_train)

# Step 6: Model Evaluation
y_pred = model.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
conf_matrix = confusion_matrix(y_test, y_pred)
class_report = classification_report(y_test, y_pred)

# Print evaluation metrics
print(f'Accuracy: {accuracy:.2f}')
print('Confusion Matrix:')
print(conf_matrix)
print('Classification Report:')
print(class_report)

# Visualization of the confusion matrix
plt.figure(figsize=(8, 6))
sns.heatmap(conf_matrix, annot=True, fmt='d', cmap='Blues',
            xticklabels=['Negative', 'Positive'],
            yticklabels=['Negative', 'Positive'])
plt.xlabel('Predicted')
plt.ylabel('Actual')
plt.title('Confusion Matrix')
plt.show()

# Step 7: Single User Input Testing
def predict_review(input_review):
    # Convert input review to TF-IDF vector
    input_vector = tfidf.transform([input_review]).toarray()
    prediction = model.predict(input_vector)
    return "Positive" if prediction[0] == 1 else "Negative"


