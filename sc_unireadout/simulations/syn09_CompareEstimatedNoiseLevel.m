%% Compare noise levels estimated with various denoising strategies
% Author: Francesco Grussu, <f.grussu@ucl.ac.uk>
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
close all
clear all
clc

%% Input info

datadir = '../sc_phantom';
rician = 0;   % Set 1 if Rician noise floor mitigation is used or not
snr = [10 20 30 40];
cord = '../sc_phantom/cord.nii';

if rician==1
    syndir = 'multimodal_noiserealisation_rician';
else
    syndir = 'multimodal_noiserealisation_gauss';    
end

MKS = 6;


%% Code: look at sigma of noise when modalities are denoised independently
mask = niftiread(cord);
cc = 1;
figure('Name','Individual denoising')
for ss=1:length(snr)
   
    %%%% Load data
    dwi = fullfile(datadir,syndir,['vartissue_dwi_noisyrice_snr' num2str(snr(ss)) '_sigma.nii']);
    dwi = niftiread(dwi);
    dwi = dwi(mask==1);
    
    qmt = fullfile(datadir,syndir,['vartissue_qmt_noisyrice_snr' num2str(snr(ss)) '_sigma.nii']);
    qmt = niftiread(qmt);
    qmt = qmt(mask==1);
        
    irse = fullfile(datadir,syndir,['vartissue_irse_noisyrice_snr' num2str(snr(ss)) '_sigma.nii']);
    irse = niftiread(irse);
    irse = irse(mask==1);
    
    mese = fullfile(datadir,syndir,['vartissue_mese_noisyrice_snr' num2str(snr(ss)) '_sigma.nii']);
    mese = niftiread(mese);
    mese = mese(mask==1);    
    
    %%% Scatter
    subplot(length(snr),3,cc)
    plot(dwi,qmt,'o','MarkerSize',MKS,'MarkerFaceColor',[0.0 0.0 0.0],'MarkerEdgeColor',[0.0 0.0 0.0])
    hold on
    plot([min(min(dwi),min(qmt)) max(max(dwi),max(qmt))],...
         [min(min(dwi),min(qmt)) max(max(dwi),max(qmt))],'LineWidth',2,'Color',[0.4 0.4 0.4])
    xlabel('\sigma from DWI')
    ylabel('\sigma from qMT')
    legend({'qMT denoised alone','Identity'})
    title(['qMT; SNR = ' num2str(snr(ss))])
    axis([min(min(dwi),min(qmt)) max(max(dwi),max(qmt)) min(min(dwi),min(qmt)) max(max(dwi),max(qmt))]); %axis equal
    cc = cc+1;
    grid on
    
    subplot(length(snr),3,cc)
    plot(dwi,irse,'o','MarkerSize',MKS,'MarkerFaceColor',[1 0.5 0],'MarkerEdgeColor',[1 0.5 0])
    hold on
    plot([min(min(dwi),min(irse)) max(max(dwi),max(irse))],...
         [min(min(dwi),min(irse)) max(max(dwi),max(irse))],'LineWidth',2,'Color',[0.4 0.4 0.4])
    xlabel('\sigma from DWI')
    ylabel('\sigma from IR')
    legend({'IR denoised alone','Identity'})
    title(['IR; SNR = ' num2str(snr(ss))]) 
    axis([min(min(dwi),min(irse)) max(max(dwi),max(irse)) min(min(dwi),min(irse)) max(max(dwi),max(irse))]); %axis equal
    cc = cc+1;
    grid on
    
    subplot(length(snr),3,cc)
    plot(dwi,mese,'o','MarkerSize',MKS,'MarkerFaceColor',[145 0 255]/255,'MarkerEdgeColor',[145 0 255]/255)
    hold on
    plot([min(min(dwi),min(mese)) max(max(dwi),max(mese))],...
         [min(min(dwi),min(mese)) max(max(dwi),max(mese))],'LineWidth',2,'Color',[0.4 0.4 0.4])
    xlabel('\sigma from DWI')
    ylabel('\sigma from mTE')
    legend({'mTE denoised alone','Identity'})
    axis([min(min(dwi),min(mese)) max(max(dwi),max(mese)) min(min(dwi),min(mese)) max(max(dwi),max(mese))]); %axis equal
    title(['mTE; SNR = ' num2str(snr(ss))])    
    cc = cc+1;
    grid on
    
    
    
    
    
end




%% Code: look at sigma of noise when modalities are denoised jointly to DWI
mask = niftiread(cord);
cc = 1;
figure('Name','Joint denoising')
for ss=1:length(snr)
   
    %%%% Load data
    dwi = fullfile(datadir,syndir,['vartissue_dwi_noisyrice_snr' num2str(snr(ss)) '_sigma.nii']);
    dwi = niftiread(dwi);
    dwi = dwi(mask==1);
    
    qmt = fullfile(datadir,syndir,['vartissue_dwiqmt_noisyrice_snr' num2str(snr(ss)) '_sigma.nii']);
    qmt = niftiread(qmt);
    qmt = qmt(mask==1);
        
    irse = fullfile(datadir,syndir,['vartissue_dwiirse_noisyrice_snr' num2str(snr(ss)) '_sigma.nii']);
    irse = niftiread(irse);
    irse = irse(mask==1);
    
    mese = fullfile(datadir,syndir,['vartissue_dwimese_noisyrice_snr' num2str(snr(ss)) '_sigma.nii']);
    mese = niftiread(mese);
    mese = mese(mask==1);    
    
    %%% Scatter
    subplot(length(snr),3,cc)
    plot(dwi,qmt,'o','MarkerSize',MKS,'MarkerFaceColor',[0.0 0.0 0.0],'MarkerEdgeColor',[0.0 0.0 0.0])
    hold on
    plot([min(min(dwi),min(qmt)) max(max(dwi),max(qmt))],...
         [min(min(dwi),min(qmt)) max(max(dwi),max(qmt))],'LineWidth',2,'Color',[0.4 0.4 0.4])
    xlabel('\sigma from DWI')
    ylabel('\sigma from qMT')
    legend({'Joint denoising DWI-qMT','Identity'})
    title(['qMT; SNR = ' num2str(snr(ss))])
    axis([min(min(dwi),min(qmt)) max(max(dwi),max(qmt)) min(min(dwi),min(qmt)) max(max(dwi),max(qmt))]); %axis equal
    cc = cc+1;
    grid on
    
    subplot(length(snr),3,cc)
    plot(dwi,irse,'o','MarkerSize',MKS,'MarkerFaceColor',[1 0.5 0],'MarkerEdgeColor',[1 0.5 0])
    hold on
    plot([min(min(dwi),min(irse)) max(max(dwi),max(irse))],...
         [min(min(dwi),min(irse)) max(max(dwi),max(irse))],'LineWidth',2,'Color',[0.4 0.4 0.4])
    xlabel('\sigma from DWI')
    ylabel('\sigma from IR')
    legend({'Joint denoising DWI-IR','Identity'})
    title(['IR; SNR = ' num2str(snr(ss))])
    axis([min(min(dwi),min(irse)) max(max(dwi),max(irse)) min(min(dwi),min(irse)) max(max(dwi),max(irse))]); %axis equal
    cc = cc+1;
    grid on
    
    subplot(length(snr),3,cc)
    plot(dwi,mese,'o','MarkerSize',MKS,'MarkerFaceColor',[145 0 255]/255,'MarkerEdgeColor',[145 0 255]/255)
    hold on
    plot([min(min(dwi),min(mese)) max(max(dwi),max(mese))],...
         [min(min(dwi),min(mese)) max(max(dwi),max(mese))],'LineWidth',2,'Color',[0.4 0.4 0.4])
    xlabel('\sigma from DWI')
    ylabel('\sigma from mTE')
    legend({'Joint denoising DWI-mTE','Identity'})
    title(['mTE; SNR = ' num2str(snr(ss))])
    axis([min(min(dwi),min(mese)) max(max(dwi),max(mese)) min(min(dwi),min(mese)) max(max(dwi),max(mese))]); %axis equal
    cc = cc+1;
    grid on
    
    
    
    
    
end
