close all, clear all;
%% Indique los nombres de archivo tanto del audio a evaluar como del audio de referencia.
ref_audio = 'speech.wav';
ev_audio = 'speech_LQ.wav';

%% Carga de los archivos de audio.
[reference, fs1] = audioread(ref_audio);
[degraded, fs2] = audioread(ev_audio);

%% Almacenamiento de la longitud de la grabación.
ref_len = length(reference)/fs1;

%% Remuestreo para poder realizar la comparativa con igual fs.
if fs1~=fs2
    degraded = resample(degraded,fs1,fs2);
end

%% Obtención del PESQ-MOS (restringido a 5 segundos)
if ref_len<=5
    score = pesq_mex(reference, degraded, fs1);
else
    score = pesq_mex(reference(1:5*fs1), degraded(1:5*fs1), fs1);
end