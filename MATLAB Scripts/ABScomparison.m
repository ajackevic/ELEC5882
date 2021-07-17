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





%%
% Alpha (1/1) max plus beta (1/2) min.

% Empty array to store the alpha max plus beta min values.
alphaBetaOut1 = [];


% A for loop 
for i = 1:1:dataLength
    if(abs(real(complexData(i))) >= abs(imag(complexData(i))))
       absAlphaValue = abs(real(complexData(i)));
       absBetaValue = abs(imag(complexData(i)));
    else
       absAlphaValue = abs(imag(complexData(i)));
       absBetaValue = abs(real(complexData(i)));
    end
    absBetaValue = bitshift(absBetaValue,-1);
    alphaBetaOut1 = [alphaBetaOut1 (absAlphaValue + absBetaValue)];
end




%%
% Alpha (1/1) max plus beta (1/4) min.


% Empty array to store the alpha max plus beta min values.
alphaBetaOut2 = [];

for i = 1:1:dataLength
    if(abs(real(complexData(i))) >= abs(imag(complexData(i))))
       absAlphaValue = abs(real(complexData(i)));
       absBetaValue = abs(imag(complexData(i)));
    else
       absAlphaValue = abs(imag(complexData(i)));
       absBetaValue = abs(real(complexData(i)));
    end
    absBetaValue = bitshift(absBetaValue,-2);
    alphaBetaOut2 = [alphaBetaOut2 (absAlphaValue + absBetaValue)];
end



%%
% Alpha (1/1) max plus beta (3/8) min.


% Empty array to store the alpha max plus beta min values.
alphaBetaOut3 = [];

for i = 1:1:dataLength
    if(abs(real(complexData(i))) >= abs(imag(complexData(i))))
       absAlphaValue = abs(real(complexData(i)));
       absBetaValue = abs(imag(complexData(i)));
    else
       absAlphaValue = abs(imag(complexData(i)));
       absBetaValue = abs(real(complexData(i)));
    end
    absBetaValue = (bitshift(absBetaValue,-3) * 3);
    alphaBetaOut3 = [alphaBetaOut3 (absAlphaValue + absBetaValue)];
end



