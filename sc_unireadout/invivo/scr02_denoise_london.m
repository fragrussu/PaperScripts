%% Denoise London data and perform nosie floor mitigation with the method of moments afterwards
%  Method of Moments: Koay and Basser, JMR 2006, http://doi.org/10.1016/j.jmr.2006.01.016
%  Author: Francesco Grussu, f.grussu@ucl.ac.uk
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


%% Input

datadir = '../sc_invivo/london';

Ndwi = 68;
Nqmt = 44;
Nirse = 12;
Nmese = 7;


%% Loop

fprintf('****************************************************************\n');
fprintf('                   %s\n',mfilename);
fprintf('****************************************************************\n\n\n');

% Loop across subjects
for sb=1:4
    
    fprintf('              subject: %d\n\n',sb);
    
    % Loop across scans
    for sc=1:2
        
        
        fprintf('                            scan: %d\n',sc);
        
        % Input files to be denoised and outputs
        
        %%%%%
        
        dwi = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'dwib300b1000b2000b2800_M');
        qmt = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'qmt_M');
        irse = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'irse_M');
        mese = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'mese_M');
        
        dwiqmt = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'dwib300b1000b2000b2800-qmt_M');
        dwiirse = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'dwib300b1000b2000b2800-irse_M');
        dwimese = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'dwib300b1000b2000b2800-mese_M');
        
        dwiqmtirsemese = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'dwib300b1000b2000b2800-qmt-irse-mese_M');
        
        
        %%%%
        
        dwi_single_gauss = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'dwib300b1000b2000b2800_M_densingle');
        qmt_single_gauss = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'qmt_M_densingle');
        irse_single_gauss = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'irse_M_densingle');
        mese_single_gauss = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'mese_M_densingle');
        
        dwi_single_rice = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'dwib300b1000b2000b2800_M_densingle_riceunbias');
        qmt_single_rice = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'qmt_M_densingle_riceunbias');
        irse_single_rice = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'irse_M_densingle_riceunbias');
        mese_single_rice = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'mese_M_densingle_riceunbias');
        
        
        %%%%
        
        
        dwi_joint4_gauss = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'dwib300b1000b2000b2800_M_denjointall');
        qmt_joint4_gauss = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'qmt_M_denjointall');
        irse_joint4_gauss = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'irse_M_denjointall');
        mese_joint4_gauss = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'mese_M_denjointall');
        
        dwi_joint4_rice = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'dwib300b1000b2000b2800_M_denjointall_riceunbias');
        qmt_joint4_rice = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'qmt_M_denjointall_riceunbias');
        irse_joint4_rice = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'irse_M_denjointall_riceunbias');
        mese_joint4_rice = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'mese_M_denjointall_riceunbias');
        
        %%%%
        
        dwi_joint2irse_gauss = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'dwib300b1000b2000b2800_M_denjoint2irse');
        dwi_joint2mese_gauss = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'dwib300b1000b2000b2800_M_denjoint2mese');
        dwi_joint2qmt_gauss = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'dwib300b1000b2000b2800_M_denjoint2qmt');
        qmt_joint2_gauss = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'qmt_M_denjoint2dwi');
        irse_joint2_gauss = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'irse_M_denjoint2dwi');
        mese_joint2_gauss = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'mese_M_denjoint2dwi');
        
        dwi_joint2irse_rice = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'dwib300b1000b2000b2800_M_denjoint2irse_riceunbias');
        dwi_joint2mese_rice = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'dwib300b1000b2000b2800_M_denjoint2mese_riceunbias');
        dwi_joint2qmt_rice = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'dwib300b1000b2000b2800_M_denjoint2qmt_riceunbias');
        qmt_joint2_rice = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'qmt_M_denjoint2dwi_riceunbias');
        irse_joint2_rice = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'irse_M_denjoint2dwi_riceunbias');
        mese_joint2_rice = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'mese_M_denjoint2dwi_riceunbias');
        
        
        
        % Cord mask
        dwiqmtirsemese_cord = fullfile(datadir,['subject0' num2str(sb) '_scan0' num2str(sc)],'dwib300b1000b2000b2800-qmt-irse-mese_cord');
        
        
        % Run denoising: MP without noise floor mitigation
        fprintf('                                      MP denoising... ')
        MP_slicewise_nifti([dwi '.nii'],[dwiqmtirsemese_cord '.nii'],dwi_single_gauss);
        MP_slicewise_nifti([qmt '.nii'],[dwiqmtirsemese_cord '.nii'],qmt_single_gauss);
        MP_slicewise_nifti([irse '.nii'],[dwiqmtirsemese_cord '.nii'],irse_single_gauss);
        MP_slicewise_nifti([mese '.nii'],[dwiqmtirsemese_cord '.nii'],mese_single_gauss);
        
        MP_slicewise_nifti([dwiqmt '.nii'],[dwiqmtirsemese_cord '.nii'],dwiqmt);
        MP_slicewise_nifti([dwiirse '.nii'],[dwiqmtirsemese_cord '.nii'],dwiirse);
        MP_slicewise_nifti([dwimese '.nii'],[dwiqmtirsemese_cord '.nii'],dwimese);
        
        MP_slicewise_nifti([dwiqmtirsemese '.nii'],[dwiqmtirsemese_cord '.nii'],dwiqmtirsemese);
        
        
        
        % Run denoising: MP without noise floor mitigation
        fprintf(' noise floor mitigation...')
        MPmoments_nifti([dwi '.nii'],[dwiqmtirsemese_cord '.nii'],dwi_single_rice);
        MPmoments_nifti([qmt '.nii'],[dwiqmtirsemese_cord '.nii'],qmt_single_rice);
        MPmoments_nifti([irse '.nii'],[dwiqmtirsemese_cord '.nii'],irse_single_rice);
        MPmoments_nifti([mese '.nii'],[dwiqmtirsemese_cord '.nii'],mese_single_rice);
        
        MPmoments_nifti([dwiqmt '.nii'],[dwiqmtirsemese_cord '.nii'],[dwiqmt '_riceunbias']);
        MPmoments_nifti([dwiirse '.nii'],[dwiqmtirsemese_cord '.nii'],[dwiirse '_riceunbias']);
        MPmoments_nifti([dwimese '.nii'],[dwiqmtirsemese_cord '.nii'],[dwimese '_riceunbias']);
        
        MPmoments_nifti([dwiqmtirsemese '.nii'],[dwiqmtirsemese_cord '.nii'],[dwiqmtirsemese '_riceunbias']);
        
        
        % Separate scans
        fprintf(' separating scans...')

        %%%% Extract sub-experiments from joint denoising with all modalities
        str_list={'denoised' 'res'};
        for mm=1:length(str_list)
            
            str = str_list{mm};   
            
            mynifti = nifti([dwiqmtirsemese '_' str '.nii']); mynifti = mynifti.dat(:,:,:,:); delete([dwiqmtirsemese '_' str '.nii']);
            copyfile([dwi '.nii'],[dwi_joint4_gauss '_' str '.nii']); buff = nifti([dwi_joint4_gauss '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,1:Ndwi);
            copyfile([qmt '.nii'],[qmt_joint4_gauss '_' str '.nii']); buff = nifti([qmt_joint4_gauss '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,Ndwi+1:Ndwi+Nqmt);
            copyfile([irse '.nii'],[irse_joint4_gauss '_' str '.nii']); buff = nifti([irse_joint4_gauss '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,Ndwi+Nqmt+1:Ndwi+Nqmt+Nirse);
            copyfile([mese '.nii'],[mese_joint4_gauss '_' str '.nii']); buff = nifti([mese_joint4_gauss '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,Ndwi+Nqmt+Nirse+1:Ndwi+Nqmt+Nirse+Nmese);
            
            mynifti = nifti([dwiqmtirsemese '_riceunbias_' str '.nii']); mynifti = mynifti.dat(:,:,:,:); delete([dwiqmtirsemese '_riceunbias_' str '.nii']);
            copyfile([dwi '.nii'],[dwi_joint4_rice '_' str '.nii']); buff = nifti([dwi_joint4_rice '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,1:Ndwi);
            copyfile([qmt '.nii'],[qmt_joint4_rice '_' str '.nii']); buff = nifti([qmt_joint4_rice '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,Ndwi+1:Ndwi+Nqmt);
            copyfile([irse '.nii'],[irse_joint4_rice '_' str '.nii']); buff = nifti([irse_joint4_rice '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,Ndwi+Nqmt+1:Ndwi+Nqmt+Nirse);
            copyfile([mese '.nii'],[mese_joint4_rice '_' str '.nii']); buff = nifti([mese_joint4_rice '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,Ndwi+Nqmt+Nirse+1:Ndwi+Nqmt+Nirse+Nmese);
       
        end
        
        str_list={'sigma' 'nsig'};
        for mm=1:length(str_list)
            
            str = str_list{mm};   
            
            mynifti = nifti([dwiqmtirsemese '_' str '.nii']); mynifti = mynifti.dat(:,:,:); delete([dwiqmtirsemese '_' str '.nii']);
            copyfile([dwiqmtirsemese_cord '.nii'],[dwi_joint4_gauss '_' str '.nii']); buff = nifti([dwi_joint4_gauss '_' str '.nii']); buff.dat(:,:,:,:) = mynifti;%(:,:,:,1:Ndwi);
            copyfile([dwiqmtirsemese_cord '.nii'],[qmt_joint4_gauss '_' str '.nii']); buff = nifti([qmt_joint4_gauss '_' str '.nii']); buff.dat(:,:,:,:) = mynifti;%(:,:,:,Ndwi+1:Ndwi+Nqmt);
            copyfile([dwiqmtirsemese_cord '.nii'],[irse_joint4_gauss '_' str '.nii']); buff = nifti([irse_joint4_gauss '_' str '.nii']); buff.dat(:,:,:,:) = mynifti;%(:,:,:,Ndwi+Nqmt+1:Ndwi+Nqmt+Nirse);
            copyfile([dwiqmtirsemese_cord '.nii'],[mese_joint4_gauss '_' str '.nii']); buff = nifti([mese_joint4_gauss '_' str '.nii']); buff.dat(:,:,:,:) = mynifti;%(:,:,:,Ndwi+Nqmt+Nirse+1:Ndwi+Nqmt+Nirse+Nmese);
            
            mynifti = nifti([dwiqmtirsemese '_riceunbias_' str '.nii']); mynifti = mynifti.dat(:,:,:); delete([dwiqmtirsemese '_riceunbias_' str '.nii']);
            copyfile([dwiqmtirsemese_cord '.nii'],[dwi_joint4_rice '_' str '.nii']); buff = nifti([dwi_joint4_rice '_' str '.nii']); buff.dat(:,:,:) = mynifti;%(:,:,:,1:Ndwi);
            copyfile([dwiqmtirsemese_cord '.nii'],[qmt_joint4_rice '_' str '.nii']); buff = nifti([qmt_joint4_rice '_' str '.nii']); buff.dat(:,:,:) = mynifti;%(:,:,:,Ndwi+1:Ndwi+Nqmt);
            copyfile([dwiqmtirsemese_cord '.nii'],[irse_joint4_rice '_' str '.nii']); buff = nifti([irse_joint4_rice '_' str '.nii']); buff.dat(:,:,:) = mynifti;%(:,:,:,Ndwi+Nqmt+1:Ndwi+Nqmt+Nirse);
            copyfile([dwiqmtirsemese_cord '.nii'],[mese_joint4_rice '_' str '.nii']); buff = nifti([mese_joint4_rice '_' str '.nii']); buff.dat(:,:,:) = mynifti;%(:,:,:,Ndwi+Nqmt+Nirse+1:Ndwi+Nqmt+Nirse+Nmese);
       
        end
        
        
 
        
        
        %%%% Extract sub-experiments from joint denoising with 2 modalities
        str_list={'denoised' 'res'};
        for mm=1:length(str_list)
            
            str = str_list{mm};  
            
            mynifti = nifti([dwiqmt '_' str '.nii']); mynifti = mynifti.dat(:,:,:,:); delete([dwiqmt '_' str '.nii']);
            copyfile([dwi '.nii'],[dwi_joint2qmt_gauss '_' str '.nii']); buff = nifti([dwi_joint2qmt_gauss '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,1:Ndwi);
            copyfile([qmt '.nii'],[qmt_joint2_gauss '_' str '.nii']); buff = nifti([qmt_joint2_gauss '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,Ndwi+1:Ndwi+Nqmt);
            
            mynifti = nifti([dwiirse '_' str '.nii']); mynifti = mynifti.dat(:,:,:,:); delete([dwiirse '_' str '.nii']);
            copyfile([dwi '.nii'],[dwi_joint2irse_gauss '_' str '.nii']); buff = nifti([dwi_joint2irse_gauss '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,1:Ndwi);
            copyfile([irse '.nii'],[irse_joint2_gauss '_' str '.nii']); buff = nifti([irse_joint2_gauss '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,Ndwi+1:Ndwi+Nirse);
        
            mynifti = nifti([dwimese '_' str '.nii']); mynifti = mynifti.dat(:,:,:,:); delete([dwimese '_' str '.nii']);
            copyfile([dwi '.nii'],[dwi_joint2mese_gauss '_' str '.nii']); buff = nifti([dwi_joint2mese_gauss '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,1:Ndwi);
            copyfile([mese '.nii'],[mese_joint2_gauss '_' str '.nii']); buff = nifti([mese_joint2_gauss '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,Ndwi+1:Ndwi+Nmese);
        
              
            
            mynifti = nifti([dwiqmt '_riceunbias_' str '.nii']); mynifti = mynifti.dat(:,:,:,:); delete([dwiqmt '_riceunbias_' str '.nii']);
            copyfile([dwi '.nii'],[dwi_joint2qmt_rice '_' str '.nii']); buff = nifti([dwi_joint2qmt_rice '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,1:Ndwi);
            copyfile([qmt '.nii'],[qmt_joint2_rice '_' str '.nii']); buff = nifti([qmt_joint2_rice '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,Ndwi+1:Ndwi+Nqmt);
            
            mynifti = nifti([dwiirse '_riceunbias_' str '.nii']); mynifti = mynifti.dat(:,:,:,:); delete([dwiirse '_riceunbias_' str '.nii']);
            copyfile([dwi '.nii'],[dwi_joint2irse_rice '_' str '.nii']); buff = nifti([dwi_joint2irse_rice '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,1:Ndwi);
            copyfile([irse '.nii'],[irse_joint2_rice '_' str '.nii']); buff = nifti([irse_joint2_rice '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,Ndwi+1:Ndwi+Nirse);
        
            mynifti = nifti([dwimese '_riceunbias_' str '.nii']); mynifti = mynifti.dat(:,:,:,:); delete([dwimese '_riceunbias_' str '.nii']);
            copyfile([dwi '.nii'],[dwi_joint2mese_rice '_' str '.nii']); buff = nifti([dwi_joint2mese_rice '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,1:Ndwi);
            copyfile([mese '.nii'],[mese_joint2_rice '_' str '.nii']); buff = nifti([mese_joint2_rice '_' str '.nii']); buff.dat(:,:,:,:) = mynifti(:,:,:,Ndwi+1:Ndwi+Nmese);
            
        end
        
        
        str_list={'sigma' 'nsig'};
        for mm=1:length(str_list)
            
            str = str_list{mm};  
            
            mynifti = nifti([dwiqmt '_' str '.nii']); mynifti = mynifti.dat(:,:,:); delete([dwiqmt '_' str '.nii']);
            copyfile([dwiqmtirsemese_cord '.nii'],[dwi_joint2qmt_gauss '_' str '.nii']); buff = nifti([dwi_joint2qmt_gauss '_' str '.nii']); buff.dat(:,:,:) = mynifti(:,:,:);%,1:Ndwi);
            copyfile([dwiqmtirsemese_cord '.nii'],[qmt_joint2_gauss '_' str '.nii']); buff = nifti([qmt_joint2_gauss '_' str '.nii']); buff.dat(:,:,:) = mynifti(:,:,:);%,Ndwi+1:Ndwi+Nqmt);
            
            mynifti = nifti([dwiirse '_' str '.nii']); mynifti = mynifti.dat(:,:,:); delete([dwiirse '_' str '.nii']);
            copyfile([dwiqmtirsemese_cord '.nii'],[dwi_joint2irse_gauss '_' str '.nii']); buff = nifti([dwi_joint2irse_gauss '_' str '.nii']); buff.dat(:,:,:) = mynifti(:,:,:);%,1:Ndwi);
            copyfile([dwiqmtirsemese_cord '.nii'],[irse_joint2_gauss '_' str '.nii']); buff = nifti([irse_joint2_gauss '_' str '.nii']); buff.dat(:,:,:) = mynifti(:,:,:);%,Ndwi+1:Ndwi+Nirse);
        
            mynifti = nifti([dwimese '_' str '.nii']); mynifti = mynifti.dat(:,:,:); delete([dwimese '_' str '.nii']);
            copyfile([dwiqmtirsemese_cord '.nii'],[dwi_joint2mese_gauss '_' str '.nii']); buff = nifti([dwi_joint2mese_gauss '_' str '.nii']); buff.dat(:,:,:) = mynifti(:,:,:);%,1:Ndwi);
            copyfile([dwiqmtirsemese_cord '.nii'],[mese_joint2_gauss '_' str '.nii']); buff = nifti([mese_joint2_gauss '_' str '.nii']); buff.dat(:,:,:) = mynifti(:,:,:);%,Ndwi+1:Ndwi+Nmese);
        
              
            
            mynifti = nifti([dwiqmt '_riceunbias_' str '.nii']); mynifti = mynifti.dat(:,:,:); delete([dwiqmt '_riceunbias_' str '.nii']);
            copyfile([dwiqmtirsemese_cord '.nii'],[dwi_joint2qmt_rice '_' str '.nii']); buff = nifti([dwi_joint2qmt_rice '_' str '.nii']); buff.dat(:,:,:) = mynifti(:,:,:);%,1:Ndwi);
            copyfile([dwiqmtirsemese_cord '.nii'],[qmt_joint2_rice '_' str '.nii']); buff = nifti([qmt_joint2_rice '_' str '.nii']); buff.dat(:,:,:) = mynifti(:,:,:);%,Ndwi+1:Ndwi+Nqmt);
            
            mynifti = nifti([dwiirse '_riceunbias_' str '.nii']); mynifti = mynifti.dat(:,:,:); delete([dwiirse '_riceunbias_' str '.nii']);
            copyfile([dwiqmtirsemese_cord '.nii'],[dwi_joint2irse_rice '_' str '.nii']); buff = nifti([dwi_joint2irse_rice '_' str '.nii']); buff.dat(:,:,:) = mynifti(:,:,:);%,1:Ndwi);
            copyfile([dwiqmtirsemese_cord '.nii'],[irse_joint2_rice '_' str '.nii']); buff = nifti([irse_joint2_rice '_' str '.nii']); buff.dat(:,:,:) = mynifti(:,:,:);%,Ndwi+1:Ndwi+Nirse);
        
            mynifti = nifti([dwimese '_riceunbias_' str '.nii']); mynifti = mynifti.dat(:,:,:); delete([dwimese '_riceunbias_' str '.nii']);
            copyfile([dwiqmtirsemese_cord '.nii'],[dwi_joint2mese_rice '_' str '.nii']); buff = nifti([dwi_joint2mese_rice '_' str '.nii']); buff.dat(:,:,:) = mynifti(:,:,:);%,1:Ndwi);
            copyfile([dwiqmtirsemese_cord '.nii'],[mese_joint2_rice '_' str '.nii']); buff = nifti([mese_joint2_rice '_' str '.nii']); buff.dat(:,:,:) = mynifti(:,:,:);%,Ndwi+1:Ndwi+Nmese);
            
        end
        
        
        
        fprintf('\n\n');
        
        
    end
    
    
    fprintf('\n');
    
end



