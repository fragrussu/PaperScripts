function MPmoments_slicewise_nifti(input,mask,output)
% MP denoising slice-by-slice within a mask with noise floor mitigation
%
% MPmoments_slicewise_nifti(input,mask,output)
% - input: path of 4D NIFTI to denoise
% - mask: spinal cord mask
% - output: output file root name (several output files are provided:
%           *_denoised.nii for denoised images, *_res.nii for residuals,
%           *_sigma.nii for noise map, 
%           *_nsig.nii for significant singular value above the MP bulk
%
%
% Requires Matlab R2017b or later for NIFTI input/output
%
% BSD 2-Clause License
% 
% Copyright (c) 2019, 2020, University College London.
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


data = double(niftiread(input)); 
info = niftiinfo(input);

data_den = zeros(size(data));
sigma_map = zeros([size(data,1) size(data,2) size(data,3)]);
nsig_map = zeros([size(data,1) size(data,2) size(data,3)]);
roi = double(niftiread(mask));
roi(roi~=0) = 1;

% Slice-wise denoising
for zz=1:size(roi,3)
    
    roi_sl = zeros(size(roi));
    roi_sl(:,:,zz) = roi(:,:,zz);
    [data_sl,idx_sl] = ExtractVoxelsWithinMask(data, roi_sl);
    
    % Denoising for slices whose mask is not empty
    if(isempty(idx_sl)==0)
        [data_sl_den,sigma,nsig,~] = mppca_moments_mat(transpose(data_sl),0);
        if(isreal(data_sl)==0)
            sigma = sigma/sqrt(2);   % Scale sigma for complex-valued data
        end
        buff = Fill4DsignalsWithinMask(transpose(data_sl_den),idx_sl,size(data));
        data_den(:,:,zz,:) = buff(:,:,zz,:);
        sigma_map(:,:,zz) = sigma;
        nsig_map(:,:,zz) = nsig;
    else
        data_den(:,:,zz,:) = data(:,:,zz,:);
        sigma_map(:,:,zz) = 0;
        nsig_map(:,:,zz) = 0;
    end
    
end

% Mask sigma and signal components map
sigma_map = sigma_map.*roi;
nsig_map = nsig_map.*roi;

% Copy original data outside mask
for vv=1:size(data,4)
    data_den_vol = squeeze(data_den(:,:,:,vv));
    data_vol = squeeze(data(:,:,:,vv));
    data_den_vol(roi==0) = data_vol(roi==0);
    data_den(:,:,:,vv) = data_den_vol;
end

% Save as NIFTIs
infoout = info;
infoout.Datatype = 'double';   
niftiwrite(data_den, [output '_denoised.nii'], infoout);
niftiwrite(data_den - data, [output '_res.nii'], infoout);
    
infosingle = info;
infosingle.Datatype = 'double';
infosingle.ImageSize = info.ImageSize(1:3);
infosingle.PixelDimensions = info.PixelDimensions(1:3);
niftiwrite(sigma_map, [output '_sigma.nii'], infosingle);
niftiwrite(nsig_map, [output '_nsig.nii'], infosingle);
    

end


