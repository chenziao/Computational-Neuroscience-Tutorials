clear;
close all;

filename = '191002_cell2';
Tunit = 1000;   % ms to 1 unit in recording
Vunit = 1;      % mV to 1 unit in recording
Iunit = 0.1;	% nA to 1 unit in recording

data = load([filename,'.mat']);
varname = fieldnames(data);
Tn = varname(cellfun(@(x)~isempty(x),strfind(varname,'T')));
Yn = varname(cellfun(@(x)~isempty(x),strfind(varname,'Y')));

n = length(Tn);
Dat = cell(n,3);
Tlast = 0;
for i = 1:n
    Dat{i,1} = data.(Tn{i})+Tlast;
    Tlast = 2*Dat{i,1}(end)-Dat{i,1}(end-1);
    Dat{i,2} = data.(Yn{i})(:,1);
    Dat{i,3} = data.(Yn{i})(:,2);
end

T = cell2mat(Dat(:,1))*Tunit;   % ms
V = cell2mat(Dat(:,2))*Vunit;   % mV
I = cell2mat(Dat(:,3))*Iunit;   % nA
dt = mean(diff(T)); % ms

%% Save file
save([filename,'_mat','.mat'],'dt','V','I');

digitize = 2;   % 0 for float values, 1 for digitized values, 2 for both
if digitize == 0 || digitize==2
    fid = fopen([filename,'.txt'],'w');
    fprintf(fid,'time step (ms) = %.18f\n',dt);
    headers = strjoin({'V(mV)','I(nA)'},'\t');
    fprintf(fid,'%s\n',headers);
    fclose(fid);
    dlmwrite([filename,'_float.txt'],[V,I],'-append','delimiter','\t','precision',5);
end
if digitize
    [Vd,dV] = GCD_digitize(V);
    [Id,dI] = GCD_digitize(I);
    fid = fopen([filename,'_digit.txt'],'w');
    fprintf(fid,'time step (ms) = %.18f\n',dt);
    fprintf(fid,'V unit (mV) = %.18f\n',dV);
    fprintf(fid,'I unit (nA) = %.19f\n',dI);
    headers = strjoin({'V','I'},',');
    fprintf(fid,'%s\n',headers);
    fclose(fid);
    dlmwrite([filename,'.txt'],[Vd,Id],'-append','delimiter',',','precision','%d');
end

