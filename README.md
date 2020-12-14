# Defect-Detection


Documentation
=============
**General Description:**

This project is a visual based defect detection and intelligent sorting system programmed with python and MATLAB

Project mainly includes four parts:
1. preprocessing part
2. InceptionV4 part
3. Simulation part
4. User Interface part

Dependencies
-------------
**Language:**  python, MATLAB

package             | version       
------------------- | --------------
*numpy*|1.18.2
*pandas*|0.0.97
*matplotlib*|3.3.3
*sklearn*|0.0
*tqdm*|-
*pytorch*|-
*PIL*|-
*skimage*|-
*pylab*|-
*PyQt5*|-

Project Architecture
-------------
```buildoutcfg
│  Document.pdf //technical documentation of this project
│  README.md    // help
│
├─InceptionV4
│      gen_label_csv.py     // generate labels for imgaines
│      main_inception_v4.py //inceptionV4 main function
│      model_v4.py          // model for inceptionV4
│      test.py              // test for model
│
├─Preprocessing
│      Denoising_Mean.py    // imagine denoising 1
│      Denoising_Median.py  //imagine denoising 2
│      Histogram.py         // histogram of imagines
│      image.jpg
│      Sharpening.py        // image sharpening
│
├─Simulation                // maniputor simulation
│      DobotManipulator.m
│      getFixedAngleXYZ.m
│      jumpMode.m
│      lineMode.m
│      my_fkine.m
│      my_ikine.m
│      teachMode.m
│
└─User Interface            // User Interface based on PyQt5
    │  app.py
    │  dobot_control.py
    │  dobot_dll_type.py
    │  model_v4.py
    │  run.py
    │
    └─venv
```