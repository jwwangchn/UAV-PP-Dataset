# -*- coding: UTF-8 -*-
import os
import shutil
import re
import numpy as np  # 1. Annotation路径和图片路径


scenePath = "H:/Data/UAV/UAV-PP-V1.0.1-Beta"
annotationPath = "H:/Data/UAV/UAV-GV1-0-1 大量修改 无效/Annotations"
dstPath = "H:/Data/UAV/UAV-PP-V1.0.1-Beta/Annotations"

noAnnotationImage = open("./No-Annotation-Image.txt", "w", encoding='utf-8') # 存储没有 Annotation 的图像文件

# 2. 提取图片路径下的目录
sceneList = os.listdir(scenePath)
annotationList = os.listdir(annotationPath)

# 3. 两层for循环, 外层处理场景分类路径, 内层处理图片名, 使用图片名去annotation路径下提取文件, 并将xml文件copy到dst路径下面

firstIn = True
for sceneName in sceneList:

    ## 图像文件夹路径
    imagePath = scenePath + '/' + sceneName

    ## 在新 Annotation 文件夹中创建新目录
    newAnnotationScenePath = dstPath + '/' + sceneName
    if not os.path.exists(newAnnotationScenePath):
        os.mkdir(newAnnotationScenePath)

    ## 图像名
    imageList = os.listdir(imagePath)
    for imageName in imageList:

        ## 得到 Annotation 文件名
        annotationName = (annotationPath + '/' + imageName).replace(".jpg","") + ".xml"
        # newAnnotationSceneName = (newAnnotationScenePath + '/' + imageName).replace(".jpg", "") + ".xml"
        print("copy: ", newAnnotationScenePath, "to", annotationName)

        if os.path.exists(annotationName):
            shutil.copy(annotationName, newAnnotationScenePath)
        else:
            noAnnotationImage.write(annotationName + "\n")

noAnnotationImage.close()
    


