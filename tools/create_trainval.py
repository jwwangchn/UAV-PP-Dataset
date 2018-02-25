import os
import shutil

trainval = './train_data'
lines = []
for image_name in os.listdir(trainval):
    annotation_name = image_name + '.rbox'
    print image_name, annotation_name
    lines.append(image_name + ' ' + annotation_name)

trainval_file = open('trainval.txt', 'w')
for line in lines:
    trainval_file.write(line)
    trainval_file.write('\n')
trainval_file.close()
