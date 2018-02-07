import os

category = '3_Bush'

imgDir = 'H:/Data/WHU_Bottle/RAW/' + category + '/' + 'RAW/'
annDir = 'H:/Data/WHU_Bottle/RAW/' + category + '/' + 'Annotations/'
imgLists = os.listdir(imgDir)

k = 0
for imgName in imgLists:
    k += 1
    imgPath = imgDir + imgName
    annPath = annDir + imgName.replace(".JPG","") + ".mat"
    print(imgPath, annPath)

    newImgName = category + '_' + '%06d' % k + '.jpg'
    newAnnName = category + '_' + '%06d' % k + '.mat'
    print(newImgName, newAnnName)
    newImgPath = imgDir + newImgName
    newAnnPath = annDir + newAnnName
    os.rename(imgPath, newImgPath)
    os.rename(annPath, newAnnPath)
