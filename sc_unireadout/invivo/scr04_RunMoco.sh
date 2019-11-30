#!/bin/bash
#### Run MOCO on EPI data
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


####### LONDON DATA

rootdir="../sc_invivo/london"


for SBJ in "1" "2" "3" "4"    ###### <---- CONTINUE FROM HERE! SUBJECT 1 ALREADY RUN!
do

	for SC in "1" "2"
	do


		datadir=$rootdir"/subject0"$SBJ"_scan0"$SC
		qmri=$datadir"/dwib300b1000b2000b2800-qmt-irse-mese_M.nii"
		bvec=$datadir"/dwib300b1000b2000b2800-qmt-irse-mese_imagespace.bvec"

		# Run motion correction without removing the temporary directory and with very verbose output
		sct_dmri_moco -i $qmri -bvec $bvec -ofolder $datadir -r 0 -v 2


		# Copy output transformations!
		echo ""
		echo ""
		echo ""
		echo ""
		echo "ATTENTION PLEASE!!!"
		echo "Data in: "$datadir
		read -p "BEFORE CONTINUING, COPY TRANSFORMATIONS USING ANOTHER TERMINAL!"
		echo ""
		echo ""

	done

done




####### NYU DATA

rootdir="../sc_invivo/nyu"


for SBJ in "1" "2"
do



		datadir=$rootdir"/subject0"$SBJ"scan01"
		qmri=$datadir"/dwib300b1000b2000b2800-mese_M.nii"
		bvec=$datadir"/dwib300b1000b2000b2800-mese_imagespace.bvec"

		# Run motion correction without removing the temporary directory and with very verbose output
		sct_dmri_moco -i $qmri -bvec $bvec -ofolder $datadir -r 0 -v 2

		# Copy output transformations!
		echo ""
		echo ""
		echo ""
		echo ""
		echo "ATTENTION PLEASE!!!"
		echo "Data in: "$datadir
		read -p "BEFORE CONTINUING, COPY TRANSFORMATIONS USING ANOTHER TERMINAL!"
		echo ""
		echo ""


done




####### MONTREAL DATA

rootdir="../sc_invivo/montreal"


for SBJ in "1"
do



		datadir=$rootdir"/subject0"$SBJ"scan01"
		qmri=$datadir"/dwib300b1000b2000b2800-mese_M.nii"
		bvec=$datadir"/dwib300b1000b2000b2800-mese_imagespace.bvec"

		# Run motion correction without removing the temporary directory and with very verbose output
		sct_dmri_moco -i $qmri -bvec $bvec -ofolder $datadir -r 0 -v 2

		# Copy output transformations!
		echo ""
		echo ""
		echo ""
		echo ""
		echo "ATTENTION PLEASE!!!"
		echo "Data in: "$datadir
		read -p "BEFORE CONTINUING, COPY TRANSFORMATIONS USING ANOTHER TERMINAL!"
		echo ""
		echo ""


done
