function [ jointTraj, jointAngleProfile, jointVelProfile, jointAccProfile, MOTIONEXITFLAG ] = lineMode( startTransMatrix, endTransMatrix, steps)
%LINEMODE ���ڵѿ�������ϵ�Ĺ켣�滮��ĩ��ִ������ֱ���˶�
%   ���������startTransMatrix����ʼλ�õ���α任����endTransMatrix���յ�λ�õ���α任����steps���˶��������켣�м����steps-2
%   ���������jointTraj���м�λ�˶�Ӧ�Ĺؽڽ������飬�൱�ڹؽڽ������ı仯�켣
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
        jointAngleProfile = [jointTraj(:,1:3),jointTraj(:,5)];      %steps*4�ľ��󣬵�1��4�зֱ��Ӧtheta_1��theta_2��theta_3��theta_5�ı仯
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
            jointAngleProfile = [jointTraj(:,1:3),jointTraj(:,5)];      %steps*4�ľ��󣬵�1��4�зֱ��Ӧtheta_1��theta_2��theta_3��theta_5�ı仯
            jointVelProfile = zeros(steps,4);
            jointAccProfile = zeros(steps,4);
            return;
        end
        jointTraj = [jointTraj; tempJointVec];
    end
    jointAngleProfile = [jointTraj(:,1:3),jointTraj(:,5)];      %steps*4�ľ��󣬵�1��4�зֱ��Ӧtheta_1��theta_2��theta_3��theta_5�ı仯
    jointVelProfile = zeros(steps,4);
    jointAccProfile = zeros(steps,4);
    for i=1:steps-1                  %�ؽڽǲ��ֵ����ؽ��ٶ�
     jointVelProfile(i+1,:) = jointAngleProfile(i+1,:)-jointAngleProfile(i,:);
    end
    for i=1:steps-1                  %�ؽ��ٶȲ��ֵ����ؽڼ��ٶ�
     jointAccProfile(i+1,:) = jointVelProfile(i+1,:)-jointVelProfile(i,:);
    end
end

