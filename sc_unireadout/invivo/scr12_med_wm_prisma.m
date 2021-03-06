%% Calculate Median Values
% Author: Francesco Grussu, f.grussu@ucl.ac.uk
% Used to generate tables 5 to 8
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
clear all
close all
clc


%% Add useful libraries

addpath(genpath('../dependencies'))



%% Input info

rootdir = {'../sc_invivo/nyu/subject01scan01', '../sc_invivo/nyu/subject02scan01', ...
           '../sc_invivo/montreal/subject01scan01'};
tissuefile = 'ffe_crop_wm2epiref_moco.nii';
interpmeth = 'spline';  % interpolation method used

nboot = 1000;

% lists of metrics
falist = {['dwib300b1000b2000b2800_M_moco-' interpmeth '/fit_fa.nii'],...
          ['dwib300b1000b2000b2800_M_densingle_riceunbias_denoised_moco-' interpmeth '/fit_fa.nii'],...
          ['dwib300b1000b2000b2800_M_denjoint2mese_riceunbias_denoised_moco-' interpmeth '/fit_fa.nii']};
       
mdlist = {['dwib300b1000b2000b2800_M_moco-' interpmeth '/fit_md.nii'],...
           ['dwib300b1000b2000b2800_M_densingle_riceunbias_denoised_moco-' interpmeth '/fit_md.nii'],...
           ['dwib300b1000b2000b2800_M_denjoint2mese_riceunbias_denoised_moco-' interpmeth '/fit_md.nii']};
       
mklist = {['dwib300b1000b2000b2800_M_moco-' interpmeth '/fit_mk.nii'],...
           ['dwib300b1000b2000b2800_M_densingle_riceunbias_denoised_moco-' interpmeth '/fit_mk.nii'],...
           ['dwib300b1000b2000b2800_M_denjoint2mese_riceunbias_denoised_moco-' interpmeth '/fit_mk.nii']};       
              
t2list = {['mese_M_moco-' interpmeth '/fit_TxyME.nii'],...
            ['mese_M_densingle_riceunbias_denoised_moco-' interpmeth '/fit_TxyME.nii'],...
            ['mese_M_denjoint2dwi_riceunbias_denoised_moco-' interpmeth '/fit_TxyME.nii']}; 


        
        
%% Load metrics

%%%% Plot info on tissue
fprintf('****     Median in %s mask   ****\n\n\n',tissuefile)

%%%%% FA
mylist = falist;
fprintf('FA\n');
metricvals = zeros(2,1,length(mylist));
for mm=1:length(mylist)
    
    fprintf('    metric: %s\n',mylist{mm});
    
    % Calculate observed median
    for ss=1:3
        for tt=1:1

            metric = nifti(fullfile(rootdir{ss},mylist{mm}));
            metric = metric.dat(:,:,:);
            tissue = nifti(fullfile(rootdir{ss},tissuefile));
            tissue = tissue.dat(:,:,:);
            voxels = metric(tissue==1);
            
            metricvals(ss,tt,mm) = median(voxels);
            
            fprintf('            subject %d, scan %d: %f\n',ss,tt,metricvals(ss,tt,mm))
            
        end 
    end
    
    currmeth = squeeze(metricvals(:,:,mm));
    fprintf('                      mean (std) across subjects and scans: %f (%f)\n',mean(currmeth(:)), std(currmeth(:)) )
    fprintf('\n')
    
end
fprintf('\n\n');



%%%%% MD
mylist = mdlist;
fprintf('MD\n');
metricvals = zeros(2,1,length(mylist));
for mm=1:length(mylist)
    
    fprintf('    metric: %s\n',mylist{mm});
    
    % Calculate observed median
    for ss=1:3
        for tt=1:1

            metric = nifti(fullfile(rootdir{ss},mylist{mm}));
            metric = metric.dat(:,:,:);
            tissue = nifti(fullfile(rootdir{ss},tissuefile));
            tissue = tissue.dat(:,:,:);
            voxels = metric(tissue==1);
            
            metricvals(ss,tt,mm) = median(voxels);
            
            fprintf('            subject %d, scan %d: %f\n',ss,tt,metricvals(ss,tt,mm))
            
        end 
    end
    
    currmeth = squeeze(metricvals(:,:,mm));
    fprintf('                      mean (std) across subjects and scans: %f (%f)\n',mean(currmeth(:)), std(currmeth(:)) )
    fprintf('\n')
    
end
fprintf('\n\n');



%%%%% MK
mylist = mklist;
fprintf('MK\n');
metricvals = zeros(2,1,length(mylist));
for mm=1:length(mylist)
    
    fprintf('    metric: %s\n',mylist{mm});
    
    % Calculate observed median
    for ss=1:3
        for tt=1:1

            metric = nifti(fullfile(rootdir{ss},mylist{mm}));
            metric = metric.dat(:,:,:);
            tissue = nifti(fullfile(rootdir{ss},tissuefile));
            tissue = tissue.dat(:,:,:);
            voxels = metric(tissue==1);
            
            metricvals(ss,tt,mm) = median(voxels);
            
            fprintf('            subject %d, scan %d: %f\n',ss,tt,metricvals(ss,tt,mm))
            
        end 
    end
    
    currmeth = squeeze(metricvals(:,:,mm));
    fprintf('                      mean (std) across subjects and scans: %f (%f)\n',mean(currmeth(:)), std(currmeth(:)) )
    fprintf('\n')
    
end
fprintf('\n\n');


%%%%% T2
mylist = t2list;
fprintf('T2\n');
metricvals = zeros(2,1,length(mylist));
for mm=1:length(mylist)
    
    fprintf('    metric: %s\n',mylist{mm});
    
    % Calculate observed median
    for ss=1:3
        for tt=1:1

            metric = nifti(fullfile(rootdir{ss},mylist{mm}));
            metric = metric.dat(:,:,:);
            tissue = nifti(fullfile(rootdir{ss},tissuefile));
            tissue = tissue.dat(:,:,:);
            voxels = metric(tissue==1);
            
            metricvals(ss,tt,mm) = median(voxels);
            
            fprintf('            subject %d, scan %d: %f\n',ss,tt,metricvals(ss,tt,mm))
            
        end 
    end
    
    currmeth = squeeze(metricvals(:,:,mm));
    fprintf('                      mean (std) across subjects and scans: %f (%f)\n',mean(currmeth(:)), std(currmeth(:)) )
    fprintf('\n')
    
end
fprintf('\n\n');
