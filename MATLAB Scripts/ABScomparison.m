% ABScomparison.m
% --------------
% By: Augustas Jackevic
% Date: July 2021
% Script Description:
% -------------------
% This script compares the different methods of acquiring an absolute value
% (abs) of complex numbers in a fixed-point number format. three different
% sets of Alpha max plus Beta min algorithms are implemented (bete = 1/2,
% 1/4, and 3/8) and compared.
%
%
% The algorithm works in the folloing manner:
% Output = Alpha(|max value|) + Beta(|min value|)
% The larger abs value of the complex pair is multiplied by alpha whilst
% the smaller abs value is multiplied by the beta value.



% Clear any saved vairable from MATLAB's workspace section.
clear all


% Creating a rand complex array of 1000 values ranging from minBound
% to maxBound.

% Creating the max and min bounds for the rand arrays.
minBound = -100000000;
maxBound = 100000000;
dataLength = 100000;

% Creating the random real and imaginary array values using the max, min
% bounds, array length.
randRealValues = randi([minBound,maxBound],1,dataLength);
randImagValues = randi([minBound,maxBound],1,dataLength);

% Creating the complex array from the arrays randRealValues and
% randImagValues.
complexData = complex(randRealValues, randImagValues);


% Calculating the ideal ABS output.
idealOut = abs(complexData);







%%
% Alpha (1/1) max plus beta (1/2) min.

% Empty array to store the alpha max plus beta min values.
alphaBetaOut1 = [];


% A for loop to acquire the abs values from the variable complexData.
for i = 1:1:dataLength
    % If the real abs value is larger than imag abs value, set
    % absAlphaValue to the real abs value and absBetaValue to the imag abs
    % value. Same but the other way round if the if statement does not meet.
    if(abs(real(complexData(i))) >= abs(imag(complexData(i))))
       absAlphaValue = abs(real(complexData(i)));
       absBetaValue = abs(imag(complexData(i)));
    else
       absAlphaValue = abs(imag(complexData(i)));
       absBetaValue = abs(real(complexData(i)));
    end
    % Bit shift absBetaValue by 1 to aquire the required 1/2 value. It
    % should be noted that this value is rounded down.
    absBetaValue = bitshift(absBetaValue,-1);
    % Added the alpha and beta value to the output array.
    alphaBetaOut1 = [alphaBetaOut1 (absAlphaValue + absBetaValue)];
end








%%
% Alpha (1/1) max plus beta (1/4) min.


% Empty array to store the alpha max plus beta min values.
alphaBetaOut2 = [];

% A for loop to acquire the abs values from the variable complexData.
for i = 1:1:dataLength
    % If the real abs value is larger than imag abs value, set
    % absAlphaValue to the real abs value and absBetaValue to the imag abs
    % value. Same but the other way round if the if statement does not meet.
    if(abs(real(complexData(i))) >= abs(imag(complexData(i))))
       absAlphaValue = abs(real(complexData(i)));
       absBetaValue = abs(imag(complexData(i)));
    else
       absAlphaValue = abs(imag(complexData(i)));
       absBetaValue = abs(real(complexData(i)));
    end
    % Bit shift absBetaValue by 2 to aquire the required 1/4 value. It
    % should be noted that this value is rounded down.
    absBetaValue = bitshift(absBetaValue,-2);
    % Added the alpha and beta value to the output array.
    alphaBetaOut2 = [alphaBetaOut2 (absAlphaValue + absBetaValue)];
end








%%
% Alpha (1/1) max plus beta (3/8) min.


% Empty array to store the alpha max plus beta min values.
alphaBetaOut3 = [];

% A for loop to acquire the abs values from the variable complexData.
for i = 1:1:dataLength
    % If the real abs value is larger than imag abs value, set
    % absAlphaValue to the real abs value and absBetaValue to the imag abs
    % value. Same but the other way round if the if statement does not meet.
    if(abs(real(complexData(i))) >= abs(imag(complexData(i))))
       absAlphaValue = abs(real(complexData(i)));
       absBetaValue = abs(imag(complexData(i)));
    else
       absAlphaValue = abs(imag(complexData(i)));
       absBetaValue = abs(real(complexData(i)));
    end
    % Bit shift absBetaValue by 3 to aquire the 1/8 value and then 
    % muiltiply by 3 to aquire the 3/8 value. It should be noted that this 
    % value is rounded down.
    absBetaValue = (bitshift(absBetaValue * 3,-3));
    % Added the alpha and beta value to the output array.
    alphaBetaOut3 = [alphaBetaOut3 (absAlphaValue + absBetaValue)];
end





%%
% Calculation of the abs values using Non-Restoring Square Root algorithm.
% The values are squared and added then passed through squareRootCal
% function to calculate the abs value.
squareRootMethod = [];
for i = 1:1:dataLength
    realSquared = real(complexData(i)) * real(complexData(i));
    imagSquared = imag(complexData(i)) * imag(complexData(i));
    squareRootMethod = [squareRootMethod squareRootCal(realSquared + imagSquared)];  
end






%%
% Calculaing the error values from the obtianed alpha max plus beta min 
%algorithm and the non-restoring square root algorithm. The average and max
%errors are also calculated.


% Empty arrays which are then used to store the errors.
absOut1Error = [];
absOut2Error = [];
absOut3Error = [];
squrOutError = [];


% A for loop that is used to calculate the error of each value and then
% store it in absOutXError arrays.
for i = 1:1:dataLength
    % Error = (|obtained value - expected value|/expected value) * 100
    error1 = (abs((alphaBetaOut1(i) - idealOut(i)))/idealOut(i)) * 100;
    error2 = (abs((alphaBetaOut2(i) - idealOut(i)))/idealOut(i)) * 100;
    error3 = (abs((alphaBetaOut3(i) - idealOut(i)))/idealOut(i)) * 100;
    squrError = (abs((squareRootMethod(i) - idealOut(i)))/idealOut(i)) * 100;
    
    
    
    % Store the calculated errors in the array.
    absOut1Error = [absOut1Error error1];  
    absOut2Error = [absOut2Error error2];  
    absOut3Error = [absOut3Error error3];  
    squrOutError = [squrOutError squrError];
end


avgError1str = "Avg error: " + string(round(mean(absOut1Error),2));
avgError2str = "Avg error: " + string(round(mean(absOut2Error),2));
avgError3str = "Avg error: " + string(round(mean(absOut3Error),2));
avgSquarErrorstr = "Avg error: " + string(round(mean(squrOutError),2));

maxError1str = "Max error: " + string(round(max(absOut1Error),2));
maxError2str = "Max error: " + string(round(max(absOut2Error),2));
maxError3str = "Max error: " + string(round(max(absOut3Error),2));
maxSquarErrorstr = "Max error: " + string(round(max(squrOutError),2));




%%
% Ploting the errors.

xAxis = 1:1:dataLength;

figure(1)
tiledlayout(3,1);


nexttile
scatter(xAxis, absOut1Error,3,'x');
title('Aquired error through alpha (1/1) max plus beta (1/2) min alogirthm.')
ylabel('Error (%)')
xlabel('Data points')
ylim([0 13]);
yticks([0 2 4 6 8 10 12]);
annotation('textbox',[0.91 .7 .1 .2],'String',avgError1str,'EdgeColor','none')
annotation('textbox',[0.91 .67 .1 .2],'String',maxError1str,'EdgeColor','none')



nexttile
scatter(xAxis, absOut2Error,3,'x');
title('Aquired error through alpha (1/1) max plus beta (1/4) min alogirthm.')
ylabel('Error (%)')
xlabel('Data points')
ylim([0 13]);
yticks([0 2 4 6 8 10 12]);
annotation('textbox',[0.91 .4 .1 .2],'String',avgError2str,'EdgeColor','none')
annotation('textbox',[0.91 .37 .1 .2],'String',maxError2str,'EdgeColor','none')




nexttile
scatter(xAxis, absOut3Error,3,'x');
title('Aquired error through alpha (1/1) max plus beta (3/8) min alogirthm.')
ylabel('Error (%)')
xlabel('Data points')
ylim([0 8]);
annotation('textbox',[0.91 .08 .1 .2],'String',avgError3str,'EdgeColor','none')
annotation('textbox',[0.91 .05 .1 .2],'String',maxError3str,'EdgeColor','none')

figure(2)
scatter(xAxis, squrOutError,3,'x');
title('Aquired error through non-restoring square root algorithm.')
ylabel('Error (%)')
xlabel('Data points')
annotation('textbox',[0.91 .45 .1 .2],'String',avgSquarErrorstr,'EdgeColor','none')
annotation('textbox',[0.91 .42 .1 .2],'String',maxSquarErrorstr,'EdgeColor','none')



figure(3)
histogram(absOut1Error);
title('Aquired error of alpha (1/1) max plus beta (1/2) min alogirthm');
ylabel('Number of data points');
xlabel('Error (%)');
set(gca,'FontSize',30);


figure(4)
histogram(absOut2Error);
title('Aquired error of alpha (1/1) max plus beta (1/4) min alogirthm')
ylabel('Number of data points');
xlabel('Error (%)');
set(gca,'FontSize',30);


figure(5)
histogram(absOut3Error);
title('Aquired error of alpha (1/1) max plus beta (3/8) min alogirthm')
ylabel('Number of data points');
xlabel('Error (%)');
set(gca,'FontSize',30);


figure(6)
histogram(squrOutError);
title('Aquired error of non-restoring square root algorithm')
ylabel('Number of data points');
xlabel('Error (%)');
set(gca,'FontSize',30);