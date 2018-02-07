import os
import cv2
import numpy as np
import xml.etree.ElementTree as ET


def draw_box(im, BBox, color, path):
    cx, cy, h, w, angle = BBox[0:5]
    lt = [cx - w / 2, cy - h / 2, 1]
    rt = [cx + w / 2, cy - h / 2, 1]
    lb = [cx - w / 2, cy + h / 2, 1]
    rb = [cx + w / 2, cy + h / 2, 1]
    pts = []
    pts.append(lt)
    pts.append(rt)
    pts.append(rb)
    pts.append(lb)
    angle = -angle
    cos_cita = np.cos(np.pi / 180 * angle)
    sin_cita = np.sin(np.pi / 180 * angle)
    M0 = np.array([[1, 0, 0], [0, 1, 0], [-cx, -cy, 1]])
    M1 = np.array([[cos_cita, sin_cita, 0],
                   [-sin_cita, cos_cita, 0], [0, 0, 1]])
    M2 = np.array([[1, 0, 0], [0, 1, 0], [cx, cy, 1]])
    rotation_matrix = M0.dot(M1).dot(M2)
    rotated_pts = np.dot(np.array(pts), rotation_matrix)

    cv2.line(im, (int(rotated_pts[0, 0]), int(rotated_pts[0, 1])),
             (int(rotated_pts[1, 0]), int(rotated_pts[1, 1])), color, 5)
    cv2.line(im, (int(rotated_pts[1, 0]), int(rotated_pts[1, 1])),
             (int(rotated_pts[2, 0]), int(rotated_pts[2, 1])), color, 5)
    cv2.line(im, (int(rotated_pts[2, 0]), int(rotated_pts[2, 1])),
             (int(rotated_pts[3, 0]), int(rotated_pts[3, 1])), color, 5)
    cv2.line(im, (int(rotated_pts[3, 0]), int(rotated_pts[3, 1])),
             (int(rotated_pts[0, 0]), int(rotated_pts[0, 1])), color, 5)
    cv2.imwrite(path, im)


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
        cx = int(float(robndbox.find('cx').text))
        cy = int(float(robndbox.find('cy').text))
        w = int(float(robndbox.find('w').text))
        h = int(float(robndbox.find('h').text))
        angle = float(robndbox.find('angle').text)
        angle = int(-angle * 180.0 / np.pi)
        obj_struct['bbox'] = [cx, cy, h, w, angle]
        objects.append(obj_struct)
    return objects


raw_path = 'E:/jwwangchn/ICIP/bottle_UAV-BD/raw'
draw_path = 'E:/jwwangchn/ICIP/bottle_UAV-BD'
anno_path = 'E:/jwwangchn/Data/UAV-Bottle/UAV-Bottle-V3.0.0/Annotations'

for img in os.listdir(raw_path):
    img_name = img.split(".")[0]
    im = cv2.imread(os.path.join(raw_path, img))
    objects = parse_rec(os.path.join(anno_path, img_name + '.xml'))
    for object in objects:
        box = object['bbox']
        save_path = os.path.join(draw_path, img)
        draw_box(im, box, (0, 0, 255), save_path)
