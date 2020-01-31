%% Denoise one noise realisation in simulations to look at residual plots -- Rician noise
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


%% Clear all
clear all
close all
clc


%% Input options

%%%% These worked quite nicely

noisy_marker = 'o';
denjoint4_marker = 'x';
densingledwi_marker = 's';
densingleirse_marker = '*';
densinglemese_marker = 'd';
densingleqmt_marker = '^';
denjoint2irse_marker = '+';
denjoint2mese_marker = '>';
denjoint2qmt_marker = '<';


noisy_color = [0 0 0];
denjoint4_color = [1 0 0];
densingledwi_color = [1 1 0];
densingleirse_color = [0 0 1];
densinglemese_color = [0 0.7 1];
densingleqmt_color = [0 1 0];
denjoint2irse_color = [1 0.5 0];
denjoint2mese_color = [145 0 255]/255;   % [1 0.5 0.5]
denjoint2qmt_color = [0 0 0];


noisy_width = 2.5;
denjoint4_width = 2.5;
densingledwi_width = 2.5;
densingleirse_width = 2.5;
densinglemese_width = 2.5;
densingleqmt_width = 2.5;
denjoint2irse_width = 2.5;
denjoint2mese_width = 2.5;
denjoint2qmt_width = 2.5;


noisy_size = 10;
denjoint4_size = 10;
densingledwi_size = 10;
densingleirse_size = 10;
densinglemese_size = 10;
densingleqmt_size = 10;
denjoint2irse_size = 10;
denjoint2mese_size = 10;
denjoint2qmt_size = 10;


REFCOL = [0.5 0.5 0.5];
RES_MAX = sqrt(15);   % limit to plot reference Gaussian curve
LIM_INF = -log(sqrt(2*pi)) -0.5*RES_MAX*RES_MAX;    % Limit for axis given the extension of the reference
LW = 2;
SCALE = 1.1;   % To scale axese in plots
%%%%



%snr_to_show = [10 15 20 40];
%nobins = 20;

snr_to_show = [10 15 20 40];
nobins = 100;




datadir = '../sc_phantom/multimodal_noiserealisation_rician';
cordfile = fullfile('../sc_phantom','cord.nii');

Nmeas_dwi = 68;
Nmeas_qmt = 44;
Nmeas_irse = 12;
Nmeas_mese = 7;

%% Loop: calculate residuals and plot

cord = nifti(cordfile); cord = cord.dat(:,:,:);

pltidx = 1;
for ss=1:length(snr_to_show)
   
    % Input file name
    
    dwiqmtirsemesefile_noisy = fullfile(datadir,['vartissue_dwiqmtirsemese_noisyrice_snr' num2str(snr_to_show(ss)) '.nii']);
    dwiqmtirsemesefile_denoised = fullfile(datadir,['vartissue_dwiqmtirsemese_noisyrice_snr' num2str(snr_to_show(ss)) '_denoised.nii']);
    dwiqmtirsemesefile_sigma = fullfile(datadir,['vartissue_dwiqmtirsemese_noisyrice_snr' num2str(snr_to_show(ss)) '_sigma.nii']);
        
    dwiqmtfile_noisy = fullfile(datadir,['vartissue_dwiqmt_noisyrice_snr' num2str(snr_to_show(ss)) '.nii']);
    dwiqmtfile_denoised = fullfile(datadir,['vartissue_dwiqmt_noisyrice_snr' num2str(snr_to_show(ss)) '_denoised.nii']);
    dwiqmtfile_sigma = fullfile(datadir,['vartissue_dwiqmt_noisyrice_snr' num2str(snr_to_show(ss)) '_sigma.nii']);
        
    dwiirsefile_noisy = fullfile(datadir,['vartissue_dwiirse_noisyrice_snr' num2str(snr_to_show(ss)) '.nii']);
    dwiirsefile_denoised = fullfile(datadir,['vartissue_dwiirse_noisyrice_snr' num2str(snr_to_show(ss)) '_denoised.nii']);
    dwiirsefile_sigma = fullfile(datadir,['vartissue_dwiirse_noisyrice_snr' num2str(snr_to_show(ss)) '_sigma.nii']);
    
    dwimesefile_noisy = fullfile(datadir,['vartissue_dwimese_noisyrice_snr' num2str(snr_to_show(ss)) '.nii']);
    dwimesefile_denoised = fullfile(datadir,['vartissue_dwimese_noisyrice_snr' num2str(snr_to_show(ss)) '_denoised.nii']);
    dwimesefile_sigma = fullfile(datadir,['vartissue_dwimese_noisyrice_snr' num2str(snr_to_show(ss)) '_sigma.nii']);
    
    
    dwifile_noisy = fullfile(datadir,['vartissue_dwi_noisyrice_snr' num2str(snr_to_show(ss)) '.nii']);
    dwifile_denoised = fullfile(datadir,['vartissue_dwi_noisyrice_snr' num2str(snr_to_show(ss)) '_denoised.nii']);
    dwifile_sigma = fullfile(datadir,['vartissue_dwi_noisyrice_snr' num2str(snr_to_show(ss)) '_sigma.nii']);
    
    qmtfile_noisy = fullfile(datadir,['vartissue_qmt_noisyrice_snr' num2str(snr_to_show(ss)) '.nii']);
    qmtfile_denoised = fullfile(datadir,['vartissue_qmt_noisyrice_snr' num2str(snr_to_show(ss)) '_denoised.nii']);
    qmtfile_sigma = fullfile(datadir,['vartissue_qmt_noisyrice_snr' num2str(snr_to_show(ss)) '_sigma.nii']);
    
    irsefile_noisy = fullfile(datadir,['vartissue_irse_noisyrice_snr' num2str(snr_to_show(ss)) '.nii']);
    irsefile_denoised = fullfile(datadir,['vartissue_irse_noisyrice_snr' num2str(snr_to_show(ss)) '_denoised.nii']);
    irsefile_sigma = fullfile(datadir,['vartissue_irse_noisyrice_snr' num2str(snr_to_show(ss)) '_sigma.nii']);
    
    mesefile_noisy = fullfile(datadir,['vartissue_irse_noisyrice_snr' num2str(snr_to_show(ss)) '.nii']);
    mesefile_denoised = fullfile(datadir,['vartissue_irse_noisyrice_snr' num2str(snr_to_show(ss)) '_denoised.nii']);
    mesefile_sigma = fullfile(datadir,['vartissue_irse_noisyrice_snr' num2str(snr_to_show(ss)) '_sigma.nii']);

    
    % Load data and calculate residuals
    namelist = {'dwiqmtirsemese' 'dwiqmt' 'dwiirse' 'dwimese' 'dwi' 'qmt' 'irse' 'mese'};
    for mm=1:length(namelist)
       
        eval([namelist{mm} '_noisy = nifti(' namelist{mm} 'file_noisy); ' namelist{mm} '_noisy = ' namelist{mm} '_noisy.dat(:,:,:,:);']);
        eval([namelist{mm} '_sigma = nifti(' namelist{mm} 'file_sigma); ' namelist{mm} '_sigma = ' namelist{mm} '_sigma.dat(:,:,:);']);
        eval([namelist{mm} '_denoised = nifti(' namelist{mm} 'file_denoised); ' namelist{mm} '_denoised = ' namelist{mm} '_denoised.dat(:,:,:,:);']);
        eval([namelist{mm} '_res = ( ' namelist{mm} '_denoised - ' namelist{mm} '_noisy ) ./ repmat(' namelist{mm} '_sigma,[1 1 1 size(' namelist{mm} '_noisy,4)]);']);
        
        
    end
    
    % Get residuals of interest for different denoising approcaes
    dwi_res_denoiseall = dwiqmtirsemese_res(:,:,:,1:Nmeas_dwi);
    qmt_res_denoiseall = dwiqmtirsemese_res(:,:,:,Nmeas_dwi+1:Nmeas_dwi+Nmeas_qmt);
    irse_res_denoiseall = dwiqmtirsemese_res(:,:,:,Nmeas_dwi+Nmeas_qmt+1:Nmeas_dwi+Nmeas_qmt+Nmeas_irse);
    mese_res_denoiseall = dwiqmtirsemese_res(:,:,:,Nmeas_dwi+Nmeas_qmt+Nmeas_irse+1:Nmeas_dwi+Nmeas_qmt+Nmeas_irse+Nmeas_mese);
    
    qmt_res_denoise2 = dwiqmt_res(:,:,:,Nmeas_dwi+1:Nmeas_dwi+Nmeas_qmt);
    irse_res_denoise2 = dwiirse_res(:,:,:,Nmeas_dwi+1:Nmeas_dwi+Nmeas_irse);
    mese_res_denoise2 = dwimese_res(:,:,:,Nmeas_dwi+1:Nmeas_dwi+Nmeas_mese);
    
    dwi_res_denoise2qmt = dwiqmt_res(:,:,:,1:Nmeas_dwi);
    dwi_res_denoise2irse = dwiirse_res(:,:,:,1:Nmeas_dwi);
    dwi_res_denoise2mese = dwimese_res(:,:,:,1:Nmeas_dwi);
    

    % Get information for plots
    [dwi_res_denoiseall_x,dwi_res_denoiseall_y] = GetLogResPlot(dwi_res_denoiseall(repmat(cord,[1 1 1 Nmeas_dwi])==1),nobins);
    [dwi_res_denoise2qmt_x,dwi_res_denoise2qmt_y] = GetLogResPlot(dwi_res_denoise2qmt(repmat(cord,[1 1 1 Nmeas_dwi])==1),nobins);
    [dwi_res_denoise2irse_x,dwi_res_denoise2irse_y] = GetLogResPlot(dwi_res_denoise2irse(repmat(cord,[1 1 1 Nmeas_dwi])==1),nobins);
    [dwi_res_denoise2mese_x,dwi_res_denoise2mese_y] = GetLogResPlot(dwi_res_denoise2mese(repmat(cord,[1 1 1 Nmeas_dwi])==1),nobins);
    [dwi_res_x,dwi_res_y] = GetLogResPlot(dwi_res(repmat(cord,[1 1 1 Nmeas_dwi])==1),nobins);
    
    [qmt_res_denoiseall_x,qmt_res_denoiseall_y] = GetLogResPlot(qmt_res_denoiseall(repmat(cord,[1 1 1 Nmeas_qmt])==1),nobins);
    [qmt_res_denoise2_x,qmt_res_denoise2_y] = GetLogResPlot(qmt_res_denoise2(repmat(cord,[1 1 1 Nmeas_qmt])==1),nobins);
    [qmt_res_x,qmt_res_y] = GetLogResPlot(qmt_res(repmat(cord,[1 1 1 Nmeas_qmt])==1),nobins);
    
    [irse_res_denoiseall_x,irse_res_denoiseall_y] = GetLogResPlot(irse_res_denoiseall(repmat(cord,[1 1 1 Nmeas_irse])==1),nobins);
    [irse_res_denoise2_x,irse_res_denoise2_y] = GetLogResPlot(irse_res_denoise2(repmat(cord,[1 1 1 Nmeas_irse])==1),nobins);
    [irse_res_x,irse_res_y] = GetLogResPlot(irse_res(repmat(cord,[1 1 1 Nmeas_irse])==1),nobins);
    
    [mese_res_denoiseall_x,mese_res_denoiseall_y] = GetLogResPlot(mese_res_denoiseall(repmat(cord,[1 1 1 Nmeas_mese])==1),nobins);
    [mese_res_denoise2_x,mese_res_denoise2_y] = GetLogResPlot(mese_res_denoise2(repmat(cord,[1 1 1 Nmeas_mese])==1),nobins);
    [mese_res_x,mese_res_y] = GetLogResPlot(mese_res(repmat(cord,[1 1 1 Nmeas_mese])==1),nobins);
    
    
    %%% Perform plots
    
    subplot(length(snr_to_show),4,pltidx);
    plot(dwi_res_x,dwi_res_y,densingledwi_marker,'Color',densingledwi_color,'LineWidth',densingledwi_width,'MarkerSize',densingledwi_size);
    hold on
    plot(dwi_res_denoise2qmt_x,dwi_res_denoise2qmt_y,denjoint2qmt_marker,'Color',denjoint2qmt_color,'LineWidth',denjoint2qmt_width,'MarkerSize',denjoint2qmt_size);
    hold on
    plot(dwi_res_denoise2irse_x,dwi_res_denoise2irse_y,denjoint2irse_marker,'Color',denjoint2irse_color,'LineWidth',denjoint2irse_width,'MarkerSize',denjoint2irse_size);
    hold on
    plot(dwi_res_denoise2mese_x,dwi_res_denoise2mese_y,denjoint2mese_marker,'Color',denjoint2mese_color,'LineWidth',denjoint2mese_width,'MarkerSize',denjoint2mese_size);
    hold on
    plot(dwi_res_denoiseall_x,dwi_res_denoiseall_y,denjoint4_marker,'Color',denjoint4_color,'LineWidth',denjoint4_width,'MarkerSize',denjoint4_size);
    hold on
    plot([0 RES_MAX*RES_MAX],...
         [-log(sqrt(2*pi)) ( -log(sqrt(2*pi)) - 0.5*RES_MAX*RES_MAX )],'Color',REFCOL,'LineWidth',LW);
    xlabel('r^2')
    ylabel('log P(r)')
    grid on; set(gca,'XLim',[0 SCALE*RES_MAX*RES_MAX],'YLim',[SCALE*LIM_INF 0]);
    title(['DW Imaging; SNR = ' num2str(snr_to_show(ss))]);
    legend({'DWI only', 'DWI and qMT', 'DWI and IR', 'DWI and mTE', 'DWI. qMT, IR, mTE', 'Ref.'});
    pltidx = pltidx + 1;
    
    
    subplot(length(snr_to_show),4,pltidx);
    plot(qmt_res_x,qmt_res_y,densingledwi_marker,'Color',densingleqmt_color,'LineWidth',densingleqmt_width,'MarkerSize',densingleqmt_size);
    hold on
    plot(qmt_res_denoise2_x,qmt_res_denoise2_y,denjoint2qmt_marker,'Color',denjoint2qmt_color,'LineWidth',denjoint2qmt_width,'MarkerSize',denjoint2qmt_size);
    hold on
    plot(qmt_res_denoiseall_x,qmt_res_denoiseall_y,denjoint4_marker,'Color',denjoint4_color,'LineWidth',denjoint4_width,'MarkerSize',denjoint4_size);
    hold on
    plot([0 RES_MAX*RES_MAX],...
         [-log(sqrt(2*pi)) ( -log(sqrt(2*pi)) - 0.5*RES_MAX*RES_MAX )],'Color',REFCOL,'LineWidth',LW);
    xlabel('r^2')
    ylabel('log P(r)')
    grid on; set(gca,'XLim',[0 SCALE*RES_MAX*RES_MAX],'YLim',[SCALE*LIM_INF 0]);
    title(['qMT Imaging; SNR = ' num2str(snr_to_show(ss))]);
    legend({'qMT only', 'DWI and qMT', 'DWI. qMT, IR, mTE', 'Ref.'});
    pltidx = pltidx + 1;
    
    subplot(length(snr_to_show),4,pltidx);
    plot(irse_res_x,irse_res_y,densingledwi_marker,'Color',densingleirse_color,'LineWidth',densingleirse_width,'MarkerSize',densingleirse_size);
    hold on
    plot(irse_res_denoise2_x,irse_res_denoise2_y,denjoint2irse_marker,'Color',denjoint2irse_color,'LineWidth',denjoint2irse_width,'MarkerSize',denjoint2irse_size);
    hold on
    plot(irse_res_denoiseall_x,irse_res_denoiseall_y,denjoint4_marker,'Color',denjoint4_color,'LineWidth',denjoint4_width,'MarkerSize',denjoint4_size);
    hold on
    plot([0 RES_MAX*RES_MAX],...
         [-log(sqrt(2*pi)) ( -log(sqrt(2*pi)) - 0.5*RES_MAX*RES_MAX )],'Color',REFCOL,'LineWidth',LW);
    xlabel('r^2')
    ylabel('log P(r)')
    grid on; set(gca,'XLim',[0 SCALE*RES_MAX*RES_MAX],'YLim',[SCALE*LIM_INF 0]);
    title(['IR Imaging; SNR = ' num2str(snr_to_show(ss))]);
    legend({'IR only', 'DWI and IR', 'DWI, qMT, IR, mTE', 'Ref.'});
    pltidx = pltidx + 1;
    
    
    subplot(length(snr_to_show),4,pltidx);
    plot(mese_res_x,mese_res_y,densingledwi_marker,'Color',densinglemese_color,'LineWidth',densinglemese_width,'MarkerSize',densinglemese_size);
    hold on
    plot(mese_res_denoise2_x,mese_res_denoise2_y,denjoint2mese_marker,'Color',denjoint2mese_color,'LineWidth',denjoint2mese_width,'MarkerSize',denjoint2mese_size);
    hold on
    plot(mese_res_denoiseall_x,mese_res_denoiseall_y,denjoint4_marker,'Color',denjoint4_color,'LineWidth',denjoint4_width,'MarkerSize',denjoint4_size);
    hold on
    plot([0 RES_MAX*RES_MAX],...
         [-log(sqrt(2*pi)) ( -log(sqrt(2*pi)) - 0.5*RES_MAX*RES_MAX )],'Color',REFCOL,'LineWidth',LW);
    xlabel('r^2')
    ylabel('log P(r)')
    grid on; set(gca,'XLim',[0 SCALE*RES_MAX*RES_MAX],'YLim',[SCALE*LIM_INF 0]);
    title(['mTE Imaging; SNR = ' num2str(snr_to_show(ss))]);
    legend({'mTE only', 'DWI and mTE', 'DWI, qMT, IR, mTE', 'Ref.'});
    pltidx = pltidx + 1;
    
   
    
    
    
    
end











