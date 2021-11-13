
% Codificador de video Experimental
% Grupo: G10
% Alumnos: Elena María del Río Galera & Yolanda Lillo Mata

FileName= '1-Face.png';
N=8;
Q=32;
% QFlag: "0" uniforme, 21" perceptual

close('all');

% Leo la imagen en RGB
RGB = imread(FileName);
imshow(RGB);

% Calculo la resolucion de la imagen
[Rows,Cols,Z]=size(RGB);

%Comprobacion Rows y Cols es multiplo de 8
if mod(Rows,N)== 0
    NewRows = Rows;
else 
    NewRows = ceil(Rows/N)*N;
end

if mod(Cols,N)== 0
    NewCols = Cols;
else 
    NewCols = ceil(Cols/N)*N;
end

New_Y = zeros(NewRows, NewCols);

% Convierto la imagen RGB al espacio de color YCbCr 
YCbCr=rgb2ycbcr(RGB);
Y = YCbCr(:,:,1); %1 es y, 2 cb, 3cr

%Imagen original dentro de la nueva
New_Y (1:Rows,1:Cols)=Y;
imshow(New_Y,[]); title('New Y');

% Submuestre las componentes de crominancia Cb y Cr a 4:2:0 con imsize()
Cb = YCbCr(:,:,2);
Cr = YCbCr(:,:,3);
SCb = imresize(Cb, 1/2);
SCr = imresize(Cr, 1/2);
%figure; imshow(SCb,[]); title('SCb');
%figure; imshow(SCr,[]); title('SCr');

% Ajusto la resolucion de la imagen a un multiplo de N
[RowsC,ColsC]=size(SCb);
if mod(RowsC,N)== 0
    NewRowsC = RowsC;
else 
    NewRowsC = ceil(RowsC/N)*N;
end

if mod(ColsC,N)== 0
    NewColsC = ColsC;
else 
    NewColsC = ceil(ColsC/N)*N;
end

New_Cb = zeros(NewRowsC, NewColsC);
New_Cb(1:RowsC, 1:ColsC) = SCb;
figure; imshow(New_Cb, []); title('New_Cb');

New_Cr = zeros(NewRowsC, NewColsC);
New_Cr(1:RowsC, 1:ColsC) = SCr;
figure; imshow(New_Cr, []); title('New_Cr');

% Inicializo el Bloque NxN
B=zeros(N,N);
% Inicializo el de Predicción NxN
P = zeros(N,N);
% Inicializo el bloque de Residuo NxN
R = zeros (N,N);

% Inicializo el Bloque del nucleo de Transformación (opcional)
% T=

% Calculo el Nucleo de Transformación (opcional)
%for u=1:N
 %   for n=1:n
       % Si u=0
            % T=
       
       % else
            % T=
        
  %  end
%end

% Inicializo el Bloque Tranformado C(u,v)
C = zeros(N,N);

% Inicializo el Bloque cuantificado Z(u,v)
Z = zeros(N,N);

% Inicializo el Bloque de escalado Cq(u,v)
Cq = zeros(N,N);
% Inicializo el Bloque de transformación inversa Rq(i,j)
Rq = zeros(N,N);

% Inicializo el Bloque decodificado Bq(i,j)
Bq = zeros(N,N);

% Codifico los Bloques B(i,j) de la Y
for i=1:N:NewRows
    for j=1:N:NewCols
        %fprintf('- Procesando Bloque (i,j)=(%d,%d)\n\n', i, j);
        % Selecciono l bloque B
         B=New_Y(i:i+N-1,j:j+N-1);
        
        % Calculo el predictoe para ese bloque
        if i==1 || j==1
            P(:,:) = 128;
        else
            P(:,:) = 128;
        end
        
        % Calculo el residuo para ese bloque
        R = B -P;
                
        % Calculo la Transformada bidimensional del Residuo
        C= dct2(R);
        
        % Cuantifico los coeficientes transformados
        Z = floor (C/Q);
               
        %OPCIONAL: codificacion Huffman
        
        % Reconstruyo los coeficientes cuantificados
        Cq=Z.*Q;
        
        % Aplico la transformacion inversa
        Rq = idct2(Cq);
                
        % Reconstruyo el Bloque sumandole el predictor
        Bq = P +Rq;
        
        % Coloco el bloque decodificado en la posicion correcta de la
        % imagen decodificada YCbCrq
        Yq(i:i+N-1,j:j+N-1,1) = uint8(Bq);
        
    end
end
%Quitar linea negra de la derecha para que la imagen vuelva a tener
%su tamaño original
New_Yq = Yq(1:Rows,1:Cols);
YCbCrq(:,:,1) = New_Yq;
figure, imshow(New_Yq), title('Yq');

% Codifico igualmente la Cb y Cr
for i=1:N:NewRowsC
    for j=1:N:NewColsC
        %Igual que el bucle de arriba pero con Cb y Cr
        % Selecciono l bloque B
         B_Cb=New_Cb(i:i+N-1,j:j+N-1);
         B_Cr = New_Cr(i:i+N-1,j:j+N-1);
        
        % Calculo el predictor para ese bloque
        if i==1 || j==1
            P(:,:) = 128;
        else
            P(:,:) = 128;
        end
              
        % Calculo el residuo para ese bloque
        R_Cb = B_Cb -P;
        R_Cr = B_Cr -P;                
        % Calculo la Transformada bidimensional del Residuo
        C_Cb = dct2(R_Cb);
        C_Cr = dct2(R_Cr);
        
        % Cuantifico los coeficientes transformados
        Z_Cb = floor (C_Cb/Q);
        Z_Cr = floor (C_Cr/Q);
               
        %OPCIONAL: codificacion Huffman
        
        % Reconstruyo los coeficientes cuantificados
        Cq_Cb=Z_Cb.*Q;
        Cq_Cr=Z_Cr.*Q;

        % Aplico la transformacion inversa
        Rq_Cb = idct2(Cq_Cb);
        Rq_Cr = idct2(Cq_Cr);
                
        % Reconstruyo el Bloque sumandole el predictor
        Bq_Cb = P +Rq_Cb;
        Bq_Cr = P +Rq_Cr;
        
        % Coloco el bloque decodificado en la posicion correcta de la
        % imagen decodificada YCbCrq
        Cbq(i:i+N-1,j:j+N-1) = uint8(Bq_Cb);
        Crq(i:i+N-1,j:j+N-1) = uint8(Bq_Cr);
 
    end
 end
figure, imshow(Cbq,[]), title('Cbq');
figure, imshow(Crq,[]), title('Crq');

% Interpolo las componentes de Cb y Cr decodificadas Cbq y Crq a 4:4:4 con imsize()
Cb_q = Cbq(1:RowsC, 1:ColsC);
Deco_Cb = imresize(Cb_q,2);
YCbCrq(:,:,2) = Deco_Cb;

Cr_q = Crq(1:RowsC, 1:ColsC);
Deco_Cr = imresize(Cr_q,2);
YCbCrq(:,:,3) = Deco_Cr;

figure, imshow(YCbCrq), title('YCbCrq');


% Convierto la imagen YCbCrq al espacio RGB para visualizarla
RGB_dec = ycbcr2rgb(YCbCrq);

figure, imshow(RGB_dec), title('Decodificada RGB');

% Calculo la PSNR entre la imagen original YCbCr y la decodificada YCbCrq

Y_Original = YCbCr(:,:,1);
Y_Decodec =  YCbCrq(:,:,1);

Cb_Original = YCbCr(:,:,2);
Cb_Decodec =  YCbCrq(:,:,2);

Cr_Original = YCbCr(:,:,3);
Cr_Decodec =  YCbCrq(:,:,3);

%Calculamos la PSNR de cada componente

PSNR_Y = psnr(Y_Original(1:Rows,1:Cols),Y_Decodec(1:Rows,1:Cols));
PSNR_Cb = psnr(Cb_Original(1:Rows,1:Cols),Cb_Decodec(1:Rows,1:Cols));
PSNR_Cr = psnr(Cr_Original(1:Rows,1:Cols),Cr_Decodec(1:Rows,1:Cols));
fprintf('PSNR(Y)= %f\n', PSNR_Y);
fprintf('PSNR(Cb)= %f\n', PSNR_Cb);
fprintf('PSNR(Cr)= %f\n', PSNR_Cr);

