import os
import shutil

trainval = '/home/ubuntu/data/VOCdevkit/VOC2018/ImageSets/Main/trainval.txt'
image_path = '/home/ubuntu/data/VOCdevkit/VOC2018/JPEGImages'

image_list = []
with open(trainval, 'r') as f:
    line = f.readline()
    while line:
        line = line.strip('\n')
        line = line + '.jpg'
        image = os.path.join(image_path, line)
        print image
        shutil.copy(image, './train_data')
        line = f.readline()
