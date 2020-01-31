%% Calculate COV Values
% Author: Francesco Grussu, f.grussu@ucl.ac.uk
% Used to generate tables 5 to 8

clear all
close all
clc


%% Add useful libraries

addpath(genpath('../dependencies'))


%% Input info

rootdir = '../sc_invivo/london';
tissuefile = 'ffe_crop_gm2epiref_moco.nii';
interpmeth = 'spline'; % interpolation method used

nboot = 1000;

% lists of metrics
falist = {['dwib300b1000b2000b2800_M_moco-' interpmeth '/fit_fa.nii'],...
          ['dwib300b1000b2000b2800_M_densingle_riceunbias_denoised_moco-' interpmeth '/fit_fa.nii'],...
          ['dwib300b1000b2000b2800_M_denjoint2mese_riceunbias_denoised_moco-' interpmeth '/fit_fa.nii'],...
          ['dwib300b1000b2000b2800_M_denjoint2irse_riceunbias_denoised_moco-' interpmeth '/fit_fa.nii'],...
          ['dwib300b1000b2000b2800_M_denjoint2qmt_riceunbias_denoised_moco-' interpmeth '/fit_fa.nii'],...
          ['dwib300b1000b2000b2800_M_denjointall_riceunbias_denoised_moco-' interpmeth '/fit_fa.nii']};
       
mdlist = {['dwib300b1000b2000b2800_M_moco-' interpmeth '/fit_md.nii'],...
           ['dwib300b1000b2000b2800_M_densingle_riceunbias_denoised_moco-' interpmeth '/fit_md.nii'],...
           ['dwib300b1000b2000b2800_M_denjoint2mese_riceunbias_denoised_moco-' interpmeth '/fit_md.nii'],...
           ['dwib300b1000b2000b2800_M_denjoint2irse_riceunbias_denoised_moco-' interpmeth '/fit_md.nii'],...
           ['dwib300b1000b2000b2800_M_denjoint2qmt_riceunbias_denoised_moco-' interpmeth '/fit_md.nii'],...
           ['dwib300b1000b2000b2800_M_denjointall_riceunbias_denoised_moco-' interpmeth '/fit_md.nii']};
       
mklist = {['dwib300b1000b2000b2800_M_moco-' interpmeth '/fit_mk.nii'],...
           ['dwib300b1000b2000b2800_M_densingle_riceunbias_denoised_moco-' interpmeth '/fit_mk.nii'],...
           ['dwib300b1000b2000b2800_M_denjoint2mese_riceunbias_denoised_moco-' interpmeth '/fit_mk.nii'],...
           ['dwib300b1000b2000b2800_M_denjoint2irse_riceunbias_denoised_moco-' interpmeth '/fit_mk.nii'],...
           ['dwib300b1000b2000b2800_M_denjoint2qmt_riceunbias_denoised_moco-' interpmeth '/fit_mk.nii'],...
           ['dwib300b1000b2000b2800_M_denjointall_riceunbias_denoised_moco-' interpmeth '/fit_mk.nii']};       
       
       
bpflist = {['qmt_M_moco-' interpmeth '/fit_BPF.nii'],...
           ['qmt_M_densingle_riceunbias_denoised_moco-' interpmeth '/fit_BPF.nii'],...
           ['qmt_M_denjoint2dwi_riceunbias_denoised_moco-' interpmeth '/fit_BPF.nii'],...
           ['qmt_M_denjointall_riceunbias_denoised_moco-' interpmeth '/fit_BPF.nii']};
       
klist = {['qmt_M_moco-' interpmeth '/fit_kFB.nii'],...
           ['qmt_M_densingle_riceunbias_denoised_moco-' interpmeth '/fit_kFB.nii'],...
           ['qmt_M_denjoint2dwi_riceunbias_denoised_moco-' interpmeth '/fit_kFB.nii'],...
           ['qmt_M_denjointall_riceunbias_denoised_moco-' interpmeth '/fit_kFB.nii']};       
       
       
t1list = {['irse_M_moco-' interpmeth '/fit_T1IR.nii'],...
            ['irse_M_densingle_riceunbias_denoised_moco-' interpmeth '/fit_T1IR.nii'],...
            ['irse_M_denjoint2dwi_riceunbias_denoised_moco-' interpmeth '/fit_T1IR.nii'],...
            ['irse_M_denjointall_riceunbias_denoised_moco-' interpmeth '/fit_T1IR.nii']} ;    
       
       
t2list = {['mese_M_moco-' interpmeth '/fit_TxyME.nii'],...
            ['mese_M_densingle_riceunbias_denoised_moco-' interpmeth '/fit_TxyME.nii'],...
            ['mese_M_denjoint2dwi_riceunbias_denoised_moco-' interpmeth '/fit_TxyME.nii'],...
            ['mese_M_denjointall_riceunbias_denoised_moco-' interpmeth '/fit_TxyME.nii']}; 


        
        
%% Load metrics

%%%% Plot info on tissue
fprintf('****     CoV in %s mask   ****\n\n\n',tissuefile)

%%%%% FA
mylist = falist;
fprintf('FA\n');
metricvals = zeros(4,2,length(mylist));
for mm=1:length(mylist)
    
    fprintf('    metric: %s\n',mylist{mm});
    
    % Calculate observed COV
    for ss=1:4
        for tt=1:2

            metric = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],mylist{mm}));
            metric = metric.dat(:,:,:);
            tissue = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],tissuefile));
            tissue = tissue.dat(:,:,:);
            voxels = metric(tissue==1);
            
            metricvals(ss,tt,mm) = 100*iqr(voxels)/median(voxels);
            
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
metricvals = zeros(4,2,length(mylist));
for mm=1:length(mylist)
    
    fprintf('    metric: %s\n',mylist{mm});
    
    % Calculate observed COV
    for ss=1:4
        for tt=1:2

            metric = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],mylist{mm}));
            metric = metric.dat(:,:,:);
            tissue = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],tissuefile));
            tissue = tissue.dat(:,:,:);
            voxels = metric(tissue==1);
            
            metricvals(ss,tt,mm) = 100*iqr(voxels)/median(voxels);
            
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
metricvals = zeros(4,2,length(mylist));
for mm=1:length(mylist)
    
    fprintf('    metric: %s\n',mylist{mm});
    
    % Calculate observed COV
    for ss=1:4
        for tt=1:2

            metric = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],mylist{mm}));
            metric = metric.dat(:,:,:);
            tissue = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],tissuefile));
            tissue = tissue.dat(:,:,:);
            voxels = metric(tissue==1);
            
            metricvals(ss,tt,mm) = 100*iqr(voxels)/median(voxels);
            
            fprintf('            subject %d, scan %d: %f\n',ss,tt,metricvals(ss,tt,mm))
            
        end 
    end
    
    currmeth = squeeze(metricvals(:,:,mm));
    fprintf('                      mean (std) across subjects and scans: %f (%f)\n',mean(currmeth(:)), std(currmeth(:)) )
    fprintf('\n')
    
end
fprintf('\n\n');



%%%%% BPF
mylist = bpflist;
fprintf('BPF\n');
metricvals = zeros(4,2,length(mylist));
for mm=1:length(mylist)
    
    fprintf('    metric: %s\n',mylist{mm});
    
    % Calculate observed COV
    for ss=1:4
        for tt=1:2

            metric = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],mylist{mm}));
            metric = metric.dat(:,:,:);
            tissue = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],tissuefile));
            tissue = tissue.dat(:,:,:);
            voxels = metric(tissue==1);
            
            metricvals(ss,tt,mm) = 100*iqr(voxels)/median(voxels);
            
            fprintf('            subject %d, scan %d: %f\n',ss,tt,metricvals(ss,tt,mm))
            
        end 
    end
    
    currmeth = squeeze(metricvals(:,:,mm));
    fprintf('                      mean (std) across subjects and scans: %f (%f)\n',mean(currmeth(:)), std(currmeth(:)) )
    fprintf('\n')
    
end
fprintf('\n\n');


%%%%% K
mylist = klist;
fprintf('K\n');
metricvals = zeros(4,2,length(mylist));
for mm=1:length(mylist)
    
    fprintf('    metric: %s\n',mylist{mm});
    
    % Calculate observed COV
    for ss=1:4
        for tt=1:2

            metric = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],mylist{mm}));
            metric = metric.dat(:,:,:);
            tissue = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],tissuefile));
            tissue = tissue.dat(:,:,:);
            voxels = metric(tissue==1);
            
            metricvals(ss,tt,mm) = 100*iqr(voxels)/median(voxels);
            
            fprintf('            subject %d, scan %d: %f\n',ss,tt,metricvals(ss,tt,mm))
            
        end 
    end
    
    currmeth = squeeze(metricvals(:,:,mm));
    fprintf('                      mean (std) across subjects and scans: %f (%f)\n',mean(currmeth(:)), std(currmeth(:)) )
    fprintf('\n')
    
end
fprintf('\n\n');


%%%%% T1
mylist = t1list;
fprintf('T1\n');
metricvals = zeros(4,2,length(mylist));
for mm=1:length(mylist)
    
    fprintf('    metric: %s\n',mylist{mm});
    
    % Calculate observed COV
    for ss=1:4
        for tt=1:2

            metric = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],mylist{mm}));
            metric = metric.dat(:,:,:);
            tissue = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],tissuefile));
            tissue = tissue.dat(:,:,:);
            voxels = metric(tissue==1);
            
            metricvals(ss,tt,mm) = 100*iqr(voxels)/median(voxels);
            
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
metricvals = zeros(4,2,length(mylist));
for mm=1:length(mylist)
    
    fprintf('    metric: %s\n',mylist{mm});
    
    % Calculate observed COV
    for ss=1:4
        for tt=1:2

            metric = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],mylist{mm}));
            metric = metric.dat(:,:,:);
            tissue = nifti(fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],tissuefile));
            tissue = tissue.dat(:,:,:);
            voxels = metric(tissue==1);
            
            metricvals(ss,tt,mm) = 100*iqr(voxels)/median(voxels);
            
            fprintf('            subject %d, scan %d: %f\n',ss,tt,metricvals(ss,tt,mm))
            
        end 
    end
    
    currmeth = squeeze(metricvals(:,:,mm));
    fprintf('                      mean (std) across subjects and scans: %f (%f)\n',mean(currmeth(:)), std(currmeth(:)) )
    fprintf('\n')
    
end
fprintf('\n\n');