close all;
clear; clc;
%%
%��ģ
d1 = 135; a2 = 135; a3 = 147;
d = 100;
%         theta    d        a        alpha     sigma
L1 = Link([0       d1       0        0         0     ], 'modified'); %�������˵�D-H����
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
%����
%�б�ѡ��Ի��� 
[input_mode,flag1]=listdlg('liststring',{'�ؽڽ�����(��1,��2,��3,��5)','�ѿ�������(x,y,z,��)'},'listsize',[240 80],'OkString','ȷ��','CancelString','ȡ��',...  
     'promptstring','����ģʽ','name','ѡ������ģʽ','selectionmode','single');  % selectmode������2��ѡ��single��multiple
if flag1 == 1
    if input_mode == 1  %����ؽڽ�����
        inputJointCell1 = inputdlg({'������1(��)(-90~90)','��ۦ�2(��)(0~85)','С�ۦ�3(��)(-90~10)','ĩ��ִ������5(��)(-135~135)                                                     .'},'��ʼ�ؽڽ�����',1,{'0','85','-90','0'});  % ��Ĭ��ֵ
        start_theta_1 = str2double(char(inputJointCell1(1)))*pi/180;           %�Ƕ��Ʊ�ɻ�����
        start_theta_2 = str2double(char(inputJointCell1(2)))*pi/180;
        start_theta_3 = str2double(char(inputJointCell1(3)))*pi/180;
        start_theta_5 = str2double(char(inputJointCell1(4)))*pi/180;
        startJointVec = [start_theta_1, start_theta_2, start_theta_3, -(start_theta_2+start_theta_3), start_theta_5];
        
        inputJointCell2 = inputdlg({'������1(��)(-90~90)','��ۦ�2(��)(0~85)','С�ۦ�3(��)(-90~10)','ĩ��ִ������5(��)(-135~135)                                                     .'},'��ֹ�ؽڽ�����',1,{'0','85','-90','0'});  % ��Ĭ��ֵ
        end_theta_1 = str2double(char(inputJointCell2(1)))*pi/180;
        end_theta_2 = str2double(char(inputJointCell2(2)))*pi/180;
        end_theta_3 = str2double(char(inputJointCell2(3)))*pi/180;
        end_theta_5 = str2double(char(inputJointCell2(4)))*pi/180;
        endJointVec = [end_theta_1, end_theta_2, end_theta_3, -(end_theta_2+end_theta_3), end_theta_5];
        
    elseif input_mode == 2  %����ѿ�������
        inputPosCell1 = inputdlg({'x(mm)','y(mm)','z(mm)','alpha(��)ĩ��ִ��������                                                            .'},'��ʼ��������',1,{'160','0','160','0'});  % ��Ĭ��ֵ
        start_x = str2double(char(inputPosCell1(1)));
        start_y = str2double(char(inputPosCell1(2)));
        start_z = str2double(char(inputPosCell1(3)));
        start_alpha = str2double(char(inputPosCell1(4)))*pi/180;
        startPos = [start_x, start_y, start_z, start_alpha];
        
        [startJointVec, EXITFLAG] = my_ikine(startPos);
        while EXITFLAG == 0
            button=questdlg('�õ㲻�ڹ����ռ���','����','����','����');%���ݣ����⣬ѡ�Ĭ��ѡ��
            if strcmp(button,'����')
                inputPosCell1 = inputdlg({'x(mm)','y(mm)','z(mm)','alpha(��)ĩ��ִ��������                                                            .'},'��ʼ��������',1,{'160','0','160','0'});  % ��Ĭ��ֵ
                start_x = str2double(char(inputPosCell1(1)));
                start_y = str2double(char(inputPosCell1(2)));
                start_z = str2double(char(inputPosCell1(3)));
                start_alpha = str2double(char(inputPosCell1(4)))*pi/180;
                startPos = [start_x, start_y, start_z, start_alpha];
                [startJointVec, EXITFLAG] = my_ikine(startPos);
            end
        end
        
        inputPosCell2 = inputdlg({'x(mm)','y(mm)','z(mm)','alpha(��)ĩ��ִ��������                                                            .'},'�յ���������',1,{'160','0','160','0'});  % ��Ĭ��ֵ
        end_x = str2double(char(inputPosCell2(1)));
        end_y = str2double(char(inputPosCell2(2)));
        end_z = str2double(char(inputPosCell2(3)));
        end_alpha = str2double(char(inputPosCell2(4)))*pi/180;
        endPos = [end_x, end_y, end_z, end_alpha];
        
        [endJointVec, EXITFLAG] = my_ikine(endPos);
        while EXITFLAG == 0
            button=questdlg('�õ㲻�ڹ����ռ���','����','����','����');%���ݣ����⣬ѡ�Ĭ��ѡ��
            if strcmp(button,'����')
                inputPosCell2 = inputdlg({'x(mm)','y(mm)','z(mm)','alpha(��)ĩ��ִ��������                                                            .'},'�յ���������',1,{'160','0','160','0'});  % ��Ĭ��ֵ
                end_x = str2double(char(inputPosCell2(1)));
                end_y = str2double(char(inputPosCell2(2)));
                end_z = str2double(char(inputPosCell2(3)));
                end_alpha = str2double(char(inputPosCell2(4)))*pi/180;
                endPos = [end_x, end_y, end_z, end_alpha];
                [endJointVec, EXITFLAG] = my_ikine(endPos);
            end
        end        
    end
    
    [motion_mode,flag2]=listdlg('liststring',{'�ؽ��˶�ģʽ','ֱ���˶�ģʽ','�����˶�ģʽ','ʾ��ģʽ'},'listsize',[240 80],'OkString','ȷ��','CancelString','ȡ��',...  
         'promptstring','�˶�ģʽ','name','ѡ���˶�ģʽ','selectionmode','single');  % selectmode������2��ѡ��single��multiple
    if flag2 == 1
        steps = 50;
        startTransMatrix = my_fkine(startJointVec);
        endTransMatrix = my_fkine(endJointVec);
        
        if motion_mode == 1    %���ڹؽڿռ���˶��滮
            startJoint1235 = [startJointVec(1:3),startJointVec(5)];         %ǰ�����ؽڱ����͵�����ؽڱ������ǿɿصģ�
            endJoint1235 = [endJointVec(1:3),endJointVec(5)];             %���ĸ��ؽڱ�������theta_2��theta_3������
            [jointAngleProfile, jointVelProfile, jointAccProfile] = jtraj(startJoint1235, endJoint1235, steps);    %��ζ���ʽ��ֵ���õ�ǰ�����ؽڽǵ��м�ֵ�Լ����ٶȺͽǼ��ٶ�
            jointTraj = [jointAngleProfile(:,1:3), -(jointAngleProfile(:,2)+jointAngleProfile(:,3)), jointAngleProfile(:,4)];               %��ǰ�����ؽڽǵõ����ĸ��ؽڽǣ��������ؽڽǹ�ͬ���ɹؽڽ������Ĺ켣
        elseif motion_mode == 2    %ֱ���˶�
            [jointTraj, jointAngleProfile, jointVelProfile, jointAccProfile, MOTIONEXITFLAG] = lineMode(startTransMatrix, endTransMatrix, steps);
        elseif motion_mode == 3    %�����˶�
            %���������̧���߶�
            inputHeightCell = inputdlg({'̧���߶�(mm)                                                          .'},'����̧���߶�',1,{'100'});  % ��Ĭ��ֵ
            height = str2double(char(inputHeightCell(1)));
            [jointTraj, jointAngleProfile, jointVelProfile, jointAccProfile, MOTIONEXITFLAG] = jumpMode(startTransMatrix, endTransMatrix, height, steps);

            while MOTIONEXITFLAG == 0
                button=questdlg('���������ռ���','����','����','����');%���ݣ����⣬ѡ�Ĭ��ѡ��
                if strcmp(button,'����')
                    inputHeightCell = inputdlg({'̧���߶�(mm)                                                          .'},'����̧���߶�',1,{'100'});  % ��Ĭ��ֵ
                    height = str2double(char(inputHeightCell(1)));
                    [jointTraj, jointAngleProfile, jointVelProfile, jointAccProfile, MOTIONEXITFLAG] = jumpMode(startTransMatrix, endTransMatrix, height, steps);
                end
            end
        elseif motion_mode == 4    %ʾ��ģʽ
            %�����м�����
            inputNumCell = inputdlg({'�м�����                                                          .'},'�����м�����',1,{'3'});  % ��Ĭ��ֵ
            num = str2double(char(inputNumCell(1)));
            interJointMatrix = [];
            %����������м��
             if input_mode == 1  %����ؽڽ�����
                for i = 1:1:num
                    inputJointCell3 = inputdlg({'������1(��)(-90~90)','��ۦ�2(��)(0~85)','С�ۦ�3(��)(-90~10)','ĩ��ִ������5(��)(-135~135)                                                     .'},'�м�ؽڽ�����',1,{'0','85','-90','0'});  % ��Ĭ��ֵ
                    inter_theta_1 = str2double(char(inputJointCell3(1)))*pi/180;           %�Ƕ��Ʊ�ɻ�����
                    inter_theta_2 = str2double(char(inputJointCell3(2)))*pi/180;
                    inter_theta_3 = str2double(char(inputJointCell3(3)))*pi/180;
                    inter_theta_5 = str2double(char(inputJointCell3(4)))*pi/180;
                    interJointVec = [inter_theta_1, inter_theta_2, inter_theta_3, -(inter_theta_2+inter_theta_3), inter_theta_5];
                    interJointMatrix = [interJointMatrix; interJointVec];
                end
            elseif input_mode == 2  %����ѿ�������
                for i = 1:1:num
                    inputPosCell3 = inputdlg({'x(mm)','y(mm)','z(mm)','alpha(��)ĩ��ִ��������                                                            .'},'�м����������',1,{'160','0','160','0'});  % ��Ĭ��ֵ
                    inter_x = str2double(char(inputPosCell3(1)));
                    inter_y = str2double(char(inputPosCell3(2)));
                    inter_z = str2double(char(inputPosCell3(3)));
                    inter_alpha = str2double(char(inputPosCell3(4)))*pi/180;
                    interPos = [inter_x, inter_y, inter_z, inter_alpha];

                    [interJointVec, EXITFLAG] = my_ikine(interPos);
                    while EXITFLAG == 0
                        button=questdlg('�õ㲻�ڹ����ռ���','����','����','����');%���ݣ����⣬ѡ�Ĭ��ѡ��
                        if strcmp(button,'����')
                            inputPosCell3 = inputdlg({'x(mm)','y(mm)','z(mm)','alpha(��)ĩ��ִ��������                                                            .'},'�м����������',1,{'160','0','160','0'});  % ��Ĭ��ֵ
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
            %ʾ��ģʽ���ùؽڿռ�Ĺ켣�滮
            [jointTraj, jointAngleProfile, jointVelProfile, jointAccProfile] = teachMode(startJointVec, endJointVec, interJointMatrix, num, steps);
        end

    end
end
%%
%��ͼ
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
%���ƻ�е���˶�����
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
%���ƹؽڽǱ仯���ߡ����ٶ����ߡ��Ǽ��ٶ�����
figure(2);
i=1:4;
subplot(3,1,1); %�ؽڽǱ仯����
plot(jointAngleProfile(:,i),'Linewidth',1); title('�ؽڽǱ仯');  xlabel('step'); ylabel('$\theta(rad)$', 'interpreter', 'Latex', 'Rotation', 0);  
legend('������1','��ۦ�2','С�ۦ�3','ĩ��ִ������5', 'Location', 'eastoutside');    grid on;
subplot(3,1,2); %�ٶȱ仯����
plot(jointVelProfile(:,i),'Linewidth',1); title('���ٶȱ仯');  xlabel('step'); ylabel('$\dot{\theta}(rad/s)$', 'interpreter', 'Latex', 'Rotation', 0);
legend('������1','��ۦ�2','С�ۦ�3','ĩ��ִ������5', 'Location', 'eastoutside');    grid on;
subplot(3,1,3);  %���ٶȱ仯����
plot(jointAccProfile(:,i),'Linewidth',1); title('�Ǽ��ٶȱ仯');  xlabel('step'); ylabel('$\ddot{\theta}(rad/s^2)$', 'interpreter', 'Latex', 'Rotation', 0);
legend('������1','��ۦ�2','С�ۦ�3','ĩ��ִ������5', 'Location', 'eastoutside');    grid on;

%%

