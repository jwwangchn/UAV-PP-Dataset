# -*- coding: UTF-8 -*-
import os
import cv2
import numpy as np
import xml.etree.ElementTree as ET
from matplotlib import pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages
from xml.dom.minidom import Document


def parse_rbbox(filename):
    """ Parse a PASCAL VOC xml file """
    tree = ET.parse(filename)
    root = tree.getroot()
    objects = []
    image_size = root.find('size')
    width = int(image_size.find('width').text)
    height = int(image_size.find('height').text)
    depth = int(image_size.find('depth').text)
    segmented = int(root.find('segmented').text)
    for object in root.findall('object'):
        obj_struct = {}
        obj_struct['size'] = [width, height, depth]
        obj_struct['segmented'] = segmented
        obj_struct['name'] = object.find('name').text
        obj_struct['pose'] = object.find('pose').text
        obj_struct['truncated'] = int(object.find('truncated').text)
        obj_struct['difficult'] = int(object.find('difficult').text)
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


def parse_bbox(filename):
    """ Parse a PASCAL VOC xml file """
    tree = ET.parse(filename)
    root = tree.getroot()
    objects = []

    for object in root.findall('object'):
        obj_struct = {}
        obj_struct['name'] = object.find('name').text
        obj_struct['pose'] = object.find('pose').text
        obj_struct['truncated'] = int(object.find('truncated').text)
        obj_struct['difficult'] = int(object.find('difficult').text)
        bndbox = object.find('bndbox')
        xmin = int(float(bndbox.find('xmin').text))
        ymin = int(float(bndbox.find('ymin').text))
        xmax = int(float(bndbox.find('xmax').text))
        ymax = int(float(bndbox.find('ymax').text))

        obj_struct['bbox'] = [xmin, ymin, xmax, ymax]
        objects.append(obj_struct)
    return objects


def check_image_annotations(delete_files=False):
    """
    用于检查原始图像和标注文件的数量
    delete_files: 是否删除不匹配的文件
    :return:
    """
    categories = ['1_Sand', '2_Lawn', '3_Bush', '4_Land', '5_Step', '6_Mixture', '7_Ground', '8_Playground']
    root_dir = 'E:/jwwangchn/Data/UAV-Bottle/UAV-Bottle-V3.0.0/Categroies'

    for category in categories:
        image_path = os.path.join(root_dir, category)
        annotation_path = os.path.join(root_dir, category + '_Annotations')

        for image_name in os.listdir(image_path):
            image = os.path.join(image_path, image_name)
            annotation = os.path.join(annotation_path, image_name.split('.')[0] + '.xml')

            if not os.path.exists(annotation):
                if delete_files:
                    os.remove(image)
                print image_name


def rename_two_phase_file(root_path, phase):
    categories = ['1_Sand', '2_Lawn', '3_Bush', '4_Land', '5_Step', '6_Mixture', '7_Ground', '8_Playground']

    for category in categories:
        image_path = os.path.join(root_path, category)
        annotation_path = os.path.join(root_path, category + '_Annotations')
        image_lists = os.listdir(image_path)
        for image_name in image_lists:
            no_extension_name = image_name.split('.')[0]
            image = os.path.join(image_path, image_name)
            annotation = os.path.join(annotation_path, no_extension_name + '.xml')

            if phase == '1':
                new_image = os.path.join(image_path, no_extension_name + '_1' + '.jpg')
                new_annotation = os.path.join(annotation_path, no_extension_name + '_1' + '.xml')
            elif phase == '2':
                new_image = os.path.join(image_path, no_extension_name + '_2' + '.jpg')
                new_annotation = os.path.join(annotation_path, no_extension_name + '_2' + '.xml')
            os.rename(image, new_image)
            os.rename(annotation, new_annotation)


def num_each_category(root_path):
    categories_dict = {'1_Sand': 0, '2_Lawn': 0, '3_Bush': 0, '4_Land': 0, '5_Step': 0, '6_Mixture': 0, '7_Ground': 0,
                       '8_Playground': 0}
    for file_name in os.listdir(root_path):
        category_index = file_name.split('_')[0]
        category_name = file_name.split('_')[1]
        category = category_index + '_' + category_name
        categories_dict[category] += 1
    return categories_dict


def num_object(root_path):
    categories_dict = {'1_Sand': 0, '2_Lawn': 0, '3_Bush': 0, '4_Land': 0, '5_Step': 0, '6_Mixture': 0, '7_Ground': 0,
                       '8_Playground': 0}
    for file_name in os.listdir(root_path):
        category_index = file_name.split('_')[0]
        category_name = file_name.split('_')[1]
        category = category_index + '_' + category_name
        # print file_name
        objects = parse_rbbox(os.path.join(root_path, file_name))
        categories_dict[category] += len(objects)
    return categories_dict


def rot_pts(det):
    cx, cy, h, w, angle = det[0:5]
    lt = [cx - w / 2, cy - h / 2, 1]
    rt = [cx + w / 2, cy - h / 2, 1]
    lb = [cx - w / 2, cy + h / 2, 1]
    rb = [cx + w / 2, cy + h / 2, 1]

    pts = []

    # angle = angle * 0.45

    pts.append(lt)
    pts.append(rt)
    pts.append(rb)
    pts.append(lb)

    angle = -angle

    # if angle != 0:
    cos_cita = np.cos(np.pi / 180 * angle)
    sin_cita = np.sin(np.pi / 180 * angle)

    # else :
    #	cos_cita = 1
    #	sin_cita = 0

    M0 = np.array([[1, 0, 0], [0, 1, 0], [-cx, -cy, 1]])
    M1 = np.array([[cos_cita, sin_cita, 0], [-sin_cita, cos_cita, 0], [0, 0, 1]])
    M2 = np.array([[1, 0, 0], [0, 1, 0], [cx, cy, 1]])
    rotation_matrix = M0.dot(M1).dot(M2)

    rotated_pts = np.dot(np.array(pts), rotation_matrix)

    lt = np.argmin(rotated_pts, axis=0)
    rb = np.argmax(rotated_pts, axis=0)

    left = rotated_pts[lt[0]]
    top = rotated_pts[lt[1]]
    right = rotated_pts[rb[0]]
    bottom = rotated_pts[rb[1]]

    return left, top, right, bottom


def draw_distribution(annotation_path, save_path):
    angles = []
    areas = []
    ratios = []
    for annotation in os.listdir(annotation_path):
        annotation_file = os.path.join(annotation_path, annotation)

        objects = parse_rbbox(annotation_file)

        for object_struct in objects:
            det = object_struct['bbox']
            cx, cy, w, h, angle = det

            left, top, right, bottom = rot_pts(det)

            area = w * h
            if h > w:
                ratio = h / float(w)
            else:
                ratio = w / float(h)
            dis_left_top = np.sqrt((left[0] - top[0]) ** 2 + (left[1] + top[1]) ** 2)
            dis_right_top = np.sqrt((right[0] - top[0]) ** 2 + (right[1] + top[1]) ** 2)

            if dis_left_top > dis_right_top:
                angle = 180 * np.arctan((left[1] - top[1]) / (left[0] - top[0])) / np.pi
            elif dis_left_top < dis_right_top:
                angle = 180 * np.arctan((top[1] - right[1]) / (top[0] - right[0])) / np.pi
            elif dis_left_top == dis_right_top:
                angle = 180 * np.arctan((top[1] - right[1]) / (top[0] - right[0])) / np.pi

            # print 'angle: ', angle
            if angle < 0:
                angle = 180 + angle
            angles.append((angle))
            areas.append((area))
            ratios.append(ratio)
    np_angles = np.array(angles)
    np_areas = np.array(areas)
    np_ratios = np.array(ratios)
    # hist, bins = np.histogram(np_angles, bins = np.arange(0, 360, 10))
    fig1 = plt.figure(1)
    plt.hist(np_areas, bins=np.arange(np.min(np_areas), 4000, (4000 - np.min(np_areas)) / 30), histtype='bar',
             facecolor='dodgerblue', alpha=0.75, rwidth=0.9)
    plt.title('Size distribution')
    plt.xlabel('size')
    fig1.savefig(os.path.join(save_path, 'size_hist.pdf'), bbox_inches='tight')

    fig2 = plt.figure(2)
    plt.hist(np_angles, bins=np.arange(0, 180, 5), histtype='bar', facecolor='dodgerblue', alpha=0.75, rwidth=0.9)
    plt.title('Angle distribution')
    plt.xlabel('angle')
    fig2.savefig(os.path.join(save_path, 'angle_hist.pdf'), bbox_inches='tight')

    fig3 = plt.figure(3)
    plt.hist(np_ratios, bins=np.arange(1, 5, 4 / 30.0), histtype='bar', facecolor='dodgerblue', alpha=0.75, rwidth=0.9)
    plt.title('Ratio distribution')
    plt.xlabel('ratio')
    fig3.savefig(os.path.join(save_path, 'ratio_hist.pdf'), bbox_inches='tight')

    plt.show()


def select_image_size(annotation_path, image_path, delete_file=False):
    for annotation in os.listdir(annotation_path):
        annotation_file = os.path.join(annotation_path, annotation)
        image_file = os.path.join(image_path, annotation.split('.')[0] + '.jpg')
        objects = parse_rbbox(annotation_file)
        object_struct = objects[0]
        image_size = object_struct['size']
        if image_size[0] != 342 or image_size[1] != 342:
            print annotation.split('.')[0]
            if delete_file == True:
                os.remove(image_file)
                os.remove(annotation_file)


def coordinate_to_xy(left, top, right, bottom):
    xmin = left[0]
    xmax = right[0]
    ymin = top[0]
    ymax = bottom[0]
    w = xmax - xmin
    h = ymax - ymin
    return xmin, xmax, ymin, ymax, w, h


def write_xml(structs, image_filename, image_path, save_path):
    struct = structs[0]
    doc = Document()  # 创建DOM文档对象
    annotation = doc.createElement('annotation')
    annotation.setAttribute('verified', "no")
    doc.appendChild(annotation)

    # folder
    folder = doc.createElement('folder')
    folder_text = doc.createTextNode('JPEGImages')
    annotation.appendChild(folder)
    folder.appendChild(folder_text)

    # filename
    filename = doc.createElement('filename')
    filename_text = doc.createTextNode(image_filename)
    annotation.appendChild(filename)
    filename.appendChild(filename_text)

    # path
    path = doc.createElement('path')
    path_text = doc.createTextNode(image_path)
    annotation.appendChild(path)
    path.appendChild(path_text)

    # source
    source = doc.createElement('source')
    database = doc.createElement('database')
    database_text = doc.createTextNode('UAV-BD')
    annotation.appendChild(source)
    source.appendChild(database)
    database.appendChild(database_text)

    # size
    size = doc.createElement('size')
    width = doc.createElement('width')
    height = doc.createElement('height')
    depth = doc.createElement('depth')

    [struct_width, struct_height, struct_depth] = struct['size']
    width_text = doc.createTextNode(str(struct_width))
    height_text = doc.createTextNode(str(struct_height))
    depth_text = doc.createTextNode(str(struct_depth))

    annotation.appendChild(size)
    size.appendChild(width)
    size.appendChild(height)
    size.appendChild(depth)
    width.appendChild(width_text)
    height.appendChild(height_text)
    depth.appendChild(depth_text)

    # segmented
    segmented = doc.createElement('segmented')
    segmented_text = doc.createTextNode('0')
    annotation.appendChild(segmented)
    segmented.appendChild(segmented_text)

    # object
    for struct in structs:
        det = struct['bbox']

        left, top, right, bottom = rot_pts(det)
        struct_xmin, struct_xmax, struct_ymin, struct_ymax, struct_w, struct_h = coordinate_to_xy(left, top, right,
                                                                                                  bottom)

        object = doc.createElement('object')
        name = doc.createElement('name')
        pose = doc.createElement('pose')
        truncated = doc.createElement('truncated')
        difficult = doc.createElement('difficult')
        bndbox = doc.createElement('bndbox')
        xmin = doc.createElement('xmin')
        ymin = doc.createElement('ymin')
        xmax = doc.createElement('xmax')
        ymax = doc.createElement('ymax')
        name_text = doc.createTextNode(struct['name'])
        pose_text = doc.createTextNode(struct['pose'])
        truncated_text = doc.createTextNode(str(struct['truncated']))
        difficult_text = doc.createTextNode(str(struct['difficult']))
        bndbox_text = doc.createTextNode('bndbox')
        xmin_text = doc.createTextNode(str(int(struct_xmin)))
        ymin_text = doc.createTextNode(str(int(struct_ymin)))
        xmax_text = doc.createTextNode(str(int(struct_xmax)))
        ymax_text = doc.createTextNode(str(int(struct_ymax)))
        annotation.appendChild(object)
        object.appendChild(name)
        object.appendChild(pose)
        object.appendChild(truncated)
        object.appendChild(difficult)
        object.appendChild(bndbox)
        bndbox.appendChild(xmin)
        bndbox.appendChild(ymin)
        bndbox.appendChild(xmax)
        bndbox.appendChild(ymax)

        name.appendChild(name_text)
        pose.appendChild(pose_text)
        truncated.appendChild(truncated_text)
        difficult.appendChild(difficult_text)
        xmin.appendChild(xmin_text)
        ymin.appendChild(ymin_text)
        xmax.appendChild(xmax_text)
        ymax.appendChild(ymax_text)

    save_file = os.path.join(save_path, image_filename.split('.')[0] + '.xml')
    print save_file
    f = open(save_file, 'w')
    doc.writexml(f, indent='\t', newl='\n', addindent='\t', encoding='utf-8')
    f.close()


def rbbox_to_bbox(annotation_path, image_path, save_path):
    for annotation in os.listdir(annotation_path):
        annotation_file = os.path.join(annotation_path, annotation)
        structs = parse_rbbox(annotation_file)

        image_filename = annotation.split('.')[0] + '.jpg'
        write_xml(structs, image_filename, image_path, save_path)
    print "finish convert!"


def generate_train_test_val(annotation_path, save_path, trainval_percentage=0.8, train_percentage=0.8):
    all_annotation = []
    for annotation_file in os.listdir(annotation_path):
        file_name = annotation_file.split('.')[0]
        all_annotation.append(file_name)
    annotation_num = len(all_annotation)
    all_annotation = np.array(all_annotation)
    np.random.shuffle(all_annotation)
    trainval_num = int(annotation_num * trainval_percentage)
    train_num = int(annotation_num * trainval_percentage * train_percentage)
    val_num = trainval_num - train_num
    test_num = annotation_num - trainval_num

    trainval_list = all_annotation[0 : trainval_num - 1]
    train_list = all_annotation[0 : train_num - 1]
    val_list = all_annotation[train_num - 1 : trainval_num - 1]
    test_list = all_annotation[trainval_num -  1 : annotation_num]

    np.savetxt(os.path.join(save_path, 'trainval.txt'), trainval_list, fmt = "%s")
    np.savetxt(os.path.join(save_path, 'train.txt'), train_list, fmt = "%s")
    np.savetxt(os.path.join(save_path, 'val.txt'), val_list, fmt = "%s")
    np.savetxt(os.path.join(save_path, 'test.txt'), test_list, fmt = "%s")



if __name__ == "__main__":
    # 1. 检查图像和标注文件是否匹配
    # check_image_annotations(delete_files=False)

    # 2. 将两阶段的图像和标注文件重命名
    # rename_two_phase_file('E:/jwwangchn/Data/UAV-Bottle/UAV-Bottle-V3.1.0/Categroies/Phase1', phase = '1')

    # 3. 统计各个类别图片数量
    # object_dict = num_each_category('E:/jwwangchn/Data/UAV-Bottle/UAV-Bottle-V3.1.0/JPEGImages')
    # print object_dict
    # print "Number of objects: ", sum(object_dict.values())

    # 4. 统计各个类别中目标数量
    # object_dict = num_object('E:/jwwangchn/Data/UAV-Bottle/UAV-Bottle-V3.1.0/Annotations')
    # print object_dict
    # print "Number of objects: ", sum(object_dict.values())

    # 5. 分布图
    # annotation_path = 'E:/jwwangchn/Data/UAV-Bottle/UAV-Bottle-V3.1.0/Annotations'
    # save_path = 'E:/jwwangchn/Software/Bottle-Detection-Paper/images/'
    # draw_distribution(annotation_path=annotation_path, save_path=save_path)

    # 6. 筛选图片尺寸不是 342*342 的图片, 并删除
    # annotation_path = 'E:/jwwangchn/Data/UAV-Bottle/UAV-Bottle-V3.1.0/Annotations'
    # image_path = 'E:/jwwangchn/Data/UAV-Bottle/UAV-Bottle-V3.1.0/JPEGImages'
    # select_image_size(annotation_path, image_path, delete_file = False)

    # 7. 生成最小外接矩形框的标注文件
    # annotation_path = 'E:/jwwangchn/Data/UAV-Bottle/UAV-Bottle-V3.1.0/Annotations'
    # save_path = 'E:/jwwangchn/Data/UAV-Bottle/UAV-Bottle-V3.1.0/Annotations_bbox'
    # image_path = 'E:/jwwangchn/Data/UAV-Bottle/UAV-Bottle-V3.1.0/JPEGImages'
    #
    # rbbox_to_bbox(annotation_path, image_path, save_path)

    # 8. 生成 trainval train test val 文件
    # annotation_path = 'E:/jwwangchn/Data/UAV-Bottle/UAV-Bottle-V3.1.0/Annotations'
    # save_path = 'E:/jwwangchn/Data/UAV-Bottle/UAV-Bottle-V3.1.0/ImageSets/Main'
    # generate_train_test_val(annotation_path, save_path, 0.8, 0.8)