clear;
project_name = 'beampinpin';
load(strcat(project_name,'.mat'));


%% List of Fx, Fy Applied on the Nodes               
loadVal2   = [-0.5000, 0.0000;
              -0.5000, 0.0000;
              -0.5000, 0.0000;
              -0.5000, 0.0000;
              -0.5000, 0.0000;
              -0.5000, 0.0000;
              -0.5000, 0.0000;
              -0.5000, 0.0000;
              -0.5000, 0.0000;
              -0.5000, 0.0000;
              -0.5000, 0.0000;
              0.0000, 1.0000;
              0.0000, -2.0000]; % N
%% Location of Loads (Non-Dimensional Location 0.0-1.0)
loadLoc2  = [0.0, 0.0;
             0.0, 0.1;
             0.0, 0.2;
             0.0, 0.3;
             0.0, 0.4;
             0.0, 0.5;
             0.0, 0.6;
             0.0, 0.7;
             0.0, 0.8;
             0.0, 0.9;
             0.0, 1.0;
             0.1, 1.0;
             0.8, 0.0];
        
nload = size(loadVal2, 1);

loadIndex = zeros(nload,1);
%% Search Nearest Load in the List
for iload = 1 : nload
    mind = 1e9;
    for iloc = 1 : size(loadLoc,1);
        dist = norm(loadLoc2(iload, :) - loadLoc(iloc, :));
        if(dist < mind)
            mind = dist;
            loadIndex(iload) = iloc;
        end
    end
end
            
%% Linear Combinations of Stresses
sxx_comb = zeros(nelem,1);
syy_comb = zeros(nelem,1);
sxy_comb = zeros(nelem,1);
out = ''
for iload = 1 : nload
    out = [out, sprintf('%d & %2.1f & %f & %2.1f & %f & %f \n', ...
        iload,...
        loadVal2(iload,1), s_xx(loadIndex(iload), 1, 961), ...
        loadVal2(iload,2), s_xx(loadIndex(iload), 2, 961),...
        loadVal2(iload,1) * (s_xx(loadIndex(iload), 1, 961)) + loadVal2(iload,2) * (s_xx(loadIndex(iload), 2, 961)))]
    sxx_comb = sxx_comb + loadVal2(iload,1) ...
                 * squeeze(s_xx(loadIndex(iload), 1, :));
    sxx_comb = sxx_comb + loadVal2(iload,2) ...
                 * squeeze(s_xx(loadIndex(iload), 2, :));
    syy_comb = syy_comb + loadVal2(iload,1) ...
                 * squeeze(s_yy(loadIndex(iload), 1, :));
    syy_comb = syy_comb + loadVal2(iload,2) ...
                 * squeeze(s_yy(loadIndex(iload), 2, :));
    sxy_comb = sxy_comb + loadVal2(iload,1) ...
                 * squeeze(s_xy(loadIndex(iload), 1, :));
    sxy_comb = sxy_comb + loadVal2(iload,2) ...
                 * squeeze(s_xy(loadIndex(iload), 2, :));
end

vm_comb = squeeze( sqrt(  sxx_comb.^2 ...
                        + syy_comb.^2 ...
                        - sxx_comb .*  syy_comb ...
                        + 3 * sxy_comb.^2 ) );

max_vm = max(vm_comb)
%% Validate with Ansys Run
delete('file.*');delete('*.lock');delete(strcat(resultf,'.txt'));

% Create Ansys Input File
createAnsysIn(ansys_input,resultf, ...
              E,nu,H,L,n, ...
              dispLocUx, dispLocUy, ...
              loadLoc2,loadVal2);         
% Run Ansys
status  = dos(ansys_run)
% Load results
FEM_data = load(strcat(resultf,'.txt'));

% Postprocessing
stress_validate = FEM_data(:,1:5);
stress_vm_validate = FEM_data(:,6);

valid1 = norm(vm_comb - stress_vm_validate)
valid2 = norm(vm_comb - stress_vm_validate,inf)