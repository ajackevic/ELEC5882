function output = squareRootCal(valueIn)
   a = dec2bin(valueIn,32);
   q = dec2bin(0,16);
   left = dec2bin(0,18);
   right = dec2bin(0,18);
   r = dec2bin(0,18);
   
   for i = 1:1:16
       right = [q r(1) '1'];
       left = [r(3:18) a(1:2)];
       aValue = [a '00'];
       a = aValue(end - 31:end);
       
       if(left(1) == '1')
           left32 = ['11111111111111' left];
       else
           left32 = ['00000000000000' left];
       end
      if(right(1) == '1')
           right32 = ['11111111111111' right];
       else
           right32 = ['00000000000000' right];
      end
       
      
       if(r(1) == '1')
           % This is the issue. The int16. It should be 18 bits not 16.
           r = dec2bin(typecast(uint32(bin2dec(left32)), 'int32') + typecast(uint32(bin2dec(right32)), 'int32'),18);
       else
           r = dec2bin(typecast(uint32(bin2dec(left32)), 'int32') - typecast(uint32(bin2dec(right32)), 'int32'),18);
       end
       
       q = [q(2:16) dec2bin(~bin2dec(r(1)))];
       out = bin2dec(q);
   end   
   output = bin2dec(q);
    
end