B = zeros(5,9);
B = [203 193 193 195 207 207 207 207 207;
    201 192 190 198 196 0 0 0 0;
    204 194 197 196 207 0 0 0 0;
    206 207 193 200 202 0 0 0 0;
    203 207 208 209 210 0 0 0 0]

Bpix = B(2:5,2:5)
%% DC
PDC = zeros(4,4);
PrefDC = [B(1,:) , B(2:5,1)']; % Concatenamos matrices y es un vector
DC = round(mean(PrefDC)); % Calcula la media de ese nivel de datos, redondeado
PDC(:,:) = DC;
RDC = Bpix - PDC
EDC = sum(RDC(:).^2)
%% PH
PH = ones(4,4);
PrefH = [PH .* B(2:5,1)];
RH = Bpix - PrefH
EH = sum(RH(:).^2)
%% PV
PV = ones(4,4);
PrefV = [PV .* B(1,2:5)];
RV = Bpix - PrefV
EV = sum(RV(:).^2)
%% PDL
PDL = ones(4,4);
Pref1 = [diag(B(1,1) * diag(PDL))];
Pref2 = [diag(B(1,2) * diag(PDL,1),1)];
Pref3 = [diag(B(1,3) * diag(PDL,2),2)];
Pref4 = [diag(B(1,4) * diag(PDL,3),3)];
Pref5 = [diag(B(2,1) * diag(PDL,-1),-1)];
Pref6 = [diag(B(3,1) * diag(PDL,-2),-2)];
Pref7 = [diag(B(4,1) * diag(PDL,-3),-3)];
PrefV = Pref1 + Pref2 + Pref3 + Pref4 + Pref5 + Pref6 + Pref7;

RDL = Bpix -PrefV
EDL = sum(RDL(:).^2)
