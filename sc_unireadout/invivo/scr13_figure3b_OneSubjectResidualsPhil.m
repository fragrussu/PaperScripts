%% Plot residuals after denoising from Philips data
% Author: Francesco Grussu f.grussu@ucl.ac.uk
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


%% Clear all
clear all
close all
clc


%% Lib


addpath(genpath('../dependencies'));




%% Options

rootdir = '../sc_invivo/london';
scan = '02';



%%%% Plotting options

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
densingledwi_size = 14;
densingleirse_size = 10;
densinglemese_size = 10;
densingleqmt_size = 10;
denjoint2irse_size = 10;
denjoint2mese_size = 10;
denjoint2qmt_size = 10;


REFCOL = [0.5 0.5 0.5];
RES_MAX = sqrt(16);   % limit to plot reference Gaussian curve
LIM_INF = -log(sqrt(2*pi)) -0.5*RES_MAX*RES_MAX;    % Corresponding logP to the maximum residual RES_MAX
LW = 4;
SCALE = 16/15;   % To scale axese in plots

nobins = 100; % Number of bins for plots


%% Load data

pltidx = 1;
for ss=1:1

    
    subject = ['0' num2str(ss)];
    inputdir = fullfile(rootdir,['subject' subject '_scan' scan]);

    cord = fullfile(inputdir,'epiref_moco_seg.nii');

    res_dwi_jointall = fullfile(fullfile(inputdir,'dwib300b1000b2000b2800_M_denjointall_res.nii')); 
    res_qmt_jointall = fullfile(fullfile(inputdir,'qmt_M_denjointall_res.nii'));
    res_irse_jointall = fullfile(fullfile(inputdir,'irse_M_denjointall_res.nii'));
    res_mese_jointall = fullfile(fullfile(inputdir,'mese_M_denjointall_res.nii'));

    res_dwi_single = fullfile(fullfile(inputdir,'dwib300b1000b2000b2800_M_densingle_res.nii'));
    res_qmt_single = fullfile(fullfile(inputdir,'qmt_M_densingle_res.nii'));
    res_irse_single = fullfile(fullfile(inputdir,'irse_M_densingle_res.nii'));
    res_mese_single = fullfile(fullfile(inputdir,'mese_M_densingle_res.nii'));

    res_dwi_joint2qmt = fullfile(fullfile(inputdir,'dwib300b1000b2000b2800_M_denjoint2qmt_res.nii'));
    res_dwi_joint2irse = fullfile(fullfile(inputdir,'dwib300b1000b2000b2800_M_denjoint2irse_res.nii'));
    res_dwi_joint2mese = fullfile(fullfile(inputdir,'dwib300b1000b2000b2800_M_denjoint2mese_res.nii'));

    res_qmt_joint2 = fullfile(fullfile(inputdir,'qmt_M_denjoint2dwi_res.nii'));
    res_irse_joint2 = fullfile(fullfile(inputdir,'irse_M_denjoint2dwi_res.nii'));
    res_mese_joint2 = fullfile(fullfile(inputdir,'mese_M_denjoint2dwi_res.nii'));



    sigma_dwi_jointall = fullfile(fullfile(inputdir,'dwib300b1000b2000b2800_M_denjointall_sigma.nii')); 
    sigma_qmt_jointall = fullfile(fullfile(inputdir,'qmt_M_denjointall_sigma.nii'));
    sigma_irse_jointall = fullfile(fullfile(inputdir,'irse_M_denjointall_sigma.nii'));
    sigma_mese_jointall = fullfile(fullfile(inputdir,'mese_M_denjointall_sigma.nii'));

    sigma_dwi_single = fullfile(fullfile(inputdir,'dwib300b1000b2000b2800_M_densingle_sigma.nii'));
    sigma_qmt_single = fullfile(fullfile(inputdir,'qmt_M_densingle_sigma.nii'));
    sigma_irse_single = fullfile(fullfile(inputdir,'irse_M_densingle_sigma.nii'));
    sigma_mese_single = fullfile(fullfile(inputdir,'mese_M_densingle_sigma.nii'));

    sigma_dwi_joint2qmt = fullfile(fullfile(inputdir,'dwib300b1000b2000b2800_M_denjoint2qmt_sigma.nii'));
    sigma_dwi_joint2irse = fullfile(fullfile(inputdir,'dwib300b1000b2000b2800_M_denjoint2irse_sigma.nii'));
    sigma_dwi_joint2mese = fullfile(fullfile(inputdir,'dwib300b1000b2000b2800_M_denjoint2mese_sigma.nii'));

    sigma_qmt_joint2 = fullfile(fullfile(inputdir,'qmt_M_denjoint2dwi_sigma.nii'));
    sigma_irse_joint2 = fullfile(fullfile(inputdir,'irse_M_denjoint2dwi_sigma.nii'));
    sigma_mese_joint2 = fullfile(fullfile(inputdir,'mese_M_denjoint2dwi_sigma.nii'));


    cord = nifti(cord); cord = cord.dat(:,:,:);


    %%% Extract residuals and sigmas within the cord and normalise residuals

    mylist_str = {'dwi_jointall' 'qmt_jointall' 'irse_jointall' 'mese_jointall',...
                  'dwi_single' 'qmt_single' 'irse_single' 'mese_single',...
                  'dwi_joint2qmt' 'dwi_joint2irse' 'dwi_joint2mese',...
                  'qmt_joint2','irse_joint2','mese_joint2'};


    for mm=1:length(mylist_str)

        % Extract residuals
        eval(['res_' mylist_str{mm} ' = nifti(res_' mylist_str{mm} ');'])
        eval(['res_' mylist_str{mm} ' = res_' mylist_str{mm} '.dat(:,:,:,:);']);

        % Extract sigma
        eval(['sigma_' mylist_str{mm} ' = nifti(sigma_' mylist_str{mm} ');'])
        eval(['sigma_' mylist_str{mm} ' = sigma_' mylist_str{mm} '.dat(:,:,:);']);

        % Replicate cord and sigma to be 4D
        eval(['cord_rep = repmat(cord,[1 1 1 size(res_' mylist_str{mm} ',4)]);']);
        eval(['sigma_rep = repmat(sigma_' mylist_str{mm} ',[1 1 1 size(res_' mylist_str{mm} ',4)]);']);

        % Noramlise residuals with respect to estimated sigma
        eval(['res_' mylist_str{mm} ' = res_' mylist_str{mm} './sigma_rep;']);
        clear sigma_rep

        % Get residuals as an array
        eval(['res_' mylist_str{mm} ' = res_' mylist_str{mm} '(cord_rep==1);']);

    end



        %%% Obtain Gaussianity features

        [dwi_res_denoiseall_x,dwi_res_denoiseall_y] = GetLogResPlot(res_dwi_jointall,nobins);
        [dwi_res_denoise2qmt_x,dwi_res_denoise2qmt_y] = GetLogResPlot(res_dwi_joint2qmt,nobins);
        [dwi_res_denoise2irse_x,dwi_res_denoise2irse_y] = GetLogResPlot(res_dwi_joint2irse,nobins);
        [dwi_res_denoise2mese_x,dwi_res_denoise2mese_y] = GetLogResPlot(res_dwi_joint2mese,nobins);
        [dwi_res_x,dwi_res_y] = GetLogResPlot(res_dwi_single,nobins);

        [qmt_res_denoiseall_x,qmt_res_denoiseall_y] = GetLogResPlot(res_qmt_jointall,nobins);
        [qmt_res_denoise2_x,qmt_res_denoise2_y] = GetLogResPlot(res_qmt_joint2,nobins);
        [qmt_res_x,qmt_res_y] = GetLogResPlot(res_qmt_single,nobins);

        [irse_res_denoiseall_x,irse_res_denoiseall_y] = GetLogResPlot(res_irse_jointall,nobins);
        [irse_res_denoise2_x,irse_res_denoise2_y] = GetLogResPlot(res_irse_joint2,nobins);
        [irse_res_x,irse_res_y] = GetLogResPlot(res_irse_single,nobins);

        [mese_res_denoiseall_x,mese_res_denoiseall_y] = GetLogResPlot(res_mese_jointall,nobins);
        [mese_res_denoise2_x,mese_res_denoise2_y] = GetLogResPlot(res_mese_joint2,nobins);
        [mese_res_x,mese_res_y] = GetLogResPlot(res_mese_single,nobins);



        %%% Plots

        subplot(4,1,pltidx);
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
        grid on; set(gca,'XLim',[0 SCALE*RES_MAX*RES_MAX],'YLim',[SCALE*LIM_INF 0],'XTick',[0 3 6 9 12 15]);
        if(ss==1)
            legend({'DWI only', 'DWI and qMT', 'DWI and IR', 'DWI and mTE', 'DWI, qMT, IR, mTE', 'Reference'});
            title('Diffusion');
        end
        pltidx = pltidx + 1;


        subplot(4,1,pltidx);
        plot(qmt_res_x,qmt_res_y,densingleqmt_marker,'Color',densingleqmt_color,'LineWidth',densingleqmt_width,'MarkerSize',densingleqmt_size);
        hold on
        plot(qmt_res_denoise2_x,qmt_res_denoise2_y,denjoint2qmt_marker,'Color',denjoint2qmt_color,'LineWidth',denjoint2qmt_width,'MarkerSize',denjoint2qmt_size);
        hold on
        plot(qmt_res_denoiseall_x,qmt_res_denoiseall_y,denjoint4_marker,'Color',denjoint4_color,'LineWidth',denjoint4_width,'MarkerSize',denjoint4_size);
        hold on
        plot([0 RES_MAX*RES_MAX],...
             [-log(sqrt(2*pi)) ( -log(sqrt(2*pi)) - 0.5*RES_MAX*RES_MAX )],'Color',REFCOL,'LineWidth',LW);
        xlabel('r^2')
        ylabel('log P(r)')
        grid on; set(gca,'XLim',[0 SCALE*RES_MAX*RES_MAX],'YLim',[SCALE*LIM_INF 0],'XTick',[0 3 6 9 12 15]);
        if(ss==1)
            legend({'qMT only', 'DWI and qMT', 'DWI, qMT, IR, mTE', 'Reference'});
            title('Quantitative MT');
        end
        pltidx = pltidx + 1;

        subplot(4,1,pltidx);
        plot(irse_res_x,irse_res_y,densingleirse_marker,'Color',densingleirse_color,'LineWidth',densingleirse_width,'MarkerSize',densingleirse_size);
        hold on
        plot(irse_res_denoise2_x,irse_res_denoise2_y,denjoint2irse_marker,'Color',denjoint2irse_color,'LineWidth',denjoint2irse_width,'MarkerSize',denjoint2irse_size);
        hold on
        plot(irse_res_denoiseall_x,irse_res_denoiseall_y,denjoint4_marker,'Color',denjoint4_color,'LineWidth',denjoint4_width,'MarkerSize',denjoint4_size);
        hold on
        plot([0 RES_MAX*RES_MAX],...
             [-log(sqrt(2*pi)) ( -log(sqrt(2*pi)) - 0.5*RES_MAX*RES_MAX )],'Color',REFCOL,'LineWidth',LW);
        xlabel('r^2')
        ylabel('log P(r)')
        grid on; set(gca,'XLim',[0 SCALE*RES_MAX*RES_MAX],'YLim',[SCALE*LIM_INF 0],'XTick',[0 3 6 9 12 15]);
        if(ss==1)
            legend({'IR only', 'DWI and IR', 'DWI, qMT, IR, mTE', 'Reference'});
            title('Inversion recovery');
        end
        pltidx = pltidx + 1;


        subplot(4,1,pltidx);
        plot(mese_res_x,mese_res_y,densinglemese_marker,'Color',densinglemese_color,'LineWidth',densinglemese_width,'MarkerSize',densinglemese_size);
        hold on
        plot(mese_res_denoise2_x,mese_res_denoise2_y,denjoint2mese_marker,'Color',denjoint2mese_color,'LineWidth',denjoint2mese_width,'MarkerSize',denjoint2mese_size);
        hold on
        plot(mese_res_denoiseall_x,mese_res_denoiseall_y,denjoint4_marker,'Color',denjoint4_color,'LineWidth',denjoint4_width,'MarkerSize',denjoint4_size);
        hold on
        plot([0 RES_MAX*RES_MAX],...
             [-log(sqrt(2*pi)) ( -log(sqrt(2*pi)) - 0.5*RES_MAX*RES_MAX )],'Color',REFCOL,'LineWidth',LW);
        xlabel('r^2')
        ylabel('log P(r)')
        grid on; set(gca,'XLim',[0 SCALE*RES_MAX*RES_MAX],'YLim',[SCALE*LIM_INF 0],'XTick',[0 3 6 9 12 15]);
        if(ss==1)
            legend({'mTE only', 'DWI and mTE', 'DWI, qMT, IR, mTE', 'Reference'});
            title('Multi-TE');
        end
        pltidx = pltidx + 1;




end






