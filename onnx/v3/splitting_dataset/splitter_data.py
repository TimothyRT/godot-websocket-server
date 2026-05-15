import pandas as pd
import re
import os
import glob

# Config 
INPUT_FOLDER = r'D:\Kuliah\Project\TA\Project TA\godot-websocket-server\onnx\v3\splitting_dataset\dataset'

OUTPUT_FOLDER = r'D:\Kuliah\Project\TA\Project TA\godot-websocket-server\onnx\v3\splitting_dataset\output' 

# Ensure output directory existsss
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

csv_files = glob.glob(os.path.join(INPUT_FOLDER, '*.csv'))
csv_files = [f for f in csv_files if not os.path.basename(f).startswith('dataset_')]

if not csv_files:
    print(f"No original CSV files found to process in '{INPUT_FOLDER}'.")
else:
    print(f"Found {len(csv_files)} files. Starting batch process...\n")

for file_path in csv_files:
    filename = os.path.basename(file_path)
    file_base, extension = os.path.splitext(filename)
    
    # Load the dataset
    df = pd.read_csv(file_path)
    
    even_mapping = {}
    odd_mapping = {}
    
    # Loop through columns to sort and rename dynamically
    for col in df.columns:
        if col == 'motion_type':
            continue 
            
        match = re.match(r"^(.*)_(\d+)$", col)
        if match:
            base_name = match.group(1)
            old_idx = int(match.group(2))
            
            new_idx = old_idx // 2
            new_col_name = f"{base_name}_{new_idx}"
            
            if old_idx % 2 == 0:
                even_mapping[col] = new_col_name
            else:
                odd_mapping[col] = new_col_name

    # Create the new DataFrames
    df_even = df[list(even_mapping.keys())].rename(columns=even_mapping)
    df_odd  = df[list(odd_mapping.keys())].rename(columns=odd_mapping)

    # Add the label column back
    if 'motion_type' in df.columns:
        df_even['motion_type'] = df['motion_type']
        df_odd['motion_type']  = df['motion_type']

    # Generate the new file names using your specific format
    new_even_name = f"dataset_{file_base}_even.csv"
    new_odd_name = f"dataset_{file_base}_odd.csv"

    # Define exact save paths
    save_path_even = os.path.join(OUTPUT_FOLDER, new_even_name)
    save_path_odd = os.path.join(OUTPUT_FOLDER, new_odd_name)

    # Save the results
    df_even.to_csv(save_path_even, index=False)
    df_odd.to_csv(save_path_odd, index=False)
    
    print(f"Processed '{filename}' -> Created '{new_even_name}' and '{new_odd_name}'")

print("\nAll datasets have been successfully split and saved in the target folder!")