#!/bin/bash
## Segment spinal cord on Philips data
# Author: Francesco Grussu <f.grussu@ucl.ac.uk>
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

rootdir="../sc_invivo/london"

# Loop through subjects
for ss in 1 2 3 4
do		

	# Loop through scans
	for cc in 1 2
	do
			
			# Data directory
			datadir=$rootdir"/subject0"$ss"_scan0"$cc 
			echo "Analysing subject "$datadir

			# Separate b = 0 and DWI data
			mkdir -v $datadir"/dwisgm"
			sct_dmri_separate_b0_and_dwi -i $datadir"/dwib300b1000b2000b2800_M.nii" -bvec $datadir"/dwib300b1000b2000b2800_imagespace.bvec" -ofolder $datadir"/dwisgm"
			# Extract centerline from mean DWI data
			sct_get_centerline -i $datadir"/dwisgm/dwi_mean.nii" -c dwi -ofolder $datadir"/dwisgm"
			
			# Compute mask around centerline with sct_propseg
			mkdir -v $datadir"/dwisgm/smg"
			sct_propseg -i $datadir"/dwisgm/dwi_mean.nii" -c t1 -init-centerline $datadir"/dwisgm/dwi_mean_centerline_optic.nii" -ofolder $datadir"/dwisgm/smg"
			cp -v $datadir"/dwisgm/smg/dwi_mean_seg.nii" $datadir"/dwib300b1000b2000b2800_cord.nii"
			rm -r -f -v $datadir"/dwisgm"

			# Convert to float
			fslmaths $datadir"/dwib300b1000b2000b2800_cord.nii" -mul 1.0 $datadir"/dwib300b1000b2000b2800_cord.nii"

			# Dilate cord mask of two voxels
			fslmaths $datadir"/dwib300b1000b2000b2800_cord.nii" -dilM $datadir"/dwib300b1000b2000b2800_cord_dil1vox.nii"
			fslmaths $datadir"/dwib300b1000b2000b2800_cord_dil1vox.nii" -dilM $datadir"/dwib300b1000b2000b2800_cord_dil2vox.nii" 


	done

done


