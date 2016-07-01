% Traverse And Network Adjustment .
% Distance observation equation
% Angle observation equation
format long;
clc
clear

data1 = xlsread('distance.xlsx');
data2 = xlsread('angles_and_points.xlsx');
cord = xlsread('coordinates.xlsx');
X=zeros(2.*size(cord,1),1);
xx=[];
Iter = input('Enter Iteration : ');
for ite =1:Iter
    A1 =zeros(size(data1,1),2*size(cord,1));
    A2 = zeros(size(data2,1),2*size(cord,1));
 Q1 = []; 
 Q2 = [];
 
% Distance observation equation
 
 for i = 1:size(data1,1)
     fpnum = data1(i,1);
     spnum = data1(i,2);
     fpx = cord(fpnum,1);
     fpy = cord(fpnum,2);
     spx = cord(spnum,1);
     spy = cord(spnum,2);
     
     length = data1(i,3);
     IJ = sqrt((fpx-spx).^2 +(fpy-spy).^2);
	 a = (fpx-spx)./IJ;
	 b = (fpy-spy)./IJ;
	 c = (spx-fpx)./IJ;
	 d =  (spy-fpy)./IJ;
	 f = length - IJ;
     A1(i,(fpnum.*2-1)) =a;
     A1(i,(fpnum.*2)) =b;
     A1(i,(spnum.*2-1)) =c;
     A1(i,(spnum.*2)) =d;
     Q1 = [Q1;f];
     
     
     
     
     
     
     
 end
 
 % Angle observation equation
 
 for j =1:size(data2,1)
     fpnum = data2(j,1);
     spnum = data2(j,3);
     mpnum = data2(j,2);
     fpx = cord(fpnum,1);
     fpy = cord(fpnum,2);
     spx = cord(spnum,1);
     spy = cord(spnum,2);
     mpx = cord(mpnum,1);
     mpy = cord(mpnum,2);
     MF = sqrt((fpx-mpx).^2 +(fpy-mpy).^2);
     MS = sqrt((spx-mpx).^2 +(spy-mpy).^2);
     b = (fpx-mpx)./MF;
	 a = (fpy-mpy)./MF;
	 d = (spx-mpx)./MS;
	 c =  (spy-mpy)./MS;
     e = ((fpy-mpy)./MF -(spy-mpy)./MS);
     g = ((mpx-fpx)./MF-(mpy-spy)./MS);
     th1 =dms2degrees([data2(j,4),data2(j,5),data2(j,6)]);
     th2 =atand((spx-mpx)/(spy-mpy))-atand((fpx-mpx)/(fpy-mpy));
     f2=th1-th2;
     A2(j,(fpnum.*2-1)) =a;
     A2(j,(fpnum.*2)) =b;
     A2(j,(spnum.*2-1)) =c;
     A2(j,(spnum.*2)) =d;
     A2(j,(mpnum.*2-1)) =e;
     A2(j,(mpnum.*2)) =g;
     Q2 =[Q2;f2];
     
     
     
     
 end
 A =[A1;A2];
 Q =[Q1;Q2];
 
  X =inv(A' * A) * (A' * Q);
  cord = cord +vec2mat(X,2);
  disp(['Iteration : ',num2str(ite),'   And   Standard Deviation : ',num2str(sqrt(sum(X.^2)/(2.*size(cord,1))))] );

 end
disp(['Standard Deviation : ',num2str(sqrt(sum(X.^2)/(2.*size(cord,1))))]);
disp(['Redundancies : ',num2str(size(A,1)-size(cord,1))]);
xlswrite('Corrected.xlsx',cord);
disp('Data Saved To Corrected.xlsx');