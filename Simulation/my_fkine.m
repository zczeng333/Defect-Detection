function [ transMatrix ] = my_fkine(jointVec) 
%MY_FKINE ��������Dobot�����˶�ѧ�任
%   �������joint���ؽڽǹ��ɵ���������1*5�ľ��󣬽Ƕ��û����Ʊ�ʾ
%   �������transMatrix���ӻ�����ϵ����������ϵ����α任������4*4�ľ���
    d1 = 135; a2 = 135; a3 = 147;
    d = 100;
    transMatrix = zeros(4,4);
    transMatrix(1,1) = cos(jointVec(1)+jointVec(5));
    transMatrix(1,2) = -sin(jointVec(1)+jointVec(5));
    transMatrix(2,1) = sin(jointVec(1)+jointVec(5));
    transMatrix(2,2) = cos(jointVec(1)+jointVec(5));
    transMatrix(3,3) = 1;
    transMatrix(1,4) = cos(jointVec(1))*(a3*cos(jointVec(2)+jointVec(3))+a2*cos(jointVec(2)));
    transMatrix(2,4) = sin(jointVec(1))*(a3*cos(jointVec(2)+jointVec(3))+a2*cos(jointVec(2)));
    transMatrix(3,4) = a3*sin(jointVec(2)+jointVec(3))+a2*sin(jointVec(2))+d1-d;
    transMatrix(4,4) = 1;

end

