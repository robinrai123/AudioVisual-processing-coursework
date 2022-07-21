function [fbank] = PLOTmelTriangularFilterbank(magSpec, numFilters, frameLength)

melLength = hertz2mel(frameLength);     %Get largest mel value
melLength = floor(melLength) + 1;       %always round up just to make sure our range covers everything

eachMelIndex = zeros(1, numFilters);  %Array for every index point
linearSpace = (melLength/numFilters);     %Linear spacing ready to be applied to mel array

eachMelIndex(1,1) = 1;      %The first index is 1/the start
eachSpace = 0;

figure;
hold on;

for i = 2:numFilters*2        %rest of coordinates/index
    eachSpace = eachSpace + linearSpace;              %get linear spaced index
    eachMelIndex(1, i) = round(mel2hertz(eachSpace));    %get mel coordinate with it
end


for i = 1:numFilters
    triangle = zeros(1,frameLength);       %zero the whole thing
    leftCorner = eachMelIndex(i);          %start point of triangle base
    rightCorner = eachMelIndex(i+2);       %end point of triangle base

    midpoint = (rightCorner-leftCorner)/2; %halfway point of triangle base
   
    triangle(leftCorner) = 0;              %r(1)
    
    %Work out points from left side to midpoint
    for x = 1:(floor(midpoint))                  %For every index from the start of the trangle to the midpoint
        triangle(leftCorner+x) = x*(1/midpoint); %y = mx + c
    end

%Work out points from midpoint to right side
rightSide = rightCorner-leftCorner;
if floor(midpoint) ~= midpoint           %If there's a non integer midpoint
    rightSide = rightSide -1;            %Shift by one to the left so we don't work out the midpoint (which goes past 1)
end
    for x = floor(midpoint):rightSide    %from midpoint to end point of triangle
        
        if floor(midpoint) ~= midpoint   %If midpoint isn't integer
            triangle(leftCorner+x+1) = (-(x+1)*(1/midpoint))+2; %y = mx+c shifted by 1
        else
            triangle(leftCorner+x) = (-(x)*(1/midpoint))+2;     %y = mx+c
        end
       
    end
    %fbank(i) = triangle * magSpec;     %Multiply with the triangles
    plot(triangle);
    %append to matrix instead
    %hold on
end

%do the fbank * outside the forloop use hemal
%how on earth would that be faster, don't do it for now

end