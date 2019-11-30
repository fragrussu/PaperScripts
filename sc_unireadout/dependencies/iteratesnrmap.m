function [theta_opt,niter] = iteratesnrmap(mag_expect,mag_std,tol)
%
% mag_expect: expected value of magnitude measurements
% mag_std: standard deviation of magnitude measurements
%
% Code required for the implementation of the method of moments
% Method of Moments: Koay and Basser, JMR 2006, http://doi.org/10.1016/j.jmr.2006.01.016
% Author: Francesco Grussu, f.grussu@ucl.ac.uk
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

% Maximum number of iterations
NITERMAX = 80;
% Iteration counter
niter = 1;
% Lower bound for the ratio of moments given one coil
minval = sqrt(pi/(4-pi));
% Get ratio of moments
momratio = mag_expect/mag_std;

% Check whether the ratio is plausible or not
if(momratio<=minval)
    theta_opt = 0;
else

	% Initialise the iterative map
	theta = momratio - minval;	
	g_of_theta = snrmap(theta,mag_expect,mag_std);

	% Iterate map
    while niter<NITERMAX
        tolval = abs(theta - g_of_theta);
        if tolval<tol
            theta_opt = theta;
            break
        else
        theta = g_of_theta;
        g_of_theta = snrmap(theta,mag_expect,mag_std);
        theta_opt = g_of_theta;
        niter = niter + 1;
        end
    end
    
end


end


