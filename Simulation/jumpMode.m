function [ jointTraj, jointAngleProfile, jointVelProfile, jointAccProfile, MOTIONEXITFLAG] = jumpMode( startTransMatrix, endTransMatrix, height, steps )
%JUMPMODE 基于笛卡尔坐标系的轨迹规划，末端执行器运动轨迹是门型
%   输入变量：startTransMatrix-起始齐次变换矩阵, endTransMatrix-终止齐次变换矩阵, height-抬升高度,
%   steps-每段直线的步数
    MOTIONEXITFLAG = 1;
    tempTransMatrix1 = startTransMatrix;
    tempTransMatrix1(3,4) = tempTransMatrix1(3,4)+height;
    tempTransMatrix2 = endTransMatrix;
    tempTransMatrix2(3,4) = tempTransMatrix2(3,4)+height;
    [jointTraj1, jointAngleProfile1, jointVelProfile1, jointAccProfile1, FLAG1] = lineMode(startTransMatrix, tempTransMatrix1, steps);
    if FLAG1 == 0
        MOTIONEXITFLAG = 0;
        jointTraj = zeros(steps*3, 5);
        jointAngleProfile = [jointTraj(:,1:3),jointTraj(:,5)];      %steps*4的矩阵，第1到4列分别对应theta_1、theta_2、theta_3、theta_5的变化
        jointVelProfile = zeros(steps,4);
        jointAccProfile = zeros(steps,4);        
        return;
    end
    [jointTraj2, jointAngleProfile2, jointVelProfile2, jointAccProfile2, FLAG2] = lineMode(tempTransMatrix1, tempTransMatrix2, steps);
    if FLAG2 == 0
        MOTIONEXITFLAG = 0;
        jointTraj = zeros(steps*3, 5);
        jointAngleProfile = [jointTraj(:,1:3),jointTraj(:,5)];      %steps*4的矩阵，第1到4列分别对应theta_1、theta_2、theta_3、theta_5的变化
        jointVelProfile = zeros(steps,4);
        jointAccProfile = zeros(steps,4);
        return;
    end
    [jointTraj3, jointAngleProfile3, jointVelProfile3, jointAccProfile3, FLAG3] = lineMode(tempTransMatrix2, endTransMatrix, steps);
    if FLAG3 == 0
        MOTIONEXITFLAG = 0;
        jointTraj = zeros(steps*3, 5);
        jointAngleProfile = [jointTraj(:,1:3),jointTraj(:,5)];      %steps*4的矩阵，第1到4列分别对应theta_1、theta_2、theta_3、theta_5的变化
        jointVelProfile = zeros(steps,4);
        jointAccProfile = zeros(steps,4);
        return;
    end
    jointTraj = [jointTraj1; jointTraj2; jointTraj3];
    jointAngleProfile = [jointAngleProfile1; jointAngleProfile2; jointAngleProfile3];
    jointVelProfile = [jointVelProfile1; jointVelProfile2; jointVelProfile3];
    jointAccProfile = [jointAccProfile1; jointAccProfile2; jointAccProfile3];
end

