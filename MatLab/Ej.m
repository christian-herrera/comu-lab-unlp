clc;
clearvars;
close all;

% Crear una instancia de la clase 'op'
fun = op();


% Importo las muestras
load('FM_STEREO_15s.mat');


% Grafica de la DEP
% X = fun.plotDEP(x, fs, 1.5e-4, 100);
% title("");


% % Filtrado de la señal
x1 = fun.filtro(x, fs, 256e3, 5);
% fun.plotDEP(x1, fs, 1.5e-4, 100);
% title("");


% % Diezmado
f_lim = 120e3;
N = ceil(fs/2/f_lim);
fs_new = fs/N;
x2 = decimate(x1, N, 'fir');
% fun.plotDEP(x2, fs_new, 1.5e-4, 100);
% title("");


% Mensaje
phi = unwrap(angle(x2));
phi_diff = diff(phi);
m = (1 / (2 * pi * 75e3)) * phi_diff * fs_new;
% fun.plotDEP(m, fs_new, 3.6e-5, 1);
% title("");


% Filtrado para quedarme con L+R
m1 = fun.filtro(m, fs_new, 15e3, 20);
fun.plotDEP(m1, fs_new, 3.6e-5, 1);
title("");


% Reproducción de la señal de mensaje
N2 = ceil(fs_new/48000);
fs_new2 = fs_new/N2;
fprintf("Nueva fs=%.2f...\n", fs_new2);
m3 = decimate(m1, N2, 'fir');

fun.plotDEP(m3, fs_new2, 7e-5, 1);
title("")




sound(m3, fs_new2);










