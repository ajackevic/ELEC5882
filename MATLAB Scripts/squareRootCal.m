function outputData = squareRootCal(inputData)

    dataIn = dec2bin(inputData,142);
    currentBits = dec2bin(0,142);
    subtractBits = dec2bin(0,142);
    remainderBits = dec2bin(0,142);
    tempOut = dec2bin(0,71);
    
    
    pows2 = 2.^(142-1:-1:0);
    pows_2 = 2.^(71-1:-1:0);
    
    for i = 71:-1:1
        currentBits = [currentBits(3:142) dataIn(1:2)];
        dataIn = [dataIn(3:142) '00'];
        
        subtractBits = [remainderBits(3:142) '01'];
        
        decCBValue = pows2*(currentBits-'0')';
        decSBValue = pows2*(subtractBits-'0')';
        
        if(decSBValue > decCBValue)
            tempOut((71 - i)+1) = '0';  
        else
            tempOut((71 - i)+1) = '1';
            currentBits = dec2bin(decCBValue - decSBValue,142); 
        end
        
        decTOValue = pows_2*(tempOut-'0')';
        remainderBits = [dec2bin(0,(142 - (72 - i)))  tempOut(1:(72-i))];
        
    end

    outputData = pows_2*(tempOut-'0')';
end
