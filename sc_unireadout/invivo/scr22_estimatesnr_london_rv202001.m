%% Estimate SNR in London (Philips) data
%
% Author: Francesco Grussu, <f.grussu@ucl.ac.uk> 
%
% BSD 2-Clause License
% 
% Copyright (c) 2019 and 2020, University College London.
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

clear all
close all
clc


%% Add useful libraries

addpath(genpath('../dependencies'))


%% Input info

rootdir = '../sc_invivo/london';
tissuefile = 'epiref_moco_seg.nii';

%% Calculation of SNR

metricvals = zeros(4,2);

    
    fprintf('*****      SNR at b = 0     *****\n\n');
    
    % Calculate SNR
    for ss=1:4
        for tt=1:2

            dwi = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],'dwib300b1000b2000b2800_M_densingle_riceunbias_denoised.nii'));
            dwi = dwi.dat(:,:,:,:);
            noise = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],'dwib300b1000b2000b2800_M_densingle_riceunbias_sigma.nii'));
            noise = noise.dat(:,:,:);
            bval = load(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],'dwib300b1000b2000b2800.bval'));
            b0 = dwi(:,:,:,bval==0);
            tissue = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],tissuefile));
            tissue = tissue.dat(:,:,:);
            snr = nanmean(b0,4)./noise;
            snr(isinf(snr)) = nan;
            metricvals(ss,tt) = nanmean(snr(tissue==1));
            
            fprintf('            subject %d, scan %d: %f\n',ss,tt,metricvals(ss,tt))
            
        end 
    end
    
    currmeth = squeeze(metricvals(:,:));
    fprintf('                      mean (std) across subjects and scans: %f (%f)\n',mean(currmeth(:)), std(currmeth(:)) )
    fprintf('\n')
    

fprintf('\n\n');

