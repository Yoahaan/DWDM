import pandas as pd
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler, LabelEncoder

# Load data from CSV (replace with your actual file path)
file_path = 'C:/Study/SEM5/Data Warehouse and Data Mining/Codes/Ass_7/Mall_Customers.csv'  # Replace with the correct file path

# Reading the data (assuming you've already loaded it into the right format)
df = pd.read_csv(file_path)

# Print DataFrame columns to verify
print("Columns in DataFrame:", df.columns)

# Define the columns of interest
numerical_cols = ['Age', 'Annual Income (k$)', 'Spending Score (1-100)']
categorical_cols = ['Gender']

# Handle missing values if necessary
df = df.fillna(0)

# Apply Label Encoding to the 'Gender' column
label_encoders = {}
for col in categorical_cols:
    le = LabelEncoder()
    df[col] = le.fit_transform(df[col])  # Convert 'Male'/'Female' to 0/1 or similar
    label_encoders[col] = le

# Standardize the numerical columns
scaler = StandardScaler()
df[numerical_cols] = scaler.fit_transform(df[numerical_cols])

# Combine both numerical and categorical data for clustering
df_scaled = pd.concat([df[numerical_cols], df[categorical_cols]], axis=1)

# Set number of clusters
num_clusters = 3

# Initialize and fit the KMeans model
kmeans = KMeans(n_clusters=num_clusters, random_state=42)
kmeans.fit(df_scaled)

# Add the cluster labels to the original dataset
df['Cluster'] = kmeans.labels_

# Print cluster centers and labels
print("Cluster centers:\n", kmeans.cluster_centers_)
print("Cluster labels:\n", kmeans.labels_)

# Visualize the clusters based on two features: 'Annual Income (k$)' and 'Spending Score (1-100)'
plt.scatter(df['Annual Income (k$)'], df['Spending Score (1-100)'], c=kmeans.labels_, cmap='rainbow')
plt.title('K-means Clustering of Customers')
plt.xlabel('Annual Income (k$)')
plt.ylabel('Spending Score (1-100)')
plt.show()

# Save the data with cluster labels to a new CSV file
df.to_csv('customers_with_clusters.csv', index=False)
