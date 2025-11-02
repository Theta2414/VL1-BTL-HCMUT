tic
clc, clearvars, close all
syms x;

eq = 1.5967e+08 + (2.2180e+05)*x - 1/2*9.81*x^2 == 0;

S = round(solve(eq),2);
toc