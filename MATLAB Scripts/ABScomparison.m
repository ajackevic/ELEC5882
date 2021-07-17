% Creating the max and min bounds for the rand arrays.
minBound = -100000000;
maxBound = 100000000;
arrayLength = 1000;

% Creating the random real and imaginary array values using the max, min
% bounds, array length.
randRealValues = randi([minBound,maxBound],1,arrayLength);
randImagValues = randi([minBound,maxBound],1,arrayLength);





