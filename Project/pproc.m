% Author: Doug Shi-Dong
% email: doug.shi-dong@mail.mcgill.ca
% date: December 2015

%% Defining Parameters
project_name = 'beampinpin';
ansys_path   = ['"C:\Program Files\ANSYS Inc\v162\' ...
                'ansys\bin\winx64\ansys162.exe"'];
work_dir     = '"C:\cygwin64\home\Doug\Math578\Project"';
ansys_input  = sprintf('%s.txt', project_name);
% Refer to the following link to know which ansys license is used:
% http://www.drd.com/techsupport/ansys_product_variables.aspx
% Currently using aa_t_i (ANSYS Academic Teaching Introductory)
ansys_run    = sprintf('%s -p aa_t_i -B -i %s -o %s.out -dir %s',...
                 ansys_path,ansys_input, project_name, work_dir);
resultf      = 'results';
dim          = 2;

%% Delete Files that may Cause Conflicts
delete('file.*');delete('*.lock');delete(strcat(resultf,'.txt'));
delete(strcat(project_name, '.*'));

%% Young's Modulus and Poisson's Ratio
% Aluminum
E  = 9e9;   % Pa
nu = 0.34;  % Non-dimensional

%% Beam Geometry
L  = 10;   % m
H  = 1;    % m
A  = H * L;  % m^2

%% Number of Elements Along the Length of Beam
nx     = 100;
esize  = L / nx;
ny     = round(H / esize);
nelem  = nx * ny;

% Note: All specified locations are non-dimensionalized.
%       e.g. 0.5 signifies half-way of the geometry

%% Boundary Conditions
% Fixed Ux = 0 Locations
dispLocUx = [0.4, 0.5;
            0.6, 0.5;];
% Fixed Uy = 0 Locations        
dispLocUy = [0.4, 0.5;
            0.6, 0.5;];        
% Fx, Fy Applied on the Nodes               
loadVal   = [1.0000, 0.0000;
             0.0000, 1.0000;]; % N

%% Location of Loads 
% Create a List of Load Location
loadLocX = [0 : 1/nx : 1]';
loadLocY = [0 : 1/ny : 1]';
loadLoc  = [[zeros(size(loadLocY, 1), 1), loadLocY];
            [ ones(size(loadLocY, 1), 1), loadLocY];
            [loadLocX, zeros(size(loadLocX, 1), 1)  ];
            [loadLocX,  ones(size(loadLocX, 1), 1)  ]];


%% Initialize Arrays        
s_xx    = zeros(size(loadLoc, 1), dim, nelem);
s_yy    = s_xx;
s_xy    = s_xx;
s_1     = s_xx;
s_2     = s_xx;
s_vm    = s_xx;
my_s_vm = s_xx;

FEM_data  = zeros(nelem, 3);

%% Loop through Surface and Loads
for iloc = 1 : size(loadLoc, 1)
for ifor = 1 : dim
    it = sprintf('%d out of %d Loads', ...
                (iloc - 1) * dim + ifor, size(loadLoc, 1) * dim);
    disp(it);
    % Create Ansys Input File
    createAnsysIn(ansys_input, resultf, ...
                  E, nu, H, L, nx, ...
                  dispLocUx, dispLocUy, ...
                  loadLoc(iloc, :), loadVal(ifor, :));
    % Run Ansys
    status  = dos(ansys_run);
    % Load results
    FEM_data = load(strcat(resultf, '.txt'));

    % Postprocessing
    s_xx(iloc, ifor, :) = FEM_data(:, 1);
    s_yy(iloc, ifor, :) = FEM_data(:, 2);
    s_xy(iloc, ifor, :) = FEM_data(:, 3);
    s_1(iloc, ifor, :)  = FEM_data(:, 4);
    s_2(iloc, ifor, :)  = FEM_data(:, 5);
    s_vm(iloc, ifor, :) = FEM_data(:, 6);
    % Von-Mises Stress assuming General Plane Stress
    my_s_vm(iloc, ifor, :) = squeeze(sqrt( ...
                          s_xx(iloc, ifor, :).^2 ...
                        + s_yy(iloc, ifor, :).^2 ...
                        - s_xx(iloc, ifor, :) .*  s_yy(iloc, ifor, :) ...
                        + 3 * s_xy(iloc, ifor, :).^2));
end
end

%% Save Results
save(project_name)

disp('--------------------------------------');
disp('Simulation completed successfully.');
disp('--------------------------------------');
