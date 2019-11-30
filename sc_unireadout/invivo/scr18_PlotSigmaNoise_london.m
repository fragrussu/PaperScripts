%% Compare noise estimates across modalities, London data
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


rootdir = '../sc_invivo/london';
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
    mylegend = {'qMT denoised with DWI', 'IR denoised with DWI', 'mTE denoised with DWI', 'Identity'};
    
else
    denjointly_str = 'densingle_';
    mylegend = {'qMT denoised alone', 'IR denoised alone', 'mTE denoised alone', 'Identity'};
end

Nslices = 12;
Nsubj = 4;
Nscans = 2;

MKS = 6;


sgm_qmt_array = zeros(Nslices*Nsubj*Nscans,1);
sgm_dwi_array = zeros(Nslices*Nsubj*Nscans,1);
sgm_mese_array = zeros(Nslices*Nsubj*Nscans,1);
sgm_irse_array = zeros(Nslices*Nsubj*Nscans,1);

%% Analysis

acc = 1;
for ss=1:Nsubj
    for tt=1:Nscans
        
        sgm_dwi = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],...
                                 ['dwib300b1000b2000b2800_M_densingle_' riceunbias_str 'sigma.nii']));
        sgm_dwi = sgm_dwi.dat(:,:,:);
        sgm_dwi_mask = logical(sgm_dwi);
        
        sgm_irse = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],...
                                 ['irse_M_' denjointly_str riceunbias_str 'sigma.nii']));
        sgm_irse = sgm_irse.dat(:,:,:);
        sgm_irse_mask = logical(sgm_irse);
        
        
        sgm_mese = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],...
                                 ['mese_M_' denjointly_str riceunbias_str 'sigma.nii']));
        sgm_mese = sgm_mese.dat(:,:,:);
        sgm_mese_mask = logical(sgm_mese);
        
        sgm_qmt = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],...
                                 ['qmt_M_' denjointly_str riceunbias_str 'sigma.nii']));
        sgm_qmt = sgm_qmt.dat(:,:,:);
        sgm_qmt_mask = logical(sgm_qmt);
        
        
        sgm_all_mask = sgm_qmt_mask & sgm_mese_mask & sgm_irse_mask & sgm_dwi_mask;
        sgm_all_mask = double(sgm_all_mask);
        
        for zz=1:Nslices
            
            sgm_all_mask_zz = zeros(size(sgm_all_mask));
            sgm_all_mask_zz(:,:,zz) = sgm_all_mask(:,:,zz);
            
            sgm_qmt_array(acc,1) = unique(sgm_qmt(sgm_all_mask_zz==1));
            sgm_dwi_array(acc,1) = unique(sgm_dwi(sgm_all_mask_zz==1));
            sgm_irse_array(acc,1) = unique(sgm_irse(sgm_all_mask_zz==1));
            sgm_mese_array(acc,1) = unique(sgm_mese(sgm_all_mask_zz==1));

            acc = acc + 1;
            
        end

        
    end
end
        
sgm_all = cat(2,sgm_dwi_array,sgm_qmt_array,sgm_irse_array,sgm_mese_array);
sgm_min = min(sgm_all(:));
sgm_max = max(sgm_all(:));

figure
plot(sgm_dwi_array,sgm_qmt_array,'o','MarkerSize',MKS,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0]);
hold on
plot(sgm_dwi_array,sgm_irse_array,'o','MarkerSize',MKS,'MarkerFaceColor',[1 0.5 0],'MarkerEdgeColor',[1 0.5 0]);
hold on
plot(sgm_dwi_array,sgm_mese_array,'o','MarkerSize',MKS,'MarkerFaceColor',[145 0 255]/255,'MarkerEdgeColor',[145 0 255]/255);
hold on
plot([2500 6000],[2500 6000],'LineWidth',3,'Color',[0.4 0.4 0.4])
axis([2500 5000 2500 10000])
xlabel('\sigma of noise from DWI')
ylabel('\sigma of noise')
legend(mylegend)
title(mytitle)
grid on
axis square

