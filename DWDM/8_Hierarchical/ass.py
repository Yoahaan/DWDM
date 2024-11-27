import pandas as pd
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import AgglomerativeClustering
from sklearn.decomposition import PCA
import scipy.cluster.hierarchy as shc

# Step 1: Read the CSV file
data = pd.read_csv('C:/Study/SEM5/Data Warehouse and Data Mining/Codes/Ass_10/Mall_Customers.csv')  # Replace 'your_file_path.csv' with the actual path to your CSV file

# Step 2: Select relevant features
features = ['Age', 'Annual Income (k$)', 'Spending Score (1-100)']
X = data[features].fillna(0)  # Fill missing values with 0, if any

# Step 3: Standardize the features
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Step 4: Create a dendrogram for visualizing clusters
plt.figure(figsize=(10, 7))
plt.title("Dendrogram for Customer Segmentation")
dend = shc.dendrogram(shc.linkage(X_scaled, method='ward'))
plt.xlabel("Customer Index")
plt.ylabel("Euclidean Distance")
plt.show()

# Step 5: Apply Agglomerative Clustering (using optimal clusters based on dendrogram)
optimal_clusters = 3  # Adjust this based on the dendrogram output
agg_cluster = AgglomerativeClustering(n_clusters=optimal_clusters, linkage='ward')
y_clusters = agg_cluster.fit_predict(X_scaled)

# Step 6: Use PCA to reduce dimensions for visualization
pca = PCA(n_components=2)
X_pca = pca.fit_transform(X_scaled)

# Step 7: Scatter plot showing the clusters
plt.figure(figsize=(10, 7))
plt.scatter(X_pca[:, 0], X_pca[:, 1], c=y_clusters, cmap='rainbow', marker='o', edgecolor='k')
plt.title(f"Agglomerative Clustering ({optimal_clusters} clusters)")
plt.xlabel('PCA Component 1')
plt.ylabel('PCA Component 2')
plt.colorbar(label='Cluster Label')
plt.grid()
plt.show()

# Optional: Print clustered data with labels
data['Cluster'] = y_clusters
print(data[['CustomerID', 'Age', 'Annual Income (k$)', 'Spending Score (1-100)', 'Cluster']])
