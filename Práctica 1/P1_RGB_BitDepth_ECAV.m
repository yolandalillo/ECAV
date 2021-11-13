% Cierra todas las ventanas y variables
close all;

% Selecciona el nombre del fichero
FileName = '1-Face.png';

% Lee la imagen
RGB=imread(FileName);

% Obten la información de la iamgen
whos RGB;

% Obten los parametros de la imagen
[Rows,Cols,C]=size(RGB);

% Presenta en pantalla la resolución de la imagen utilizando fprintf del modo
% Filas:xxxx, Columnas = xxx

fprintf('Filas: %0i, Columnas: %0i\n', Rows, Cols)


% Visuliza la imagen RGB
figure; imshow(RGB); title('RGB original');

% Visualiza cada una de las componente de la imagen con imshow() en
% ventanas independientes

Red=RGB(:,:,1);
figure; imshow(Red),title('Red');
Green=RGB(:,:,2);
figure; imshow(Green),title('Green');
Blue=RGB(:,:,3);
figure; imshow(Blue), title('Blue');


% Selecciona un area de la imagen con gran detalle y almacenala en la variable RGB_ROI

RGB_ROI = RGB(500:1220,500:1260,:);


% Visualiza la RGB_ROI con imshow(RGB_ROI);

figure; imshow( RGB_ROI),('Cut');



% Cuentifica la imagen con N bits, N=7,6,5,4,3,2, y 1; y almacenalo en una
% variable RGB_Nbits

for N=7:-1:1;
    b=8-N;
    RGB_Nbits= uint8(floor(double(RGB_ROI)/2^b));
    
    
    % Visualiza la imagen cuantificada utiliando imshow(RGB_Nbits*(2^b));
    
    figure, imshow(RGB_Nbits*(2^b)), title('Cuantificando');

    
    % Escribe la imagen para cada una de las cuantificaciones en un fichero
    % 'Nombre_imagen_Nbits.tiff', utilizando el comando imwrite() y
    % utilizando los campos, 'compression','none';
    
    text = sprintf('%d.tiff',N)
    imwrite(RGB_Nbits*(2^b), text);
    
    
    % Calcula la relación de compresión que se obtiene para valor de
    % cuantificacion
    
    Compresion = 8 /N;
   
    
    % Muestra por pantalla la relación de compresión obtenida para cada
    % valor de cuantificación utilizando el comando fprintf()
    
    fprintf('Relacion de compresión %0i: %0f\n',N,Compresion)

end


