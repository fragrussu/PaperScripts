%% Evaluate difference maps, London (Philips) data
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

%% Lib

addpath(genpath('../dependencies'))

%% input options


subject = '01';
scan = '02';
rootdir = '../sc_invivo/london';

datadir = fullfile(rootdir,['subject' subject '_scan' scan]);
anatimgpath = fullfile(datadir,'epimean_moco.nii');
cordpath = fullfile(datadir,'epiref_moco_seg.nii');

interpmeth = 'spline'; 
SLICE = 9;

V_DWI = 43; 
V_QMT = 7;
V_IRSE = 10;
V_MESE = 6;

XMIN=22;
XMAX=44;
YMIN=24;
YMAX=42;

QMTinfo = [[1 1 1 1] [2 2 2 2] [3 3 3 3] [4 4 4 4] [5 5 5 5] [6 6 6 6] [7 7 7 7] [8 8 8 8] [9 9 9 9] [10 10 10 10] [11 11 11 11]];

ZOOM = 4;

MYNORM = 2.5e5/100;

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


famin = -0.2; famax = 0.2; fascale = 1;
mdmin = -0.3; mdmax = 0.3; mdscale = 1;
mkmin = -0.5; mkmax = 0.5; mkscale = 1;
bpfmin = -0.05; bpfmax = 0.05; bpfscale = 1;
kmin = -0.5; kmax = 0.5; kscale = 1;
t1min = -80; t1max = 80; t1scale = 1;
t2min = -10; t2max = 10; t2scale = 1;

mycolors = colormap('parula');
mycolors = imresize(mycolors,[256 3]);



%% Load data

anatimg = nifti(anatimgpath); anatimg = anatimg.dat(:,:,:);
cord = nifti(cordpath); cord = cord.dat(:,:,:);


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

        
        
dwi = [];        
dwimet = [];
for ll=1:length(falist)
    
    
   buff = nifti(fullfile(datadir,falist{ll}));
   buff = fascale*rot90(buff.dat(XMIN:XMAX,YMIN:YMAX,SLICE));
   if(ll==1)
       myref = buff;
   end
   mask = rot90(cord(XMIN:XMAX,YMIN:YMAX,SLICE));
   b0 = rot90(anatimg(XMIN:XMAX,YMIN:YMAX,SLICE));
   buff = overlay_qMRI_over_anatomical(b0,mask,buff-myref,famin,famax,mycolors,255);
   if(ll>1)
       dwimet = cat(2,dwimet,buff);
       dwimet = cat(2,dwimet,zeros(size(dwimet,1),BLACKSIZEW,3)); 
   end 
    
end
dwi = cat(1,dwi,dwimet,zeros(BLACKSIZEH,size(dwimet,2),3)); 

dwimet = [];
for ll=1:length(mdlist)
    
    
   buff = nifti(fullfile(datadir,mdlist{ll}));
   buff = mdscale*rot90(buff.dat(XMIN:XMAX,YMIN:YMAX,SLICE));
   if(ll==1)
       myref = buff;
   end
   mask = rot90(cord(XMIN:XMAX,YMIN:YMAX,SLICE));
   b0 = rot90(anatimg(XMIN:XMAX,YMIN:YMAX,SLICE));
   buff = overlay_qMRI_over_anatomical(b0,mask,buff-myref,mdmin,mdmax,mycolors,255);
   if(ll>1)   
       dwimet = cat(2,dwimet,buff);
       dwimet = cat(2,dwimet,zeros(size(dwimet,1),BLACKSIZEW,3)); 
   end 
    
end
dwi = cat(1,dwi,dwimet,zeros(BLACKSIZEH,size(dwimet,2),3)); 

dwimet = [];
for ll=1:length(mklist)
    
    
   buff = nifti(fullfile(datadir,mklist{ll}));
   buff = mkscale*rot90(buff.dat(XMIN:XMAX,YMIN:YMAX,SLICE));
   if(ll==1)
       myref = buff;
   end   
   mask = rot90(cord(XMIN:XMAX,YMIN:YMAX,SLICE));
   b0 = rot90(anatimg(XMIN:XMAX,YMIN:YMAX,SLICE));
   buff = overlay_qMRI_over_anatomical(b0,mask,buff-myref,mkmin,mkmax,mycolors,255);
   if(ll>1)   
       dwimet = cat(2,dwimet,buff);
       dwimet = cat(2,dwimet,zeros(size(dwimet,1),BLACKSIZEW,3)); 
   end
    
end
dwi = cat(1,dwi,dwimet,zeros(BLACKSIZEH,size(dwimet,2),3)); 


qmt = [];        
qmtmet = [];
for ll=1:length(bpflist)
    
    
   buff = nifti(fullfile(datadir,bpflist{ll}));
   buff = bpfscale*rot90(buff.dat(XMIN:XMAX,YMIN:YMAX,SLICE));
   if(ll==1)
       myref = buff;
   end   
   mask = rot90(cord(XMIN:XMAX,YMIN:YMAX,SLICE));
   b0 = rot90(anatimg(XMIN:XMAX,YMIN:YMAX,SLICE));
   buff = overlay_qMRI_over_anatomical(b0,mask,buff-myref,bpfmin,bpfmax,mycolors,255);
   if(ll>1)   
       qmtmet = cat(2,qmtmet,buff);
       qmtmet = cat(2,qmtmet,zeros(size(qmtmet,1),BLACKSIZEW,3)); 
   end    
    
end
qmt = cat(1,qmt,qmtmet,zeros(BLACKSIZEH,size(qmtmet,2),3)); 


qmtmet = [];
for ll=1:length(klist)
    
    
   buff = nifti(fullfile(datadir,klist{ll}));
   buff = kscale*rot90(buff.dat(XMIN:XMAX,YMIN:YMAX,SLICE));
   if(ll==1)
       myref = buff;
   end   
   mask = rot90(cord(XMIN:XMAX,YMIN:YMAX,SLICE));
   b0 = rot90(anatimg(XMIN:XMAX,YMIN:YMAX,SLICE));
   buff = overlay_qMRI_over_anatomical(b0,mask,buff-myref,kmin,kmax,mycolors,255);
   if(ll>1)   
       qmtmet = cat(2,qmtmet,buff);
       qmtmet = cat(2,qmtmet,zeros(size(qmtmet,1),BLACKSIZEW,3)); 
   end
    
end
qmt = cat(1,qmt,qmtmet,zeros(BLACKSIZEH,size(qmtmet,2),3)); 

irse = [];
irsemet = [];
for ll=1:length(t1list)
    
    
   buff = nifti(fullfile(datadir,t1list{ll}));
   buff = t1scale*rot90(buff.dat(XMIN:XMAX,YMIN:YMAX,SLICE));
   if(ll==1)
       myref = buff;
   end   
   mask = rot90(cord(XMIN:XMAX,YMIN:YMAX,SLICE));
   b0 = rot90(anatimg(XMIN:XMAX,YMIN:YMAX,SLICE));
   buff = overlay_qMRI_over_anatomical(b0,mask,buff-myref,t1min,t1max,mycolors,255);
   if(ll>1)   
       irsemet = cat(2,irsemet,buff);
       irsemet = cat(2,irsemet,zeros(size(irsemet,1),BLACKSIZEW,3)); 
   end
    
end
irse = cat(1,irse,irsemet,zeros(BLACKSIZEH,size(irsemet,2),3)); 

mese = [];
mesemet = [];
for ll=1:length(t2list)
    
    
   buff = nifti(fullfile(datadir,t2list{ll}));
   buff = t2scale*rot90(buff.dat(XMIN:XMAX,YMIN:YMAX,SLICE));
   if(ll==1)
       myref = buff;
   end   
   mask = rot90(cord(XMIN:XMAX,YMIN:YMAX,SLICE));
   b0 = rot90(anatimg(XMIN:XMAX,YMIN:YMAX,SLICE));
   buff = overlay_qMRI_over_anatomical(b0,mask,buff-myref,t2min,t2max,mycolors,255);
   if(ll>1)   
       mesemet = cat(2,mesemet,buff);
       mesemet = cat(2,mesemet,zeros(size(mesemet,1),BLACKSIZEW,3)); 
   end    
    
end
mese = cat(1,mese,mesemet,zeros(BLACKSIZEH,size(mesemet,2),3)); 

%% Plot

myimg = cat(1,dwi,zeros(EXTRAH,size(dwi,2),3),...
              cat(2,zeros(size(qmt,1),MAKESAMEWIDTH,3),qmt,zeros(size(qmt,1),MAKESAMEWIDTH,3)),zeros(EXTRAH,size(dwi,2),3),......
              cat(2,zeros(size(irse,1),MAKESAMEWIDTH,3),irse,zeros(size(irse,1),MAKESAMEWIDTH,3)),zeros(EXTRAH,size(dwi,2),3),......
              cat(2,zeros(size(mese,1),MAKESAMEWIDTH,3),mese,zeros(size(mese,1),MAKESAMEWIDTH,3)),zeros(EXTRAH,size(dwi,2),3));

myimg = cat(2,zeros(size(myimg,1),EXTRAWL,3),myimg,zeros(size(myimg,1),EXTRAWR,3));
   
figure, imshow(myimg);

%%
c1 = colorbar; set(c1,'YTick',[]); colormap(mycolors);
set(c1,'Position',[0.6356 0.8451 0.0081 0.0612]);
set(c1,'Color',[1 1 1]);
set(c1, 'LineWidth', 1.5)


c2 = colorbar; set(c2,'YTick',[]); colormap(mycolors);
set(c2,'Position',[0.6356    0.7648    0.0081    0.0612]);
set(c2,'Color',[1 1 1]);
set(c2, 'LineWidth', 1.5)


c3 = colorbar; set(c3,'YTick',[]); colormap(mycolors);
set(c3,'Position',[0.6356    0.6845    0.0081    0.0612]);
set(c3,'Color',[1 1 1]);
set(c3, 'LineWidth', 1.5)


c4 = colorbar; set(c4,'YTick',[]); colormap(mycolors);
set(c4,'Position',[0.5924    0.5660    0.0081    0.0612]);
set(c4,'Color',[1 1 1]);
set(c4, 'LineWidth', 1.5)


c5 = colorbar; set(c5,'YTick',[]); colormap(mycolors);
set(c5,'Position',[0.5924    0.4857    0.0081    0.0612]);
set(c5,'Color',[1 1 1]);
set(c5, 'LineWidth', 1.5)


c6 = colorbar; set(c6,'YTick',[]); colormap(mycolors);
set(c6,'Position',[0.5924    0.3748    0.0081    0.0612]);
set(c6,'Color',[1 1 1]);
set(c6, 'LineWidth', 1.5)

c7 = colorbar; set(c7,'YTick',[]); colormap(mycolors);
set(c7,'Position',[0.5924    0.2639    0.0081    0.0612]);
set(c7,'Color',[1 1 1]);
set(c7, 'LineWidth', 1.5)
