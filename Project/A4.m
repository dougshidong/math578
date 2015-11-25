clear;clc;close all;
%% Defining Parameters
project_name='square';
S_load='''square_cell'',''db'',''C:\cygwin64\home\Doug\Math578\Project''';
ansys_path='"C:\Program Files\ANSYS Inc\v162\ansys\bin\winx64\ansys162.exe"';

%% Boundary Condition  
% KUBC  Uniform Displacement BCs.
% SUBC  Uniform Stress BCs.
% MUBC  Mixed uniform BCs.
BC_type='MUBC';

%% Run simulations
% load case
% 1: Uniaxial(along X)
% 2: Uniaxial(along Y)
% 3: Biaxial
% 4: Shear

FEM_data={4};

%% Output file
output_filename=sprintf('output_%s.txt',BC_type);
output_file=fopen(output_filename,'wt');

%% Young's Modulus and Poisson's Ratio
E=1000;
nu=0.25;

%% Unit Cell Geometry
L=10;
H=1;
A=H*L;

%% number of elements along the edge
n=100;

for load_case=1:4 % loop over load_case
    ansys_file_name=sprintf('%s_%s_%i.txt',project_name,BC_type,load_case);
    ansys_run=sprintf('%s -p aa_t_i -b -i %s -o %s.out',ansys_path,ansys_file_name,project_name);

    % Create 
    square_solid(ansys_run,ansys_file_name, BC_type,load_case,E,nu,H,L,n);
    %square_unit_cell(ansys_run,ansys_file_name, BC_type,load_case,E,nu,H,L,t,n);
    %circle_unit_cell(ansys_run,ansys_file_name, BC_type,load_case,E,nu,H,L,t,n);
    
    dos(ansys_run);
    
    filename=sprintf('results_%s_%i.txt',BC_type,load_case);
    FEM_data{load_case}=load(filename);

end % end of loop over load_case

%% Postprocessing

% volume of elements
vol_elem = FEM_data{1}(:,1);
for load_case=1:4
    % strain components
    strain{load_case}=FEM_data{load_case}(:,2:4);

    for ii=1:3
        strain_vol{load_case}(:,ii)=strain{load_case}(:,ii).*vol_elem(:);
    end
    avg_strain{load_case}(i,:)=sum(strain_vol{load_case});

    % stress components
    stress{load_case}=FEM_data{load_case}(:,5:7);

    for ii=1:3
        stress_vol{load_case}(:,ii)=stress{load_case}(:,ii).*vol_elem(:);
    end
    avg_stress{load_case}(i,:)=sum(stress_vol{load_case});
end

% elastic energy
W1=FEM_data{1}(:,8);
W2=FEM_data{2}(:,8);
W3=FEM_data{3}(:,8);
W4=FEM_data{4}(:,8);

if strcmp(BC_type,'SUBC')
    % compliance matrix S
    S11=2*sum(vol_elem.*W1)/A;               % S11=S1111
    S22=2*sum(vol_elem.*W2)/A;               % S22=S2222
    S12=sum(vol_elem.*W3)/A-0.5*(S11+S22);   % S12=S1122
    S66=4*sum(vol_elem.*W4)/(2*A);           % S66=4*S1212
    S=[S11 S12 0;S12 S22 0; 0 0 S66];
else
    % stiffness matrix C
    C11=2*sum(vol_elem.*W1)/A;               % C11=C1111
    C22=2*sum(vol_elem.*W2)/A;               % C22=C2222   
    C12=sum(vol_elem.*W3)/A-0.5*(C11+C22);   % C12=C1122
    C66=sum(vol_elem.*W4)/(2*A);             % C66=C1212
    C=[C11 C12 0;C12 C22 0; 0 0 C66];

    % compliance matrix S
    S=inv(C);
    S11=S(1,1);
    S22=S(2,2);
    S12=S(1,2);
    S66=S(3,3);         
end

%% Effective properties
E1_eff(i)=1/S11/E;
E2_eff(i)=1/S22/E;
nu12_eff(i)=-S12/S11/nu;
nu21_eff(i)=-S12/S22/nu;
G_eff(i)=1/S66/E;

%delete('*.txt');delete('file.*');delete('ansuitmp');delete('*.db');delete('*.out');

fclose(output_file);
disp('--------------------------------------');
disp('Simulation completed successfully.');
disp('--------------------------------------');
