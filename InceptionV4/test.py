from PIL import Image

import numpy as np
import model_v4
import torch
import torch.nn as nn
import torchvision.transforms as transforms

import sys


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


model = torch.load('model/cpu_model.pth', map_location=torch.device('cpu'))
normalize = transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
transform = transforms.Compose([
    transforms.Resize((400, 400)),
    transforms.CenterCrop(384),
    transforms.ToTensor(),
    normalize,
])

img_file = "data/pengshang.jpg"
if len(sys.argv) < 2:
    print("No image file input!")
else:
    img_file = sys.argv[1]

img = default_loader(img_file)
img = transform(img)

result = test(img_tensor=img, model=model)
probs = result.numpy()
testclass = probs.argmax(axis=1)[0]
testprob = probs[0][testclass] * 100

classes = ['正常', '不导电', '擦花', '横条压凹', '桔皮', '漏底', '碰伤', '起坑', '凸粉', '涂层开裂', '脏点', '其他']

print("class:%s, prob:%.2f" % (classes[testclass], testprob))
