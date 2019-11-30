%% Compare noise estimates across modalities, Siemens data
% Author: Francesco Grussu f.grussu@ucl.ac.uk
% For Summplementary Material
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



%% Info

addpath(genpath('../dependencies'))


rootdirs = {'../sc_invivo/nyu/subject01scan01',...
            '../sc_invivo/nyu/subject02scan01',...
            '../sc_invivo/montreal/subject01scan01'};
riceunbias = 0;
if(riceunbias)
    riceunbias_str = 'riceunbias_';
    mytitle = 'With Rician bias mitigation';
else
    riceunbias_str = '';
    mytitle = 'Without Rician bias mitigation';
end

denjointly = 1;
if(denjointly)
    denjointly_str = 'denjoint2dwi_';
    mylegend = {'mTE denoised with DWI', 'Identity'};
    
else
    denjointly_str = 'densingle_';
    mylegend = {'mTE denoised alone', 'Identity'};
end

Nslices = 12;
Nscans = 3;

MKS = 6;


sgm_qmt_array = zeros(Nslices*Nscans,1);
sgm_dwi_array = zeros(Nslices*Nscans,1);
sgm_mese_array = zeros(Nslices*Nscans,1);
sgm_irse_array = zeros(Nslices*Nscans,1);

%% Analysis

acc = 1;
for ss=1:Nscans
        
        sgm_dwi = nifti(fullfile(rootdirs{ss},...
                                 ['dwib300b1000b2000b2800_M_densingle_' riceunbias_str 'sigma.nii']));
        sgm_dwi = sgm_dwi.dat(:,:,:);
        sgm_dwi_mask = logical(sgm_dwi);

        
        sgm_mese = nifti(fullfile(rootdirs{ss},...
                                 ['mese_M_' denjointly_str riceunbias_str 'sigma.nii']));
        sgm_mese = sgm_mese.dat(:,:,:);
        sgm_mese_mask = logical(sgm_mese);

        
        
        sgm_all_mask =  sgm_mese_mask  & sgm_dwi_mask;
        sgm_all_mask = double(sgm_all_mask);
        
        for zz=1:Nslices
            
            sgm_all_mask_zz = zeros(size(sgm_all_mask));
            sgm_all_mask_zz(:,:,zz) = sgm_all_mask(:,:,zz);
            
            sgm_dwi_array(acc,1) = unique(sgm_dwi(sgm_all_mask_zz==1));
            sgm_mese_array(acc,1) = unique(sgm_mese(sgm_all_mask_zz==1));

            acc = acc + 1;
            
        end


end
        
sgm_all = cat(2,sgm_dwi_array,sgm_mese_array);
sgm_min = min(sgm_all(:));
sgm_max = max(sgm_all(:));

figure
plot(sgm_dwi_array,sgm_mese_array,'o','MarkerSize',MKS,'MarkerFaceColor',[145 0 255]/255,'MarkerEdgeColor',[145 0 255]/255);
hold on
plot([15 40],[15 40],'LineWidth',3,'Color',[0.4 0.4 0.4])
axis([15 40 15 40])
xlabel('\sigma of noise from DWI')
ylabel('\sigma of noise')
legend(mylegend)
title(mytitle)
grid on
axis square

