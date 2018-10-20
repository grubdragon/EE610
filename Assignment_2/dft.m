I = double(imread('lena_color_256.tif'));
I = I(:,:,1)
disp(size(I))
DFT = zeros('like',I);
[M,N] = size(I);

x = repmat([0:M-1]-(M-1)/2,N,1)';
y = repmat([0:N-1]-(N-1)/2,M,1);

x_=1;

p = 0;
for u = [0:M-1]-(M-1)/2
   y_=1;
   for v = [0:N-1]-(N-1)/2
       currsum = sum(sum(I.*exp(-1i*2*pi*(u*x/M+v*y/N))));
       DFT(x_,y_) = currsum;
       y_ = y_ + 1;
       p = p+1;
       disp(p/(M*N));
   end
   x_ = x_ + 1;
end
imshow(uint8(abs(DFT)))