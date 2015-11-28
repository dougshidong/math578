function createAnsysIn(ansys_input,resultf, ...
                       E,nu,H,L,n, ...
                       dispLocUx, dispLocUy, ...
                       loadLoc,loadVal)
%createAnsysIn - Create an ANSYS input file (APDL)
% Creates a rectangle geometry with zero displacement locations
% and loads at specified locations
%
% Inputs:
%    ansys_input, resultf - String for input/results file names. 
%                           No file extension for resultf
%    E, nu                - Young's Modulus, Poisson's Ratio
%    H, L                 - Rectangle dimensions (Height and Length)
%    n                    - Number of elements along the length
%    dispLocUx, dispLocUy - Locations where Ux = 0, Uy = 0
%    loadLoc, loadVal     - Location of the loads
%
% Input Formats
%    ansys_input, resultf - String
%    E, nu, H, L          - Double
%    n                    - Integer
%    dispLocUx, dispLocUy - N x 2 Double array. 
%                           Each row contains X and Y components
%    loadLoc, loadVal     - N x 2 Double array. 
%                           Each row contains X and Y components
%
% Author: Doug Shi-Dong
% email: doug.shi-dong@mail.mcgill.ca
% date: November 2015

%% Preprocessing

Ansys_file=fopen(ansys_input,'wt');
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
% Element Type and Size
elem_type='PLANE42';
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

% Create area
fprintf(Ansys_file, 'AL,1,2,3,4\n');

% Assign Element Type to Mesh
fprintf(Ansys_file, 'ASEL,S,AREA,,1 \n');
fprintf(Ansys_file, 'AATT,1, ,1,0, \n');

% Mesh Size
elem_size=L/n;
fprintf(Ansys_file, 'AESIZE,ALL, %f,  \n',elem_size);

% MSHKEY, KEY  free meshing or mapped meshing
fprintf(Ansys_file, 'MSHKEY,0\n');
fprintf(Ansys_file, 'AMESH,ALL\n');

%% Constrain Rigid Body Motion

% Ux = 0
nUx = size(dispLocUx,1);
for i = 1 : nUx
    XLoc = dispLocUx(i,1) * L;
    YLoc = dispLocUx(i,2) * H;
        
    fprintf(Ansys_file,'NSEL,S,NODE,,NODE(%f,%f,0) \n',XLoc,YLoc);
    fprintf(Ansys_file,'D,ALL,UX,0 \n');
    fprintf(Ansys_file,'D,ALL,UY,0 \n');
    fprintf(Ansys_file,'ALLSEL,ALL \n');
end
% Uy = 0
nUy = size(dispLocUy,1);
for i = 1 : nUy
    XLoc = dispLocUy(i,1) * L;
    YLoc = dispLocUy(i,2) * H;
        
    fprintf(Ansys_file,'NSEL,S,NODE,,NODE(%f,%f,0) \n',XLoc,YLoc);
    fprintf(Ansys_file,'D,ALL,UX,0 \n');
    fprintf(Ansys_file,'D,ALL,UY,0 \n');
    fprintf(Ansys_file,'ALLSEL,ALL \n');
end

%% Loads on Nodes

nload = size(loadLoc,1);
for i = 1 : nload
    loadLocX = loadLoc(i,1) * L;
    loadLocY = loadLoc(i,2) * H;
    
    loadValX = loadVal(i,1);
    loadValY = loadVal(i,2);
    
    fprintf(Ansys_file,'NSEL,S,NODE,,NODE(%f,%f,0) \n',loadLocX,loadLocY);
    fprintf(Ansys_file,'F, ALL, FX, %f, , ,  \n',loadValX);
    fprintf(Ansys_file,'F, ALL, FY, %f, , ,  \n',loadValY);
    fprintf(Ansys_file,'ALLSEL,ALL \n');
end

fprintf(Ansys_file, 'NUMMRG,ALL\n');
fprintf(Ansys_file,'ALLSEL,ALL \n');   

%% Solve

fprintf(Ansys_file, '/SOL \n');
fprintf(Ansys_file, '/solu \n');
fprintf(Ansys_file, 'solve \n');

%% Postprocessing

fprintf(Ansys_file, '/POST1 \n');

% Output Stress Components 
fprintf(Ansys_file, 'ETABLE,s_xx,S,X \n');
fprintf(Ansys_file, '*VGET,s_xx,ELEM, ,ETAB,s_xx, , ,2  \n');

fprintf(Ansys_file, 'ETABLE,s_yy,S,Y \n');
fprintf(Ansys_file, '*VGET,s_yy,ELEM, ,ETAB,s_yy, , ,2  \n');  

fprintf(Ansys_file, 'ETABLE,s_xy,S,XY \n');
fprintf(Ansys_file, '*VGET,s_xy,ELEM, ,ETAB,s_xy, , ,2  \n'); 

fprintf(Ansys_file, 'ETABLE,s_1,S,1 \n');
fprintf(Ansys_file, '*VGET,s_1,ELEM, ,ETAB,s_1, , ,2  \n');

fprintf(Ansys_file, 'ETABLE,s_2,S,2 \n');
fprintf(Ansys_file, '*VGET,s_2,ELEM, ,ETAB,s_2, , ,2  \n');  

fprintf(Ansys_file, 'ETABLE,s_vm,S,EQV \n');
fprintf(Ansys_file, '*VGET,s_vm,ELEM, ,ETAB,s_vm, , ,2  \n'); 

fprintf(Ansys_file, '!Uncomment below to plot VM stresses in APDL \n');
fprintf(Ansys_file, '!PLETAB,s_vm,NOAVG \n');

fprintf(Ansys_file, '*CFOPEN,''%s'',''txt'','' '' \n', resultf);
fprintf(Ansys_file, ['*VWRITE,s_xx(1),s_yy(1),s_xy(1),'...
                    's_1(1),s_2(1),s_vm(1), , \n']);
fprintf(Ansys_file, '(f20.10,f20.10,f20.10,f20.10,f20.10,f20.10) \n');
fprintf(Ansys_file, '*CFCLOS \n');
fprintf(Ansys_file, '*END \n');

fclose(Ansys_file);
    
    