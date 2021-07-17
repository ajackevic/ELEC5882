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



