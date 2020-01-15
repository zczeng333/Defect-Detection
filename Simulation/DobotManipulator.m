close all;
clear; clc;
%%
%建模
d1 = 135; a2 = 135; a3 = 147;
d = 100;
%         theta    d        a        alpha     sigma
L1 = Link([0       d1       0        0         0     ], 'modified'); %定义连杆的D-H参数
L2 = Link([0       0        0        pi/2      0     ], 'modified');
L3 = Link([0       0        a2       0         0     ], 'modified');
L4 = Link([0       0        a3       0         0     ], 'modified');
L5 = Link([0       0        0        -pi/2     0     ], 'modified');
L1.qlim = [-pi/2, pi/2];
L2.qlim = [0, 85*pi/180];
L3.qlim = [-pi/2, 10*pi/180];
L4.qlim = [-95*pi/180, pi/2];
L5.qlim = [-3*pi/4, 3*pi/4];
Dobot = SerialLink([L1, L2, L3, L4, L5],'name','Dobot','tool',transl(0, 0, -d)); 
% Dobot.teach();
%%
%输入
%列表选择对话框 
[input_mode,flag1]=listdlg('liststring',{'关节角向量(θ1,θ2,θ3,θ5)','笛卡尔坐标(x,y,z,α)'},'listsize',[240 80],'OkString','确定','CancelString','取消',...  
     'promptstring','输入模式','name','选择输入模式','selectionmode','single');  % selectmode属性有2个选项single和multiple
if flag1 == 1
    if input_mode == 1  %输入关节角向量
        inputJointCell1 = inputdlg({'底座θ1(°)(-90~90)','大臂θ2(°)(0~85)','小臂θ3(°)(-90~10)','末端执行器θ5(°)(-135~135)                                                     .'},'起始关节角设置',1,{'0','85','-90','0'});  % 有默认值
        start_theta_1 = str2double(char(inputJointCell1(1)))*pi/180;           %角度制变成弧度制
        start_theta_2 = str2double(char(inputJointCell1(2)))*pi/180;
        start_theta_3 = str2double(char(inputJointCell1(3)))*pi/180;
        start_theta_5 = str2double(char(inputJointCell1(4)))*pi/180;
        startJointVec = [start_theta_1, start_theta_2, start_theta_3, -(start_theta_2+start_theta_3), start_theta_5];
        
        inputJointCell2 = inputdlg({'底座θ1(°)(-90~90)','大臂θ2(°)(0~85)','小臂θ3(°)(-90~10)','末端执行器θ5(°)(-135~135)                                                     .'},'终止关节角设置',1,{'0','85','-90','0'});  % 有默认值
        end_theta_1 = str2double(char(inputJointCell2(1)))*pi/180;
        end_theta_2 = str2double(char(inputJointCell2(2)))*pi/180;
        end_theta_3 = str2double(char(inputJointCell2(3)))*pi/180;
        end_theta_5 = str2double(char(inputJointCell2(4)))*pi/180;
        endJointVec = [end_theta_1, end_theta_2, end_theta_3, -(end_theta_2+end_theta_3), end_theta_5];
        
    elseif input_mode == 2  %输入笛卡尔坐标
        inputPosCell1 = inputdlg({'x(mm)','y(mm)','z(mm)','alpha(°)末端执行器朝向                                                            .'},'起始坐标设置',1,{'160','0','160','0'});  % 有默认值
        start_x = str2double(char(inputPosCell1(1)));
        start_y = str2double(char(inputPosCell1(2)));
        start_z = str2double(char(inputPosCell1(3)));
        start_alpha = str2double(char(inputPosCell1(4)))*pi/180;
        startPos = [start_x, start_y, start_z, start_alpha];
        
        [startJointVec, EXITFLAG] = my_ikine(startPos);
        while EXITFLAG == 0
            button=questdlg('该点不在工作空间内','警告','重试','重试');%内容，标题，选项，默认选项
            if strcmp(button,'重试')
                inputPosCell1 = inputdlg({'x(mm)','y(mm)','z(mm)','alpha(°)末端执行器朝向                                                            .'},'起始坐标设置',1,{'160','0','160','0'});  % 有默认值
                start_x = str2double(char(inputPosCell1(1)));
                start_y = str2double(char(inputPosCell1(2)));
                start_z = str2double(char(inputPosCell1(3)));
                start_alpha = str2double(char(inputPosCell1(4)))*pi/180;
                startPos = [start_x, start_y, start_z, start_alpha];
                [startJointVec, EXITFLAG] = my_ikine(startPos);
            end
        end
        
        inputPosCell2 = inputdlg({'x(mm)','y(mm)','z(mm)','alpha(°)末端执行器朝向                                                            .'},'终点坐标设置',1,{'160','0','160','0'});  % 有默认值
        end_x = str2double(char(inputPosCell2(1)));
        end_y = str2double(char(inputPosCell2(2)));
        end_z = str2double(char(inputPosCell2(3)));
        end_alpha = str2double(char(inputPosCell2(4)))*pi/180;
        endPos = [end_x, end_y, end_z, end_alpha];
        
        [endJointVec, EXITFLAG] = my_ikine(endPos);
        while EXITFLAG == 0
            button=questdlg('该点不在工作空间内','警告','重试','重试');%内容，标题，选项，默认选项
            if strcmp(button,'重试')
                inputPosCell2 = inputdlg({'x(mm)','y(mm)','z(mm)','alpha(°)末端执行器朝向                                                            .'},'终点坐标设置',1,{'160','0','160','0'});  % 有默认值
                end_x = str2double(char(inputPosCell2(1)));
                end_y = str2double(char(inputPosCell2(2)));
                end_z = str2double(char(inputPosCell2(3)));
                end_alpha = str2double(char(inputPosCell2(4)))*pi/180;
                endPos = [end_x, end_y, end_z, end_alpha];
                [endJointVec, EXITFLAG] = my_ikine(endPos);
            end
        end        
    end
    
    [motion_mode,flag2]=listdlg('liststring',{'关节运动模式','直线运动模式','门型运动模式','示教模式'},'listsize',[240 80],'OkString','确定','CancelString','取消',...  
         'promptstring','运动模式','name','选择运动模式','selectionmode','single');  % selectmode属性有2个选项single和multiple
    if flag2 == 1
        steps = 50;
        startTransMatrix = my_fkine(startJointVec);
        endTransMatrix = my_fkine(endJointVec);
        
        if motion_mode == 1    %基于关节空间的运动规划
            startJoint1235 = [startJointVec(1:3),startJointVec(5)];         %前三个关节变量和第五个关节变量才是可控的，
            endJoint1235 = [endJointVec(1:3),endJointVec(5)];             %第四个关节变量是由theta_2和theta_3决定的
            [jointAngleProfile, jointVelProfile, jointAccProfile] = jtraj(startJoint1235, endJoint1235, steps);    %五次多项式插值，得到前三个关节角的中间值以及角速度和角加速度
            jointTraj = [jointAngleProfile(:,1:3), -(jointAngleProfile(:,2)+jointAngleProfile(:,3)), jointAngleProfile(:,4)];               %由前三个关节角得到第四个关节角，与第五个关节角共同构成关节角向量的轨迹
        elseif motion_mode == 2    %直线运动
            [jointTraj, jointAngleProfile, jointVelProfile, jointAccProfile, MOTIONEXITFLAG] = lineMode(startTransMatrix, endTransMatrix, steps);
        elseif motion_mode == 3    %门型运动
            %需额外输入抬升高度
            inputHeightCell = inputdlg({'抬升高度(mm)                                                          .'},'设置抬升高度',1,{'100'});  % 有默认值
            height = str2double(char(inputHeightCell(1)));
            [jointTraj, jointAngleProfile, jointVelProfile, jointAccProfile, MOTIONEXITFLAG] = jumpMode(startTransMatrix, endTransMatrix, height, steps);

            while MOTIONEXITFLAG == 0
                button=questdlg('超出工作空间内','警告','重试','重试');%内容，标题，选项，默认选项
                if strcmp(button,'重试')
                    inputHeightCell = inputdlg({'抬升高度(mm)                                                          .'},'设置抬升高度',1,{'100'});  % 有默认值
                    height = str2double(char(inputHeightCell(1)));
                    [jointTraj, jointAngleProfile, jointVelProfile, jointAccProfile, MOTIONEXITFLAG] = jumpMode(startTransMatrix, endTransMatrix, height, steps);
                end
            end
        elseif motion_mode == 4    %示教模式
            %输入中间点个数
            inputNumCell = inputdlg({'中间点个数                                                          .'},'设置中间点个数',1,{'3'});  % 有默认值
            num = str2double(char(inputNumCell(1)));
            interJointMatrix = [];
            %需额外输入中间点
             if input_mode == 1  %输入关节角向量
                for i = 1:1:num
                    inputJointCell3 = inputdlg({'底座θ1(°)(-90~90)','大臂θ2(°)(0~85)','小臂θ3(°)(-90~10)','末端执行器θ5(°)(-135~135)                                                     .'},'中间关节角设置',1,{'0','85','-90','0'});  % 有默认值
                    inter_theta_1 = str2double(char(inputJointCell3(1)))*pi/180;           %角度制变成弧度制
                    inter_theta_2 = str2double(char(inputJointCell3(2)))*pi/180;
                    inter_theta_3 = str2double(char(inputJointCell3(3)))*pi/180;
                    inter_theta_5 = str2double(char(inputJointCell3(4)))*pi/180;
                    interJointVec = [inter_theta_1, inter_theta_2, inter_theta_3, -(inter_theta_2+inter_theta_3), inter_theta_5];
                    interJointMatrix = [interJointMatrix; interJointVec];
                end
            elseif input_mode == 2  %输入笛卡尔坐标
                for i = 1:1:num
                    inputPosCell3 = inputdlg({'x(mm)','y(mm)','z(mm)','alpha(°)末端执行器朝向                                                            .'},'中间点坐标设置',1,{'160','0','160','0'});  % 有默认值
                    inter_x = str2double(char(inputPosCell3(1)));
                    inter_y = str2double(char(inputPosCell3(2)));
                    inter_z = str2double(char(inputPosCell3(3)));
                    inter_alpha = str2double(char(inputPosCell3(4)))*pi/180;
                    interPos = [inter_x, inter_y, inter_z, inter_alpha];

                    [interJointVec, EXITFLAG] = my_ikine(interPos);
                    while EXITFLAG == 0
                        button=questdlg('该点不在工作空间内','警告','重试','重试');%内容，标题，选项，默认选项
                        if strcmp(button,'重试')
                            inputPosCell3 = inputdlg({'x(mm)','y(mm)','z(mm)','alpha(°)末端执行器朝向                                                            .'},'中间点坐标设置',1,{'160','0','160','0'});  % 有默认值
                            inter_x = str2double(char(inputPosCell3(1)));
                            inter_y = str2double(char(inputPosCell3(2)));
                            inter_z = str2double(char(inputPosCell3(3)));
                            inter_alpha = str2double(char(inputPosCell3(4)))*pi/180;
                            interPos = [inter_x, inter_y, inter_z, inter_alpha];
                            [interJointVec, EXITFLAG] = my_ikine(interPos);
                        end
                    end
                    interJointMatrix = [interJointMatrix; interJointVec];
                end
             end
            %示教模式采用关节空间的轨迹规划
            [jointTraj, jointAngleProfile, jointVelProfile, jointAccProfile] = teachMode(startJointVec, endJointVec, interJointMatrix, num, steps);
        end

    end
end
%%
%绘图
wspace = [-500, 500, -500, 500, -200, 600];
n = length(jointTraj);
XYZTraj = [];
for j = 1:1:n
    tempTransMatrix = my_fkine(jointTraj(j,:));
    tempXYZ = tempTransMatrix(1:3,4)';
    XYZTraj = [XYZTraj; tempXYZ];
end
x = XYZTraj(:,1);
y = XYZTraj(:,2);
z = XYZTraj(:,3);
%绘制机械臂运动过程
figure(1);
grid on
% while 1
    for j = 1:1:n-1
        Dobot.plot(jointTraj(j,:), 'workspace', wspace);
        hold on
        plot3(x(j:j+1,:),y(j:j+1,:),z(j:j+1,:),'b','LineWidth',2);
    end
    Dobot.plot(jointTraj(n,:), 'workspace', wspace);
    for j = n-1:-1:1
        Dobot.plot(jointTraj(j,:), 'workspace', wspace);
        hold on
        plot3(x(j+1:j,:),y(j+1:j,:),z(j+1:j,:),'b','LineWidth',2);
    end
    Dobot.plot(jointTraj(1,:), 'workspace', wspace);
% end
%绘制关节角变化曲线、角速度曲线、角加速度曲线
figure(2);
i=1:4;
subplot(3,1,1); %关节角变化曲线
plot(jointAngleProfile(:,i),'Linewidth',1); title('关节角变化');  xlabel('step'); ylabel('$\theta(rad)$', 'interpreter', 'Latex', 'Rotation', 0);  
legend('底座θ1','大臂θ2','小臂θ3','末端执行器θ5', 'Location', 'eastoutside');    grid on;
subplot(3,1,2); %速度变化曲线
plot(jointVelProfile(:,i),'Linewidth',1); title('角速度变化');  xlabel('step'); ylabel('$\dot{\theta}(rad/s)$', 'interpreter', 'Latex', 'Rotation', 0);
legend('底座θ1','大臂θ2','小臂θ3','末端执行器θ5', 'Location', 'eastoutside');    grid on;
subplot(3,1,3);  %加速度变化曲线
plot(jointAccProfile(:,i),'Linewidth',1); title('角加速度变化');  xlabel('step'); ylabel('$\ddot{\theta}(rad/s^2)$', 'interpreter', 'Latex', 'Rotation', 0);
legend('底座θ1','大臂θ2','小臂θ3','末端执行器θ5', 'Location', 'eastoutside');    grid on;

%%

