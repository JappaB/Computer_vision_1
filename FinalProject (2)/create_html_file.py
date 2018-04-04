import numpy as np
import scipy.io

def rank_paths(model_name):
    image_folders = ['Caltech4/ImageData/airplanes_test', 'Caltech4/ImageData/cars_test',
                   'Caltech4/ImageData/faces_test' , 'Caltech4/ImageData/motorbikes_test']
    image_paths = []

    for i, class_id in enumerate([1]*50 + [2]*50 + [3]*50 + [4]*50):
        folder = image_folders[class_id - 1]
        n = i % 50 + 1
        title = f'img{n:03}.jpg'
        image_paths.append(f"{folder}/{title}")

    path_array = np.array(image_paths, dtype=object)
    path_array = np.vstack((path_array, path_array, path_array, path_array)).T

    predictions = scipy.io.loadmat(f'predictions/{model_name}')['predictions']
    sorted_idx = np.argsort(predictions, axis=0)

    ranked_imgs = np.flip(path_array[sorted_idx, np.arange(4)], axis=0)

    return ranked_imgs

def create_html_table_body(ranked_paths):
    result = "<tbody>"

    for rank in ranked_paths:
        row = f"<tr><td><img src='{rank[0]}' /></td><td><img src='{rank[1]}' /></td><td><img src='{rank[2]}' /></td><td><img src='{rank[3]}' /></td></tr>"
        result += row

    result += "</tbody>"

    return result

print(create_html_table_body(rank_paths('stride-20_n-5_k-40_dense-0_colorspace-gray')))
