#!/bin/bash
# Fit DKI on NYU data
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


####### NYU DATA
rootdir="../sc_invivo/nyu/nyu"
dwilist="scr05_ApplyMoco_dwinames_nyu.dat"



##### LOOP OVER DIFFERENT SUBJECTS
for SBJ in "1" "2"  
do

	##### LOOP OVER DIFFERENT SCANS
	for SC in "1"
	do

		# Data directory
		datadir=$rootdir"/subject0"$SBJ"scan0"$SC
	
		##### LOOP OVER DIFFUSION SCANS
		for DIFF in `cat $dwilist`
		do

			# Output directory
			mocodirspline=$datadir"/"$DIFF"_moco-spline"

			# Remove old directories
			rm -r -f -v $mocodirspline
			mkdir -v $mocodirspline

			# NIFTIs
			moconiftispline=$mocodirspline".nii"

			# b-val/b-vec files
			bvec=$datadir"/dwib300b1000b2000b2800_imagespace.bvec"
			bval=$datadir"/dwib300b1000b2000b2800.bval"			

			# Fitting
			python ../dependencies/MRItools/MRItools/fitdki.py $moconiftispline $mocodirspline"/fit" $bval $bvec

		done

		


	done

done


