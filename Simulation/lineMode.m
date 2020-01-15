function [ jointTraj, jointAngleProfile, jointVelProfile, jointAccProfile, MOTIONEXITFLAG ] = lineMode( startTransMatrix, endTransMatrix, steps)
%LINEMODE 基于笛卡尔坐标系的轨迹规划，末端执行器沿直线运动
%   输入变量：startTransMatrix是起始位置的齐次变换矩阵，endTransMatrix是终点位置的齐次变换矩阵，steps是运动步数，轨迹中间点有steps-2
%   输出变量：jointTraj是中间位姿对应的关节角向量组，相当于关节角向量的变化轨迹
    MOTIONEXITFLAG = 1;
    startRotMatrix = startTransMatrix(1:3,1:3);
    endRotMatrix = endTransMatrix(1:3,1:3);
    startXYZ = getFixedAngleXYZ(startRotMatrix);
    endXYZ = getFixedAngleXYZ(endRotMatrix);
    start_alpha = startXYZ(3);
    end_alpha = endXYZ(3);
    startPos = [startTransMatrix(1:3,4)',start_alpha];
    endPos = [endTransMatrix(1:3,4)',end_alpha];
    dPos = (endPos-startPos)/(steps-1);
    posTraj = startPos;
    for k = 1:1:steps-1
        posTraj = [posTraj; startPos+k*dPos];
    end
    [tempJointVec, EXITFLAG] = my_ikine(posTraj(1,:));
    if EXITFLAG == 0
        MOTIONEXITFLAG = 0;
        jointTraj = zeros(steps, 5);
        jointAngleProfile = [jointTraj(:,1:3),jointTraj(:,5)];      %steps*4的矩阵，第1到4列分别对应theta_1、theta_2、theta_3、theta_5的变化
        jointVelProfile = zeros(steps,4);
        jointAccProfile = zeros(steps,4);
        return;
    end
        
    jointTraj = tempJointVec;
    for k = 2:1:steps
        [tempJointVec, EXITFLAG] = my_ikine(posTraj(k,:));
        if EXITFLAG == 0
            MOTIONEXITFLAG = 0;
            jointTraj = zeros(steps, 5);
            jointAngleProfile = [jointTraj(:,1:3),jointTraj(:,5)];      %steps*4的矩阵，第1到4列分别对应theta_1、theta_2、theta_3、theta_5的变化
            jointVelProfile = zeros(steps,4);
            jointAccProfile = zeros(steps,4);
            return;
        end
        jointTraj = [jointTraj; tempJointVec];
    end
    jointAngleProfile = [jointTraj(:,1:3),jointTraj(:,5)];      %steps*4的矩阵，第1到4列分别对应theta_1、theta_2、theta_3、theta_5的变化
    jointVelProfile = zeros(steps,4);
    jointAccProfile = zeros(steps,4);
    for i=1:steps-1                  %关节角差分值代替关节速度
     jointVelProfile(i+1,:) = jointAngleProfile(i+1,:)-jointAngleProfile(i,:);
    end
    for i=1:steps-1                  %关节速度差分值代替关节加速度
     jointAccProfile(i+1,:) = jointVelProfile(i+1,:)-jointVelProfile(i,:);
    end
end

