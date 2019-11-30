%% Create a .bvec file for the entire qMRI experiment to run motion correction
% Author: Francesco Grussu, f.grussu@ucl.ac.uk
%
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

addpath(genpath('../dependencies'))


%% Create .bvec for Philips

fprintf('Philips\n\n')

for ss=1:4
    for sc=1:2

        
        fprintf('Subject %d, scan %d\n\n',ss,sc)
        
        bvec_old = load(fullfile('../sc_invivo/london',...
                                ['subject0' num2str(ss) '_scan0' num2str(sc)],...
                                'dwib300b1000b2000b2800_imagespace.bvec'));
                            
        bvec_new_path = fullfile('../sc_invivo/london',...
                                ['subject0' num2str(ss) '_scan0' num2str(sc)],...
                                'dwib300b1000b2000b2800-qmt-irse-mese_imagespace.bvec');
        
        qmri_path = fullfile('../sc_invivo/london',...
                                ['subject0' num2str(ss) '_scan0' num2str(sc)],...
                                'dwib300b1000b2000b2800-qmt-irse-mese_M.nii');
                            
        qmri = nifti(qmri_path);
        qmri = qmri.dat(:,:,:,:);
        Nqmri = size(qmri,4);
                            
        g = zeros(3,Nqmri);
        g(:,1:size(bvec_old,2)) = bvec_old;
        
        dlmwrite(bvec_new_path,g,'delimiter',' ','precision','%.6f');
                            
        
        
    end
end




%% Create .bvec for NYU

fprintf('NYU\n\n')

for ss=1:2

    
        fprintf('Subject %d, scan 1\n\n',ss)

        bvec_old = load(fullfile('../sc_invivo/nyu',...
                                ['subject0' num2str(ss) 'scan01'],...
                                'dwib300b1000b2000b2800_imagespace.bvec'));
                            
        bvec_new_path = fullfile('../sc_invivo/nyu',...
                                ['subject0' num2str(ss) 'scan01'],...
                                'dwib300b1000b2000b2800-mese_imagespace.bvec');
                            
        qmri_path = fullfile('../sc_invivo/nyu',...
                                ['subject0' num2str(ss) 'scan01'],...
                                'dwib300b1000b2000b2800-mese_M.nii');
                            
        qmri = nifti(qmri_path);
        qmri = qmri.dat(:,:,:,:);
        Nqmri = size(qmri,4);                    
                            
        g = zeros(3,Nqmri);
        g(:,1:size(bvec_old,2)) = bvec_old;
        
        dlmwrite(bvec_new_path,g,'delimiter',' ','precision','%.6f');
                            

end



%% Create .bvec for Montreal

fprintf('Montreal\n\n')

for ss=1:1


        fprintf('Subject %d, scan 1\n\n',ss)   
    
        bvec_old = load(fullfile('../sc_invivo/montreal',...
                                ['subject0' num2str(ss) 'scan01'],...
                                'dwib300b1000b2000b2800_imagespace.bvec'));
                            
        bvec_new_path = fullfile('../sc_invivo/montreal',...
                                ['subject0' num2str(ss) 'scan01'],...
                                'dwib300b1000b2000b2800-mese_imagespace.bvec');
                            
        qmri_path = fullfile('../sc_invivo/montreal',...
                                ['subject0' num2str(ss) 'scan01'],...
                                'dwib300b1000b2000b2800-mese_M.nii');
                            
        qmri = nifti(qmri_path);
        qmri = qmri.dat(:,:,:,:);
        Nqmri = size(qmri,4);                    
                            
        g = zeros(3,Nqmri);
        g(:,1:size(bvec_old,2)) = bvec_old;
        
        dlmwrite(bvec_new_path,g,'delimiter',' ','precision','%.6f');
                            

end


