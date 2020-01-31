%% Plot performance of MP-PCA denoising of multimodal spinal cord denoising (accuracy and precision of signal prediction)
% Author: Francesco Grussu, <f.grussu@ucl.ac.uk>
% Used to generate Figure 2
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


%% Inputs and options
figurename = 'Gaussian noise; accuracy and precision';
inputdata = 'syn06_EvaluateAccPrecGaussian.mat';


alpha = 0.2;

%%% INFO
%{


           b     blue          .     point              -     solid
           g     green         o     circle             :     dotted
           r     red           x     x-mark             -.    dashdot 
           c     cyan          +     plus               --    dashed   
           m     magenta       *     star             (none)  no line
           y     yellow        s     square
           k     black         d     diamond
           w     white         v     triangle (down)
                               ^     triangle (up)
                               <     triangle (left)
                               >     triangle (right)
                               p     pentagram
                               h     hexagram


%}

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



%% Inputs and options


%% Load data
load(inputdata);



%% Plot accuracy and precision

figure('Name',figurename);

%%%% Accuracy



% DWI
subplot(2,4,1)

var_noisy = median(accur_dwi_noisy,2);
var_densingle = median(accur_dwi_densingle,2);
var_denjoint2irse = median(accur_dwi_denjoint2irse,2);
var_denjoint2mese = median(accur_dwi_denjoint2mese,2);
var_denjoint2qmt = median(accur_dwi_denjoint2qmt ,2);
var_denjointall = median(accur_dwi_denjoint4,2);

lim1_noisy = min(accur_dwi_noisy,[],2);
lim1_densingle = min(accur_dwi_densingle,[],2);
lim1_denjoint2irse = min(accur_dwi_denjoint2irse,[],2);
lim1_denjoint2mese = min(accur_dwi_denjoint2mese,[],2);
lim1_denjoint2qmt = min(accur_dwi_denjoint2qmt,[],2);
lim1_denjointall = min(accur_dwi_denjoint4,[],2);

lim2_noisy = max(accur_dwi_noisy,[],2);
lim2_densingle = max(accur_dwi_densingle,[],2);
lim2_denjoint2irse = max(accur_dwi_denjoint2irse,[],2);
lim2_denjoint2mese = max(accur_dwi_denjoint2mese,[],2);
lim2_denjoint2qmt = max(accur_dwi_denjoint2qmt,[],2);
lim2_denjointall = max(accur_dwi_denjoint4,[],2);



plot(snrvals,var_densingle,densingledwi_marker,'MarkerSize',densingledwi_size,'Color',densingledwi_color,'LineWidth',densingledwi_width);
hold on
plot(snrvals,var_denjoint2mese,denjoint2mese_marker,'MarkerSize',denjoint2mese_size,'Color',denjoint2mese_color,'LineWidth',denjoint2mese_width);
hold on
plot(snrvals,var_denjoint2irse,denjoint2irse_marker,'MarkerSize',denjoint2irse_size,'Color',denjoint2irse_color,'LineWidth',denjoint2irse_width);
hold on
plot(snrvals,var_denjoint2qmt,denjoint2qmt_marker,'MarkerSize',denjoint2qmt_size,'Color',denjoint2qmt_color,'LineWidth',denjoint2qmt_width);
hold on
plot(snrvals,var_denjointall,denjoint4_marker,'MarkerSize',denjoint4_size,'Color',denjoint4_color,'LineWidth',denjoint4_width);
hold on


fl = fill([snrvals wrev(snrvals)],[lim1_densingle' wrev(lim2_densingle')],densingledwi_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_denjoint2mese' wrev(lim2_denjoint2mese')],denjoint2mese_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_denjoint2irse' wrev(lim2_denjoint2irse')],denjoint2irse_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_denjoint2qmt' wrev(lim2_denjoint2qmt')],denjoint2qmt_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_denjointall' wrev(lim2_denjointall')],denjoint4_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on


plot(snrvals,var_densingle,densingledwi_marker,'MarkerSize',densingledwi_size,'Color',densingledwi_color,'LineWidth',densingledwi_width);
hold on
plot(snrvals,var_denjoint2mese,denjoint2mese_marker,'MarkerSize',denjoint2mese_size,'Color',denjoint2mese_color,'LineWidth',denjoint2mese_width);
hold on
plot(snrvals,var_denjoint2irse,denjoint2irse_marker,'MarkerSize',denjoint2irse_size,'Color',denjoint2irse_color,'LineWidth',denjoint2irse_width);
hold on
plot(snrvals,var_denjoint2qmt,denjoint2qmt_marker,'MarkerSize',denjoint2qmt_size,'Color',denjoint2qmt_color,'LineWidth',denjoint2qmt_width);
hold on
plot(snrvals,var_denjointall,denjoint4_marker,'MarkerSize',denjoint4_size,'Color',denjoint4_color,'LineWidth',denjoint4_width);
hold on
grid on; xlabel('DWI SNR (@ b=0)');
ylabel('Median residual [%]'); title('Diffusion');
legend({'DWI alone','DWI and mTE','DWI and IR','DWI and qMT','DWI, qMT, IR and mTE'});
set(gca,'XTick',[10 15 20 25 30 35 40]);



% qMT
subplot(2,4,2)

var_noisy = median(accur_qmt_noisy,2);
var_densingle = median(accur_qmt_densingle,2);
var_denjoint2 = median(accur_qmt_denjoint2,2);
var_denjointall = median(accur_qmt_denjoint4,2);

lim1_noisy = min(accur_qmt_noisy,[],2);
lim1_densingle = min(accur_qmt_densingle,[],2);
lim1_denjoint2 = min(accur_qmt_denjoint2,[],2);
lim1_denjointall = min(accur_qmt_denjoint4,[],2);

lim2_noisy = max(accur_qmt_noisy,[],2);
lim2_densingle = max(accur_qmt_densingle,[],2);
lim2_denjoint2 = max(accur_qmt_denjoint2,[],2);
lim2_denjointall = max(accur_qmt_denjoint4,[],2);



plot(snrvals,var_densingle,densingleqmt_marker,'MarkerSize',densingleqmt_size,'Color',densingleqmt_color,'LineWidth',densingleqmt_width);
hold on
plot(snrvals,var_denjoint2,denjoint2qmt_marker,'MarkerSize',denjoint2qmt_size,'Color',denjoint2qmt_color,'LineWidth',denjoint2qmt_width);
hold on
plot(snrvals,var_denjointall,denjoint4_marker,'MarkerSize',denjoint4_size,'Color',denjoint4_color,'LineWidth',denjoint4_width);
hold on


fl = fill([snrvals wrev(snrvals)],[lim1_densingle' wrev(lim2_densingle')],densingleqmt_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_denjoint2' wrev(lim2_denjoint2')],denjoint2qmt_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_denjointall' wrev(lim2_denjointall')],denjoint4_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on


plot(snrvals,var_densingle,densingleqmt_marker,'MarkerSize',densingleqmt_size,'Color',densingleqmt_color,'LineWidth',densingleqmt_width);
hold on
plot(snrvals,var_denjoint2,denjoint2qmt_marker,'MarkerSize',denjoint2qmt_size,'Color',denjoint2qmt_color,'LineWidth',denjoint2qmt_width);
hold on
plot(snrvals,var_denjointall,denjoint4_marker,'MarkerSize',denjoint4_size,'Color',denjoint4_color,'LineWidth',denjoint4_width);
hold on
grid on; xlabel('DWI SNR (@ b=0)');
ylabel('Median residual [%]'); title('Quantitative MT');
legend({'qMT alone','DWI and qMT','DWI, qMT, IR and mTE'});
set(gca,'XTick',[10 15 20 25 30 35 40]);



% IRSE
subplot(2,4,3)

var_noisy = median(accur_irse_noisy,2);
var_densingle = median(accur_irse_densingle,2);
var_denjoint2 = median(accur_irse_denjoint2,2);
var_denjointall = median(accur_irse_denjoint4,2);

lim1_noisy = min(accur_irse_noisy,[],2);
lim1_densingle = min(accur_irse_densingle,[],2);
lim1_denjoint2 = min(accur_irse_denjoint2,[],2);
lim1_denjointall = min(accur_irse_denjoint4,[],2);

lim2_noisy = max(accur_irse_noisy,[],2);
lim2_densingle = max(accur_irse_densingle,[],2);
lim2_denjoint2 = max(accur_irse_denjoint2,[],2);
lim2_denjointall = max(accur_irse_denjoint4,[],2);



plot(snrvals,var_densingle,densingleirse_marker,'MarkerSize',densingleirse_size,'Color',densingleirse_color,'LineWidth',densingleirse_width);
hold on
plot(snrvals,var_denjoint2,denjoint2irse_marker,'MarkerSize',denjoint2irse_size,'Color',denjoint2irse_color,'LineWidth',denjoint2irse_width);
hold on
plot(snrvals,var_denjointall,denjoint4_marker,'MarkerSize',denjoint4_size,'Color',denjoint4_color,'LineWidth',denjoint4_width);
hold on


fl = fill([snrvals wrev(snrvals)],[lim1_densingle' wrev(lim2_densingle')],densingleirse_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_denjoint2' wrev(lim2_denjoint2')],denjoint2irse_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_denjointall' wrev(lim2_denjointall')],denjoint4_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on


plot(snrvals,var_densingle,densingleirse_marker,'MarkerSize',densingleirse_size,'Color',densingleirse_color,'LineWidth',densingleirse_width);
hold on
plot(snrvals,var_denjoint2,denjoint2irse_marker,'MarkerSize',denjoint2irse_size,'Color',denjoint2irse_color,'LineWidth',denjoint2irse_width);
hold on
plot(snrvals,var_denjointall,denjoint4_marker,'MarkerSize',denjoint4_size,'Color',denjoint4_color,'LineWidth',denjoint4_width);
hold on
grid on; xlabel('DWI SNR (@ b=0)');
ylabel('Median residual [%]'); title('Inversion recovery');
legend({'IR alone','DWI and IR','DWI, qMT, IR and mTE'});
set(gca,'XTick',[10 15 20 25 30 35 40]);

% MESE
subplot(2,4,4)

var_noisy = median(accur_mese_noisy,2);
var_densingle = median(accur_mese_densingle,2);
var_denjoint2 = median(accur_mese_denjoint2,2);
var_denjointall = median(accur_mese_denjoint4,2);

lim1_noisy = min(accur_mese_noisy,[],2);
lim1_densingle = min(accur_mese_densingle,[],2);
lim1_denjoint2 = min(accur_mese_denjoint2,[],2);
lim1_denjointall = min(accur_mese_denjoint4,[],2);

lim2_noisy = max(accur_mese_noisy,[],2);
lim2_densingle = max(accur_mese_densingle,[],2);
lim2_denjoint2 = max(accur_mese_denjoint2,[],2);
lim2_denjointall = max(accur_mese_denjoint4,[],2);



plot(snrvals,var_densingle,densinglemese_marker,'MarkerSize',densinglemese_size,'Color',densinglemese_color,'LineWidth',densinglemese_width);
hold on
plot(snrvals,var_denjoint2,denjoint2mese_marker,'MarkerSize',denjoint2mese_size,'Color',denjoint2mese_color,'LineWidth',denjoint2mese_width);
hold on
plot(snrvals,var_denjointall,denjoint4_marker,'MarkerSize',denjoint4_size,'Color',denjoint4_color,'LineWidth',denjoint4_width);
hold on


fl = fill([snrvals wrev(snrvals)],[lim1_densingle' wrev(lim2_densingle')],densinglemese_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_denjoint2' wrev(lim2_denjoint2')],denjoint2mese_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_denjointall' wrev(lim2_denjointall')],denjoint4_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on


plot(snrvals,var_densingle,densinglemese_marker,'MarkerSize',densinglemese_size,'Color',densinglemese_color,'LineWidth',densinglemese_width);
hold on
plot(snrvals,var_denjoint2,denjoint2mese_marker,'MarkerSize',denjoint2mese_size,'Color',denjoint2mese_color,'LineWidth',denjoint2mese_width);
hold on
plot(snrvals,var_denjointall,denjoint4_marker,'MarkerSize',denjoint4_size,'Color',denjoint4_color,'LineWidth',denjoint4_width);
hold on
grid on; xlabel('DWI SNR (@ b=0)');
ylabel('Median residual [%]'); title('Multi-TE');
legend({'mTE alone','DWI and mTE','DWI, qMT, IR and mTE'});
set(gca,'XTick',[10 15 20 25 30 35 40]);








%%%% Precision


% DWI
subplot(2,4,5)

var_noisy = median(prec_dwi_noisy,2);
var_densingle = median(prec_dwi_densingle,2);
var_denjoint2irse = median(prec_dwi_denjoint2irse,2);
var_denjoint2mese = median(prec_dwi_denjoint2mese,2);
var_denjoint2qmt = median(prec_dwi_denjoint2qmt ,2);
var_denjointall = median(prec_dwi_denjoint4,2);

lim1_noisy = min(prec_dwi_noisy,[],2);
lim1_densingle = min(prec_dwi_densingle,[],2);
lim1_denjoint2irse = min(prec_dwi_denjoint2irse,[],2);
lim1_denjoint2mese = min(prec_dwi_denjoint2mese,[],2);
lim1_denjoint2qmt = min(prec_dwi_denjoint2qmt,[],2);
lim1_denjointall = min(prec_dwi_denjoint4,[],2);

lim2_noisy = max(prec_dwi_noisy,[],2);
lim2_densingle = max(prec_dwi_densingle,[],2);
lim2_denjoint2irse = max(prec_dwi_denjoint2irse,[],2);
lim2_denjoint2mese = max(prec_dwi_denjoint2mese,[],2);
lim2_denjoint2qmt = max(prec_dwi_denjoint2qmt,[],2);
lim2_denjointall = max(prec_dwi_denjoint4,[],2);


plot(snrvals,var_densingle,densingledwi_marker,'MarkerSize',densingledwi_size,'Color',densingledwi_color,'LineWidth',densingledwi_width);
hold on
plot(snrvals,var_denjoint2mese,denjoint2mese_marker,'MarkerSize',denjoint2mese_size,'Color',denjoint2mese_color,'LineWidth',denjoint2mese_width);
hold on
plot(snrvals,var_denjoint2irse,denjoint2irse_marker,'MarkerSize',denjoint2irse_size,'Color',denjoint2irse_color,'LineWidth',denjoint2irse_width);
hold on
plot(snrvals,var_denjoint2qmt,denjoint2qmt_marker,'MarkerSize',denjoint2qmt_size,'Color',denjoint2qmt_color,'LineWidth',denjoint2qmt_width);
hold on
plot(snrvals,var_denjointall,denjoint4_marker,'MarkerSize',denjoint4_size,'Color',denjoint4_color,'LineWidth',denjoint4_width);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_densingle' wrev(lim2_densingle')],densingledwi_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_denjoint2mese' wrev(lim2_denjoint2mese')],denjoint2mese_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_denjoint2irse' wrev(lim2_denjoint2irse')],denjoint2irse_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_denjoint2qmt' wrev(lim2_denjoint2qmt')],denjoint2qmt_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_denjointall' wrev(lim2_denjointall')],denjoint4_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
plot(snrvals,var_densingle,densingledwi_marker,'MarkerSize',densingledwi_size,'Color',densingledwi_color,'LineWidth',densingledwi_width);
hold on
plot(snrvals,var_denjoint2mese,denjoint2mese_marker,'MarkerSize',denjoint2mese_size,'Color',denjoint2mese_color,'LineWidth',denjoint2mese_width);
hold on
plot(snrvals,var_denjoint2irse,denjoint2irse_marker,'MarkerSize',denjoint2irse_size,'Color',denjoint2irse_color,'LineWidth',denjoint2irse_width);
hold on
plot(snrvals,var_denjoint2qmt,denjoint2qmt_marker,'MarkerSize',denjoint2qmt_size,'Color',denjoint2qmt_color,'LineWidth',denjoint2qmt_width);
hold on
plot(snrvals,var_denjointall,denjoint4_marker,'MarkerSize',denjoint4_size,'Color',denjoint4_color,'LineWidth',denjoint4_width);
hold on
grid on; xlabel('DWI SNR (@ b=0)');
ylabel('Residual IQR [%]'); title('Diffusion');
legend({'DWI alone','DWI and mTE','DWI and IR','DWI and qMT','DWI, qMT, IR and mTE'});
set(gca,'XTick',[10 15 20 25 30 35 40]);



% qMT
subplot(2,4,6)

var_noisy = median(prec_qmt_noisy,2);
var_densingle = median(prec_qmt_densingle,2);
var_denjoint2 = median(prec_qmt_denjoint2,2);
var_denjointall = median(prec_qmt_denjoint4,2);

lim1_noisy = min(prec_qmt_noisy,[],2);
lim1_densingle = min(prec_qmt_densingle,[],2);
lim1_denjoint2 = min(prec_qmt_denjoint2,[],2);
lim1_denjointall = min(prec_qmt_denjoint4,[],2);

lim2_noisy = max(prec_qmt_noisy,[],2);
lim2_densingle = max(prec_qmt_densingle,[],2);
lim2_denjoint2 = max(prec_qmt_denjoint2,[],2);
lim2_denjointall = max(prec_qmt_denjoint4,[],2);


plot(snrvals,var_densingle,densingleqmt_marker,'MarkerSize',densingleqmt_size,'Color',densingleqmt_color,'LineWidth',densingleqmt_width);
hold on
plot(snrvals,var_denjoint2,denjoint2qmt_marker,'MarkerSize',denjoint2qmt_size,'Color',denjoint2qmt_color,'LineWidth',denjoint2qmt_width);
hold on
plot(snrvals,var_denjointall,denjoint4_marker,'MarkerSize',denjoint4_size,'Color',denjoint4_color,'LineWidth',denjoint4_width);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_densingle' wrev(lim2_densingle')],densingleqmt_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_denjoint2' wrev(lim2_denjoint2')],denjoint2qmt_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_denjointall' wrev(lim2_denjointall')],denjoint4_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
plot(snrvals,var_densingle,densingleqmt_marker,'MarkerSize',densingleqmt_size,'Color',densingleqmt_color,'LineWidth',densingleqmt_width);
hold on
plot(snrvals,var_denjoint2,denjoint2qmt_marker,'MarkerSize',denjoint2qmt_size,'Color',denjoint2qmt_color,'LineWidth',denjoint2qmt_width);
hold on
plot(snrvals,var_denjointall,denjoint4_marker,'MarkerSize',denjoint4_size,'Color',denjoint4_color,'LineWidth',denjoint4_width);
hold on
grid on; xlabel('DWI SNR (@ b=0)');
ylabel('Residual IQR [%]'); title('Quantitative MT');
legend({'qMT alone','DWI and qMT','DWI, qMT, IR and mTE'});
set(gca,'XTick',[10 15 20 25 30 35 40]);


% IRSE
subplot(2,4,7)

var_noisy = median(prec_irse_noisy,2);
var_densingle = median(prec_irse_densingle,2);
var_denjoint2 = median(prec_irse_denjoint2,2);
var_denjointall = median(prec_irse_denjoint4,2);

lim1_noisy = min(prec_irse_noisy,[],2);
lim1_densingle = min(prec_irse_densingle,[],2);
lim1_denjoint2 = min(prec_irse_denjoint2,[],2);
lim1_denjointall = min(prec_irse_denjoint4,[],2);

lim2_noisy = max(prec_irse_noisy,[],2);
lim2_densingle = max(prec_irse_densingle,[],2);
lim2_denjoint2 = max(prec_irse_denjoint2,[],2);
lim2_denjointall = max(prec_irse_denjoint4,[],2);


plot(snrvals,var_densingle,densingleirse_marker,'MarkerSize',densingleirse_size,'Color',densingleirse_color,'LineWidth',densingleirse_width);
hold on
plot(snrvals,var_denjoint2,denjoint2irse_marker,'MarkerSize',denjoint2irse_size,'Color',denjoint2irse_color,'LineWidth',denjoint2irse_width);
hold on
plot(snrvals,var_denjointall,denjoint4_marker,'MarkerSize',denjoint4_size,'Color',denjoint4_color,'LineWidth',denjoint4_width);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_densingle' wrev(lim2_densingle')],densingleirse_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_denjoint2' wrev(lim2_denjoint2')],denjoint2irse_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_denjointall' wrev(lim2_denjointall')],denjoint4_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
plot(snrvals,var_densingle,densingleirse_marker,'MarkerSize',densingleirse_size,'Color',densingleirse_color,'LineWidth',densingleirse_width);
hold on
plot(snrvals,var_denjoint2,denjoint2irse_marker,'MarkerSize',denjoint2irse_size,'Color',denjoint2irse_color,'LineWidth',denjoint2irse_width);
hold on
plot(snrvals,var_denjointall,denjoint4_marker,'MarkerSize',denjoint4_size,'Color',denjoint4_color,'LineWidth',denjoint4_width);
hold on
grid on; xlabel('DWI SNR (@ b=0)');
ylabel('Residual IQR [%]'); title('Inversion recovery');
legend({'IR alone','DWI and IR','DWI, qMT, IR and mTE'});
set(gca,'XTick',[10 15 20 25 30 35 40]);


% MESE
subplot(2,4,8)

var_noisy = median(prec_mese_noisy,2);
var_densingle = median(prec_mese_densingle,2);
var_denjoint2 = median(prec_mese_denjoint2,2);
var_denjointall = median(prec_mese_denjoint4,2);

lim1_noisy = min(prec_mese_noisy,[],2);
lim1_densingle = min(prec_mese_densingle,[],2);
lim1_denjoint2 = min(prec_mese_denjoint2,[],2);
lim1_denjointall = min(prec_mese_denjoint4,[],2);

lim2_noisy = max(prec_mese_noisy,[],2);
lim2_densingle = max(prec_mese_densingle,[],2);
lim2_denjoint2 = max(prec_mese_denjoint2,[],2);
lim2_denjointall = max(prec_mese_denjoint4,[],2);


plot(snrvals,var_densingle,densinglemese_marker,'MarkerSize',densinglemese_size,'Color',densinglemese_color,'LineWidth',densinglemese_width);
hold on
plot(snrvals,var_denjoint2,denjoint2mese_marker,'MarkerSize',denjoint2mese_size,'Color',denjoint2mese_color,'LineWidth',denjoint2mese_width);
hold on
plot(snrvals,var_denjointall,denjoint4_marker,'MarkerSize',denjoint4_size,'Color',denjoint4_color,'LineWidth',denjoint4_width);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_densingle' wrev(lim2_densingle')],densinglemese_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_denjoint2' wrev(lim2_denjoint2')],denjoint2mese_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
fl = fill([snrvals wrev(snrvals)],[lim1_denjointall' wrev(lim2_denjointall')],denjoint4_color);
set(fl,'EdgeAlpha',0,'FaceAlpha',alpha);
hold on
plot(snrvals,var_densingle,densinglemese_marker,'MarkerSize',densinglemese_size,'Color',densinglemese_color,'LineWidth',densinglemese_width);
hold on
plot(snrvals,var_denjoint2,denjoint2mese_marker,'MarkerSize',denjoint2mese_size,'Color',denjoint2mese_color,'LineWidth',denjoint2mese_width);
hold on
plot(snrvals,var_denjointall,denjoint4_marker,'MarkerSize',denjoint4_size,'Color',denjoint4_color,'LineWidth',denjoint4_width);
hold on
grid on; xlabel('DWI SNR (@ b=0)');
ylabel('Residual IQR [%]'); title('Multi-TE');
legend({'mTE alone','DWI and mTE','DWI, qMT, IR and mTE'});
set(gca,'XTick',[10 15 20 25 30 35 40]);
