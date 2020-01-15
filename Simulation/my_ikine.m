function [ jointVec, EXITFLAG] = my_ikine( posVec )
%MY_IKINE 仅适用于Dobot的逆运动学
%   输入变量posVec：末端执行器尖端位置在基坐标系的描述(x,y,z,alpha)，是1*4的矩阵，长度单位是mm，角度采用弧度制
%   输出变量EXITFLAG：逆运动学解的存在情况标记，若EXIT = 0，说明无解，若EXIT = 1说明解存在
%   输出变量jointVec：各关节角构成的向量，是1*5的矩阵，角度采用弧度制表示
    d1 = 135; a2 = 135; a3 = 147;
    d = 100;
    epsilon = 0.01;     %计算误差容许限
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
        if theta_3 < -pi/2-epsilon          %theta_3在[-pi/2,10*pi/180]的范围之外，无解
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
                if theta_3 > 10*pi/180+epsilon  %theta_3在[-pi/2,10*pi/180]的范围之外，无解
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

