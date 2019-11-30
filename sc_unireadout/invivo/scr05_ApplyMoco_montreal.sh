#!/bin/bash
#### Run MOCO on qMRI data
# author: Francesco Grussu, <f.grussu@ucl.ac.uk>
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

INTERP="spline"    # Interplolation method

####### MONTREAL DATA

rootdir="../sc_invivo/montreal"
dwilist="scr05_ApplyMoco_dwinames_montreal.dat"
qmtlist="__NONE__"                 # No qMT scan @ Montreal!
irselist="__NONE__"                # No IRSE scan @ Montreal!
meselist="scr05_ApplyMoco_mesenames_montreal.dat"
xfmstr="xfmmoco_dwib300b1000b2000b2800-mese"


##### LOOP OVER DIFFERENT SUBJECTS
for SBJ in "1" 
do

	##### LOOP OVER DIFFERENT SCANS
	for SC in "1"
	do


		# Information on subject, scan and motion-correcting transformations
		datadir=$rootdir"/subject0"$SBJ"scan0"$SC
		xfmdir=$datadir"/"$xfmstr


		# Initialise volume counts
		let nvol=0
		let qmri_vol_count=0

		#### LOOP OVER DIFFERENT qMRI EXPERIMENTS
		for filelist in $dwilist $meselist
		do



			# Number of 
			let qmri_vol_count=nvol+qmri_vol_count      # Volume counter along the 4D full qMRI experiment (DWI + qMT + IRSE + MESE)

			# Loop over different denoised versions (including no denoising)
			#for NIFTI in `cat $filelist`			
			for NIFTI in `cat $filelist`
			do

				niftifile=$datadir"/"$NIFTI".nii"      # NIFTI file
				nvol=`fslval $niftifile dim4`    # Number of volumes
				currentdate=`date '+%Y%m%d_%H%M%S'`   # Date and time of execution
				tmpfolder=$datadir"/__tmp"$RANDOM"_"$currentdate    # Temporary directory		
				mkdir -v $tmpfolder    # Create temporary directory

				# Extract different volumes of exam and warp them
				for vv in `seq 1 $nvol`
				do
				

					# Extract volume along 4D NIFTI	
					let vv_fsl=vv-1          # Volume index in FSL (i.e. 0, 1, ..., nvol - 1)
					vv_fsl_str="0000000000"$vv_fsl      		 # Fiddle around with string length to create something like 0119, 0032, 0002, etc		
					vv_fsl_last=${#vv_fsl_str}
					let vv_fsl_first=vv_fsl_last-3
					vv_fsl_str=`echo $vv_fsl_str | cut -c$vv_fsl_first-$vv_fsl_last`
					fslroi $niftifile $tmpfolder"/"$NIFTI"_vol"$vv_fsl_str".nii" $vv_fsl 1     # Extract volume

					# Find registration transformation
					let xfmnr_fsl=vv_fsl+qmri_vol_count
					xfmnr_fsl_str="0000000000"$xfmnr_fsl      		 # Fiddle around with string length to create something like 0119, 0032, 0002, etc		
					xfmnr_fsl_last=${#xfmnr_fsl_str}
					let xfmnr_fsl_first=xfmnr_fsl_last-3
					xfmnr_fsl_str=`echo $xfmnr_fsl_str | cut -c$xfmnr_fsl_first-$xfmnr_fsl_last`
					xfmnifti=$xfmdir"/mat.Z0000T"$xfmnr_fsl_str"Warp.nii.gz"

					echo "File: "$tmpfolder"/"$NIFTI"_vol"$vv_fsl_str".nii"
					echo "Reg: "$xfmnifti
					echo ""
					echo ""


					# Warp the volume
					sct_apply_transfo -i $tmpfolder"/"$NIFTI"_vol"$vv_fsl_str".nii" -d $tmpfolder"/"$NIFTI"_vol"$vv_fsl_str".nii" -o $tmpfolder"/"$NIFTI"_vol"$vv_fsl_str"_warped.nii" -w $xfmnifti -x $INTERP



				done

				# Merge the different volumes as a output NIFTI
				cd $tmpfolder
				fslmerge -t $datadir"/"$NIFTI"_moco-"$INTERP".nii" `ls $tmpfolder | grep warped.nii | sort`
				cd $workingdir

				# Remove the temporary directory
				rm -r -f -v $tmpfolder

				

			done


		done
		


	done

done




