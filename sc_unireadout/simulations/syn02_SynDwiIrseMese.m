%% Genereate synthetic signals for DWI, IR and MESE
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


clear all
close all
clc
addpath(genpath('../dependencies')) 


%% input parameters
buff = '../sc_phantom/dwib300b1000b2000b2800_M.nii';
buffirse = '../sc_phantom/irse_M.nii';
buffmese = '../sc_phantom/mese_M.nii';

vcsf_file = '../sc_phantom/vcsf.nii';
vwm_file = '../sc_phantom/vwm.nii';
vgm_file = '../sc_phantom/vgm.nii';

bval = '../sc_phantom/dwib300b1000b2000b2800.bval';
bvec = '../sc_phantom/dwib300b1000b2000b2800_imagespace.bvec';
tefile = '../sc_phantom/mese.te';
tifile = '../sc_phantom/irse.ti';

outfile = fullfile('../sc_phantom/multimodal_images','vartissue_dwi_M.nii');
outfileirse = fullfile('../sc_phantom/multimodal_images','vartissue_irse_M.nii');
outfilemese = fullfile('../sc_phantom/multimodal_images','vartissue_mese_M.nii');

rho_csf_file =  fullfile('../sc_phantom/multimodal_tissueprops','rhocsf.nii');
rho_wm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','rhowm.nii');
rho_gm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','rhogm.nii');

t2_csf_file  =  fullfile('../sc_phantom/multimodal_tissueprops','t2csf_ms.nii');
t2_wm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','t2wm_ms.nii');
t2_gm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','t2gm_ms.nii');

t1_csf_file  =  fullfile('../sc_phantom/multimodal_tissueprops','t1csf_ms.nii');
t1_wm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','t1wm_ms.nii');
t1_gm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','t1gm_ms.nii');

ad_csf_file  =  fullfile('../sc_phantom/multimodal_tissueprops','adcsf_um2ms.nii');
ad_wm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','adwm_um2ms.nii');
ad_gm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','adgm_um2ms.nii');

rd_csf_file  =  fullfile('../sc_phantom/multimodal_tissueprops','rdcsf_um2ms.nii');
rd_wm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','rdwm_um2ms.nii');
rd_gm_file  =  fullfile('../sc_phantom/multimodal_tissueprops','rdgm_um2ms.nii');

TE = 72;
TEirse = 24;

if(~isdir('../sc_phantom/multimodal_images'))
   mkdir('../sc_phantom/multimodal_images'); 
end

%% Load data

% Volume fractions
vcsf = nifti(vcsf_file); vcsf = vcsf.dat(:,:,:);
vgm = nifti(vgm_file); vgm = vgm.dat(:,:,:);
vwm = nifti(vwm_file); vwm = vwm.dat(:,:,:);

% Diffusion protocol
b = load(bval); b = b/1000;
g = load(bvec);

% Sequence timing
TEs = load(tefile);
TIs = load(tifile);

rho_csf = nifti(rho_csf_file); rho_csf = rho_csf.dat(:,:,:);
rho_gm = nifti(rho_gm_file); rho_gm = rho_gm.dat(:,:,:);
rho_wm = nifti(rho_wm_file); rho_wm = rho_wm.dat(:,:,:);

t2_csf = nifti(t2_csf_file); t2_csf = t2_csf.dat(:,:,:);
t2_gm = nifti(t2_gm_file); t2_gm = t2_gm.dat(:,:,:);
t2_wm = nifti(t2_wm_file); t2_wm = t2_wm.dat(:,:,:);

t1_csf = nifti(t1_csf_file); t1_csf = t1_csf.dat(:,:,:);
t1_gm = nifti(t1_gm_file); t1_gm = t1_gm.dat(:,:,:);
t1_wm = nifti(t1_wm_file); t1_wm = t1_wm.dat(:,:,:);

ad_csf = nifti(ad_csf_file); ad_csf = ad_csf.dat(:,:,:);
ad_gm = nifti(ad_gm_file); ad_gm = ad_gm.dat(:,:,:);
ad_wm = nifti(ad_wm_file); ad_wm = ad_wm.dat(:,:,:);

rd_csf = nifti(rd_csf_file); rd_csf = rd_csf.dat(:,:,:);
rd_gm = nifti(rd_gm_file); rd_gm = rd_gm.dat(:,:,:);
rd_wm = nifti(rd_wm_file); rd_wm = rd_wm.dat(:,:,:);
%% Generate signals: DWI



dwibuff = nifti(buff); dwibuff = dwibuff.dat(:,:,:,:); dwi = zeros(size(dwibuff));
Nmeas = size(dwi,4);

fprintf('\n\nDWI\n\n')
for kk=1:size(dwi,3)
    
    fprintf('      Slice %d out of %d\n',kk,size(dwi,3));
    
    for jj=1:size(dwi,2)
        for ii=1:size(dwi,1)

            
            f_csf = vcsf(ii,jj,kk);
            f_gm = vgm(ii,jj,kk);
            f_wm = vwm(ii,jj,kk);
            
            rhoval_csf = rho_csf(ii,jj,kk);
            rhoval_gm = rho_gm(ii,jj,kk);
            rhoval_wm = rho_wm(ii,jj,kk);
            
            t2val_csf = t2_csf(ii,jj,kk);
            t2val_gm = t2_gm(ii,jj,kk);
            t2val_wm = t2_wm(ii,jj,kk);
            
            adval_csf = ad_csf(ii,jj,kk);
            adval_gm = ad_gm(ii,jj,kk);
            adval_wm = ad_wm(ii,jj,kk);
            
            rdval_csf = rd_csf(ii,jj,kk);
            rdval_gm = rd_gm(ii,jj,kk);
            rdval_wm = rd_wm(ii,jj,kk);
            
            Dcsf = [rdval_csf 0 0; 0 rdval_csf 0; 0 0 adval_csf];
            Dgm = [rdval_gm 0 0; 0 rdval_gm 0; 0 0 adval_gm];
            Dwm = [rdval_wm 0 0; 0 rdval_wm 0; 0 0 adval_wm];
            
            sig = zeros(1,Nmeas);
            
            for nn=1:Nmeas
               
                bv = b(nn);
                gv = g(:,nn);
                
                sig_csf = rhoval_csf*exp(-TE/t2val_csf)*exp(-bv*transpose(gv)*Dcsf*gv);
                sig_wm = rhoval_wm*exp(-TE/t2val_wm)*exp(-bv*transpose(gv)*Dwm*gv);
                sig_gm = rhoval_gm*exp(-TE/t2val_gm)*exp(-bv*transpose(gv)*Dgm*gv);
                
                sig(nn) = f_csf*sig_csf + f_gm*sig_gm + f_wm*sig_wm;
                
            end
            
            dwi(ii,jj,kk,:) = sig;
            
            
            
            
            
            
            
            
        end
    end
end


copyfile(buff,outfile);
mynifti = nifti(outfile);
mynifti.dat(:,:,:,:) = dwi;




%% Generate signals: IRSE


irsebuff = nifti(buffirse); irsebuff = irsebuff.dat(:,:,:,:); irse = zeros(size(irsebuff));
Nmeas = size(irse,4);

vcsf = nifti(vcsf_file); vcsf = vcsf.dat(:,:,:);
vgm = nifti(vgm_file); vgm = vgm.dat(:,:,:);
vwm = nifti(vwm_file); vwm = vwm.dat(:,:,:);

fprintf('\n\nIRSE\n\n')
for kk=1:size(irse,3)
    
    fprintf('      Slice %d out of %d\n',kk,size(irse,3));
    
    for jj=1:size(irse,2)
        for ii=1:size(irse,1)

            
            f_csf = vcsf(ii,jj,kk);
            f_gm = vgm(ii,jj,kk);
            f_wm = vwm(ii,jj,kk);
            
            rhoval_csf = rho_csf(ii,jj,kk);
            rhoval_gm = rho_gm(ii,jj,kk);
            rhoval_wm = rho_wm(ii,jj,kk);
            
            t2val_csf = t2_csf(ii,jj,kk);
            t2val_gm = t2_gm(ii,jj,kk);
            t2val_wm = t2_wm(ii,jj,kk);
            
            t1val_csf = t1_csf(ii,jj,kk);
            t1val_gm = t1_gm(ii,jj,kk);
            t1val_wm = t1_wm(ii,jj,kk);
            
            sig = zeros(1,Nmeas);
            
            for nn=1:Nmeas
               
                ti_nn = TIs(nn);
                
                sig_csf = rhoval_csf*exp(-TEirse/t2val_csf)*abs(  1 - 2*exp(-ti_nn/t1val_csf)   );
                sig_wm = rhoval_wm*exp(-TEirse/t2val_wm)*abs(  1 - 2*exp(-ti_nn/t1val_wm)   );
                sig_gm = rhoval_gm*exp(-TEirse/t2val_gm)*abs(  1 - 2*exp(-ti_nn/t1val_gm)   );
                
                sig(nn) = f_csf*sig_csf + f_gm*sig_gm + f_wm*sig_wm;
                
            end
            
            irse(ii,jj,kk,:) = sig;
            
            
            
            
            
            
            
            
        end
    end
end


copyfile(buffirse,outfileirse);
mynifti = nifti(outfileirse);
mynifti.dat(:,:,:,:) = irse;




%% Generate multi-echo spin echo

mesebuff = nifti(buffmese); mesebuff = mesebuff.dat(:,:,:,:); mese = zeros(size(mesebuff));
Nmeas = size(mese,4);

vcsf = nifti(vcsf_file); vcsf = vcsf.dat(:,:,:);
vgm = nifti(vgm_file); vgm = vgm.dat(:,:,:);
vwm = nifti(vwm_file); vwm = vwm.dat(:,:,:);

fprintf('\n\nMESE\n\n')
for kk=1:size(mese,3)
    
    fprintf('      Slice %d out of %d\n',kk,size(mese,3));
    
    for jj=1:size(mese,2)
        for ii=1:size(mese,1)

            
            f_csf = vcsf(ii,jj,kk);
            f_gm = vgm(ii,jj,kk);
            f_wm = vwm(ii,jj,kk);
            
            rhoval_csf = rho_csf(ii,jj,kk);
            rhoval_gm = rho_gm(ii,jj,kk);
            rhoval_wm = rho_wm(ii,jj,kk);
            
            t2val_csf = t2_csf(ii,jj,kk);
            t2val_gm = t2_gm(ii,jj,kk);
            t2val_wm = t2_wm(ii,jj,kk);
            
            sig = zeros(1,Nmeas);
            
            for nn=1:Nmeas
               
                te_nn = TEs(nn);
                
                sig_csf = rhoval_csf*exp(-te_nn/t2val_csf);
                sig_wm = rhoval_wm*exp(-te_nn/t2val_wm);
                sig_gm = rhoval_gm*exp(-te_nn/t2val_gm);
                
                sig(nn) = f_csf*sig_csf + f_gm*sig_gm + f_wm*sig_wm;
                
            end
            
            mese(ii,jj,kk,:) = sig;
            
            
            
        end
    end
end


copyfile(buffmese,outfilemese);
mynifti = nifti(outfilemese);
mynifti.dat(:,:,:,:) = mese;
