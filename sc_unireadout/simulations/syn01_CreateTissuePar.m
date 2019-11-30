%% Generate voxel-wise tissue properties adding within tissue varaibility
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
clear all
close all
clc

%% Libraries
addpath(genpath('../dependencies'));

%% Clear all
std_ratio = 0.10;   % STD = std_ratio * MEAN for each metric of WM and GM
refniti = '../sc_phantom/refnifti.nii';
outdir = '../sc_phantom/multimodal_tissueprops';

%%% Mean values of metrics

rhocsf = 100;
rhogm = 80;
rhowm = 70;

t2wm = 70;
t2gm = 80;
t2csf = 800;

t1wm = 1000;
t1gm = 1200;
t1csf = 4000;

MDcsf = 3;
ADwm = 2.10;
RDwm = 0.40;
ADgm = 1.60;
RDgm = 0.55;

BPFwm = 0.14;
BPFgm = 0.08;
t2bwm = 12;   % mus
t2bgm = 12;   % mus
kwm = 2.3;       % Hz
kgm = 1.7;       % Hz


%% Load useful information and create output folder

if(~isdir(outdir))
    mkdir(outdir);
end

buffer = nifti(refniti); buffer = buffer.dat(:,:,:);

%% Create metrics: CSF


% rho
outfile = fullfile(outdir,'rhocsf.nii');
copyfile(refniti,outfile); saver = nifti(outfile); saver.dat(:,:,:) = rhocsf*ones(size(buffer));

% T2
outfile = fullfile(outdir,'t2csf_ms.nii');
copyfile(refniti,outfile); saver = nifti(outfile); saver.dat(:,:,:) = t2csf*ones(size(buffer));

% T1
outfile = fullfile(outdir,'t1csf_ms.nii');
copyfile(refniti,outfile); saver = nifti(outfile); saver.dat(:,:,:) = t1csf*ones(size(buffer));

% AD
outfile = fullfile(outdir,'adcsf_um2ms.nii');
copyfile(refniti,outfile); saver = nifti(outfile); saver.dat(:,:,:) = MDcsf*ones(size(buffer));

% RD
outfile = fullfile(outdir,'rdcsf_um2ms.nii');
copyfile(refniti,outfile); saver = nifti(outfile); saver.dat(:,:,:) = MDcsf*ones(size(buffer));




%% Create metrics: WM


% rho
outfile = fullfile(outdir,'rhowm.nii');
copyfile(refniti,outfile); saver = nifti(outfile);
map = rhowm + std_ratio*rhowm*randn(size(buffer)); map(map<0) = 0; map(map>rhocsf) = rhocsf;
saver.dat(:,:,:) = map;


% T2
outfile = fullfile(outdir,'t2wm_ms.nii');
copyfile(refniti,outfile); saver = nifti(outfile);
map = t2wm + std_ratio*t2wm*randn(size(buffer)); map(map<0) = 0; map(map>t2csf) = t2csf;
saver.dat(:,:,:) = map;


% T1
outfile = fullfile(outdir,'t1wm_ms.nii');
copyfile(refniti,outfile); saver = nifti(outfile);
map = t1wm + std_ratio*t1wm*randn(size(buffer)); map(map<0) = 0; map(map>t1csf) = t1csf;
saver.dat(:,:,:) = map;


% AD and RD (check that they do not get swapped
outfilead = fullfile(outdir,'adwm_um2ms.nii');
copyfile(refniti,outfilead); saverad = nifti(outfilead);
admap = ADwm + std_ratio*ADwm*randn(size(buffer)); admap(admap<0) = 0; admap(admap>MDcsf) = MDcsf;
outfilerd = fullfile(outdir,'rdwm_um2ms.nii');
copyfile(refniti,outfilerd); saverrd = nifti(outfilerd);
rdmap = RDwm + std_ratio*RDwm*randn(size(buffer)); rdmap(rdmap<0) = 0; rdmap(rdmap>MDcsf) = MDcsf;
adfinal = admap;  rdfinal = rdmap;
adfinal(rdmap>admap) = rdmap(rdmap>admap);
rdfinal(rdmap>admap) = admap(rdmap>admap);
saverad.dat(:,:,:) = adfinal; saverrd.dat(:,:,:) = rdfinal;

% BPF
outfile = fullfile(outdir,'bpfwm.nii');
copyfile(refniti,outfile); saver = nifti(outfile);
map = BPFwm + std_ratio*BPFwm*randn(size(buffer)); map(map<0) = 0; map(map>1) = 1;
saver.dat(:,:,:) = map;


% T2b
outfile = fullfile(outdir,'t2bwm_us.nii');
copyfile(refniti,outfile); saver = nifti(outfile);
map = t2bwm + std_ratio*t2bwm*randn(size(buffer)); map(map<0) = 0;
saver.dat(:,:,:) = map;


% K
outfile = fullfile(outdir,'kwm_hz.nii');
copyfile(refniti,outfile); saver = nifti(outfile);
map = kwm + std_ratio*kwm*randn(size(buffer)); map(map<0) = 0;
saver.dat(:,:,:) = map;




%% Create metrics: GM


% rho
outfile = fullfile(outdir,'rhogm.nii');
copyfile(refniti,outfile); saver = nifti(outfile);
map = rhogm + std_ratio*rhogm*randn(size(buffer)); map(map<0) = 0; map(map>rhocsf) = rhocsf;
saver.dat(:,:,:) = map;


% T2
outfile = fullfile(outdir,'t2gm_ms.nii');
copyfile(refniti,outfile); saver = nifti(outfile);
map = t2gm + std_ratio*t2gm*randn(size(buffer)); map(map<0) = 0; map(map>t2csf) = t2csf;
saver.dat(:,:,:) = map;


% T1
outfile = fullfile(outdir,'t1gm_ms.nii');
copyfile(refniti,outfile); saver = nifti(outfile);
map = t1gm + std_ratio*t1gm*randn(size(buffer)); map(map<0) = 0; map(map>t1csf) = t1csf;
saver.dat(:,:,:) = map;


% AD and RD (check that they do not get swapped
outfilead = fullfile(outdir,'adgm_um2ms.nii');
copyfile(refniti,outfilead); saverad = nifti(outfilead);
admap = ADgm + std_ratio*ADgm*randn(size(buffer)); admap(admap<0) = 0; admap(admap>MDcsf) = MDcsf;
outfilerd = fullfile(outdir,'rdgm_um2ms.nii');
copyfile(refniti,outfilerd); saverrd = nifti(outfilerd);
rdmap = RDgm + std_ratio*RDgm*randn(size(buffer)); rdmap(rdmap<0) = 0; rdmap(rdmap>MDcsf) = MDcsf;
adfinal = admap;  rdfinal = rdmap;
adfinal(rdmap>admap) = rdmap(rdmap>admap);
rdfinal(rdmap>admap) = admap(rdmap>admap);
saverad.dat(:,:,:) = adfinal; saverrd.dat(:,:,:) = rdfinal;

% BPF
outfile = fullfile(outdir,'bpfgm.nii');
copyfile(refniti,outfile); saver = nifti(outfile);
map = BPFgm + std_ratio*BPFgm*randn(size(buffer)); map(map<0) = 0; map(map>1) = 1;
saver.dat(:,:,:) = map;


% T2b
outfile = fullfile(outdir,'t2bgm_us.nii');
copyfile(refniti,outfile); saver = nifti(outfile);
map = t2bgm + std_ratio*t2bgm*randn(size(buffer)); map(map<0) = 0;
saver.dat(:,:,:) = map;


% K
outfile = fullfile(outdir,'kgm_hz.nii');
copyfile(refniti,outfile); saver = nifti(outfile);
map = kgm + std_ratio*kgm*randn(size(buffer)); map(map<0) = 0;
saver.dat(:,:,:) = map;

