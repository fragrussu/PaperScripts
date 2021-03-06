function outmap=FillVoxelsWithinMask(arrayin,idx,sizes)
% Creates 3D data from ROIs obtained with ExtractVoxelsWithinMask()
%
% outmap=FillVoxelsWithinMask(arrayin,idx,mask)
%
% INPUTS
% 1) arrayin: array of Nvox elements where each line contains the 
%            signal or a quantitative index corresponding to a voxel.
% 2) idx:    location of the Nvox voxels whose information is stored in the
%            input variable values. idx is Nvox x 3 matrix such that 
%            arrayin(p) will be stored in output 
%            outmap(idx(p,1), idx(p,2), idx(p,3) ).
% 3) sizes:  sizes = [Nx Ny Nz] is a 3-element array storting the number of
%            voxels along first dimension (Nx), second dimension (Ny) and 
%            third dimension (Nz)
%
% OUTPUT
% 1) outmap: matrix of Nx x Ny x Nz elements storting the data in values in
%            the location specified by idx, so that arrayin(p) will be stored 
%            outmap(idx(p,1), idx(p,2), idx(p,3) ).
%
% Author: Francesco Grussu, UCL, f.grussu@ucl.ac.uk
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
  
outmap = zeros(sizes);

for cc=1:size(idx,1)   
    outmap( idx(cc,1), idx(cc,2), idx(cc,3) ) = arrayin(cc);   
end

end