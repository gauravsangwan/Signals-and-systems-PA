%clearing command window and making output format compact
clc

format compact
%main body
%importing data from data.csv as data.mat
%by running this syntax in command line load("/MATLAB Drive/data/data.mat")
%or using UI interface to import anyone of them

%declaring the impulse response of the blurring system(i.e h[n] , given) 
hn = (1/16)*[1 4 6 4 1]

%making 193 samples of w 
w = 0:(2*pi/192):2*pi

%as calculated in report 
H = (1/16)*(exp(2*1i*w)+4*exp(1i*w)+6+4*exp(-1i*w)+exp(-2*1i*w))

%plotting all this information on a figure

figure;
subplot(3,1,1);
title("Plot of y[n] and x[n] ");hold on;
xlabel("n"); hold on;
plot(data.xn);hold on;plot(data.yn);legend({"x[n]","y[n]"},"location","southeast");hold on;

subplot(3,1,2);
title("Plot of h[n] ");hold on;
xlabel("n");hold on;
stem(-2:2,hn);hold on;

%plotting H(w) to get a better view of H(w) overe -pi to pi we declare a
%new variable w1
w1 = -pi:(2*pi/192):pi
HH = (1/16)*(exp(2*1i*w1)+4*exp(1i*w1)+6+4*exp(-1i*w1)+exp(-2*1i*w1))
subplot(3,1,3);
title("Plot of H(w)");hold on;
xlabel("w");hold on;
plot(w1,HH)
%converting y[n] from a column vector to row vector 
%below in the program there would many instances of using transpose because
%while doing the calculations we need to have every vector as a row vector
%It is to make every column vector a row vector. 
y = (data.yn)'
Y = dft_ga(y)
Y = Y'
%
%
% Part A denoise and then deblur
%
%
%denoise
y1 = deNoise(y)
%deblur
Y1 = dft_ga(y1)
Y1 = Y1'
Y11 = []
for k = 0:length(H)-1
    if abs(H(k+1)) < 0.5
        Y11=[Y11 0.5]
    else
        temp = (Y1(k+1))/(H(k+1))
        Y11 = [Y11 temp]
    end
end
xn1 = idft_ga(Y11)
xn1 = (xn1)'
%
%
% Part B deblur then denoise
%
%
%deblur
Y = dft_ga(y)
Y = Y'
X =[]
for k = 0:length(H)-1
    if abs(H(k+1)) < 0.5
        X=[X 0.5]
    else
        temp = (Y(k+1))/(H(k+1))
        X = [X temp]
    end
end
x1 = idft_ga(X)
%denoise
xn2 = deNoise(x1)
xn2 = (xn2)'
%plotting every processed signal for observation
figure;
subplot(2,2,1);
title("Plot of y[n] and x[n]");hold on;
xlabel("n");hold on;
plot(data.yn);hold on;plot(data.xn);legend({"y[n]","x[n]"},"location","southeast");


subplot(2,2,2);
title("Plot of x[n] and x1[n]");hold on;
xlabel("n");hold on;
plot(data.xn);hold on;plot(abs(xn1));legend({"x[n]","x1[n]"},"location","southeast");

subplot(2,2,3);
title("Plot of x[n] and x2[n]");hold on;
xlabel("n");hold on;
plot(data.xn);hold on;plot(abs(xn2));legend({"x[n]","x2[n]"},"location","southeast");

subplot(2,2,4);
title("Plot of x1[n] and x2[n]");hold on;
xlabel("n");hold on;
plot(abs(xn1));hold on;plot(abs(xn2));legend({"x1[n]","x2[n]"},"location","southeast");

%plotting x1[n] vs x2[n] on a new figure to zoom in and take screenshot for
%observation 
figure;
title("Plot of x1[n] and x2[n]");hold on;
xlabel("n");hold on;
plot(abs(xn1));hold on;plot(abs(xn2));legend({"x1[n]","x2[n]"},"location","southeast");

%Functions 
%DtFT
function [ X ] = dft_ga( x )
N=length(x);
n=0:N-1;
k=0:N-1;
W=exp((-1i*2*pi*k'*n)/N);
X=W*x';
end
%IDFT
function [ x1 ]= idft_ga( X )
N=length(X);
n=0:N-1;
k=0:N-1;
w=exp((1i*2*pi*k'*n)/N);
x1=w*X'/N;
end
%Denoise
function [yden] = deNoise(x)
%we will take average of 3 surrounding valeus (reason in report)
yden = []
l = length(x)
for i = 0:l-1
    if i == 0 
        temp = (x(i+1)+x(i+2)+x(i+3))/3
        yden = [yden temp]
    elseif i == l-1
        %temp = (x(i+1)+x(i)+x(i-1)/3)
        temp = x(i+1)
        yden = [yden temp]
    else
        temp = (x(i)+x(i+1)+x(i+2))/3
        yden = [yden temp]
    end
 
end
end

