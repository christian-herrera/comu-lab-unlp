function [z_out, z_N2, z_B2, z_dis, y_N1, y_B1] = FM_DEMOD_HerreraChristian(x, B1, N1, B2, N2, fs)
    %% Parametros
    O1 = 5;     % Orden del primer filtro. Con este valor se filtra adecuadamente
    O2 = 20;    % Orden del segundo filtro. Aqui se necesita mas selectividad. Con 20 se escucha bien.
    
    %% LPF B1
    % Filtro butter LPF de orden 5, normalizado a fs/2.
    [b, a] = butter(O1, B1/(fs/2), 'low');
    y_B1 = filter(b, a, x); 

    %% Diezmado con N1
    y_N1 = decimate(y_B1, N1, "fir");
    fs = fs/N1;

    %% Discriminador
    phi = unwrap(angle(y_N1));
    phi = diff(phi);
    z_dis = (1 / (2 * pi * 75e3)) * phi * fs;

    %% LPF B2
    % Filtro butter LPF de orden 20, normalizado a fs/2/N1
    [b, a] = butter(O2, B2/(fs/2), 'low');
    z_B2 = filter(b, a, z_dis);

    %% Diezmado con N2
    z_N2 = decimate(z_B2, N2, "fir");


    %% Salida final
    z_out = z_N2;

end





