function [kernel_pad, kernel_pad_fft] = pad2im(kernel, img)
[h_k,w_k,d_k] = size(kernel);
[h_i,w_i,d_i] = size(img);

kernel_pad = zeros(h_i,w_i);
kernel_pad(1:h_k, 1:w_k) = kernel(:,:);

kernel_pad_fft = fft2(kernel_pad);
kernel_pad_fft = kernel_pad_fft + 1*(abs(kernel_pad_fft)<1);
end