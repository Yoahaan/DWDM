import pandas as pd
from apyori import apriori

# Load the dataset from the specified path
file_path = r"C:\Users\saura\Downloads\Market_Basket_Optimisation.csv"  # Update the file path
df = pd.read_csv(file_path, header=None)

# Preview the data
print("Initial Data Preview:")
print(df.head())

# Replace empty values with 0
df.fillna(0, inplace=True)

# Convert data into list format for Apriori
transactions = []
for i in range(len(df)):
    transactions.append([str(df.values[i, j]) for j in range(0, 20) if str(df.values[i, j]) != '0'])

# Call apriori function
rules = apriori(transactions, min_support=0.003, min_confidence=0.2, min_lift=3, min_length=2)

# Generate a list of rules
Results = list(rules)

# Convert results into a DataFrame
df_results = pd.DataFrame(Results)

# Ensure we have the expected columns
print("\nResults DataFrame Preview:")
print(df_results.head())
print("\nColumns in Results DataFrame:")
print(df_results.columns)

# Prepare to convert order statistics into proper format
first_values = []
second_values = []
third_values = []
fourth_value = []

# Loop through the results and append values to lists
for i in range(df_results.shape[0]):
    single_list = df_results['ordered_statistics'][i][0]
    first_values.append(list(single_list[0]))
    second_values.append(list(single_list[1]))
    third_values.append(single_list[2])
    fourth_value.append(single_list[3])

# Extract support values from the 'df_results'
support = df_results['support']

# Convert lists into DataFrames for further operations
lhs = pd.DataFrame(first_values)
rhs = pd.DataFrame(second_values)
confidence = pd.DataFrame(third_values, columns=['Confidence'])
lift = pd.DataFrame(fourth_value, columns=['Lift'])

# Concatenate all DataFrames into a final DataFrame, including 'support'
df_final = pd.concat([lhs, rhs, support, confidence, lift], axis=1)

# Check the number of columns in df_final
print("\nColumns in Final DataFrame Before Renaming:")
print(df_final.shape[1])

# Replace NaN with empty strings for better representation
df_final.fillna(value=' ', inplace=True)

# Set dynamic column names based on the number of LHS and RHS items
num_lhs_items = lhs.shape[1]  # Number of LHS items
num_rhs_items = rhs.shape[1]  # Number of RHS items

# Prepare column names dynamically
lhs_columns = [f'LHS_Item_{i+1}' for i in range(num_lhs_items)]
rhs_columns = [f'RHS_Item_{i+1}' for i in range(num_rhs_items)]
all_columns = lhs_columns + rhs_columns + ['Support', 'Confidence', 'Lift']

# Assign new column names to the final DataFrame
df_final.columns = all_columns

# Combine LHS items into one column for clearer representation
df_final['LHS'] = df_final[lhs_columns].apply(lambda x: ', '.join(x.astype(str)), axis=1)

# Combine RHS items into one column for clearer representation
df_final['RHS'] = df_final[rhs_columns].apply(lambda x: ', '.join(x.astype(str)), axis=1)

# Drop the individual LHS and RHS columns
df_final.drop(columns=lhs_columns + rhs_columns, inplace=True)

# Display the final output
print("Final Output:")
print(df_final.head())
