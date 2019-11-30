function [roi,idx] = ExtractVoxelsWithinMask(signals, mask)
% Extracts signals within a ROI
%
% [roi,idx] = ExtractVoxelsWithinMask(signals, mask)
%
% INPUT
% 1) signals: 4D matrix containing the signals (a sequence of volumes)
% 2) mask: a 3D matrix containing 1 for voxels to extract and 0 for voxels
%          to discard
% OUTPUT
% 1) roi: signals extracted from input signals. Each line corresponds to a
%         voxel and each column to measurement.
% 2) idx: location of voxels in roi within the original 3D or 4D input
%          signals. 
%
% In practice, the signals in roi(p,:) are located 
% in signals(idx(p,1), idx(p,2), idx(p,3), :). 
%
% Author: Francesco Grussu, UCL (f.grussu@ucl.ac.uk)
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
    

% Get image sizes
xsize = size(signals,1);
ysize = size(signals,2);
zsize = size(signals,3);
nmeas = size(signals,4);

% Get number of voxels in mask
mask(mask>0) = 1;
nvox = length(mask(mask==1));

% Allocate outputs
roi = zeros(nvox,nmeas);
idx = zeros(nvox,3);

% Store voxel signals and position of the voxel within the 3D volume
p=1;
for ii=1:xsize
    for jj=1:ysize
        for kk=1:zsize
            
            if(mask(ii,jj,kk)==1)
               
                roi(p,:) = signals(ii,jj,kk,:);
                idx(p,1) = ii;
                idx(p,2) = jj;
                idx(p,3) = kk;
                
                p = p+1;
                
                
            end
   
         
            
            
        end
    end
end


end