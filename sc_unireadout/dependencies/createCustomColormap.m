function [myColormap]=createCustomColormap(colormapLandmarks,colorsPerStep)
% Create custom colour maps.
%
% Author: Francesco Grussu, <f.grussu@ucl.ac.uk>
%
% function [myColormap] = ... 
%                 ... createCustomColormap(colormapLandmarks,colorsPerStep)
%
% INPUTS:
%
% 1) colormapLandmarks
%    It is a Nx3 matrix of colour-components in the rgb space.
%    Each row must correspond to a colour in [0;1]x[0;1]x[0;1].
% 2) colorsPerStep   
%    It is a N-1 vector of integers.
%
% OUTPUTS:
% 
% myColormap   It is a colour map which corresponds to a piece-wise
%              trajectory in the rgb space [0;1]x[0;1]x[0;1]. 
%              The trajectory is the concatenation of N-1 linear paths.
%              The n-th path is a collection of  
%              colorsPerStep(n) colours which sample evenly a line 
%              connecting the two colours colormapLandmarks(n,:) and 
%              colormapLandmarks(n+1,:), for n = 1, ..., N-1.
%                
%              myColormap has sum(colorsPerStep)x3 elements.
%
%
% BSD 2-Clause License
% 
% Copyright (c) 2019, University College London.
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 
% 1. Redistributions of source code must retain the above copyright notice, this
%    list of conditions and the following disclaimer.
% 
% 2. Redistributions in binary form must reproduce the above copyright notice,
%    this list of conditions and the following disclaimer in the documentation
%    and/or other materials provided with the distribution.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
% 

%%%% Check for errors
if nargin~=2
    error('You need to specify two inputs when calling this function.')
end

if ( size(colormapLandmarks,2)~=3 )
    error('colormapLandmarks must be a N x 3 matrix. Each row is a color and columns stand for r,g and b.')
end

if ( isreal(colormapLandmarks)==0 )
    error('colormapLandmarks contains complex colours.')
end

if( ( max(max(colormapLandmarks)) > 1 ) || ( min(min(colormapLandmarks)) < 0 ))   
    error('All elements of colormapLandmarks must be in the range [0; 1].')
end

if( isvector(colorsPerStep)~=1 )
   error('colorsPerStep must be a vector, having as many elements as rows in colormapLandmarks.') 
end

if( numel(colorsPerStep)~=(size(colormapLandmarks,1)-1) )
   error('colorsPerStep must contain as many elements as number of rows in colormapLandmarks - 1.') 
end

%%%% Navigate in the RGB space and update the output map stored in myColormap
totColNr = numel(colorsPerStep) + 1;
myColormap = [];

for ll=2:totColNr
   
    ColNr = round(colorsPerStep(ll-1));
    
    pF = colormapLandmarks(ll,:);    % Final point in RGB for this step
    pI = colormapLandmarks(ll-1,:);  % Initial point in RGB for this step
    pUnit = pF - pI;  % Direction in the RGB space to implement the equation  p(a) = pI + a*pUnit s.t. p(a=1) = pF
    
    pIMat = repmat(pI,ColNr,1);
    pUnitMat = diag(pUnit);
    aMat = repmat(linspace(1/ColNr,1,ColNr)',1,3);   % Recall: we reach the final color for a = 1
    
    p = pIMat + aMat*pUnitMat;   % Get an even sampling along the current direction in RGB
    
    myColormap = vertcat(myColormap,p);
    
end

%%%% Add the first colour
myColormap = vertcat(colormapLandmarks(1,:),myColormap);

end
