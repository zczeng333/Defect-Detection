function [ jointTraj, jointAngleProfile, jointVelProfile, jointAccProfile, MOTIONEXITFLAG] = jumpMode( startTransMatrix, endTransMatrix, height, steps )
%JUMPMODE ���ڵѿ�������ϵ�Ĺ켣�滮��ĩ��ִ�����˶��켣������
%   ���������startTransMatrix-��ʼ��α任����, endTransMatrix-��ֹ��α任����, height-̧���߶�,
%   steps-ÿ��ֱ�ߵĲ���
    MOTIONEXITFLAG = 1;
    tempTransMatrix1 = startTransMatrix;
    tempTransMatrix1(3,4) = tempTransMatrix1(3,4)+height;
    tempTransMatrix2 = endTransMatrix;
    tempTransMatrix2(3,4) = tempTransMatrix2(3,4)+height;
    [jointTraj1, jointAngleProfile1, jointVelProfile1, jointAccProfile1, FLAG1] = lineMode(startTransMatrix, tempTransMatrix1, steps);
    if FLAG1 == 0
        MOTIONEXITFLAG = 0;
        jointTraj = zeros(steps*3, 5);
        jointAngleProfile = [jointTraj(:,1:3),jointTraj(:,5)];      %steps*4�ľ��󣬵�1��4�зֱ��Ӧtheta_1��theta_2��theta_3��theta_5�ı仯
        jointVelProfile = zeros(steps,4);
        jointAccProfile = zeros(steps,4);        
        return;
    end
    [jointTraj2, jointAngleProfile2, jointVelProfile2, jointAccProfile2, FLAG2] = lineMode(tempTransMatrix1, tempTransMatrix2, steps);
    if FLAG2 == 0
        MOTIONEXITFLAG = 0;
        jointTraj = zeros(steps*3, 5);
        jointAngleProfile = [jointTraj(:,1:3),jointTraj(:,5)];      %steps*4�ľ��󣬵�1��4�зֱ��Ӧtheta_1��theta_2��theta_3��theta_5�ı仯
        jointVelProfile = zeros(steps,4);
        jointAccProfile = zeros(steps,4);
        return;
    end
    [jointTraj3, jointAngleProfile3, jointVelProfile3, jointAccProfile3, FLAG3] = lineMode(tempTransMatrix2, endTransMatrix, steps);
    if FLAG3 == 0
        MOTIONEXITFLAG = 0;
        jointTraj = zeros(steps*3, 5);
        jointAngleProfile = [jointTraj(:,1:3),jointTraj(:,5)];      %steps*4�ľ��󣬵�1��4�зֱ��Ӧtheta_1��theta_2��theta_3��theta_5�ı仯
        jointVelProfile = zeros(steps,4);
        jointAccProfile = zeros(steps,4);
        return;
    end
    jointTraj = [jointTraj1; jointTraj2; jointTraj3];
    jointAngleProfile = [jointAngleProfile1; jointAngleProfile2; jointAngleProfile3];
    jointVelProfile = [jointVelProfile1; jointVelProfile2; jointVelProfile3];
    jointAccProfile = [jointAccProfile1; jointAccProfile2; jointAccProfile3];
end

