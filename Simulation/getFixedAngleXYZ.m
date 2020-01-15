function [ angleVec ] = getFixedAngleXYZ( rotMatrix )
%GETFIXEDANGLEXYZ ����ת����õ��̶��Ǳ�ʾ
%   �������rotationMatrix��������̬����ת������3*3����
%   �������angleVec����̬��XYZ�̶��Ǳ�ʾ���ǶȲ��û����ƣ���1*3����
    beta = atan2(-rotMatrix(3,1),sqrt(rotMatrix(1,1)*rotMatrix(1,1)+rotMatrix(2,1)*rotMatrix(2,1)));
    alpha = atan2(rotMatrix(2,1)/cos(beta),rotMatrix(1,1)/cos(beta));
    gamma = atan2(rotMatrix(3,2)/cos(beta),rotMatrix(3,3)/cos(beta));
    angleVec = [gamma, beta, alpha];    %gamma��Ӧ��X����ת��beta��Ӧ��Y����ת��alpha��Ӧ��Z����ת
end

