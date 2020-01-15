function [ transMatrix ] = my_fkine(jointVec) 
%MY_FKINE 仅适用于Dobot的正运动学变换
%   输入变量joint：关节角构成的向量，是1*5的矩阵，角度用弧度制表示
%   输出变量transMatrix：从基坐标系到工具坐标系的齐次变换矩阵，是4*4的矩阵
    d1 = 135; a2 = 135; a3 = 147;
    d = 100;
    transMatrix = zeros(4,4);
    transMatrix(1,1) = cos(jointVec(1)+jointVec(5));
    transMatrix(1,2) = -sin(jointVec(1)+jointVec(5));
    transMatrix(2,1) = sin(jointVec(1)+jointVec(5));
    transMatrix(2,2) = cos(jointVec(1)+jointVec(5));
    transMatrix(3,3) = 1;
    transMatrix(1,4) = cos(jointVec(1))*(a3*cos(jointVec(2)+jointVec(3))+a2*cos(jointVec(2)));
    transMatrix(2,4) = sin(jointVec(1))*(a3*cos(jointVec(2)+jointVec(3))+a2*cos(jointVec(2)));
    transMatrix(3,4) = a3*sin(jointVec(2)+jointVec(3))+a2*sin(jointVec(2))+d1-d;
    transMatrix(4,4) = 1;

end

