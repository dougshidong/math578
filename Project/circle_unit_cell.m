%% MATLAB script for preparation of ANSYS input file
% Computational homogenization of a rectangular unit cell
%% 15 February 2015
%% Ahmad Rafsanjani (ahmad.rafsanjani@mcgill.ca)



function circle_unit_cell(ansys_run,ansys_file_name, BC_type,load_case,E,nu,H,L,t,n)



%clc
format long


elem_type='PLANE42';
elem_size=L/n;



    %% Writing ANSYS APDL

    %% Preprocessing
    %%
    
    % while solution_garantee==0 &&count<6

    result_file=fopen('output_res.txt','wt');
    fprintf(result_file, '-10001\n');
    fprintf(result_file, '-10001\n');
    fclose(result_file);

    Ansys_file=fopen(ansys_file_name,'wt');
    fprintf(Ansys_file, '/CLEAR,START \n');
    fprintf(Ansys_file, '/NOPR\n');
    fprintf(Ansys_file, '/PMETH,OFF,0\n');
    fprintf(Ansys_file, 'KEYW,PR_SET,1\n');
    fprintf(Ansys_file, 'KEYW,PR_STRUC,1 	!*Static structural study\n');
    fprintf(Ansys_file, 'KEYW,PR_THERM,0 \n');
    fprintf(Ansys_file, 'KEYW,PR_FLUID,0 \n');
    fprintf(Ansys_file, 'KEYW,PR_ELMAG,0 \n');
    fprintf(Ansys_file, 'KEYW,MAGNOD,0 \n');
    fprintf(Ansys_file, 'KEYW,MAGEDG,0 \n');
    fprintf(Ansys_file, 'KEYW,MAGHFE,0 \n');
    fprintf(Ansys_file, 'KEYW,MAGELC,0 \n');
    fprintf(Ansys_file, 'KEYW,PR_MULTI,0\n');
    fprintf(Ansys_file, 'KEYW,PR_CFD,0\n');
    fprintf(Ansys_file, '/GO 			!*Reactives supressed printout\n');
    fprintf(Ansys_file, '/PREP7  		!*Begin preprocesing\n');
    
    % element type
    fprintf(Ansys_file, 'ET,1,%s\n',elem_type); 
    % Defines a temperature table for material properties.
    fprintf(Ansys_file, 'MPTEMP,,,,,,,,\n'); 
    % Defines property data to be associated with the temperature table.
    fprintf(Ansys_file, 'MPTEMP,1,0\n');
    fprintf(Ansys_file, 'MPDATA,EX,1,,%f\n',E);
    fprintf(Ansys_file, 'MPDATA,PRXY,1,,%f\n',nu);

    % Defines keypoints   
    % K, NPT, X, Y, Z
    fprintf(Ansys_file, 'K,1,0,0,,\n');
    fprintf(Ansys_file, 'K,2,%f,0,,\n',L);
    fprintf(Ansys_file, 'K,3,%f,%f,,\n',L,H);
    fprintf(Ansys_file, 'K,4,0,%f,,\n',H);


    % Defines a straight line irrespective of the active coordinate system.
    % LSTR, P1, P2
    
    fprintf(Ansys_file, 'LSTR,       1,       2\n');
    fprintf(Ansys_file, 'LSTR,       2,       3\n');
    fprintf(Ansys_file, 'LSTR,       3,       4\n');
    fprintf(Ansys_file, 'LSTR,       4,       1\n');

    fprintf(Ansys_file, 'AL,1,2,3,4\n');
    fprintf(Ansys_file, 'CYL4,0.5,0.5,%f \n',L/2-t);
    fprintf(Ansys_file, 'ASBA,       1,2 \n');
    fprintf(Ansys_file, 'AESIZE, 3, %f,  \n',elem_size);
    
    % MSHKEY, KEY  free meshing or mapped meshing
    fprintf(Ansys_file, 'MSHKEY,0\n');
    fprintf(Ansys_file, 'AMESH,ALL\n');
    

    
    
    % apply boundary condition
    BoundaryConditions;
    
    % Merges coincident or equivalently defined items
    fprintf(Ansys_file, 'NUMMRG,ALL\n');
    fprintf(Ansys_file,'ALLSEL,ALL \n');   
        
    %% Solution
    %% Solve the problem
    
    

    fprintf(Ansys_file, '/SOL \n');
    fprintf(Ansys_file, '/solu \n');
    fprintf(Ansys_file, 'solve \n');

    
    
    
    %% Postprocessing
    %% output desired results

    fprintf(Ansys_file, '/POST1 \n');

    % output volume 
    fprintf(Ansys_file, 'ETABLE,VOL,VOLU, \n');
    fprintf(Ansys_file, '*VGET,volume,ELEM, ,ETAB,VOL, , ,2  \n');

    % output strain components 
    fprintf(Ansys_file, 'ETABLE,e_xx,EPEL,X \n');
    fprintf(Ansys_file, '*VGET,e_xx,ELEM, ,ETAB,e_xx, , ,2  \n');

    fprintf(Ansys_file, 'ETABLE,e_yy,EPEL,Y \n');
    fprintf(Ansys_file, '*VGET,e_yy,ELEM, ,ETAB,e_yy, , ,2  \n');

    fprintf(Ansys_file, 'ETABLE,e_xy,EPEL,XY \n');
    fprintf(Ansys_file, '*VGET,e_xy,ELEM, ,ETAB,e_xy, , ,2  \n');

    % output stress components 
    fprintf(Ansys_file, 'ETABLE,s_xx,S,X \n');
    fprintf(Ansys_file, '*VGET,s_xx,ELEM, ,ETAB,s_xx, , ,2  \n');

    fprintf(Ansys_file, 'ETABLE,s_yy,S,Y \n');
    fprintf(Ansys_file, '*VGET,s_yy,ELEM, ,ETAB,s_yy, , ,2  \n');

    fprintf(Ansys_file, 'ETABLE,s_xy,S,XY \n');
    fprintf(Ansys_file, '*VGET,s_xy,ELEM, ,ETAB,s_xy, , ,2  \n');    
    
    % output strain energy 
    fprintf(Ansys_file, 'ETABLE,ENERGY,SEDN, \n');
    fprintf(Ansys_file, '*VGET,energy,ELEM, ,ETAB,ENERGY, , ,2  \n');

    
    fprintf(Ansys_file, '*CREATE,ansuitmp \n');
    fprintf(Ansys_file, '*CFOPEN,''results_%s_%i'',''txt'','' '' \n',BC_type,load_case);
    fprintf(Ansys_file, '*VWRITE,volume(1),e_xx(1),e_yy(1),e_xy(1),s_xx(1),s_yy(1),s_xy(1),energy(1), , \n');
    fprintf(Ansys_file, '(f20.10,f20.10,f20.10,f20.10,f20.10,f20.10,f20.10,f20.10) \n');
    fprintf(Ansys_file, '*CFCLOS \n');
    fprintf(Ansys_file, '*END \n');
    fprintf(Ansys_file, '/INPUT,ansuitmp \n'); 
     
    
    fclose(Ansys_file);   % writing ANSYS file is finished.
    
    %% Run ANSYS from MATLAB    

    dos(ansys_run);

 


