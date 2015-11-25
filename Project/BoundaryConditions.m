%% Boundary conditions for 2D unit cells
% Applying boundary conditions for uniaxial, biaxial and shear load cases
%% 14 February 2015
%% Ahmad Rafsanjani (ahmad.rafsanjani@mcgill.ca)

switch BC_type    % start of switch for boundary condition type
    %% uniform displacement
    case 'KUBC'    
        % Define Function X
        
        fprintf(Ansys_file, '*DEL,_FNCNAME \n');
        fprintf(Ansys_file, '*DEL,_FNCMTID \n');
        fprintf(Ansys_file, '*SET,_FNCNAME,''func_X'' \n');
        fprintf(Ansys_file, '*DIM,%%_FNCNAME%%,TABLE,6,3,1 \n');
        fprintf(Ansys_file, '%%_FNCNAME%%(0,0,1)= 0.0, -999\n');
        fprintf(Ansys_file, '%%_FNCNAME%%(2,0,1)= 0.0 \n');
        fprintf(Ansys_file, '%%_FNCNAME%%(3,0,1)= 0.0 \n');
        fprintf(Ansys_file, '%%_FNCNAME%%(4,0,1)= 0.0 \n');
        fprintf(Ansys_file, '%%_FNCNAME%%(5,0,1)= 0.0 \n');
        fprintf(Ansys_file, '%%_FNCNAME%%(6,0,1)= 0.0 \n');
        fprintf(Ansys_file, '%%_FNCNAME%%(0,1,1)= 1.0, 99, 0, 1, 2, 0, 0 \n');
        fprintf(Ansys_file, '%%_FNCNAME%%(0,2,1)= 0 \n');
        fprintf(Ansys_file, '%%_FNCNAME%%(0,3,1)= 0 \n');

        % Define Function Y

        fprintf(Ansys_file, '*DEL,_FNCNAME \n');
        fprintf(Ansys_file, '*DEL,_FNCMTID \n');
        fprintf(Ansys_file, '*SET,_FNCNAME,''func_Y'' \n');
        fprintf(Ansys_file, '*DIM,%%_FNCNAME%%,TABLE,6,3,1 \n');
        fprintf(Ansys_file, '%%_FNCNAME%%(0,0,1)= 0.0, -999\n');
        fprintf(Ansys_file, '%%_FNCNAME%%(2,0,1)= 0.0 \n');
        fprintf(Ansys_file, '%%_FNCNAME%%(3,0,1)= 0.0 \n');
        fprintf(Ansys_file, '%%_FNCNAME%%(4,0,1)= 0.0 \n');
        fprintf(Ansys_file, '%%_FNCNAME%%(5,0,1)= 0.0 \n');
        fprintf(Ansys_file, '%%_FNCNAME%%(6,0,1)= 0.0 \n');
        fprintf(Ansys_file, '%%_FNCNAME%%(0,1,1)= 1.0, 99, 0, 1, 3, 0, 0 \n');
        fprintf(Ansys_file, '%%_FNCNAME%%(0,2,1)= 0 \n');
        fprintf(Ansys_file, '%%_FNCNAME%%(0,3,1)= 0 \n');

        % Select boundary lines    
        fprintf(Ansys_file,'LSEL,S,LINE,,1,4,,, \n');  
        
        
        switch load_case    % start of switch for KUBC load case
            
            case 1 % uniaxial extension
                fprintf(Ansys_file,'DL,ALL,1,UX,%%func_X%% \n');
                fprintf(Ansys_file,'DL,ALL,1,UY,0 \n'); 
                
                fprintf(Ansys_file,'ALLSEL,ALL \n');
            
            case 2 % uniaxial extension
                fprintf(Ansys_file,'DL,ALL,1,UY,%%func_Y%% \n');
                fprintf(Ansys_file,'DL,ALL,1,UX,0 \n'); 
                
                fprintf(Ansys_file,'ALLSEL,ALL \n');
                
            case 3 % biaxial extension
                fprintf(Ansys_file,'DL,ALL,1,UX,%%func_X%% \n');
                fprintf(Ansys_file,'DL,ALL,1,UY,%%func_Y%% \n'); 
                
                fprintf(Ansys_file,'ALLSEL,ALL \n');
                
            case 4 % shear deformation
                fprintf(Ansys_file,'DL,ALL,1,UX,%%func_Y%% \n');
                fprintf(Ansys_file,'DL,ALL,1,UY,%%func_X%% \n');   
                
                fprintf(Ansys_file,'ALLSEL,ALL \n');
                
        end     % end of switch for KUBC load case
        
        
         
    %% Mixed uniform boundary condition
    case 'MUBC'
        switch load_case
            case 1     % uniaxial extension                
                UX1=0;  UX2=L;
                UY1=0;  UY2=0;
                
                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',0);
                fprintf(Ansys_file,'D,ALL,UX,%f \n',UX1);        

                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',L);
                fprintf(Ansys_file,'D,ALL,UX,%f \n',UX2);  

                fprintf(Ansys_file,'NSEL,S,LOC,Y,%f \n',0);
                fprintf(Ansys_file,'D,ALL,UY,%f \n',UY1); 

                fprintf(Ansys_file,'NSEL,S,LOC,Y,%f \n',H);
                fprintf(Ansys_file,'D,ALL,UY,%f \n',UY2);  
                
                fprintf(Ansys_file,'ALLSEL,ALL \n');

            case 2     % uniaxial extension                
                UX1=0;  UX2=0;
                UY1=0;  UY2=H;
                
                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',0);
                fprintf(Ansys_file,'D,ALL,UX,%f \n',UX1);        

                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',L);
                fprintf(Ansys_file,'D,ALL,UX,%f \n',UX2);  

                fprintf(Ansys_file,'NSEL,S,LOC,Y,%f \n',0);
                fprintf(Ansys_file,'D,ALL,UY,%f \n',UY1); 

                fprintf(Ansys_file,'NSEL,S,LOC,Y,%f \n',H);
                fprintf(Ansys_file,'D,ALL,UY,%f \n',UY2);  
                
                fprintf(Ansys_file,'ALLSEL,ALL \n');
                
            case 3               
                UX1=0;  UX2=L;
                UY1=0;  UY2=H;
                
                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',0);
                fprintf(Ansys_file,'D,ALL,UX,%f \n',UX1);        

                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',L);
                fprintf(Ansys_file,'D,ALL,UX,%f \n',UX2);  

                fprintf(Ansys_file,'NSEL,S,LOC,Y,%f \n',0);
                fprintf(Ansys_file,'D,ALL,UY,%f \n',UY1); 

                fprintf(Ansys_file,'NSEL,S,LOC,Y,%f \n',H);
                fprintf(Ansys_file,'D,ALL,UY,%f \n',UY2);
                
                fprintf(Ansys_file,'ALLSEL,ALL \n');
                
            case 4
                UX1=0;  UX2=H;
                UY1=0;  UY2=L;
                
                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',0);
                fprintf(Ansys_file,'D,ALL,UY,%f \n',UY1);        

                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',L);
                fprintf(Ansys_file,'D,ALL,UY,%f \n',UY2);  

                fprintf(Ansys_file,'NSEL,S,LOC,Y,%f \n',0);
                fprintf(Ansys_file,'D,ALL,UX,%f \n',UX1); 

                fprintf(Ansys_file,'NSEL,S,LOC,Y,%f \n',H);
                fprintf(Ansys_file,'D,ALL,UX,%f \n',UX2);
                
                fprintf(Ansys_file,'ALLSEL,ALL \n');
        end
        
        
    %% uniform stress boundary condition
    case 'SUBC'     
        P=1;
        Fn=P/n;
        d=1/2; 
        switch load_case        % start of switch for SUBC load cases
            
            case 1  % uniaxial tension X
                
                % constrain rigid body motion
        
                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',0);
                fprintf(Ansys_file,'NSEL,R,LOC,Y,%f \n',0.5*H);
                fprintf(Ansys_file,'D,ALL,UY,0 \n');
               

                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',0.5*L);
                fprintf(Ansys_file,'NSEL,R,LOC,Y,%f \n',0);
                fprintf(Ansys_file,'D,ALL,UX,0 \n');  

                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',0.5*L);
                fprintf(Ansys_file,'NSEL,R,LOC,Y,%f \n',H);
                fprintf(Ansys_file,'D,ALL,UX,0 \n');   
                
                % apply pressure on edges
                
                fprintf(Ansys_file,'LSEL,S,LOC,X,%f,,,, \n',0);
                fprintf(Ansys_file,'SFL, ALL, PRES, %f, , ,  \n',-P);    
                
                fprintf(Ansys_file,'LSEL,S,LOC,X,%f,,,, \n',L);
                fprintf(Ansys_file,'SFL, ALL, PRES, %f, , ,  \n',-P);
                
                fprintf(Ansys_file,'ALLSEL,ALL \n');
                
            case 2  % uniaxial tension Y
                
                % constrain rigid body motion
        
                fprintf(Ansys_file,'NSEL,S,LOC,Y,%f \n',0);
                fprintf(Ansys_file,'NSEL,R,LOC,X,%f \n',0.5*L);
                fprintf(Ansys_file,'D,ALL,UX,0 \n');
               

                fprintf(Ansys_file,'NSEL,S,LOC,Y,%f \n',0.5*H);
                fprintf(Ansys_file,'NSEL,R,LOC,X,%f \n',0);
                fprintf(Ansys_file,'D,ALL,UY,0 \n');  

                fprintf(Ansys_file,'NSEL,S,LOC,Y,%f \n',0.5*H);
                fprintf(Ansys_file,'NSEL,R,LOC,X,%f \n',L);
                fprintf(Ansys_file,'D,ALL,UY,0 \n');   
                
                % apply pressure on edges
                
                fprintf(Ansys_file,'LSEL,S,LOC,Y,%f,,,, \n',0);
                fprintf(Ansys_file,'SFL, ALL, PRES, %f, , ,  \n',-P);    
                
                fprintf(Ansys_file,'LSEL,S,LOC,Y,%f,,,, \n',H);
                fprintf(Ansys_file,'SFL, ALL, PRES, %f, , ,  \n',-P);
                
                fprintf(Ansys_file,'ALLSEL,ALL \n');
                   
           
            case 3 % biaxial tension
                
                 
                % constrain rigid body motion
                
                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',0);
                fprintf(Ansys_file,'NSEL,R,LOC,Y,%f \n',0.5*H);
                fprintf(Ansys_file,'D,ALL,UY,0 \n');
               

                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',0.5*L);
                fprintf(Ansys_file,'NSEL,R,LOC,Y,%f \n',0);
                fprintf(Ansys_file,'D,ALL,UX,0 \n');  

                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',0.5*L);
                fprintf(Ansys_file,'NSEL,R,LOC,Y,%f \n',H);
                fprintf(Ansys_file,'D,ALL,UX,0 \n');   
                
                
                % apply pressure on edges
                
                fprintf(Ansys_file,'LSEL,S,LOC,X,%f,,,, \n',0);
                fprintf(Ansys_file,'SFL, ALL, PRES, %f, , ,  \n',-P);    
                
                fprintf(Ansys_file,'LSEL,S,LOC,X,%f,,,, \n',L);
                fprintf(Ansys_file,'SFL, ALL, PRES, %f, , ,  \n',-P);
                
                fprintf(Ansys_file,'LSEL,S,LOC,Y,%f,,,, \n',0);
                fprintf(Ansys_file,'SFL, ALL, PRES, %f, , ,  \n',-P);    
                
                fprintf(Ansys_file,'LSEL,S,LOC,Y,%f,,,, \n',H);
                fprintf(Ansys_file,'SFL, ALL, PRES, %f, , ,  \n',-P);
                
                fprintf(Ansys_file,'ALLSEL,ALL \n');       
                
           
            case 4  % shear stress
                
                
                % constrain rigid body motion
        
                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',0);
                fprintf(Ansys_file,'NSEL,R,LOC,Y,%f \n',0.5*H);
                fprintf(Ansys_file,'D,ALL,UX,0 \n');


                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',L);
                fprintf(Ansys_file,'NSEL,R,LOC,Y,%f \n',0.5*H);
                fprintf(Ansys_file,'D,ALL,UX,0 \n');

                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',0.5*L);
                fprintf(Ansys_file,'NSEL,R,LOC,Y,%f \n',0);
                fprintf(Ansys_file,'D,ALL,UY,0 \n');  

                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',0.5*L);
                fprintf(Ansys_file,'NSEL,R,LOC,Y,%f \n',H);
                fprintf(Ansys_file,'D,ALL,UX,0 \n');
                fprintf(Ansys_file,'D,ALL,UY,0 \n');     
                
                % forces on edges except corners
                
                fprintf(Ansys_file,'LSEL,S,LOC,Y,%f,,,, \n',0);
                fprintf(Ansys_file,'NSLL,S,0 \n');
                fprintf(Ansys_file,'F, ALL, FX, %f, , ,  \n',-Fn);

                fprintf(Ansys_file,'LSEL,S,LOC,Y,%f,,,, \n',H);
                fprintf(Ansys_file,'NSLL,S,0 \n');
                fprintf(Ansys_file,'F, ALL, FX, %f, , ,  \n',Fn);

                fprintf(Ansys_file,'LSEL,S,LOC,X,%f,,,, \n',L);
                fprintf(Ansys_file,'NSLL,S,0 \n');
                fprintf(Ansys_file,'F, ALL, FY, %f, , ,  \n',Fn);

                fprintf(Ansys_file,'LSEL,S,LOC,X,%f,,,, \n',0);
                fprintf(Ansys_file,'NSLL,S,0 \n');
                fprintf(Ansys_file,'F, ALL, FY, %f, , ,  \n',-Fn);
                
                
                % forces on corners
    
                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',0);
                fprintf(Ansys_file,'NSEL,R,LOC,Y,%f \n',0);
                fprintf(Ansys_file,'F, ALL, FX, %f, , ,  \n',-Fn*d);
                fprintf(Ansys_file,'F, ALL, FY, %f, , ,  \n',-Fn*d);

                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',L);
                fprintf(Ansys_file,'NSEL,R,LOC,Y,%f \n',0);
                fprintf(Ansys_file,'F, ALL, FX, %f, , ,  \n',-Fn*d);
                fprintf(Ansys_file,'F, ALL, FY, %f, , ,  \n',Fn*d);   

                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',L);
                fprintf(Ansys_file,'NSEL,R,LOC,Y,%f \n',H);
                fprintf(Ansys_file,'F, ALL, FX, %f, , ,  \n',Fn*d);
                fprintf(Ansys_file,'F, ALL, FY, %f, , ,  \n',Fn*d); 

                fprintf(Ansys_file,'NSEL,S,LOC,X,%f \n',0);
                fprintf(Ansys_file,'NSEL,R,LOC,Y,%f \n',H);
                fprintf(Ansys_file,'F, ALL, FX, %f, , ,  \n',Fn*d);
                fprintf(Ansys_file,'F, ALL, FY, %f, , ,  \n',-Fn*d);
                
                fprintf(Ansys_file,'ALLSEL,ALL \n');
                
        end     % end of switch for SUBC load cases
        

        
end   % end of switch for boundary condition type
    


