clc;
clearvars;
close all;

%% Importo las muestras
load('FM_STEREO_15s.mat');


%% Parametros
B1 = 256e3;
N1 = 9;
B2 = 15e3;
N2 = 5;

%% Obtengo los Valores ya computados
[z_out, z_N2, z_B2, z_dis, y_N1, y_B1] = FM_DEMOD_HerreraChristian(x, B1, N1, B2, N2, fs);


%% Plots
plotDEP(x, fs, -0.5e7, 11e7, 100, 0);
title("DEP de x[n]");

plotDEP(y_B1, fs, -0.5e7, 11e7, 100, 0);
title("DEP de x[n] Filtrada");

plotDEP(y_N1, fs/N1, -1e5, 13e5, 100, 0);
title("DEP antes del Discriminador");

plotDEP(z_dis, fs/N1, 10, 80, 10, 1);
title("DEP del Mensaje");

plotDEP(z_B2, fs/N1, -10, 90, 1, 1);
title("DEP del Mensaje Monoaural");

plotDEP(z_out, fs/N1/N2, -10, 70, 1, 1);
title("DEP del Mensaje con fs=45kHz");

% sound(z_out, fs/N1/N2);





%% Funcion para realizar los PLOTS de manera mas simple
% max_val       es simplemente para fijar un limite superior con `xlim`.
% down_sample   es para evitar sobrecargar la grafica. Elimina muestras
% db            es para mostrar en decibeles (db = 1 anula max_val).
function plotDEP(x, fs, min_val, max_val, down_sample, db)
    % Obtengo la DEP de x[n] que ingresa como parametro. Junto a su `fs`.
    % Esta DEP la realizo siempre con 200 realizaciones.
    [X, N] = getDEP(fs, 200, x);
    
    X = fftshift(X);
    if mod(N, 2) == 0
        f = (-1/2 : 1/N : (N-1)/(2*N)) * fs;
    else
        f = (- (N-1)/(2*N) : 1/N : (N-1)/(2*N)) * fs;
    end
    
    % Reduzco la cantidad de puntos para que no se sature la gráfica
    if down_sample > 0
        if mod(down_sample, 1) == 0
            X = downsample(X, down_sample);
            f = downsample(f, down_sample);
        else
            fprintf("↳ El valor de `down_sample` debe ser entero!\n\n");
        end
    end
    
    % Grafica en dB
    if db
        X = 10*log10(X);
    end

    fig1 = figure('Position', [100 100 1000 400], 'Name', 'Laboratorio - Fund. de las Comunicaciones', 'NumberTitle', 'off');
    ax1 = axes(fig1);
    plot(f, X, "LineWidth", 1.5);
    
    % if max_val ~= 0 && ~db
    if max_val ~= 0
        set(ax1, "Position", [0.06 0.15 0.9 0.75], "XMinorGrid", "On", "YMinorGrid", "On", "XLim", [f(1), f(end)], "YLim", [min_val, max_val]);
    else
        set(ax1, "Position", [0.06 0.15 0.9 0.75], "XMinorGrid", "On", "YMinorGrid", "On", "XLim", [f(1), f(end)]);
    end    
    xlabel(ax1, 'Frecuencia [Hz]');
end


% Esta funcion permite obtener la DEP de un proceso, dividiendo el proceso
% completo en M realizaciones de N muestras cada uno. El proceso es x[n]
% con una frecuencia de muestreo asociada de fs.
function [Sxx, N] = getDEP(fs, M, x)
    N = floor(length(x)/M);
    Sxx = zeros(N, 1);
    for m=0:M-1
        TDF = fft(x(m*N+1:N*(m+1)));
        Sxx = Sxx + (fs/(M*N))*abs(TDF).^2;
    end
end








