function [ angleVec ] = getFixedAngleXYZ( rotMatrix )
%GETFIXEDANGLEXYZ 由旋转矩阵得到固定角表示
%   输入变量rotationMatrix：描述姿态的旋转矩阵，是3*3矩阵
%   输出变量angleVec：姿态的XYZ固定角表示，角度采用弧度制，是1*3矩阵
    beta = atan2(-rotMatrix(3,1),sqrt(rotMatrix(1,1)*rotMatrix(1,1)+rotMatrix(2,1)*rotMatrix(2,1)));
    alpha = atan2(rotMatrix(2,1)/cos(beta),rotMatrix(1,1)/cos(beta));
    gamma = atan2(rotMatrix(3,2)/cos(beta),rotMatrix(3,3)/cos(beta));
    angleVec = [gamma, beta, alpha];    %gamma对应绕X轴旋转，beta对应绕Y轴旋转，alpha对应绕Z轴旋转
end

