im=imread('cv.jpeg');
imtool(im);

figure(1)
imshow(im)
%Convert the image to Grayscale
I=rgb2gray(im);
figure(2),
imshow(I);
title('Grayscale Image');

%Edge Detection
BW=edge(I,'canny',0.3,4.5);
figure(3)
imshow(BW);
title('Edge Detection');

%Hough Transform
[H,theta,rho] = hough(BW);
figure(4)
imshow(imadjust(mat2gray(H)),[],'XData',theta,'YData',rho,'InitialMagnification','fit');
xlabel('\theta (degrees)')
ylabel('\rho');
% Finding the Hough peaks (number of peaks is set to 10)
P = houghpeaks(H,9,'threshold',ceil(0.3*max(H(:))));
x = theta(P(:,2));
y = rho(P(:,1));
figure(5)
plot(x,y,'s','color','black');
%Fill the gaps of Edges and set the Minimum length of a line
lines = houghlines(BW,theta,rho,P,'FillGap',100,'MinLength',50);
figure(6) 
imshow(im)
hold on
max_len = 0;
for k = 1:length(lines)
xy = [lines(k).point1; lines(k).point2];
plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','red');
% Plot beginnings and ends of lines
plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','green');
end

%Edge coordinates using image toolbox of MATLAB
c1 =[38,180]; c2 =[50,301]; c3 =[409,283]; c4 =[414,418];
c5 =[550,169]; c6=[550,296], c7 =[199,82];

%Homogeneous Edge Coordinates
e1 =[38,180,1]; e2 =[50,301,1]; e3 =[409,283,1]; e4 =[414,418,1];
e5 =[550,169,1]; e6=[550,296,1], e7 =[199,82,1];

%Homogenous coordinate vector representing the line as the cross product of two endpoints
l2 = cross(e3,e4); l3 = cross(e5,e6);
l4 = cross(e2,e4); l5 = cross(e1,e3); l6 = cross(e5,e7);
l7 = cross(e4,e6);l8=cross(e3,e5); l9=cross(e1,e7);


%Intersection point of lines
v1=cross(l8,l9);
v2=cross(l5,l6);
v3=cross(l2,l3);

%Vanishing points in image-coordinates
v1s=v1/v1(3);
v2s=v2/v2(3);
v3s=v3/v3(3);
 
%World Origin Coordinates
w0 = [409 287 1];

%Defining reference point
ref_x = e5;
ref_y = e1; 
ref_z = e4;

%Distance in pixels between w0 and the reference points
ref_x_dis = pdist2(w0, ref_x, 'Euclidean');
ref_y_dis = pdist2(w0, ref_y, 'Euclidean');
ref_z_dis = pdist2(w0, ref_z, 'Euclidean');

%Scaling Factors
a_x=(v1s\(ref_x - w0))/ref_x_dis;   
a_y=(v2s\(ref_y - w0))/ref_y_dis;
a_z=(v3s\(ref_z - w0))/ref_z_dis;

%Projection Matrix
H=[(v1s*a_x)' (v2s*a_y)' (v3s*a_z)' (w0)'];

%Homography Matrix
Hxy=[(v1s*a_x)' (v2s*a_y)' w0'];
Hyz=[(v2s*a_y)' (v3s*a_z)' w0'];
Hxz=[(v1s*a_x)' (v3s*a_z)' w0'];

figure(7)
imshow(im)
line([c5(1) c3(1)], [c5(2) c3(2)],'color','red','linewidth',2.5);
line([c3(1) c1(1)], [c3(2) c1(2)],'color','red','linewidth',2.5);
line([c4(1) c3(1)], [c4(2) c3(2)],'color','red','linewidth',2.5);
text(413,202, '181.320px','color','green');
text(237,219, '385.0325px','color','green');
text(428,342, '135.092px','color','green');
text(559,159, 'X');
text(19,167, 'Y');
text(418,431, 'Z');
text(402,259, 'O'); 

%Texture MApping
A1= transpose([Hxy])  
t1 = projective2d(A1);
imOut1 = imwarp(im,t1);
figure(8)
imshow(imOut1)
A2 = transpose([Hyz])  
t2 = projective2d(A2);
imOut2 = imwarp(im,t2);
figure(9)
imshow(imOut2)
A3 = transpose([Hxz])  
t3 = projective2d(A3);
imOut3 = imwarp(im,t3);
figure(10)
imshow(imOut3)
