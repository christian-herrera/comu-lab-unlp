classdef op
    
    properties
        
    end
    
    methods
        function obj = op()

        end
        
        function [X, f] = DEP(~, x, fs)
            N = length(x);
            X = fftshift(fft(x));
            X = (1/(fs*N))*(abs(X).^2);

            if mod(N, 2) == 0
                f = (-1/2 : 1/N : (N-1)/(2*N)) * fs;
            else
                f = (- (N-1)/(2*N) : 1/N : (N-1)/(2*N)) * fs;
            end
        end
        
        
        function X = plotDEP(obj, x, fs, max_val, down_sample)
            [X, f] = DEP(obj, x, fs);
            
            
            
            % Reduzco la cantidad de puntos para que no se sature la gráfica
            X = downsample(X, down_sample);
            f = downsample(f, down_sample);

            % X = 10*log10(X);
            if nargin < 4
                max_val = max(X)*1.1;
            end
            
            fig1 = figure('Position', [100 100 1000 400], 'Name', 'Laboratorio - Fund. de las Comunicaciones', 'NumberTitle', 'off');
            
            ax1 = axes(fig1);
            plot(f, X);
            
            title(ax1, "Densidad Espectral de Potencia");
            set(ax1, "Position", [0.06 0.15 0.9 0.75], "XMinorGrid", "On", "YMinorGrid", "On", "XLim", [f(1), f(end)], "YLim", [min(X), max_val]);
            % set(ax1, "Position", [0.06 0.15 0.9 0.75], "XMinorGrid", "On", "YMinorGrid", "On", "XLim", [f(1), f(end)]);
            xlabel(ax1, 'Frecuencia [Hz]');
            % ylabel(ax1, 'Amplitud', Interpreter='latex');
        end


        function y = filtro(~, x, fs, fc, orden)
            [b, a] = butter(orden, fc/(fs/2), 'low');   % Diseña un filtro Butterworth de orden 5 con frecuencia de corte normalizada a fs/2
            y = filter(b, a, x);                        % Aplica el filtro a la señal de entrada x
        end
    end
end

