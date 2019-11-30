#!/bin/bash
# Segment grey matter, London data
# Author: Francesco Grussu, f.grussu@ucl.ac.uk
#
# BSD 2-Clause License
# 
# Copyright (c) 2019, University College London.
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


####### LONDON DATA

rootdir="../sc_invivo/london"

##### LOOP OVER DIFFERENT SUBJECTS
for SBJ in "1" "2" "3" "4" 
do

	##### LOOP OVER DIFFERENT SCANS
	for SC in "1" "2"
	do


		# Information on subject and scn
		datadir=$rootdir"/subject0"$SBJ"_scan0"$SC

		# Segment GM on the FFE
		sct_deepseg_gm -i $datadir"/ffe_crop.nii" -o $datadir"/ffe_crop_gm.nii" 

		# Warp the GM segmentation to diffusion space
		sct_apply_transfo -i $datadir"/ffe_crop_gm.nii" -d $datadir"/epiref_moco.nii" -w $datadir"/warp_ffe_crop2epiref_moco.nii.gz" -o $datadir"/ffe_crop_gm2epiref_moco.nii" -x nn
	
		# Obtain WM mask substracting GM from whole cord
		fslmaths $datadir"/epiref_moco_seg.nii" -sub  $datadir"/ffe_crop_gm2epiref_moco.nii"  $datadir"/ffe_crop_wm2epiref_moco.nii"

	done

done

