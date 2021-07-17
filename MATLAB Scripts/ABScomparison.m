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




% Creating a rand complex array of 1000 values ranging from minBound
% to maxBound.

% Creating the max and min bounds for the rand arrays.
minBound = -100000000;
maxBound = 100000000;
dataLength = 1000;

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
    absBetaValue = (bitshift(absBetaValue,-3) * 3);
    % Added the alpha and beta value to the output array.
    alphaBetaOut3 = [alphaBetaOut3 (absAlphaValue + absBetaValue)];
end






%%
% Calculaing the error values from the obtianed alphaBetaOut values.


% Empty arrays which are then used to store the errors.
absOut1Error = [];
absOut2Error = [];
absOut3Error = [];


% A for loop that is used to calculate the error of each value and then
% store it in absOutXError arrays.
for i = 1:1:dataLength
    % Error = (|obtained value - expected value|/expected value) * 100
    error1 = (abs((alphaBetaOut1(i) - idealOut(i)))/idealOut(i)) * 100;
    error2 = (abs((alphaBetaOut2(i) - idealOut(i)))/idealOut(i)) * 100;
    error3 = (abs((alphaBetaOut3(i) - idealOut(i)))/idealOut(i)) * 100;
    
    
    % Store the calculated errors in the array.
    absOut1Error = [absOut1Error error1];  
    absOut2Error = [absOut2Error error2];  
    absOut3Error = [absOut3Error error3];  
end



