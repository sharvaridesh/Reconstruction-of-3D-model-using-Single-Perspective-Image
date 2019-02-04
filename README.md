# Reconstruction-of-3D-model-using-Single-Perspective-Image

This project focuses on improving the implementation of the paper “single view metrology” (Criminisi, Reid and Zisserman, ICCV99) in Project01. It substitutes the manual annotation of vanishing points with a detection algorithm based on a line segment detector and the RANSAC algorithm.

## TASKS

Basically, this project includes the following 4 subtasks:
### Image acquisition
Here, we took an image of a box with 3-point perspective. The image is shown below:

![](https://github.com/sharvaridesh/Reconstruction-of-3D-model-using-Single-Perspective-Image/blob/master/results/original%20image.jpeg) |
|:--:|
|*Original Image*|

### Computing Vanishing points
- The vanishing point is an abstract point on an image plane where the parallel lines in the world intersect.
- For a 3-point perspective image there will be 3 vanishing points one along each direction i.e on the left, right and the bottom.
- Firstly, we used the canny edge detector and Hough transform to implement the LSD and RANSAC algorithms (shown below) and using that we found out the edge lines of the box .These edge lines for each of the X, Y and Z directions, as illustrated by the lines in red. Then by using the direct command imtool in MATLAB we got the co-ordinates of the edge points.

![](https://github.com/sharvaridesh/Reconstruction-of-3D-model-using-Single-Perspective-Image/blob/master/results/canny_edge_detection.PNG) |
|:--:|
|*Image after Canny Edge Detection*|

![](https://github.com/sharvaridesh/Reconstruction-of-3D-model-using-Single-Perspective-Image/blob/master/results/line%20segment%20detector.PNG) |
|:--:|
|*Line Segment Detection*|

- Now to compute the vanishing point, first we specified the end points in homogeneous co-ordinates as e=[x,y,w] and considered w=1. Then we calculated the cross product of two endpoints to get the vectors representing the lines.
- Once we have the lines, by taking the cross product of any two lines in each direction we obtain the vector representing their points of intersection and hence we get the vanishing points for the 3-point perspective image. [1]

### Computing the projection matrix and homograph matrix
- The projection matrix is a 3X4 matrix which is used to map the 2D points in an image from a 3D point in the world.
- Since we have the vanishing points it is easy to compute the projection matrix but we also have to find the scaling factor as they compute the columns of the projection matrix.
- We can select a world origin co-ordinate and use it to find the distance till the reference points (ref_x, ref_y, ref_z) for each direction in pixels. The scaling factor has a formula where the vanishing point is left divided by the difference between the reference points and the world origin co-ordinates and then the entire term is divided with the distance. For ex: a=(v\(ref-w0))/dist;
- Now after getting the scaling factors for each axis, we can get the projection matrix by multiplying it with the vanishing points and P(4) will be the world co-ordinates. [2]
- The homoraphy matrix is a 3X3 transformation matrix which is used to map the points of one image on the corresponding points of another image.
- The homography matrix (H) corresponds to each of the normal planes (ie. XY, YZ, XZ). This can be done (for Hxy) by taking the 1st, 2nd and 4th column of the projection matrix. Similarly, Hyz and Hxz are calculated.[2]

![](https://github.com/sharvaridesh/Reconstruction-of-3D-model-using-Single-Perspective-Image/blob/master/results/reference%20points.PNG) |
|:--:|
|*Reference Points Calculation*|

### Computing the texture maps for XY, YZ and XZ planes respectively
- Texture mapping originally referred to a method that simply wrapped and mapped pixels from a texture to a 3D surface. 
- In this context, this is done by transforming the original image using the Homography matrix computed above i.e Hxy, Hyz and Hxz. The following output images were obtained:

![](https://github.com/sharvaridesh/Reconstruction-of-3D-model-using-Single-Perspective-Image/blob/master/results/XY%20texture%20map.PNG) |
|:--:|
|*XY Plane*|

![](https://github.com/sharvaridesh/Reconstruction-of-3D-model-using-Single-Perspective-Image/blob/master/results/YZ%20texture%20map.PNG) |
|:--:|
|*YZ Plane*|

![](https://github.com/sharvaridesh/Reconstruction-of-3D-model-using-Single-Perspective-Image/blob/master/results/XZ%20texture%20map.PNG) |
|:--:|
|*XZ Plane*|

![](https://github.com/sharvaridesh/Reconstruction-of-3D-model-using-Single-Perspective-Image/blob/master/results/single%20perspective%20images.jpg) |
|:--:|
|*Cropped Single Perspective Images*|

### Visualizing the reconstructed 3D model
- Blender software is used to construct a 3D model of the image using the obtained texture maps of the image and their 3D coordinates.

![](https://github.com/sharvaridesh/Reconstruction-of-3D-model-using-Single-Perspective-Image/blob/master/results/rendered%20image.PNG) |
|:--:|
|*Rendered Reconstructed 3D Model*|
