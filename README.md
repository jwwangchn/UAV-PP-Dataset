UAV-PP 数据集说明
===
数据集构建方式参见 `无人机视角人体数据集构建说明.xlsx` 文件, 请按照表格规定的方式进行数据拍摄

## 目录结构
- 一级目录: 
    1. UAV-PP 文件夹, 文件夹名包含数据集版本号。 文件夹包含原始数据和 VOC 格式数据

- 二级目录:
    1. RAM: 存放原始图像
    2. Source: 存储裁剪后图像
    3. Annotations: VOC 格式数据
    4. ImageSets: VOC 格式数据
    5. JPEGImages:  VOC 格式数据
 
- 三级目录: 主要是 RAM 和 Source 目录的讲解
    1. RAW 中存放 1920*1080 大小的原始数据
    2. Source 中存放裁剪后的 1000*1000 图像

文件夹: 1.场景 -> 2.相机角度 -> 3.飞行高度 -> 4.文件

文件名: 场景名_相机角度_飞行高度_编号.jpg

## 文件名与场景对应
有重合场景, 按照人所在位置确定
1 -> 低矮灌木丛  没有大树, 芦苇, 绿化带 人没有被树遮挡
2 -> 高大密林  有大树 人被树遮挡
3 -> 草地  大面积荒草
4 -> 水边  沙地
5 -> 水中  
6 -> 山崖  大量裸露石头
7 -> 雪地

## 数据发布

- RAW 和 Source 目录中的原始数据
- VOC 格式的数据集
- MATLAB imageLabel 工具箱标注文件转 VOC 格式文件程序


## 任务
- [ ] 整理付凯敏采集的数据, 按照数据集构建说明, 对数据进行分类整理
- [ ] 针对缺失数据, 进行大量数据采集, 每次采集至少需要两个人, 一个人负责进行表格记录, 一个人负责飞无人机 (需要对任务进行详细分配, 协同指定)
    1. (时间) - (任务)
- [ ] 采集数据和标注数据同时进行, 按照数据类别和人数进行分工 (杨老师指定)
    1. 王金旺: 
    2. 梁烽: 
- [ ] 争取在月底完成数据采集工作
