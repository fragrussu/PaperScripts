function [reshist_sq,logp] = GetLogResPlot(resnorm,hist_bins)
% get data to perform residual plot as Veerart et al, NIMG 2016
% 
% [reshist_sq,logp] = GetLogResPlot(resnorm,hist_bins)
% 
% INPUT
% resnorm: normalised residuals
% hist_bins: number of bins to be used for calculation
%
% OUTPUT
% reshist_sq: squred residuals (histogram bins) 
% logp: logarithm of probability inferred from histogram
%
% author: Francesco Grussu, UCL, <f.grussu@ucl.ac.uk>
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

    resnorm_array = resnorm(:);    % Get everything as an array, in case it was not already
    [Values,Edges] = histcounts(resnorm_array,'NumBin',hist_bins,'Normalization','pdf');
    NumBins = length(Values);
    BinLimits1 = min(Edges);
    BinLimits2 = max(Edges);
    BinWidth = Edges(2) - Edges(1);
    reshist = linspace(BinLimits1+BinWidth/2,BinLimits2-BinWidth/2,NumBins);
    reshist_sq = reshist.*reshist;
    logp = log(Values);
    invalidlog = isinf(logp);
    logp(invalidlog==1) = [];
    reshist_sq(invalidlog==1) = [];
    
end
