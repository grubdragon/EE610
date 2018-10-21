a = imread('image.jpeg');
a = rgb2hsv(a);
a(:,:,3) = histeq(a(:,:,3))
imshow(hsv2rgb(a));