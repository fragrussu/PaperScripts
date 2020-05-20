function MP_slicewise_nifti(input,mask,output,varargin)
% MP denoising slice-by-slice within a mask without noise floor mitigation
%
% MP_slicewise_nifti(input,mask,output)
% MP_slicewise_nifti(input,mask,output,1), when input has to be 
%                                interpreted as concatenation of real and 
%                                imaginary parts along the 4th dimension 
%                                (first half of volumes being the real part; 
%                                second half being the imaginary part).
%
%
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
    
% User has flagged data is to be interpreted as concatenation of real and
% imaginary part, and denoising on the complex-valued data is required
if(~isempty(varargin))
    if(varargin{1}==1)
        L = size(data,4)/2;
        try
            data = data(:,:,:,1:L) + 1j*data(:,:,:,L+1:2*L);
        catch
            warning('The number of volumes in the input data is not even -- cannot be interpreted as complex-valued!');
        end
    end
end

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
        [data_sl_den,sigma,nsig,~] = mppca_mat(transpose(data_sl),0);
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
if(isreal(data_den))
    
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
    
    
    
else

    infoout = info;
    infoout.Datatype = 'double';   
    niftiwrite(cat(4,real(data_den),imag(data_den)), [output '_denoised.nii'], infoout);
    niftiwrite(cat(4,real(data_den),imag(data_den)) - cat(4,real(data),imag(data)), [output '_res.nii'], infoout);
    
    infosingle = info;
    infosingle.Datatype = 'double';
    infosingle.ImageSize = info.ImageSize(1:3);
    infosingle.PixelDimensions = info.PixelDimensions(1:3);
    niftiwrite(sigma_map, [output '_sigma.nii'], infosingle);
    niftiwrite(nsig_map, [output '_nsig.nii'], infosingle);
     
    
end

end


