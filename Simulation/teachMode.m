function [ jointTraj, jointAngleProfile, jointVelProfile, jointAccProfile ] = teachMode( startJointVec, endJointVec, interJointMatrix, num, steps )
%TEACHMODE ���ڹؽڿռ�켣�滮��ʾ��ģʽ
%   ���������startJointVec-��ʼ�ؽڽ�������endJointVec-��ֹ�ؽڽ�������interJointMatrix-ʾ�̵�ؽڽ������飻num-ʾ�̵������steps-����֮��Ĺ��ɵ����
%   ���������jointTraj-����ʼ�㵽��ֹ�������м�״̬�Ĺؽڽ�����
    startJointVec1235 = [startJointVec(1,1:3), startJointVec(1,5)];
    interJointMatrix1235 = [interJointMatrix(:,1:3), interJointMatrix(:,5)];
    endJointVec1235 = [endJointVec(1,1:3), endJointVec(1,5)];
    [jointAngleProfile, jointVelProfile, jointAccProfile] = jtraj(startJointVec1235, interJointMatrix1235(1,:), steps);    %��ζ���ʽ��ֵ���õ�ǰ�����ؽڽǵ��м�ֵ�Լ����ٶȺͽǼ��ٶ�
    jointTraj = [jointAngleProfile(:,1:3), -(jointAngleProfile(:,2)+jointAngleProfile(:,3)), jointAngleProfile(:,4)];
    for i = 1:1:num-1
        [Q, QD, QDD] = jtraj(interJointMatrix1235(i,:), interJointMatrix1235(i+1,:), steps);    %��ζ���ʽ��ֵ���õ�ǰ�����ؽڽǵ��м�ֵ�Լ����ٶȺͽǼ��ٶ�
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

