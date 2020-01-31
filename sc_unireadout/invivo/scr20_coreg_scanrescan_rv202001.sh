#!/bin/bash
# Co-register EPI rescan to first scan abd hen warp all rescan to first scan (London data, Philips)
# Author: Francesco Grussu <f.grussu@ucl.ac.uk>
#
# BSD 2-Clause License
# 
# Copyright (c) 2019 and 2020, University College London.
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 

rootdir="../sc_invivo/london"

# Loop through subjects
for ss in 1 2 3 4
do


	# File names
	refimg=$rootdir"/subject0"$ss"_scan01/epiref_moco.nii"
	refmask=$rootdir"/subject0"$ss"_scan01/epiref_moco_seg.nii"
	floimg=$rootdir"/subject0"$ss"_scan02/epiref_moco.nii"
	flomask=$rootdir"/subject0"$ss"_scan02/epiref_moco_seg.nii"
	outdir=$rootdir"/subject0"$ss"_scan01/rescan"
	xfmstr="epiref_moco_RescanToScan_warp.txt"

	rm -r -f -v $outdir
	mkdir $outdir


	# Estimate transformation to affinely co-register rescan to first scan
	reg_aladin -ref $refimg -flo $floimg -res $outdir"/epiref_moco_RescanToScan.nii" -aff  $outdir"/"$xfmstr


	# Now warp all MRI metrics (no denoising; this is done to provide an reference value of the intrinsic scan-rescan variability; linear interpolation)
	reg_resample -flo $rootdir"/subject0"$ss"_scan02/dwib300b1000b2000b2800_M_moco-spline/fit_fa.nii" -ref $refimg -trans $outdir"/"$xfmstr -res $outdir"/fa_RescanToScan.nii" -inter 1
	reg_resample -flo $rootdir"/subject0"$ss"_scan02/dwib300b1000b2000b2800_M_moco-spline/fit_md.nii" -ref $refimg -trans $outdir"/"$xfmstr -res $outdir"/md_RescanToScan.nii" -inter 1
	reg_resample -flo $rootdir"/subject0"$ss"_scan02/dwib300b1000b2000b2800_M_moco-spline/fit_mk.nii" -ref $refimg -trans $outdir"/"$xfmstr -res $outdir"/mk_RescanToScan.nii" -inter 1
	
	reg_resample -flo $rootdir"/subject0"$ss"_scan02/qmt_M_moco-spline/fit_kFB.nii" -ref $refimg -trans $outdir"/"$xfmstr -res $outdir"/kFB_RescanToScan.nii" -inter 1
	reg_resample -flo $rootdir"/subject0"$ss"_scan02/qmt_M_moco-spline/fit_BPF.nii" -ref $refimg -trans $outdir"/"$xfmstr -res $outdir"/BPF_RescanToScan.nii" -inter 1

	reg_resample -flo $rootdir"/subject0"$ss"_scan02/irse_M_moco-spline/fit_T1IR.nii" -ref $refimg -trans $outdir"/"$xfmstr -res $outdir"/T1_RescanToScan.nii" -inter 1
	reg_resample -flo $rootdir"/subject0"$ss"_scan02/mese_M_moco-spline/fit_TxyME.nii" -ref $refimg -trans $outdir"/"$xfmstr -res $outdir"/T2_RescanToScan.nii" -inter 1





done



