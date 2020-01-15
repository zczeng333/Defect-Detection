function [ jointVec, EXITFLAG] = my_ikine( posVec )
%MY_IKINE ��������Dobot�����˶�ѧ
%   �������posVec��ĩ��ִ�������λ���ڻ�����ϵ������(x,y,z,alpha)����1*4�ľ��󣬳��ȵ�λ��mm���ǶȲ��û�����
%   �������EXITFLAG�����˶�ѧ��Ĵ��������ǣ���EXIT = 0��˵���޽⣬��EXIT = 1˵�������
%   �������jointVec�����ؽڽǹ��ɵ���������1*5�ľ��󣬽ǶȲ��û����Ʊ�ʾ
    d1 = 135; a2 = 135; a3 = 147;
    d = 100;
    epsilon = 0.01;     %�������������
    px = posVec(1);
    py = posVec(2);
    pz = posVec(3)+d;
    alpha = posVec(4);
    theta_1 = atan2(py,px);
    theta_5 = alpha-theta_1;
    cosValue = (px*px+py*py+(pz-d1)*(pz-d1)-a2*a2-a3*a3)/(2*a2*a3);
    if abs(cosValue) > 1 || abs(theta_5) > 3*pi/4+epsilon
        EXITFLAG = 0;
        jointVec = zeros(1,5);
        return;
    else
        theta_3 = -acos((px*px+py*py+(pz-d1)*(pz-d1)-a2*a2-a3*a3)/(2*a2*a3));
        if theta_3 < -pi/2-epsilon          %theta_3��[-pi/2,10*pi/180]�ķ�Χ֮�⣬�޽�
            EXITFLAG = 0;
            jointVec = zeros(1,5);
            return;
        else
            phi = atan2(a3*sin(theta_3),a3*cos(theta_3)+a2);
            theta_2 = asin((pz-d1)/(sqrt(a2*a2+a3*a3+2*a2*a3*cos(theta_3))))-phi;
            if theta_2 >= -epsilon && theta_2 <= 85*pi/180+epsilon
                EXITFLAG = 1;
                theta_4 = -(theta_2+theta_3);
                jointVec = [theta_1, theta_2, theta_3, theta_4, theta_5];
            else
                theta_3 = -theta_3;
                if theta_3 > 10*pi/180+epsilon  %theta_3��[-pi/2,10*pi/180]�ķ�Χ֮�⣬�޽�
                    EXITFLAG = 0;
                    jointVec = zeros(1,5);
                    return;
                else
                    phi = atan2(a3*sin(theta_3),a3*cos(theta_3)+a2);
                    theta_2 = asin((pz-d1)/(sqrt(a2*a2+a3*a3+2*a2*a3*cos(theta_3))))-phi;
                    if theta_2 >= -epsilon && theta_2 <= 85*pi/180+epsilon
                        EXITFLAG = 1;
                        theta_4 = -(theta_2+theta_3);
                        jointVec = [theta_1, theta_2, theta_3, theta_4, theta_5];
                    else
                        EXITFLAG = 0;
                        jointVec = zeros(1,5);
                        return;
                    end
                end
            end
        end      
    end
end

