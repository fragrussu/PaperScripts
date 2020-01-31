%% Calculate scan-rescan COV in Grey Matter, London (Philips) data
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
tissuefile = 'ffe_crop_gm2epiref_moco.nii';
interpmeth = 'spline'; % choose 'nn' or 'spline'


% lists of metrics
falist = {['dwib300b1000b2000b2800_M_moco-' interpmeth '/fit_fa.nii'],...
          'rescan/fa_RescanToScan.nii'};
       
mdlist = {['dwib300b1000b2000b2800_M_moco-' interpmeth '/fit_md.nii'],...
          'rescan/md_RescanToScan.nii'};
      
mklist = {['dwib300b1000b2000b2800_M_moco-' interpmeth '/fit_mk.nii'],...
          'rescan/mk_RescanToScan.nii'};
      
bpflist = {['qmt_M_moco-' interpmeth '/fit_BPF.nii'],...
          'rescan/BPF_RescanToScan.nii'};   
      
klist = {['qmt_M_moco-' interpmeth '/fit_kFB.nii'],...
          'rescan/kFB_RescanToScan.nii'};   
      
t1list = {['irse_M_moco-' interpmeth '/fit_T1IR.nii'],...
          'rescan/T1_RescanToScan.nii'};        
      
t2list = {['mese_M_moco-' interpmeth '/fit_TxyME.nii'],...
          'rescan/T2_RescanToScan.nii'};        
            
        
%% Load metrics

%%%% Plot info on tissue
fprintf('****     Scan-rescan CoV in %s mask   ****\n\n\n',tissuefile)

%%%%% FA
mylist = falist;
fprintf('FA\n');
metricvals = zeros(4,1);

    
    % Calculate scan-rescan CoV
    for ss=1:4


            metric1 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],mylist{1}));
            metric1 = metric1.dat(:,:,:);
            metric2 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],mylist{2}));
            metric2 = metric2.dat(:,:,:);
            tissue1 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],tissuefile));
            tissue1 = tissue1.dat(:,:,:);
            tissue2 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],tissuefile));
            tissue2 = tissue2.dat(:,:,:);
            voxels1 = metric1(tissue1==1);
            voxels2 = metric2(tissue2==1);
            
            metricvals(ss,1) = 100* iqr(voxels1 - voxels2) / abs(median(cat(1,voxels1,voxels2)));
            

            
            fprintf('            subject %d: %f\n',ss,metricvals(ss,1))
            

    end
    
    currmeth = squeeze(metricvals(:,1));
    fprintf('                      mean (std) across subjects: %f (%f)\n',mean(currmeth(:)), std(currmeth(:)) )
    fprintf('\n')
    

fprintf('\n\n');






%%%%% MD
mylist = mdlist;
fprintf('MD\n');
metricvals = zeros(4,1);

    
    % Calculate scan-rescan CoV
    for ss=1:4


            metric1 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],mylist{1}));
            metric1 = metric1.dat(:,:,:);
            metric2 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],mylist{2}));
            metric2 = metric2.dat(:,:,:);
            tissue1 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],tissuefile));
            tissue1 = tissue1.dat(:,:,:);
            tissue2 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],tissuefile));
            tissue2 = tissue2.dat(:,:,:);
            voxels1 = metric1(tissue1==1);
            voxels2 = metric2(tissue2==1);
            
            metricvals(ss,1) = 100* iqr(voxels1 - voxels2) / abs(median(cat(1,voxels1,voxels2)));
            

            
            fprintf('            subject %d: %f\n',ss,metricvals(ss,1))
            

    end
    
    currmeth = squeeze(metricvals(:,1));
    fprintf('                      mean (std) across subjects: %f (%f)\n',mean(currmeth(:)), std(currmeth(:)) )
    fprintf('\n')
    

fprintf('\n\n');






%%%%% MK
mylist = mklist;
fprintf('MK\n');
metricvals = zeros(4,1);

    
    % Calculate scan-rescan CoV
    for ss=1:4


            metric1 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],mylist{1}));
            metric1 = metric1.dat(:,:,:);
            metric2 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],mylist{2}));
            metric2 = metric2.dat(:,:,:);
            tissue1 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],tissuefile));
            tissue1 = tissue1.dat(:,:,:);
            tissue2 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],tissuefile));
            tissue2 = tissue2.dat(:,:,:);
            voxels1 = metric1(tissue1==1);
            voxels2 = metric2(tissue2==1);
            
            metricvals(ss,1) = 100* iqr(voxels1 - voxels2) / abs(median(cat(1,voxels1,voxels2)));
            

            
            fprintf('            subject %d: %f\n',ss,metricvals(ss,1))
            

    end
    
    currmeth = squeeze(metricvals(:,1));
    fprintf('                      mean (std) across subjects: %f (%f)\n',mean(currmeth(:)), std(currmeth(:)) )
    fprintf('\n')
    

fprintf('\n\n');








%%%%% BPF
mylist = bpflist;
fprintf('BPF\n');
metricvals = zeros(4,1);

    
    % Calculate scan-rescan CoV
    for ss=1:4


            metric1 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],mylist{1}));
            metric1 = metric1.dat(:,:,:);
            metric2 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],mylist{2}));
            metric2 = metric2.dat(:,:,:);
            tissue1 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],tissuefile));
            tissue1 = tissue1.dat(:,:,:);
            tissue2 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],tissuefile));
            tissue2 = tissue2.dat(:,:,:);
            voxels1 = metric1(tissue1==1);
            voxels2 = metric2(tissue2==1);
            
            metricvals(ss,1) = 100* iqr(voxels1 - voxels2) / abs(median(cat(1,voxels1,voxels2)));
            

            
            fprintf('            subject %d: %f\n',ss,metricvals(ss,1))
            

    end
    
    currmeth = squeeze(metricvals(:,1));
    fprintf('                      mean (std) across subjects: %f (%f)\n',mean(currmeth(:)), std(currmeth(:)) )
    fprintf('\n')
    

fprintf('\n\n');







%%%%% K
mylist = klist;
fprintf('K\n');
metricvals = zeros(4,1);

    
    % Calculate scan-rescan CoV
    for ss=1:4


            metric1 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],mylist{1}));
            metric1 = metric1.dat(:,:,:);
            metric2 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],mylist{2}));
            metric2 = metric2.dat(:,:,:);
            tissue1 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],tissuefile));
            tissue1 = tissue1.dat(:,:,:);
            tissue2 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],tissuefile));
            tissue2 = tissue2.dat(:,:,:);
            voxels1 = metric1(tissue1==1);
            voxels2 = metric2(tissue2==1);
            
            metricvals(ss,1) = 100* iqr(voxels1 - voxels2) / abs(median(cat(1,voxels1,voxels2)));
            

            
            fprintf('            subject %d: %f\n',ss,metricvals(ss,1))
            

    end
    
    currmeth = squeeze(metricvals(:,1));
    fprintf('                      mean (std) across subjects: %f (%f)\n',mean(currmeth(:)), std(currmeth(:)) )
    fprintf('\n')
    

fprintf('\n\n');






%%%%% T1
mylist = t1list;
fprintf('T1\n');
metricvals = zeros(4,1);

    
    % Calculate scan-rescan CoV
    for ss=1:4


            metric1 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],mylist{1}));
            metric1 = metric1.dat(:,:,:);
            metric2 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],mylist{2}));
            metric2 = metric2.dat(:,:,:);
            tissue1 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],tissuefile));
            tissue1 = tissue1.dat(:,:,:);
            tissue2 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],tissuefile));
            tissue2 = tissue2.dat(:,:,:);
            voxels1 = metric1(tissue1==1);
            voxels2 = metric2(tissue2==1);
            
            metricvals(ss,1) = 100* iqr(voxels1 - voxels2) / abs(median(cat(1,voxels1,voxels2)));
            

            
            fprintf('            subject %d: %f\n',ss,metricvals(ss,1))
            

    end
    
    currmeth = squeeze(metricvals(:,1));
    fprintf('                      mean (std) across subjects: %f (%f)\n',mean(currmeth(:)), std(currmeth(:)) )
    fprintf('\n')
    

fprintf('\n\n');




%%%%% T2
mylist = t2list;
fprintf('T2\n');
metricvals = zeros(4,1);

    
    % Calculate scan-rescan CoV
    for ss=1:4


            metric1 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],mylist{1}));
            metric1 = metric1.dat(:,:,:);
            metric2 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],mylist{2}));
            metric2 = metric2.dat(:,:,:);
            tissue1 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],tissuefile));
            tissue1 = tissue1.dat(:,:,:);
            tissue2 = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan01'],tissuefile));
            tissue2 = tissue2.dat(:,:,:);
            voxels1 = metric1(tissue1==1);
            voxels2 = metric2(tissue2==1);
            
            metricvals(ss,1) = 100* iqr(voxels1 - voxels2) / abs(median(cat(1,voxels1,voxels2)));
            

            
            fprintf('            subject %d: %f\n',ss,metricvals(ss,1))
            

    end
    
    currmeth = squeeze(metricvals(:,1));
    fprintf('                      mean (std) across subjects: %f (%f)\n',mean(currmeth(:)), std(currmeth(:)) )
    fprintf('\n')
    

fprintf('\n\n');
