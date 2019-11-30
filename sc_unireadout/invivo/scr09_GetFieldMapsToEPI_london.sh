#!/bin/bash
# Calculate field maps and warp them to EPI space
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


		# Information on subject and scan
		datadir=$rootdir"/subject0"$SBJ"_scan0"$SC

		# calculate B1 map
		echo "11" > $datadir"/b1af_img2.tr"
		echo "131" > $datadir"/b1af_img1.tr"
		python ../dependencies/myrelax/myrelax/getB1AFI.py $datadir"/b1af_img2.nii" $datadir"/b1af_img1.nii" $datadir"/b1af_img2.tr" $datadir"/b1af_img1.tr" $datadir"/b1af_b1map.nii"


		### Resample B1 and B0 maps using information from the FFE-to-EPI registration
		reg_resample -ref $datadir"/ffe_crop.nii" -flo $datadir"/b0field_maphz.nii" -res $datadir"/b0field_maphz2ffe_crop.nii"
		reg_resample -ref $datadir"/ffe_crop.nii" -flo $datadir"/b1af_b1map.nii" -res $datadir"/b1af_b1map2ffe_crop.nii"
		
		sct_apply_transfo -i $datadir"/b0field_maphz2ffe_crop.nii" -d $datadir"/epiref_moco.nii" -o $datadir"/b0field_maphz2epiref_moco.nii" -w $datadir"/warp_ffe_crop2epiref_moco.nii.gz"
		sct_apply_transfo -i $datadir"/b1af_b1map2ffe_crop.nii" -d $datadir"/epiref_moco.nii" -o $datadir"/b1af_b1map2epiref_moco.nii" -w $datadir"/warp_ffe_crop2epiref_moco.nii.gz"


		echo "                              done subject "$SBJ", scan "$SC
		echo ""
		echo ""
		echo ""



	done

done


