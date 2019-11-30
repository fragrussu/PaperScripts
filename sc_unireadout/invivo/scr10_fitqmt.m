%% Fit qMT 
%
% Code for qMT fitting can be obtained upon request by 
% contacting Dr Marco Battiston at marco.battiston@ucl.ac.uk
%
% Authors: Francesco Grussu f.grussu@ucl.ac.uk 
%          Marco Battiston marco.battiston@ucl.ac.uk
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
addpath(genpath('../dependencies')) 
rootdir = '../sc_invivo/london';


%% qMT fitting


for ss=1:4
    for tt=1:2
       
        
        mask = fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],'epiref_moco_seg_dil4.nii');
        b1 = fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],'b1af_b1map2epiref_moco.nii');
        b0 = fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],'b0field_maphz2epiref_moco.nii');
        t1 = fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],'irse_M_moco-spline/fit_T1IR.nii');
        
        % Denoising approaches
        qmt_noden = fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],'qmt_M_moco-spline.nii');
        out_noden = fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],'qmt_M_moco-spline');
        mkdir(out_noden)
        
        qmt_densingle = fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],'qmt_M_densingle_riceunbias_denoised_moco-spline.nii');
        out_densingle = fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],'qmt_M_densingle_riceunbias_denoised_moco-spline');
        mkdir(out_densingle)
        
        qmt_denjoint2dwi = fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],'qmt_M_denjoint2dwi_riceunbias_denoised_moco-spline.nii');
        out_denjoint2dwi = fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],'qmt_M_denjoint2dwi_riceunbias_denoised_moco-spline');
        mkdir(out_denjoint2dwi)
        
        qmt_denjointall = fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],'qmt_M_denjointall_riceunbias_denoised_moco-spline.nii');
        out_denjointall = fullfile(rootdir,['subject0' num2str(ss) '_scan0' num2str(tt)],'qmt_M_denjointall_riceunbias_denoised_moco-spline');
        mkdir(out_denjointall)
        
        fprintf('Subject %d scan %d\n\n',ss,tt);
        
        % qmt fitting
        fit_qMTEPI(qmt_noden, mask, 4, t1, b1, b0, [], [out_noden '/fit']);
        fit_qMTEPI(qmt_densingle, mask, 4, t1, b1, b0, [], [out_densingle '/fit']);
        fit_qMTEPI(qmt_denjoint2dwi, mask, 4, t1, b1, b0, [], [out_denjoint2dwi '/fit']);
        fit_qMTEPI(qmt_denjointall, mask, 4, t1, b1, b0, [], [out_denjointall '/fit']);
        
        
    end 
end



