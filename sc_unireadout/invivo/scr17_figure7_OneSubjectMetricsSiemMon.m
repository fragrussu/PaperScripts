%% Plot quantitative maps, Montreal
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

addpath(genpath('../dependencies'))

%% input options

subject = '01';
scan = '01';


rootdir = '../sc_invivo/montreal';

datadir = fullfile(rootdir,['subject' subject 'scan' scan]);
anatimgpath = fullfile(datadir,'epimean_moco.nii');
cordpath = fullfile(datadir,'epiref_moco_seg.nii');

interpmeth = 'spline'; % interpolation method used

SLICE = 11;



XMIN=22;
XMAX=47;
YMIN=12;
YMAX=32;



BLACKSIZEW = 2;
BLACKSIZEH = 6;
EXTRAH = 10;
EXTRAWL = 20;
EXTRAWR = 15;

MAKESAMEWIDTH = 25;

SCALEDWI = 1;
SCALEQMT = 0.9;
SCALEIRSE = 1;
SCALEMESE = 0.9;


famin = 0.3; famax = 1; fascale = 1;
mdmin = 0.5; mdmax = 2; mdscale = 1;
mkmin = 0; mkmax = 2; mkscale = 1;
t2min = 50; t2max = 120; t2scale = 1;

mycolors = colormap('parula');
mycolors = imresize(mycolors,[256 3]);



%% Load data

anatimg = nifti(anatimgpath); anatimg = anatimg.dat(:,:,:);
cord = nifti(cordpath); cord = cord.dat(:,:,:);


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

        
        
dwi = [];        
dwimet = [];
for ll=1:length(falist)
    
    
   buff = nifti(fullfile(datadir,falist{ll}));
   buff = fascale*rot90(buff.dat(XMIN:XMAX,YMIN:YMAX,SLICE));
   mask = rot90(cord(XMIN:XMAX,YMIN:YMAX,SLICE));
   b0 = rot90(anatimg(XMIN:XMAX,YMIN:YMAX,SLICE));
   buff = overlay_qMRI_over_anatomical(b0,mask,buff,famin,famax,mycolors,255);
   dwimet = cat(2,dwimet,buff);
   dwimet = cat(2,dwimet,zeros(size(dwimet,1),BLACKSIZEW,3)); 
    
    
end
dwi = cat(1,dwi,dwimet,zeros(BLACKSIZEH,size(dwimet,2),3)); 

dwimet = [];
for ll=1:length(mdlist)
    
    
   buff = nifti(fullfile(datadir,mdlist{ll}));
   buff = mdscale*rot90(buff.dat(XMIN:XMAX,YMIN:YMAX,SLICE));
   mask = rot90(cord(XMIN:XMAX,YMIN:YMAX,SLICE));
   b0 = rot90(anatimg(XMIN:XMAX,YMIN:YMAX,SLICE));
   buff = overlay_qMRI_over_anatomical(b0,mask,buff,mdmin,mdmax,mycolors,255);
   dwimet = cat(2,dwimet,buff);
   dwimet = cat(2,dwimet,zeros(size(dwimet,1),BLACKSIZEW,3)); 
    
    
end
dwi = cat(1,dwi,dwimet,zeros(BLACKSIZEH,size(dwimet,2),3)); 

dwimet = [];
for ll=1:length(mklist)
    
    
   buff = nifti(fullfile(datadir,mklist{ll}));
   buff = mkscale*rot90(buff.dat(XMIN:XMAX,YMIN:YMAX,SLICE));
   mask = rot90(cord(XMIN:XMAX,YMIN:YMAX,SLICE));
   b0 = rot90(anatimg(XMIN:XMAX,YMIN:YMAX,SLICE));
   buff = overlay_qMRI_over_anatomical(b0,mask,buff,mkmin,mkmax,mycolors,255);
   dwimet = cat(2,dwimet,buff);
   dwimet = cat(2,dwimet,zeros(size(dwimet,1),BLACKSIZEW,3)); 
    
    
end
dwi = cat(1,dwi,dwimet,zeros(BLACKSIZEH,size(dwimet,2),3)); 


mese = [];
mesemet = [];
for ll=1:length(t2list)
    
    
   buff = nifti(fullfile(datadir,t2list{ll}));
   buff = t2scale*rot90(buff.dat(XMIN:XMAX,YMIN:YMAX,SLICE));
   mask = rot90(cord(XMIN:XMAX,YMIN:YMAX,SLICE));
   b0 = rot90(anatimg(XMIN:XMAX,YMIN:YMAX,SLICE));
   buff = overlay_qMRI_over_anatomical(b0,mask,buff,t2min,t2max,mycolors,255);
   mesemet = cat(2,mesemet,buff);
   mesemet = cat(2,mesemet,zeros(size(mesemet,1),BLACKSIZEW,3)); 
    
    
end
mese = cat(1,mese,mesemet,zeros(BLACKSIZEH,size(mesemet,2),3)); 

%% Plot

myimg = cat(1,dwi,...
              zeros(EXTRAH,size(dwi,2),3),...
              mese,...
              zeros(EXTRAH,size(dwi,2),3));

myimg = cat(2,zeros(size(myimg,1),EXTRAWL,3),myimg,zeros(size(myimg,1),EXTRAWR,3));

figure, imshow(myimg)

%% Colobars

c1 = colorbar; set(c1,'YTick',[]); colormap(mycolors);
set(c1,'Position',[ 0.6380    0.7740    0.0148    0.0639]);
set(c1,'Color',[1 1 1]);
set(c1, 'LineWidth', 1.5)


c2 = colorbar; set(c2,'YTick',[]); colormap(mycolors);
set(c2,'Position',[ 0.6380    0.6732    0.0148    0.0639]);
set(c2,'Color',[1 1 1]);
set(c2, 'LineWidth', 1.5)


c3 = colorbar; set(c3,'YTick',[]); colormap(mycolors);
set(c3,'Position',[ 0.6380    0.5724    0.0148    0.0639]);
set(c3,'Color',[1 1 1]);
set(c3, 'LineWidth', 1.5)

c4 = colorbar; set(c4,'YTick',[]); colormap(mycolors);
set(c4,'Position',[ 0.6380    0.4195    0.0148    0.0639]);
set(c4,'Color',[1 1 1]);
set(c4, 'LineWidth', 1.5)
