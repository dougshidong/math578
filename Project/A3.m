clear;clc;close all;
%% Defining Parameters
S_load='''square_cell'',''db'',''H:\Desktop\MECH548\A3\''';
% Young's Modulus and Poisson's Ratio
E=120000;
PR=0.3333;
% Stiffness Matrix for Linear Isotropic Plane Stress Condition
Cij=zeros(3);
Cij(1,1)=1/E;
Cij(2,2)=1/E;
Cij(1,2)=-PR/E;
Cij(2,1)=-PR/E;
Cij(3,3)=2*(1+PR)/E;
% Compliance Matrix
invCij=inv(Cij);
% Strain cases applied to the RVE boundary
epsil=[1 0 0;0 1 0; 0 0 0.5];
% Unit Cell Geometry
L=1;
H=L;
unit_cell_area=H*L;
% Relative Density
from=0.05;
to=1;
step=0.05;
iter=20;
rho_rel_matx=from:step:to;
n_elem_matx=ones(1,iter)*1200;

%% Quadratic equation elements
aq=4;
bq=-2*(H+L);

%% Loop the different Relative Densities
for i=1:size(rho_rel_matx,2)
    fprintf('Iteration %d out of %d\n',i,iter);
    rho_rel=rho_rel_matx(i);
    rho_rel_arr(i)=rho_rel;
    cq=rho_rel*H*L;
    % Solve Quadratic Equation for Thickness
    t=(-bq-sqrt(bq^2-4*aq*cq))/(2*aq);
    thickness(i)=t;
    area=L*H-(L-2*t)*(H-2*t);
    % Define number of elements and mesh size
    n_elem=n_elem_matx(i);
    mesh_size=sqrt(area/n_elem);
    
    %% Writing Default Static Structural Startup ANSYS APDL
    A_file=fopen('square_cell.txt','wt');
    fprintf(A_file, '/CLEAR,START \n');
    fprintf(A_file, '/NOPR\n');
    fprintf(A_file, '/PMETH,OFF,0\n');
    fprintf(A_file, 'KEYW,PR_SET,1\n');
    fprintf(A_file, 'KEYW,PR_STRUC,1 	!*Static structural study\n');
    fprintf(A_file, 'KEYW,PR_THERM,0 \n');
    fprintf(A_file, 'KEYW,PR_FLUID,0 \n');
    fprintf(A_file, 'KEYW,PR_ELMAG,0 \n');
    fprintf(A_file, 'KEYW,MAGNOD,0 \n');
    fprintf(A_file, 'KEYW,MAGEDG,0 \n');
    fprintf(A_file, 'KEYW,MAGHFE,0 \n');
    fprintf(A_file, 'KEYW,MAGELC,0 \n');
    fprintf(A_file, 'KEYW,PR_MULTI,0\n');
    fprintf(A_file, 'KEYW,PR_CFD,0\n');
    fprintf(A_file, '/GO 			!*Reactives supressed printout\n');
    fprintf(A_file, '/PREP7  		!*Begin preprocesing\n');
    % Define Element Type
    fprintf(A_file, 'ET,1,PLANE82\n');
    fprintf(A_file, 'MPTEMP,,,,,,,,\n');
    % Assign Material Property
    fprintf(A_file, 'MPTEMP,1,0\n');
    fprintf(A_file, 'MPDATA,EX,1,,%f\n',E);
    fprintf(A_file, 'MPDATA,PRXY,1,,%f\n',PR);
    
    %% Create Geometry
    % Quarter cell mirrored in order to have symmetric cell boundaries
    % Note that the full solid model geometry is created differently
    %   since the hollow method creates ANSYS errors
    % Define Keypoints
    fprintf(A_file, 'K,1,%f,0,,\n',L/2-t);
    fprintf(A_file, 'K,2,%f,0,,\n',L/2);
    fprintf(A_file, 'K,3,%f,%f,,\n',L/2,H/2);
    fprintf(A_file, 'K,4,0,%f,,\n',H/2);
    if(rho_rel~=1)
        fprintf(A_file, 'K,5,0,%f,,\n',H/2-t);
        fprintf(A_file, 'K,6,%f,%f,,\n',L/2-t,H/2-t);
    end 
    if(rho_rel~=1)
        % Create Lines between Keypoints
        fprintf(A_file, 'LSTR,       1,       2\n');
        fprintf(A_file, 'LSTR,       2,       3\n');
        fprintf(A_file, 'LSTR,       3,       4\n');
        fprintf(A_file, 'LSTR,       4,       5\n');
        fprintf(A_file, 'LSTR,       5,       6\n');
        fprintf(A_file, 'LSTR,       6,       1\n');
        % Create Area
        fprintf(A_file, 'AL,1,2,3,4,5,6\n');
    else
         % Create Lines between Keypoints
        fprintf(A_file, 'LSTR,       1,       2\n');
        fprintf(A_file, 'LSTR,       2,       3\n');
        fprintf(A_file, 'LSTR,       3,       4\n');
        fprintf(A_file, 'LSTR,       4,       1\n');
        % Create Area
        fprintf(A_file, 'AL,1,2,3,4\n');
    end
    
    %% Mesh Generation
    % Define Mesh Size and Free Mesh
    fprintf(A_file, 'AESIZE,1,%f,\n',mesh_size);
    fprintf(A_file, 'MSHKEY,0\n');
    fprintf(A_file, 'ASEL, , , ,1\n');
    fprintf(A_file, 'AMESH,1\n');
    % Mirror Mesh
    fprintf(A_file, 'ARSYM,X,all, , , ,0,0\n');
    fprintf(A_file, 'ARSYM,Y,all, , , ,0,0\n');
    % Concatenate Mesh
    fprintf(A_file, 'NUMMRG,ALL\n');
    fprintf(A_file, 'numcomp,all \n');
    
    %% Node Locations
    fprintf(A_file, ' *VGET,xloc,NODE, ,LOC,X, , ,2  \n');
    fprintf(A_file, ' *VGET,yloc,NODE, ,LOC,Y, , ,2  \n');
    fprintf(A_file, ' *CREATE,ansuitmp  \n');
    fprintf(A_file, ' *CFOPEN,''xloca'',''txt'','' ''  \n');
    fprintf(A_file, ' *VWRITE,xloc(1,1), , , , , , , , ,  \n');
    fprintf(A_file, ' (f20.6)  \n');
    fprintf(A_file, ' *CFCLOS  \n');
    fprintf(A_file, ' *END  \n');
    fprintf(A_file, ' /INPUT,ansuitmp  \n');
    fprintf(A_file, ' !*   \n');
    fprintf(A_file, ' *CREATE,ansuitmp  \n');
    fprintf(A_file, ' *CFOPEN,''yloca'',''txt'','' ''   \n');
    fprintf(A_file, ' *VWRITE,yloc(1,1), , , , , , , , ,  \n');
    fprintf(A_file, ' (f20.6)   \n');
    fprintf(A_file, ' *CFCLOS  \n');
    fprintf(A_file, ' *END   \n');
    fprintf(A_file, ' /INPUT,ansuitmp   \n');
    
    %% Element Area
    fprintf(A_file, ' *VGET,area_elem,ELEM, ,GEOM, , ,2 \n');
    fprintf(A_file, ' *CREATE,ansuitmp \n');
    fprintf(A_file, ' *CFOPEN,''area_elem'',''txt'','' '' \n');
    fprintf(A_file, ' *VWRITE,area_elem(1,1), , , , , , , , , \n');
    fprintf(A_file, ' (f20.10) \n');
    fprintf(A_file, ' *CFCLOS \n');
    fprintf(A_file, ' *END \n');
    fprintf(A_file, ' /INPUT,ansuitmp \n');
    
    fprintf(A_file, ' SAVE,%s  \n',S_load);
    fprintf(A_file, 'FINISH \n');
    fclose(A_file);
    dos '"C:\Program Files\ANSYS Inc\v150\ansys\bin\winx64\ANSYS150.exe" -p aa_t_a -b -i square_cell.txt -o ansys_output.out'
    
    %% Organize Elements on Periodic Boundaries
    [sort_RHS_B, sort_LHS_B, sort_UHS_B, sort_BHS_B]= ...
        input_mesh_PBC(mesh_size);
    
    A_file=fopen('square_cell.txt','wt');
    fprintf(A_file, '/CLEAR,START \n');
    fprintf(A_file, 'RESUME,%s,0,0\n',S_load);
    
    %% Applying Periodic Boundary Conditions
    [nnode_RHS,nm]=size(sort_RHS_B);
    [nnode_BHS,nm]=size(sort_BHS_B);

    xL=sort_LHS_B(1,2);
    xR=sort_RHS_B(1,2);
    yB=sort_BHS_B(1,3);
    yU=sort_UHS_B(1,3);

    NEQN=0;
    
    %% Solution of the 3 Unit Macroscopic Strain Tensor Cases
    for strain_case=1:size(epsil,1)
        e11=epsil(1,strain_case);
        e22=epsil(2,strain_case);
        e12=epsil(3,strain_case);

        fprintf(A_file, ' /SOL \n');
        
        %% Defining Constraint Equations on the RHS and UHS
        fprintf(A_file, 'D,%d,UX,\n',sort_BHS_B(1,1));
        fprintf(A_file, 'D,%d,UY,\n',sort_BHS_B(1,1));
        for RHS_node_num=1:nnode_RHS
            NEQN=NEQN+1;
            fprintf(A_file, ' CE,%d,%f,%d,UX,1,%d,UX,-1, \n', ...
                NEQN,e11*(xR-xL),sort_RHS_B(RHS_node_num,1), ...
                sort_LHS_B(RHS_node_num,1));
            NEQN=NEQN+1;
            fprintf(A_file, ' CE,%d,%f,%d,UY,1,%d,UY,-1, \n', ...
                NEQN,e12*(xR-xL),sort_RHS_B(RHS_node_num,1), ...
                sort_LHS_B(RHS_node_num,1));
        end
        for BHS_node_num=1:nnode_BHS
            NEQN=NEQN+1;
            fprintf(A_file, ' CE,%d,%f,%d,UX,1,%d,UX,-1, \n', ...
                NEQN,e12*(yU-yB),sort_UHS_B(BHS_node_num,1), ...
                sort_BHS_B(BHS_node_num,1));
            NEQN=NEQN+1;
            fprintf(A_file, ' CE,%d,%f,%d,UY,1,%d,UY,-1, \n',...
                NEQN,e22*(yU-yB),sort_UHS_B(BHS_node_num,1), ...
                sort_BHS_B(BHS_node_num,1));
        end
        %% Solve
        fprintf(A_file, '/solu \n');
        fprintf(A_file, 'solve \n');
        fprintf(A_file, ' LSCLEAR,ALL \n');
        fprintf(A_file, ' CEDELE,ALL \n');
        
        %% Save stresses
        fprintf(A_file, '/POST1 \n');
        fprintf(A_file, 'ETABLE,strx,EPTO,X \n');
        fprintf(A_file, 'ETABLE,stry,EPTO,Y \n');
        fprintf(A_file, 'ETABLE,strxy,EPTO,XY \n');
        fprintf(A_file, '*VGET,strx,ELEM, ,ETAB,STRX, , ,2 \n');
        fprintf(A_file, '*VGET,stry,ELEM, ,ETAB,STRY, , ,2 \n');
        fprintf(A_file, '*VGET,strxy,ELEM, ,ETAB,STRXY, , ,2 \n');
        
        fprintf(A_file, '*CREATE,ansuitmp \n');
        fprintf(A_file, '*CFOPEN,''strx%d'',''txt'','' '' \n',strain_case);
        fprintf(A_file, '*VWRITE,strx(1,1), , , , , , , , , \n');
        fprintf(A_file, '(f20.10) \n');
        fprintf(A_file, '*CFCLOS \n');
        fprintf(A_file, '*END \n');
        
        fprintf(A_file, '/INPUT,ansuitmp \n');
        fprintf(A_file, '*CREATE,ansuitmp \n');
        fprintf(A_file, '*CFOPEN,''stry%d'',''txt'','' '' \n',strain_case);
        fprintf(A_file, '*VWRITE,stry(1,1), , , , , , , , , \n');
        fprintf(A_file, '(f20.10) \n');
        fprintf(A_file, '*CFCLOS \n');
        fprintf(A_file, '*END \n');
        
        fprintf(A_file, '/INPUT,ansuitmp \n');
        fprintf(A_file, '*CREATE,ansuitmp \n');
        fprintf(A_file, '*CFOPEN,''strxy%d'',''txt'','' '' \n',strain_case);
        fprintf(A_file, '*VWRITE,strxy(1,1), , , , , , , , , \n');
        fprintf(A_file, '(f20.10) \n');
        fprintf(A_file, '*CFCLOS \n');
        fprintf(A_file, '*END \n');
        
        fprintf(A_file, '/INPUT,ansuitmp \n');
    end
    
    fclose(A_file);
    dos '"C:\Program Files\ANSYS Inc\v150\ansys\bin\winx64\ANSYS150.exe" -p aa_t_a -b -i square_cell.txt -o ansys_output.out'
    
    %% Calculate the M matrix
    % Since three independent unit strains are applied, the values 
    % of the M matrix correspond to the stresses calculated.
    strain_matx(:,1) = load('strx1.txt');
    strain_matx(:,2) = load('stry1.txt');
    strain_matx(:,3) = load('strxy1.txt');
    
    strain_matx(:,4) = load('strx2.txt');
    strain_matx(:,5) = load('stry2.txt');
    strain_matx(:,6) = load('strxy2.txt');
    
    strain_matx(:,7) = load('strx3.txt');
    strain_matx(:,8) = load('stry3.txt');
    strain_matx(:,9) = load('strxy3.txt');
    
    M_matx=strain_matx;
    clear strain_matx
    area_elem = load('area_elem.txt');
    
    %% Calculation of the Effective Stiffness Matrix
    C_HOMOG=zeros(3,3);
    for elem_num=1:size(M_matx,1)
        M(1,1)=M_matx(elem_num,1);
        M(2,1)=M_matx(elem_num,2);
        M(3,1)=M_matx(elem_num,3);
        M(1,2)=M_matx(elem_num,4);
        M(2,2)=M_matx(elem_num,5);
        M(3,2)=M_matx(elem_num,6);
        M(1,3)=M_matx(elem_num,7);
        M(2,3)=M_matx(elem_num,8);
        M(3,3)=M_matx(elem_num,9);
        C_HOMOG=C_HOMOG+invCij*M*area_elem(elem_num);
    end
    
    C_HOMOG_ij=C_HOMOG/(unit_cell_area);
    
    %% Effective Compliance Matrix
    S=inv(C_HOMOG_ij);
    
    %% Homogenized Material Property
    Exx(i)=1/S(1,1)/E;
    Eyy(i)=1/S(2,2)/E;
    Gxy(i)=(1/S(3,3))*2*(1+PR)/E;
    %Gxy(i)=(1/S(3,3))/E;
    PR12(i)=-S(2,1)/S(1,1)/PR;
    PR21(i)=-S(1,2)/S(2,2)/PR;
    delete('*.txt');delete('file.*');delete('ansuitmp');delete('*.db');delete('*.out');
end

%% Plot figures
showme=1;
if(showme==1)
    figure(1)
    plot(rho_rel_arr,Exx,'-o',rho_rel_arr,Gxy,'-s',rho_rel_arr,PR12,'-d')
    title('Effective Material Properties vs $$\rho_{rel}$$','interpreter','latex','fontsize',12)
    xlabel('$$\rho_{rel}$$','interpreter','latex','fontsize',12)
    ylabel('Normalized Property','fontsize',12)
    axis([0 1 0 1.01])
    legend({'$\bar{E}_{xx}/E_s$','$\bar{G}_{xy}/G_s$','$\bar{\nu}_{xy}/\nu_s$'},'Interpreter','latex','Location','northwest')
    set(gcf, 'PaperPosition', [0 0 7 5]); 
    set(gcf, 'PaperSize', [7 5]);
    saveas(gcf, 'all', 'pdf');
end
