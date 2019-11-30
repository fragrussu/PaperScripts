%% Plot spinal cord images from Philips
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
scan = '02';


rootdir = '../sc_invivo/london';

SLICE = 8;

V_DWI = 43; 
V_QMT = 7;
V_IRSE = 10;
V_MESE = 6;

XMIN=26;
XMAX=40;
YMIN=28;
YMAX=38;

QMTinfo = [[1 1 1 1] [2 2 2 2] [3 3 3 3] [4 4 4 4] [5 5 5 5] [6 6 6 6] [7 7 7 7] [8 8 8 8] [9 9 9 9] [10 10 10 10] [11 11 11 11]];

ZOOM = 4;

MYNORM = 2.5e5/100;

BLACKSIZE = 1;

SCALEDWI = 1;
SCALEQMT = 0.9;
SCALEIRSE = 1;
SCALEMESE = 0.9;


%% Load data

datadir = fullfile(rootdir,['subject' subject '_scan' scan]);

fa = load(fullfile(datadir,'qmt.fa'));
off = load(fullfile(datadir,'qmt.off'));
ti = load(fullfile(datadir,'irse.ti'));
te = load(fullfile(datadir,'mese.te'));
b = load(fullfile(datadir,'dwib300b1000b2000b2800.bval'));
g = load(fullfile(datadir,'dwib300b1000b2000b2800_imagespace.bvec'));

fa_val = fa(QMTinfo(V_QMT));
off_val = off(QMTinfo(V_QMT));
b_val = b(V_DWI);
g_val = g(:,V_DWI);
ti_val = ti(V_IRSE);
te_val = te(V_MESE);


dwilist = {'dwib300b1000b2000b2800_M.nii',...
           'dwib300b1000b2000b2800_M_densingle_denoised.nii',...
           'dwib300b1000b2000b2800_M_denjoint2mese_denoised.nii',...
           'dwib300b1000b2000b2800_M_denjoint2irse_denoised.nii',...
           'dwib300b1000b2000b2800_M_denjoint2qmt_denoised.nii',...
           'dwib300b1000b2000b2800_M_denjointall_denoised.nii'};
       
       
qmtlist = {'qmt_M.nii',...
           'qmt_M_densingle_denoised.nii',...
           'qmt_M_denjoint2dwi_denoised.nii',...
           'qmt_M_denjointall_denoised.nii'};
       
       
irselist = {'irse_M.nii',...
            'irse_M_densingle_denoised.nii',...
            'irse_M_denjoint2dwi_denoised.nii',...
            'irse_M_denjointall_denoised.nii'};       
       
       
meselist = {'mese_M.nii',...
            'mese_M_densingle_denoised.nii',...
            'mese_M_denjoint2dwi_denoised.nii',...
            'mese_M_denjointall_denoised.nii'};  
        
dwi = [];
for ll=1:length(dwilist)
    
    
   buff = nifti(fullfile(datadir,dwilist{ll}));
   buff = rot90(buff.dat(XMIN:XMAX,YMIN:YMAX,SLICE,V_DWI));
   dwi = cat(2,dwi,buff);
   
      dwi = cat(2,dwi,zeros(size(dwi,1),BLACKSIZE)); 
    
    
end
dwi = cat(2,zeros(size(dwi,1),BLACKSIZE),dwi); 



qmt = [];
for ll=1:length(qmtlist)
    
    
   buff = nifti(fullfile(datadir,qmtlist{ll}));
   buff = rot90(buff.dat(XMIN:XMAX,YMIN:YMAX,SLICE,V_QMT));
   qmt = cat(2,qmt,buff);
    

      qmt = cat(2,qmt,zeros(size(qmt,1),BLACKSIZE)); 

    
end
qmt = cat(2,zeros(size(qmt,1),BLACKSIZE),qmt);        


irse = [];
for ll=1:length(irselist)
    
    
   buff = nifti(fullfile(datadir,irselist{ll}));
   buff = rot90(buff.dat(XMIN:XMAX,YMIN:YMAX,SLICE,V_IRSE));
   irse = cat(2,irse,buff);

      irse = cat(2,irse,zeros(size(irse,1),BLACKSIZE));     
    
end
irse = cat(2,zeros(size(irse,1),BLACKSIZE),irse);        
   

mese = [];
for ll=1:length(meselist)
    
    
   buff = nifti(fullfile(datadir,meselist{ll}));
   buff = rot90(buff.dat(XMIN:XMAX,YMIN:YMAX,SLICE,V_MESE));
   mese = cat(2,mese,buff);
    
      mese = cat(2,mese,zeros(size(mese,1),BLACKSIZE)); 

    
end
mese = cat(2,zeros(size(mese,1),BLACKSIZE),mese);



%%
figure('Name',['Sub ' subject ', scan ' scan ', slice' num2str(SLICE)]);

subplot(4,1,1)
imagesc(dwi/MYNORM,[0 SCALEDWI*max(dwi(:)/MYNORM)]);
colormap gray;
axis image
set(gca,'XTick',[],'YTick',[]);
if( (g_val(1)<0) && (g_val(2)<0) && (g_val(3)<0) )
    g_val = -1*g_val;
end
title(['Diffusion (b = ' num2str(b_val) ' s/mm^2)'])
        
       

subplot(4,1,2)
imagesc(qmt/MYNORM,[0 SCALEQMT*max(qmt(:)/MYNORM)]);
colormap gray; 
axis image
set(gca,'XTick',[],'YTick',[]);
title(['Quantitative MT (FA = ' num2str(fa_val) '^\circ,  \Deltaf_0 = ' num2str(off_val/1000,'%.2f') ' KHz)']);
    


subplot(4,1,3)
imagesc(irse/MYNORM,[0 SCALEIRSE*max(irse(:)/MYNORM)]);
colormap gray; 
axis image
set(gca,'XTick',[],'YTick',[]);
title(['Inversion recovery (TI = ' num2str(ti_val) ' ms)']);


subplot(4,1,4)
imagesc(mese/MYNORM,[0 SCALEMESE*max(mese(:)/MYNORM)]);
colormap gray; 
axis image
set(gca,'XTick',[],'YTick',[]);
title(['Multi-TE (TE = ' num2str(te_val) ' ms)']);
