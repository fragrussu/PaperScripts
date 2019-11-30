function [data_den_corr,s_g,nsig,exit_info] = mppca_moments_mat(data,nbins)
% Run MP denoising on a matrix and perform "method of moments correction" on the output
% 
% Method of moments: please see
% Koay and Basser, JMR 2006, http://doi.org/10.1016/j.jmr.2006.01.016
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


% Run MP-denoising
[data_den,s_r,nsig,exit_info] = mppca_moments_mat(data,nbins);

% Loop through all measurements: mitigate noise floor in each of it
data_den_corr = zeros(size(data_den));
sigma_corr = zeros(size(data_den));
for mm=1:size(data_den,1)
    for nn=1:size(data_den,2)
        
	% Mitigate noise floor in each measurement
        data_den_meas = data_den(mm,nn);
        snr_opt = iteratesnrmap(data_den_meas,s_r,1e-08);
        corr_opt = snrfunc(snr_opt);
        sigma_corr(mm,nn) = sqrt(s_r*s_r/corr_opt);
        data_den_meas_new = sqrt( data_den(mm,nn)*data_den(mm,nn) + s_r*s_r*(corr_opt - 2)/corr_opt );   % Mitigate noise floor
        if(isreal(data_den_meas_new))   % Check that signal did actually show presence of noise floor for the estimated signal moments
           data_den_corr(mm,nn) = data_den_meas_new;
        else
            data_den_corr(mm,nn) = data_den_meas;   % Measure is already lower than noise floor and compatible with Guassian white noise 
        end
            
    end
end

% Get one summary value for sigma of noise
s_g = mean(sigma_corr(:));

end
