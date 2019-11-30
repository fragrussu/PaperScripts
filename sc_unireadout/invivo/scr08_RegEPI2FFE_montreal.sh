#!/bin/bash
# Register anatomial scan and EPI space, Montreal data
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


# Montreal data
rootdir="../sc_invivo/montreal"
epifile="dwib300b1000b2000b2800-mese_M_moco.nii"

##### LOOP OVER DIFFERENT SUBJECTS
for SBJ in "1"
do

	##### LOOP OVER DIFFERENT SCANS
	for SC in "1"
	do


		# Information on subject and scn
		datadir=$rootdir"/subject0"$SBJ"scan0"$SC

		# 4D EPI data
		epi4dfile=$datadir"/"$epifile
		
		# Get mean EPI image
		fslmaths $epi4dfile -Tmean $datadir"/epimean_moco.nii"

		# Crop FFE
		fslroi $datadir"/ffe.nii" $datadir"/ffe_crop.nii" 160 128 160 128 0 15

		# Get FFE centerline
		sct_get_centerline -i $datadir"/ffe_crop.nii" -c t2s -o $datadir"/ffe_crop_centerline"

		# Segment cord in FFE
		sct_propseg -i $datadir"/ffe_crop.nii" -c t2s -ofolder $datadir -init-centerline $datadir"/ffe_crop_centerline.nii.gz"
		seg_maths $datadir"/ffe_crop_seg.nii" -dil 3 $datadir"/ffe_crop_seg_dil3vox.nii" 

		# Split DWI and b = 0
		sct_dmri_separate_b0_and_dwi -i $datadir"/dwib300b1000b2000b2800_M_moco-nn.nii" -bvec $datadir"/dwib300b1000b2000b2800_imagespace.bvec" -ofolder $datadir
		cp -v $datadir"/dwib300b1000b2000b2800_M_moco-nn_dwi_mean.nii" $datadir"/epiref_moco.nii"

		# Segment cord in mean DWI
		sct_propseg -i $datadir"/epiref_moco.nii" -c dwi -ofolder $datadir
		
		# Registration
		sct_register_multimodal -i $datadir"/epiref_moco.nii" -d $datadir"/ffe_crop.nii" -owarp $datadir"/warp_epiref_moco2ffe_crop.nii" -o $datadir"/epiref_moco2ffe_crop.nii" -m $datadir"/ffe_crop_seg_dil3vox.nii" -iseg $datadir"/epiref_moco_seg.nii" -dseg $datadir"/ffe_crop.nii" -param step=1,type=seg,algo=slicereg,smooth=1:step=2,type=seg,algo=bsplinesyn,metric=MeanSquares,iter=5,gradStep=0.2,smooth=1,slicewise=1:step=3,type=im,algo=bsplinesyn,metric=CC,iter=10,slicewise=1
		mv -v $datadir"/epiref_moco2ffe_crop_inv.nii" $datadir"/ffe_crop2epiref_moco.nii"
		

	done

done




