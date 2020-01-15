import sys
import pandas as pd
import numpy as np
import locale
from PyQt5.QtWidgets import QApplication, QMainWindow, QLabel, QFileDialog, QMessageBox, QGraphicsScene, QGraphicsPixmapItem
from PyQt5 import QtGui
from PyQt5.QtGui import QPixmap
from app import Ui_MainWindow

from PIL import Image
from tqdm import tqdm

import numpy as np
import model_v4
import torch
import torch.nn as nn
import torchvision.transforms as transforms

import numpy as np
import cv2
from ctypes import *

import dobot_control as dbot

class MainWindow(QMainWindow):
    def __init__(self, parent=None):
        #QT界面
        super(MainWindow, self).__init__(parent)
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)
        self.setAcceptDrops(True)
        self.setWindowTitle("瑕疵识别系统")
        self.ui.uploadimg.clicked.connect(self.loadimg)
        self.ui.takephoto.clicked.connect(self.takephoto)
        self.ui.closephoto.clicked.connect(self.closephoto)
        self.ui.uploadmodel.clicked.connect(self.loadmodel)
        self.ui.classify.clicked.connect(self.classify)
        self.ui.action1.clicked.connect(self.action1)
        self.ui.action2.clicked.connect(self.action2)
        self.ui.action3.clicked.connect(self.action3)
        self.ui.action4.clicked.connect(self.action4)
        self.ui.imgpath.setPlaceholderText("请读取或将图片拖至此处")
        self.imgpath = None
        self.modelpath = None
        self.model = None
        self.transform = None
        self.ui.imglabel.setStyleSheet("border:2px solid red;")
        self.photo_control = 0

    def dragEnterEvent(self, event):
        #拖拽图片，识别图片格式
        filetype = event.mimeData().text().split('.')[-1]
        if filetype in {'jpg', 'png'}:
            event.accept()
        else:
            event.ignore()

    def dropEvent(self, event):
        #拖拽图片，寻找图片地址
        filepath = event.mimeData().text()
        filename = filepath[filepath.rfind('/') + 1:]
        self.ui.imgpath.setText(filename)
        path = filepath[filepath.find(':')+4:]
        self.imgpath = path
        self.readImage(path)

    def readImage(self, path):
        #显示图片，由jpg格式转化为QPixmap格式
        jpg = QPixmap(path).scaled(self.ui.imglabel.width(), self.ui.imglabel.height())
        self.ui.imglabel.setPixmap(jpg)
        filename = path[path.rfind('/') + 1:]
        self.ui.imgpath.setText(filename)

    def loadimg(self):
        #打开图片
        path = QFileDialog.getOpenFileName(self, "打开", self.imgpath, "jpg(*.jpg)")[0]
        if not path:
            return
        self.readImage(path)
        self.imgpath = path

    def takephoto(self):
        # 摄像头拍照与显示。

        #初始化
        dll = windll.LoadLibrary("JHCap2.dll")
        dll.CameraInit(0)
        dll.CameraSetResolution(0, 0, 0, 0)
        buflen = c_int()
        width = c_int()
        height = c_int()
        dll.CameraGetImageSize(0, byref(width), byref(height))
        dll.CameraGetImageBufferSize(0, byref(buflen), 0x4)
        inbuf = create_string_buffer(buflen.value)
        #拍照功能控制，1为开启拍摄，0为关闭拍摄
        self.photo_control=1
        while 1:
            #从摄像机获取np格式的图片并循环显示
            dll.CameraQueryImage(0, inbuf, byref(buflen), 0x104)
            arr = np.frombuffer(inbuf, np.uint8)
            img = np.reshape(arr, (height.value, width.value, 3))
            img = cv2.resize(img, (self.ui.imglabel.width(), self.ui.imglabel.height()),  interpolation=cv2.INTER_AREA)
            im2 = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

            key = cv2.waitKey(60)  # change parameter according to frame rate, wait time =1000/fps
            #np格式图片转换为QImage格式
            qimg = QtGui.QImage(im2.data, im2.shape[1], im2.shape[0], im2.shape[1]*3, QtGui.QImage.Format_RGB888)
            pixmap01 = QtGui.QPixmap.fromImage(qimg)
            self.ui.imglabel.setPixmap(pixmap01)

            #关闭拍摄并保存图片
            if self.photo_control == 0:
                cv2.imwrite('1.jpg',img)
                self.imgpath='1.jpg'
                break

    def closephoto(self):
        #关闭拍摄，保存图片
        self.photo_control = 0

    def loadmodel(self):
        #加载模型
        path = QFileDialog.getOpenFileName(self, "打开", self.modelpath, "pth(*.pth)")[0]
        self.ui.modelpath.setText(path[path.rfind('/') + 1:])
        self.modelpath = path
        if not path:
            return
        self.model = torch.load(path, map_location=torch.device('cpu'))
        QMessageBox.information(self, "完成提示", "成功载入模型！", QMessageBox.Yes)
        normalize = transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
        self.transform = transforms.Compose([
            transforms.Resize((400, 400)),
            transforms.CenterCrop(384),
            transforms.ToTensor(),
            normalize,
        ])

    def classify(self):
        #分类检测
        if not self.imgpath or not self.modelpath:
            QMessageBox.warning(self, "错误警告", "未正确载入图片或模型", QMessageBox.Ok)
            return
        img = default_loader(self.imgpath)
        img = self.transform(img)
        result = test(img_tensor=img, model=self.model)
        probs = result.numpy()
        testclass = probs.argmax(axis=1)[0]
        testprob = probs[0][testclass] * 100

        classes = ['正常', '不导电', '擦花', '横条压凹', '桔皮', '漏底', '碰伤', '起坑', '凸粉', '涂层开裂', '脏点', '其他']

        if testclass > 0:
            self.ui.havexiaci.setText("有瑕疵")
        else:
            self.ui.havexiaci.setText("无瑕疵")

        self.ui.classtext.setText(str(classes[testclass]))
        self.ui.probtext.setText("%.2f" % testprob)
        if testclass > 0:
            dbot.MoveRight()
        else:
            dbot.MoveLeft()

    def action1(self):
        # 机械臂连接
        pass

    def action2(self):
        # 机械臂复位
        pass
    def action3(self):
        # 机械臂控制动作：左移
        dbot.MoveLeft()
        pass

    def action4(self):
        # 机械臂控制动作：右移
        dbot.MoveRight()
        pass

def default_loader(path):
    return Image.open(path).convert('RGB')


def test(img_tensor, model):
    model.eval()
    image_var = img_tensor.unsqueeze(0)
    with torch.no_grad():
        y_pred = model(image_var)
        smax = nn.Softmax(1)
        smax_out = smax(y_pred)

    return smax_out


if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec_())
