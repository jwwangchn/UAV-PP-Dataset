import cv2
import os

image_path = './train_data'
for name_list in os.listdir(image_path):
    image_name = name_list.split('.')[0] + '.jpg'
    im = cv2.imread(os.path.join(image_path, image_name))
    height, width = im.shape[0:2]
    if height != 342 or width != 342:
        print "width, height: ", image_name, height, width