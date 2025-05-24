
function mk = graphon_mean(GraphonName, MotifName)
    switch GraphonName
        
        case 'NewSmoothGraphon2'
            switch MotifName
            case 'Triangle'
                mk = 3181/1715;  %% CORRECTED
            case 'Vshape'
                mk = 918/245;    %% CORRECTED
            end

        case 'NewSmoothGraphon4'
            switch MotifName
            case 'Triangle'
                mk = (7*exp(-3) + 11)/(8*(-exp(-3) + 1));  % coef=3, CORRECTED
                % mk = (-1*exp(-5)+1)^2 * (13*exp(-5)+17)/1000;  % coef=5
            case 'Vshape'
                mk = (9*exp(-3) - 27)/(8*exp(-3) - 8);  % coef=3, CORRECTED
                % mk = (3*exp(-10) - 36*exp(-5) + 33)/200;  % coef=5
            end


        case 'NewBlockModel1'
            switch MotifName
            case 'Triangle'
                mk = 2.48497;
            case 'Vshape'
                mk = 3.64463;
            end

        case 'NewBlockModel2'
            switch MotifName
            case 'Triangle'
                mk = 1.11561;
            case 'Vshape'
                mk = 3.22485;
            end


        case 'NewDegenGraphon1'
            switch MotifName
            case 'Triangle'
                mk = 370/343;
            case 'Vshape'
                mk = 3;
            end

        case 'NewDegenGraphon2'
            switch MotifName
            case 'Triangle'
                mk = 1;
            case 'Vshape'
                mk = 3;
            end


%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%



        case 'BlockModel1'
            switch MotifName
            case 'Triangle'
                mk = 1.48148;
            case 'Vshape'
                mk = 1.11111*3;
            case 'ThreeStar'
                mk =  1.48148*4;               
            end

        case 'BlockModel2'
            switch MotifName
            case 'Triangle'
                mk = 1.86589;
            case 'Vshape'
                mk = 1.18367*3;
            case 'ThreeStar'
                mk =  1.86589*4;                
            end

        case 'BlockModel3'
            switch MotifName
            case 'Triangle'
                mk = 1.33523;
            case 'Vshape'
                mk = 1.09343*3;
            case 'ThreeStar'
                mk =  1.33523*4;            
            end

        case 'BlockModel4'
            switch MotifName
            case 'Triangle'
                mk = 1.42383;
            case 'Vshape'
                mk = 1.125*3;
            case 'ThreeStar'
                mk =  1.42383*4;              
            end
    
        case 'BlockModel5'
            switch MotifName
            case 'Triangle'
                mk = 1.65306;
            case 'Vshape'
                mk = 1.16327*3;
            case 'ThreeStar'
                mk =  1.65306*4;            
            end
    
        case 'SmoothGraphon1'
            switch MotifName
            case 'Triangle'
                mk = 1.25;
            case 'Vshape'
                mk = 1.08333*3;
            case 'ThreeStar'
                mk = 1.25*4;              
            end

        case 'SmoothGraphon2'   
            switch MotifName
            case 'Triangle'
                mk = 3181/1715;
            case 'Vshape'
                mk = 918/245;
            case 'ThreeStar'
                mk = 1.85481*4;  
            end
    
        case 'SmoothGraphon3'   
            switch MotifName
            case 'Triangle'
                mk = 1.06354;
            case 'Vshape'
                mk = 1.02075*3;
            case 'ThreeStar'
                mk = 1.06354*4;             
            end

        case 'SmoothGraphon4'   
            switch MotifName
            case 'Triangle'
                mk = (1 + exp(1/3))^3/(216*(-1 + exp(1/3))^3);
            case 'Vshape'
                mk = 1/2 + 1/(-1 + exp(1/3));
            case 'ThreeStar'
                mk = 1.02798*4;            
            end
    
        case 'SmoothGraphon5'   
            switch MotifName
            case 'Triangle'
                mk = 1.01867;
            case 'Vshape'
                mk = 1.00636*3;
            case 'ThreeStar'
                mk = 1.01867*4;
            end

        case 'SmoothGraphoncomplex'     
            switch MotifName
            case 'Triangle'
                mk = 1.63853;
            case 'Vshape'
                mk = 1.19031*3;        
            case 'ThreeStar'
                mk = 1.63853*4;
            end

    end
end