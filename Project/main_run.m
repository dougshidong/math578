%% MATLAB script for running simulation 
% Computational homogenization of a rectangular unit cell based on Energy method
%% 15 February 2015
%% Ahmad Rafsanjani (ahmad.rafsanjani@mcgill.ca)


clc
clear all
%% Simulation parameters

project_name='square';

%% Material properties

E=1.0;
nu=0.3;

%% Boundary Condition  
% KUBC  Uniform Displacement BCs.
% SUBC  Uniform Stress BCs.
% MUBC  Mixed uniform BCs.

BC_type='KUBC';

%% unit cell dimensions

L=1.0;
H=1.0;
A=L*H;

%% number of elements along the edge

n=100;


%% ansys path

ansys_path='"C:\Program Files\ANSYS Inc\v145\ansys\bin\winx64\ansys145.exe"';


%% Run simulations

% load case
% 1: Uniaxial(along X)
% 2: Uniaxial(along Y)
% 3: Biaxial
% 4: Shear

FEM_data={4};

output_filename=sprintf('output_%s.txt',BC_type);
output_file=fopen(output_filename,'wt');

for i=3:3 % loop over thickness
    t=i*0.05;  
    rho=(L*H-(L-2*t)*(H-2*t))/(L*H);
     
    for load_case=1:4 % loop over load_case
        ansys_file_name=sprintf('%s_%s_%i.txt',project_name,BC_type,load_case);
        ansys_run=sprintf('%s -p -b -i %s -o %s.log',ansys_path,ansys_file_name,project_name);
        
        
        % call unit cell generator function
        square_solid(ansys_run,ansys_file_name, BC_type,load_case,E,nu,H,L,t,n);
        filename=sprintf('results_%s_%i.txt',BC_type,load_case);
        FEM_data{load_case}=load(filename);
        
    end % end of loop over load_case


% Postprocessing

    % volume of elements
    vol_elem = FEM_data{1}(:,1);

    % strain components
    strain{1}=FEM_data{1}(:,2:4);
    strain{2}=FEM_data{2}(:,2:4);
    strain{3}=FEM_data{3}(:,2:4);
    strain{4}=FEM_data{4}(:,2:4);

    % stress components
    stress{1}=FEM_data{1}(:,5:7);
    stress{2}=FEM_data{2}(:,5:7);
    stress{3}=FEM_data{3}(:,5:7);
    stress{4}=FEM_data{4}(:,5:7);
 
    
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
    
    % effective properties
    E1_eff=1/S11/E;
    E2_eff=1/S22/E;
    nu12_eff=-S12/S11/nu;
    nu21_eff=-S12/S22/nu;
    G_eff=1/S66/E;
    
    fprintf(output_file, '%f %f %f %f %f %f \n',rho,E1_eff,E2_eff,nu12_eff,nu21_eff,G_eff);
    
end % end of loop over thickness

 fclose(output_file);


 
 

disp('--------------------------------------');
disp('Simulation completed successfully.');
disp('--------------------------------------');


















