% squareRootCal.m
% --------------
% By: Augustas Jackevic
% Date: July 2021
% Script Description:
% -------------------
% This script calculates the square root value of the provided inputData 
% value. This is achieved through the usage of the non-restoring square root 
% algorithm. This copies the same logic as applied to the Verilog scrip 
% square_root_cal.m
 
% To fully understand how the Non-Restoring Square Root method works pleas 
% read the following:
% - http://www.ijcte.org/papers/281-G850.pdf
% - https://digitalsystemdesign.in/non-restoring-algorithm-for-square-root/
% - http://www.ijceronline.com/papers/(NCASSGC)/W107-116.pdf
%


function outputData = squareRootCal(inputData)
    
    % Setting the default values of the parameters.
    dataIn = dec2bin(inputData,142);
    currentBits = dec2bin(0,142);
    subtractBits = dec2bin(0,142);
    remainderBits = dec2bin(0,142);
    tempOut = dec2bin(0,71);
    
    % Setting the variable pows2 and pows_2 which are then used to convert
    % the long 142 and 71 bits to a decimal value. dec2bin cannot handel
    % variables that are 71 and over in length.
    pows2 = 2.^(142-1:-1:0);
    pows_2 = 2.^(71-1:-1:0);
    
    % For loop for each pair of bits for the input variable. This for loop
    % must equal to bit width on the input (142) devided by 1 (71).
    for i = 71:-1:1
        
        % Adding the MSB 2 bits of dataIn to the start of currentBits. Hence shift 
		% currentBits to the left by 2 positions and setting bits 0 and 1 to the 2
		% MSB's of dataIn.
        currentBits = [currentBits(3:142) dataIn(1:2)];
        % Shifting dataIn two positions so that in the next for loop iteration, the 
		% corresponding 2 bits of dataIn are processed.
        dataIn = [dataIn(3:142) '00'];
        
        
        % Setting subtractBits to remainderBits bit shifted by 2 values, with bits
		% 1 and 0 being set to 2'b01.
        subtractBits = [remainderBits(3:142) '01'];
        
        % Converting currentBits and subtractBits to decimal values.
        decCBValue = pows2*(currentBits-'0')';
        decSBValue = pows2*(subtractBits-'0')';
        
        % Check if the remainder of currentBits - subtractBits is negative. If
		% subtractBits is larger than currentBits, then the remainder would be 
		% negative, else it would be posative (0 is considered posative). 
        if(decSBValue > decCBValue)
            % If subtractBits > currentBits, set the current tempOut bit to 0.
            tempOut((71 - i)+1) = '0';  
        else
            % If currentBits > subtractBits (remainder is posative), set the
			% current tempOut bit to 1. Then recalculate currentBits. This is equal
			% to the remainder value of currentBits - subtractBits.
            tempOut((71 - i)+1) = '1';
            currentBits = dec2bin(decCBValue - decSBValue,142); 
        end
        % Converting tempOut to decimal values.
        decTOValue = pows_2*(tempOut-'0')';
        
        % Reset remainderBits, then set its value to the shifted value of tempOut.
        remainderBits = [dec2bin(0,(142 - (72 - i)))  tempOut(1:(72-i))];
        
    end

    % Converting tempOut to a decimal and passing through the value to outputData.
    outputData = pows_2*(tempOut-'0')';
end
