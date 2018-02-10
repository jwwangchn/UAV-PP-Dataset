import os
import cv2
import numpy as np
import xml.etree.ElementTree as ET


def draw_box(im, BBox, color, path):
    cx, cy, h, w, angle = BBox[0:5]
    angle = 360 - angle
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

boxes = []
#with open('BAIYUNJICHANG_Level_19_0.tif_res_0.5_232.tif.rbox','r') as f:
with open('1_Sand_000001_103.jpg.rbox','r') as f:
    line = f.readline()
    while line:
        line = line.strip("\n")
        line = line.split(' ')
        line = map(eval, line)
        boxes.append(line)
        line = f.readline()
boxes = np.array(boxes)
boxes = np.delete(boxes, 4, axis = 1)
#im = cv2.imread('BAIYUNJICHANG_Level_19_0.tif_res_0.5_232.tif')
im = cv2.imread('1_Sand_000001_103.jpg')

for box in boxes:
    draw_box(im, box, (0, 0, 255), './test.jpg')
