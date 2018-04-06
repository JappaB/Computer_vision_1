import numpy as np
import scipy.io
import os

def rank_paths(model_name):
    image_folders = ['../Caltech4/ImageData/airplanes_test', '../Caltech4/ImageData/cars_test',
                   '../Caltech4/ImageData/faces_test' , '../Caltech4/ImageData/motorbikes_test']
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

def create_html_meta_table(model_name):
    with_string = model_name.split("_")
    settings = {x.split("-")[0] : x.split("-")[1] for x in with_string}
    settings['dense'] = "DENSE" if settings['dense'] == "1" else "KEYPOINT"

    result = f"<table><tr><th>SIFT step size</th><td>{settings['stride']} px</td></tr><tr><th>SIFT block sizes</th><td>3 pixels</td></tr><tr><th>SIFT method</th><td>{settings['dense']}-SIFT</td></tr><tr><th>Vocabulary size</th><td>{settings['k']} words</td></tr><tr><th>Vocabulary fraction</th><td>1</td></tr><tr><th>SVM training data</th><td>{settings['n']} positive, 50 negative per class</td></tr><tr><th>SVM kernel type</th><td>Linear</td></tr></table>"

    return result

def create_html_table_header(model_name):
    # TODO: read avg_p values

    avg_p = scipy.io.loadmat(f'average_precision/{model_name}')['AP']
    print(avg_p)
    result = f"<thead><tr><th>Airplanes (AP: {avg_p[0,0]})</th><th>Cars (AP: {avg_p[0,1]})</th><th>Faces (AP: {avg_p[0,2]})</th><th>Motorbikes (AP: {avg_p[0,3]})</th></tr></thead>"

    return result

def create_html_table_title(model_name):
    # TODO: read avg_p values and calculate MAP

    avg_p = scipy.io.loadmat(f'average_precision/{model_name}')['AP']
    mAP = np.mean(avg_p)
    result = f"<h1>Prediction lists (MAP: {mAP})</h1>"

    return result

def create_page(model_name):
    result = "<!DOCTYPE html>\
    <html lang=\"en\">\
      <head>\
        <meta charset=\"utf-8\">\
        <title>Image list prediction</title>\
      <style type=\"text/css\">\
       img {\
         width:200px;\
       }\
      </style>\
      </head>\
      <body>\
    <h2>Jasper Bakker, Aron Hammond</h2>\
    <h1>Settings</h1>"

    result += create_html_meta_table(model_name)
    result += create_html_table_title(model_name)
    result += "<h3><font color=\"red\">Following are the ranking lists for the four categories. Please fill in your lists.</font></h3>\
    <h3><font color=\"red\">The length of each column should be 200 (containing all test images).</font></h3>"
    result += "<table>"
    result += create_html_table_header(model_name)
    result += create_html_table_body(rank_paths(model_name))
    result += "</table>\
      </body>\
    </html>"

    with open("html/" + model_name + ".html", 'w') as f:
        f.write(result)

create_page('stride-20_n-50_k-400_dense-0_colorspace-gray')

for file in os.listdir('predictions/'):
    if file.endswith('.mat') and file not in os.listdir('html/'):
        model_name = file.split('.')[0]
        create_page(model_name)
