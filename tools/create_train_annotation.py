import os
import cv2
import numpy as np
import xml.etree.ElementTree as ET


def parse_rec(filename):
    """ Parse a PASCAL VOC xml file """
    tree = ET.parse(filename)
    root = tree.getroot()
    objects = []

    for object in root.findall('object'):
        obj_struct = {}
        obj_struct['name'] = 'bottle'
        obj_struct['pose'] = 'Unspecified'
        obj_struct['truncated'] = 0
        obj_struct['difficult'] = 0
        robndbox = object.find('robndbox')
        cx = robndbox.find('cx').text
        cy = robndbox.find('cy').text
        w = robndbox.find('w').text
        h = robndbox.find('h').text
        angle = robndbox.find('angle').text
        angle = float(angle) * 180.0 / np.pi
        angle = 360 - angle
        angle = str(angle)
        obj_struct['bbox'] = cx + ' ' + cy + ' ' + h + ' ' + w + ' ' + '1' + ' ' + angle
        objects.append(obj_struct)
    return objects


image_path = '/home/ubuntu/Documents/DRBox/data/bottle/train_data'
draw_path = './annotation_data'
annotation_path = '/home/ubuntu/data/VOCdevkit/VOC2018/Annotations'
dst_anno_path = './annotation_data/'

for img in os.listdir(image_path):
    img_name = img.split(".")[0]
    objects = parse_rec(os.path.join(annotation_path, img_name + '.xml'))
    anno_name = img_name + '.jpg.rbox'
    anno_file = open(dst_anno_path + anno_name, 'w')
    for object in objects:
        box = object['bbox']
        anno_file.write(box + '\n')
    anno_file.close()
