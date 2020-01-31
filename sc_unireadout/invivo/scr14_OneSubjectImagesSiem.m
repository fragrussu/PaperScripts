%% Plot images for Siemens
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




%% input options: NYU


subjectnyu = '01';
scannyu = '01';


rootdirnyu = '../sc_invivo/nyu';

SLICE = 10;

V_DWI = 55; 
V_MESE = 6;


XMIN=27;
XMAX=39;
YMIN=21;
YMAX=29;


ZOOM = 4;

MYNORM = 2.5e5/100;

BLACKSIZE = 1;

SCALEDWI = 1;
SCALEMESE = 0.6;


%% Load data and plot NYU

datadir = fullfile(rootdirnyu,['subject' subjectnyu 'scan' scannyu]);

te = load(fullfile(datadir,'mese.te'));
b = load(fullfile(datadir,'dwib300b1000b2000b2800.bval'));

b_val = b(V_DWI);
te_val = te(V_MESE);


dwilist = {'dwib300b1000b2000b2800_M.nii',...
           'dwib300b1000b2000b2800_M_densingle_denoised.nii',...
           'dwib300b1000b2000b2800_M_denjoint2mese_denoised.nii'};
       
       
meselist = {'mese_M.nii',...
            'mese_M_densingle_denoised.nii',...
            'mese_M_denjoint2dwi_denoised.nii'};  
        
dwi = [];
for ll=1:length(dwilist)
    
    
   buff = nifti(fullfile(datadir,dwilist{ll}));
   buff = rot90(buff.dat(XMIN:XMAX,YMIN:YMAX,SLICE,V_DWI));
   dwi = cat(2,dwi,buff);
   
      dwi = cat(2,dwi,zeros(size(dwi,1),BLACKSIZE)); 
    
    
end
dwi = cat(2,zeros(size(dwi,1),BLACKSIZE),dwi); 


mese = [];
for ll=1:length(meselist)
    
    
   buff = nifti(fullfile(datadir,meselist{ll}));
   buff = rot90(buff.dat(XMIN:XMAX,YMIN:YMAX,SLICE,V_MESE));
   mese = cat(2,mese,buff);
    
      mese = cat(2,mese,zeros(size(mese,1),BLACKSIZE)); 

    
end
mese = cat(2,zeros(size(mese,1),BLACKSIZE),mese);


figure('Name',['Sub ' subjectnyu ', scan ' scannyu ', slice' num2str(SLICE)]);

subplot(4,1,1)
imagesc(dwi/MYNORM,[0 SCALEDWI*max(dwi(:)/MYNORM)]);
colormap gray; 
axis image
set(gca,'XTick',[],'YTick',[]);
title(['Diffusion (b = ' num2str(b_val) ' s/mm^2) - New York']); 
       

subplot(4,1,2)
imagesc(mese/MYNORM,[0 SCALEMESE*max(mese(:)/MYNORM)]);
colormap gray; 
axis image
set(gca,'XTick',[],'YTick',[]);
title(['Multi-TE (TE = ' num2str(te_val) ' ms) - New York']);


refheight = size(dwi,1);
img1 = dwi/MYNORM;
img2 = mese/MYNORM;

%% input options: Montreal


subjectmontreal = '01';
scanmontreal = '01';


rootdirmontreal = '../sc_invivo/montreal';

SLICE = 10;

V_DWI = 77; 
V_MESE = 6;


XMIN=29;
XMAX=41;
YMIN=20;
YMAX=28;


ZOOM = 4;

MYNORM = 2.5e5/100;

BLACKSIZE = 1;

SCALEDWI = 1;
SCALEMESE = 0.6;


%% Load data and plot Montreal

datadir = fullfile(rootdirmontreal,['subject' subjectmontreal 'scan' scanmontreal]);

te = load(fullfile(datadir,'mese.te'));
b = load(fullfile(datadir,'dwib300b1000b2000b2800.bval'));

b_val = b(V_DWI);
te_val = te(V_MESE);


dwilist = {'dwib300b1000b2000b2800_M.nii',...
           'dwib300b1000b2000b2800_M_densingle_denoised.nii',...
           'dwib300b1000b2000b2800_M_denjoint2mese_denoised.nii'};
       
       
meselist = {'mese_M.nii',...
            'mese_M_densingle_denoised.nii',...
            'mese_M_denjoint2dwi_denoised.nii'};  
        
dwi = [];
for ll=1:length(dwilist)
    
    
   buff = nifti(fullfile(datadir,dwilist{ll}));
   buff = rot90(buff.dat(XMIN:XMAX,YMIN:YMAX,SLICE,V_DWI));
   dwi = cat(2,dwi,buff);
   
      dwi = cat(2,dwi,zeros(size(dwi,1),BLACKSIZE)); 
    
    
end
dwi = cat(2,zeros(size(dwi,1),BLACKSIZE),dwi); 


mese = [];
for ll=1:length(meselist)
    
    
   buff = nifti(fullfile(datadir,meselist{ll}));
   buff = rot90(buff.dat(XMIN:XMAX,YMIN:YMAX,SLICE,V_MESE));
   mese = cat(2,mese,buff); 
   mese = cat(2,mese,zeros(size(mese,1),BLACKSIZE)); 

    
end
mese = cat(2,zeros(size(mese,1),BLACKSIZE),mese);


subplot(4,1,1+2)
imagesc(dwi/MYNORM,[0 SCALEDWI*max(dwi(:)/MYNORM)]);
colormap gray; 
axis image
set(gca,'XTick',[],'YTick',[]);
title(['Diffusion (b = ' num2str(b_val) ' s/mm^2) - Montreal']); 
       

subplot(4,1,2+2)
imagesc(mese/MYNORM,[0 SCALEMESE*max(mese(:)/MYNORM)]);
colormap gray; 
axis image
set(gca,'XTick',[],'YTick',[]);
title(['Multi-TE (TE = ' num2str(te_val) ' ms) - Montreal']);
