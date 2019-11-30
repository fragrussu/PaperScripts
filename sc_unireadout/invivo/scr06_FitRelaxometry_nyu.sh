#!/bin/bash
#### Run relaxometry fitting on NYU data
# Author: Francesco Grussu, <f.grussu@ucl.ac.uk>
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


workingdir=`pwd`

####### NYU DATA
rootdir="../sc_invivo/nyu"
irselist="__NONE__"
meselist="scr06_FitMESE_nyu.dat"


##### LOOP OVER DIFFERENT SUBJECTS
for SBJ in "1" "2"  
do

	##### LOOP OVER DIFFERENT SCANS
	for SC in "1"
	do

		# Input directory
		datadir=$rootdir"/subject0"$SBJ"scan0"$SC



		###### MESE FITTING

		#### LOOP OVER DIFFERENT DENOISING APPROACHES
		for NIFTI in `cat $meselist`
		do

			outdir=$datadir"/"$NIFTI       # Output directory
			mkdir -v $outdir               # Create output directory
			niftiinput=$outdir".nii"       # NIFTI input
			outbase=$outdir"/fit"          # Basename of output files
			seqfile=$datadir"/mese.te"     # List of sequence parameters
			
			python ~/lib/python/myrelax/myrelax/getT2T2star.py  $niftiinput $seqfile $outbase --ncpu 7 --algo nonlinear



		done




	done

done 


