function out = circle_gen(h_i, r)
N = h_i;
R = floor(r * N/sqrt(2));
ii = abs(floor((1:N) - N/2));
out = hypot(ii',ii) <= R;