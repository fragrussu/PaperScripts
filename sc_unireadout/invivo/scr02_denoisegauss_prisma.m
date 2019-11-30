%% Denoise Prisma data and perform nosie floor mitigation with the method of moments afterwards
%  Method of Moments: Koay and Basser, JMR 2006, http://doi.org/10.1016/j.jmr.2006.01.016
%  Author: Francesco Grussu, f.grussu@ucl.ac.uk
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

%% Clear

clear all
close all
clc


addpath(genpath('../dependencies'));

subfold={'../sc_invivo/nyu/subject01scan01',...
          '../sc_invivo/nyu/subject02scan01',...
          '../sc_invivo/montreal/subject01scan01'};
      
%% Code      
      
for nn=1:length(subfold)

        %%%% Input data
        dwi = fullfile(subfold{nn},'dwib300b1000b2000b2800_M');
        mese = fullfile(subfold{nn},'mese_M');
        dwimese = fullfile(subfold{nn},'dwib300b1000b2000b2800-mese_M');
        cord = fullfile(subfold{nn},'dwib300b1000b2000b2800_cord_dil1vox');
        
        % Number of measurements for each modality
        dwibuff = nifti([dwi '.nii']); dwibuff = dwibuff.dat(:,:,:,:);
        Ndwi = size(dwibuff,4);
        
        mesebuff = nifti([mese '.nii']); mesebuff = mesebuff.dat(:,:,:,:);
        Nmese = size(mesebuff,4);
        
        %%%% Output: individual denoising
        dwi_single = fullfile(subfold{nn},'dwib300b1000b2000b2800_M_densingle');
        mese_single = fullfile(subfold{nn},'mese_M_densingle');
        
        %%%% Output: joint denoising DWI and MESE
        dwi_joint2mese = fullfile(subfold{nn},'dwib300b1000b2000b2800_M_denjoint2mese');
        mese_joint2 = fullfile(subfold{nn},'mese_M_denjoint2dwi');

        
        fprintf('Analysing subject: %s\n\n',subfold{nn});
        
        %%%% Denoising without noise floor mitigation
        fprintf('       .... denoising ...\n');
        MP_slicewise_nifti([dwi '.nii'],[cord '.nii'],dwi_single);
        MP_slicewise_nifti([mese '.nii'],[cord '.nii'],mese_single);
        MP_slicewise_nifti([dwimese '.nii'],[cord '.nii'],dwimese);
        
        
        
    
        %%%% Extract sub-experiments from joint denoising with 2 modalities
        fprintf('       .... output extraction ...\n\n\n\n');
        str_list={'denoised' 'res'};
        for mm=1:length(str_list)
            
            str = str_list{mm};  
            mynifti = nifti([dwimese '_' str '.nii']); mynifti = mynifti.dat(:,:,:,:); delete([dwimese '_' str '.nii']);
            copyfile([dwi '.nii'],[dwi_joint2mese '_' str '.nii']); buff = nifti([dwi_joint2mese '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,1:Ndwi);
            copyfile([mese '.nii'],[mese_joint2 '_' str '.nii']); buff = nifti([mese_joint2 '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,Ndwi+1:Ndwi+Nmese);
            
        end
        
        
        str_list={'sigma' 'nsig'};
        for mm=1:length(str_list)
            
            str = str_list{mm};   
            mynifti = nifti([dwimese '_' str '.nii']); mynifti = mynifti.dat(:,:,:); delete([dwimese '_' str '.nii']);
            copyfile([cord '.nii'],[dwi_joint2mese '_' str '.nii']); buff = nifti([dwi_joint2mese '_' str '.nii']); buff.dat(:,:,:) = mynifti(:,:,:);%,1:Ndwi);
            copyfile([cord '.nii'],[mese_joint2 '_' str '.nii']); buff = nifti([mese_joint2 '_' str '.nii']); buff.dat(:,:,:) = mynifti(:,:,:);%,Ndwi+1:Ndwi+Nmese);
            
        end
        
        
        
        
        
end

