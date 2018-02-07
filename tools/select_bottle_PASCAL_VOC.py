import xml.etree.ElementTree as ET
import os
import numpy as np
import shutil
import cv2


def parse_rec(filename):
    """ Parse a PASCAL VOC xml file """
    tree = ET.parse(filename)
    root = tree.getroot()
    objects = []

    for object in root.findall('object'):
        obj_struct = {}
        obj_struct['name'] = object.find('name').text
        obj_struct['pose'] = object.find('pose').text
        obj_struct['truncated'] = 0
        obj_struct['difficult'] = 0
        bndbox = object.find('bndbox')
        xmin = int(float(bndbox.find('xmin').text))
        ymin = int(float(bndbox.find('ymin').text))
        xmax = int(float(bndbox.find('xmax').text))
        ymax = int(float(bndbox.find('ymax').text))

        obj_struct['bbox'] = [xmin, ymin, xmax, ymax]
        objects.append(obj_struct)
    return objects

if __name__ =='__main__':
    root_path = 'E:/jwwangchn/Data/VOCdevkit/VOC2007'
    annotation_path = os.path.join(root_path, 'Annotations')
    image_path = os.path.join(root_path, 'JPEGImages')

    annotation_list = os.listdir(annotation_path)
    for annotation in annotation_list:
        annotation_name = os.path.join(annotation_path, annotation)
        objects = parse_rec(annotation_name)
        image_name = os.path.join(image_path, annotation.split('.')[0] + '.jpg')
        img = cv2.imread(image_name)
        for object_details in objects:
           if object_details['name'] == 'bottle':
                print image_name
                # shutil.copy(image_name, 'E:/jwwangchn/ICIP/bottle_PASCAL_VOC')
                xmin, ymin, xmax, ymax = object_details['bbox']

                cv2.rectangle(img, (xmin, ymin), (xmax, ymax), (0,0,255), 5)
                filename = os.path.join('E:/jwwangchn/ICIP/bottle_PASCAL_VOC', annotation.split('.')[0] + '.jpg')
                cv2.imwrite(filename, img)