function res = psnr(I, K)

MSE = mean(mean((I-K).^2));
MAX1 = P
res = 10*log10(256*256/MSE);

end