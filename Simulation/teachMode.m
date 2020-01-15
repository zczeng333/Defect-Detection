function [ jointTraj, jointAngleProfile, jointVelProfile, jointAccProfile ] = teachMode( startJointVec, endJointVec, interJointMatrix, num, steps )
%TEACHMODE 基于关节空间轨迹规划的示教模式
%   输入参数：startJointVec-起始关节角向量；endJointVec-终止关节角向量；interJointMatrix-示教点关节角向量组；num-示教点个数；steps-两点之间的过渡点个数
%   输出参数：jointTraj-从起始点到终止点所有中间状态的关节角向量
    startJointVec1235 = [startJointVec(1,1:3), startJointVec(1,5)];
    interJointMatrix1235 = [interJointMatrix(:,1:3), interJointMatrix(:,5)];
    endJointVec1235 = [endJointVec(1,1:3), endJointVec(1,5)];
    [jointAngleProfile, jointVelProfile, jointAccProfile] = jtraj(startJointVec1235, interJointMatrix1235(1,:), steps);    %五次多项式插值，得到前三个关节角的中间值以及角速度和角加速度
    jointTraj = [jointAngleProfile(:,1:3), -(jointAngleProfile(:,2)+jointAngleProfile(:,3)), jointAngleProfile(:,4)];
    for i = 1:1:num-1
        [Q, QD, QDD] = jtraj(interJointMatrix1235(i,:), interJointMatrix1235(i+1,:), steps);    %五次多项式插值，得到前三个关节角的中间值以及角速度和角加速度
        jointVec = [Q(:,1:3), -(Q(:,2)+Q(:,3)), Q(:,4)];
        jointTraj = [jointTraj; jointVec];
        jointAngleProfile = [jointAngleProfile; Q];
        jointVelProfile = [jointVelProfile; QD];
        jointAccProfile = [jointAccProfile; QDD];
    end
    [Q, QD, QDD] = jtraj(interJointMatrix1235(num,:), endJointVec1235, steps);
    jointVec = [Q(:,1:3), -(Q(:,2)+Q(:,3)), Q(:,4)];
    jointTraj = [jointTraj; jointVec];
    jointAngleProfile = [jointAngleProfile; Q];
    jointVelProfile = [jointVelProfile; QD];
    jointAccProfile = [jointAccProfile; QDD];
end

