# Adapted from antunderwood here https://github.com/marbl/Mash/issues/9#issuecomment-509837201

import numpy as np
import pandas as pd
import argparse

def parse_args():
    parser = argparse.ArgumentParser(description='Convert triangle distance matrix to square matrix')
    parser.add_argument('filename', type=str, help='Input file')
    parser.add_argument('--ani', action='store_true', help='Convert ANI to distance')
    return parser.parse_args()

def lower_triangle_to_full_natrix(filename, ani):
    num_lines_in_file = sum(1 for line in open(filename))
    distances = []
    sample_names = []

    with open(filename) as f:
        next(f) # skip sample count line
        for line in f:
            elements = line.strip().split('\t')
            sample_names.append(elements[0])
            row = [float(e) for e in elements[1:]]
            row.extend([0.0] * (num_lines_in_file-1-len(row)))
            distances.append(row)
        np_array = np.asarray(distances)
        index_upper = np.triu_indices(num_lines_in_file-1)
        np_array[index_upper] = np_array.T[index_upper]
        print(f"\t{len(distances)}")
        df = pd.DataFrame(np_array, columns=sample_names, index=sample_names)
        if ani:
            df = 1.0 - (df / 100.0)
        return df

def main():
    args = parse_args()
    matrix = lower_triangle_to_full_natrix(args.filename, args.ani)
    print(matrix.to_csv(sep='\t', header=False), end='')

if __name__ == '__main__':
    main()