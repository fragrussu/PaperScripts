# Information
Synthetic spinal cord scans used for simulations in "Multi-parametric quantitative spinal cord MRI with unified signal readout and image denoising". Grussu F, Battiston M, Veraart J, Schneider T, Cohen-Adad J, Shepherd TM, Alexander DC, Novikov DS, Fieremans E, Gandini Wheeler-Kingshott CAM; biorxiv 2019 (DOI: 10.1101/859538). Link to preprint [here](http://doi.org/10.1101/859538).


Contact: Francesco Grussu, `<f.grussu@ucl.ac.uk>`


# License
All files in this project are released under a BSD 2-Clause License.
See file [LICENSE](http://github.com/fragrussu/PaperScripts/blob/master/LICENSE) or go to http://github.com/fragrussu/PaperScripts/blob/master/LICENSE for full license details.


# Summary description of folder content
The [`sc_phantom`](http://github.com/fragrussu/PaperScripts/tree/master/sc_unireadout/sc_phantom) folder contains the following files and sub-folders.

* README.md -> this README file
* cord.nii.gz -> spinal cord binary mask
* cord_dil1vox.nii.gz -> spinal cord binary mask dilated of 1 voxel
* dwib300b1000b2000b2800.bval -> b-values for the synthetic diffusion-weighted imaging (DWI) scan [s/mm^2]
* dwib300b1000b2000b2800_M.nii.gz -> empty file used as a reference for NIFTI headers
* dwib300b1000b2000b2800_imagespace.bvec -> gradient directions for the synthetic DWI scan
* irse.ti -> inversion times for the synthetic inversion recovery (IR) scan [ms]
* irse_M.nii.gz -> empty file used as a reference for NIFTI headers
* mese.te -> echo times used for multi-TE (mTE) imaging [ms]
* mese_M.nii.gz -> empty file used as a reference for NIFTI headers
* multimodal_images -> folder containing noise-free synthetic spinal cord scans
* multimodal_noiserealisation_gauss -> folder containing noisy/denoised synthetic spinal cord scans (Gaussian noise). Only noisy/denoised scans for a signal-to-noise ratio (SNR) of 15 are included to reduce the size of the repository. More SNRs were tested, please run script [`syn05_DenoiseOneGaussNoiseReal.m`](https://github.com/fragrussu/PaperScripts/blob/master/sc_unireadout/simulations/syn05_DenoiseOneGaussNoiseReal.m) for more SNRs
* multimodal_tissueprops -> folder containing voxel-wise tissue-specific tissue parameters used to synthesise the synthetic spinal cord scans.
* qmt.fa -> off-resonance pulse flip angles for quantitative magnetisation transfer (qMT) imaging [deg]. Note that this file contains 11 entries while the qMT NIFTIs contain 44 volumes. This is due to the fact that each off-resonance pulse is repeated 4 times; signal intensity differences among these 4 repetitions are due to the simulated order of acquisitions of the MRI slices, which mimicks the ZOOM-EPI implementation (slices acquired in multiple packages)
* qmt.off -> off-resonance pulse frequencies for qMT imaging [Hz]. Note that this file, similarly to qmt.fa, contains 11 entries while the qMT NIFTIs contain 44 volumes. This is due to the fact that each off-resonance fpulse is repeated 4 times; signal intensity differences among these 4 repetitions are due to the simulated order of acquisitions of the MRI slices, which mimicks the ZOOM-EPI implementation (slices acquired in multiple packages)
* qmt_M.nii.gz -> empty file used as a reference for NIFTI headers
* refnifti.nii.gz -> empty file used as a reference for NIFTI headers
* tissue.nii.gz -> binary mask containing cerebrospinal fluid (CSF) + spinal cord
* vcsf.nii.gz -> voxel-wise volume fraction of CSF
* vgm.nii.gz -> voxel-wise volume fraction of grey matter
* volumes.nii.gz -> empty file used as a reference for NIFTI headers
* vwm.nii.gz -> voxel-wise volume fraction of white matter




The sub-folder [`multimodal_tissueprops`](http://github.com/fragrussu/PaperScripts/tree/master/sc_unireadout/sc_phantom/multimodal_tissueprops) contains:
* adcsf_um2ms.nii.gz -> voxel-wise axial diffusivity (AD) of CSF [um^2/ms]
* adgm_um2ms.nii.gz -> voxel-wise AD of grey matter [um^2/ms]
* adwm_um2ms.nii.gz -> voxel-wise AD of white matter [um^2/ms]
* bpfgm.nii.gz -> voxel-wise bound pool fraction of grey matter
* bpfwm.nii.gz -> voxel-wise bound pool fraction of white matter
* kgm_hz.nii.gz -> voxel-wise free-to-bound pool exchange rate in grey matter [1/s]
* kwm_hz.nii.gz -> voxel-wise free-to-bound pool exchange rate in white matter [1/s]
* rdcsf_um2ms.nii.gz -> voxel-wise radial diffusivity (RD) of CSF [um^2/ms]
* rdgm_um2ms.nii.gz -> voxel-wise RD of grey matter [um^2/ms]
* rdwm_um2ms.nii.gz -> voxel-wise RD of white matter [um^2/ms]
* rhocsf.nii.gz -> voxel-wise proton density of CSF
* rhogm.nii.gz -> voxel-wise proton density of grey matter
* rhowm.nii.gz -> voxel-wise proton density of white matter
* t1csf_ms.nii.gz -> voxel-wise T1 of CSF [ms]
* t1gm_ms.nii.gz -> voxel-wise T1 of grey matter [ms]
* t1wm_ms.nii.gz -> voxel-wise T1 of white matter [ms]
* t2bgm_us.nii.gz -> voxel-wise T2 of bound pool in grey matter [us] 
* t2bwm_us.nii.gz -> voxel-wise T2 of bound pool in white matter [us]
* t2csf_ms.nii.gz -> voxel-wise macroscopic T2 of CSF [ms]
* t2gm_ms.nii.gz -> voxel-wise macroscopic T2 of grey matter [ms]
* t2wm_ms.nii.gz -> voxel-wise macroscopic T2 of white matter [ms]




The sub-folder [`multimodal_images`](http://github.com/fragrussu/PaperScripts/tree/master/sc_unireadout/sc_phantom/multimodal_images) contains:
* vartissue_dwi_M.nii.gz -> synthetic, noise-free DWI scan
* vartissue_irse_M.nii.gz -> synthetic, noise-free IR scan
* vartissue_mese_M.nii.gz -> synthetic, noise-free mTE scan
* vartissue_qmt_M.nii.gz -> synthetic, noise-free qMT scan
* vartissue_dwiirse_M.nii.gz -> concatenation of DWI and IR along 4th dimension (in this order)
* vartissue_dwimese_M.nii.gz -> concatenation of DWI and mTE along 4th dimension (in this order)
* vartissue_dwiqmt_M.nii.gz -> concatenation of DWI and qMT along 4th dimension (in this order)
* vartissue_dwiqmtirsemese_M.nii.gz -> concatenation of DWI, qMT, IR, mTE along 4th dimension (in this order)




The sub-folder [`multimodal_noiserealisation_gauss`](http://github.com/fragrussu/PaperScripts/tree/master/sc_unireadout/sc_phantom/multimodal_noiserealisation_gauss) contains:
* vartissue_dwi_noisy_snr15.nii.gz -> noisy DWI (Gaussian noise), with ...
    * vartissue_dwi_noisy_snr15_denoised.nii.gz -> denoised version
    * vartissue_dwi_noisy_snr15_nsig.nii.gz -> number of significant signal components above the Marchenko-Pastur noise distribution
    * vartissue_dwi_noisy_snr15_res.nii.gz -> residuals
    * vartissue_dwi_noisy_snr15_sigma.nii.gz -> estimate of noise standard deviation

* vartissue_irse_noisy_snr15.nii.gz -> noisy IR (Gaussian noise), with ...
    * vartissue_irse_noisy_snr15_denoised.nii.gz -> denoised version
    * vartissue_irse_noisy_snr15_nsig.nii.gz -> number of significant signal components above the Marchenko-Pastur noise distribution
    * vartissue_irse_noisy_snr15_res.nii.gz -> residuals
    * vartissue_irse_noisy_snr15_sigma.nii.gz -> estimate of noise standard deviation

* vartissue_mese_noisy_snr15.nii.gz -> noisy mTE (Gaussian noise), with ...
    * vartissue_mese_noisy_snr15_denoised.nii.gz -> denoised version
    * vartissue_mese_noisy_snr15_nsig.nii.gz  -> number of significant signal components above the Marchenko-Pastur noise distribution
    * vartissue_mese_noisy_snr15_res.nii.gz -> residuals
    * vartissue_mese_noisy_snr15_sigma.nii.gz -> estimate of noise standard deviation

* vartissue_qmt_noisy_snr15.nii.gz -> noisy qMT (Gaussian noise), with ...
    * vartissue_qmt_noisy_snr15_denoised.nii.gz -> denoised version
    * vartissue_qmt_noisy_snr15_nsig.nii.gz -> number of significant signal components above the Marchenko-Pastur noise distribution
    * vartissue_qmt_noisy_snr15_res.nii.gz -> residuals
    * vartissue_qmt_noisy_snr15_sigma.nii.gz -> estimate of noise standard deviation

* vartissue_dwiirse_noisy_snr15.nii.gz -> noisy concatenation of DWI and IR (Gaussian noise), with ...
    * vartissue_dwiirse_noisy_snr15_denoised.nii.gz -> denoised version
    * vartissue_dwiirse_noisy_snr15_nsig.nii.gz -> number of significant signal components above the Marchenko-Pastur noise distribution
    * vartissue_dwiirse_noisy_snr15_res.nii.gz -> residuals
    * vartissue_dwiirse_noisy_snr15_sigma.nii.gz -> estimate of noise standard deviation

* vartissue_dwimese_noisy_snr15.nii.gz -> noisy concatenation of DWI and mTE (Gaussian noise), with ...
    * vartissue_dwimese_noisy_snr15_denoised.nii.gz -> denoised version
    * vartissue_dwimese_noisy_snr15_nsig.nii.gz -> number of significant signal components above the Marchenko-Pastur noise distribution
    * vartissue_dwimese_noisy_snr15_res.nii.gz -> residuals
    * vartissue_dwimese_noisy_snr15_sigma.nii.gz -> estimate of noise standard deviation

* vartissue_dwiqmt_noisy_snr15.nii.gz -> noisy concatenation of DWI and qMT (Gaussian noise), with ...
    * vartissue_dwiqmt_noisy_snr15_denoised.nii.gz -> denoised version
    * vartissue_dwiqmt_noisy_snr15_nsig.nii.gz -> number of significant signal components above the Marchenko-Pastur noise distribution
    * vartissue_dwiqmt_noisy_snr15_res.nii.gz -> residuals
    * vartissue_dwiqmt_noisy_snr15_sigma.nii.gz -> estimate of noise standard deviation

* vartissue_dwiqmtirsemese_noisy_snr15.nii.gz -> noisy concatenation of DWI, qMT, IR, mTE (Gaussian noise), with ...
    * vartissue_dwiqmtirsemese_noisy_snr15_denoised.nii.gz -> denoised version
    * vartissue_dwiqmtirsemese_noisy_snr15_nsig.nii.gz -> number of significant signal components above the Marchenko-Pastur noise distribution
    * vartissue_dwiqmtirsemese_noisy_snr15_res.nii.gz -> residuals
    * vartissue_dwiqmtirsemese_noisy_snr15_sigma.nii.gz -> estimate of noise standard deviation




The sub-folder [`multimodal_noiserealisation_rician`](http://github.com/fragrussu/PaperScripts/tree/master/sc_unireadout/sc_phantom/multimodal_noiserealisation_rician) contains:
* vartissue_dwi_noisyrice_snr15.nii.gz -> noisy DWI (Rician noise), with ...
    * vartissue_dwi_noisyrice_snr15_denoised.nii.gz -> denoised version
    * vartissue_dwi_noisyrice_snr15_nsig.nii.gz -> number of significant signal components above the Marchenko-Pastur noise distribution
    * vartissue_dwi_noisyrice_snr15_res.nii.gz -> residuals
    * vartissue_dwi_noisyrice_snr15_sigma.nii.gz -> estimate of noise standard deviation

* vartissue_irse_noisyrice_snr15.nii.gz -> noisy IR (Rician noise), with ...
    * vartissue_irse_noisyrice_snr15_denoised.nii.gz -> denoised version
    * vartissue_irse_noisyrice_snr15_nsig.nii.gz -> number of significant signal components above the Marchenko-Pastur noise distribution
    * vartissue_irse_noisyrice_snr15_res.nii.gz -> residuals
    * vartissue_irse_noisyrice_snr15_sigma.nii.gz -> estimate of noise standard deviation

* vartissue_mese_noisyrice_snr15.nii.gz -> noisy mTE (Rician noise), with ...
    * vartissue_mese_noisyrice_snr15_denoised.nii.gz -> denoised version
    * vartissue_mese_noisyrice_snr15_nsig.nii.gz  -> number of significant signal components above the Marchenko-Pastur noise distribution
    * vartissue_mese_noisyrice_snr15_res.nii.gz -> residuals
    * vartissue_mese_noisyrice_snr15_sigma.nii.gz -> estimate of noise standard deviation

* vartissue_qmt_noisyrice_snr15.nii.gz -> noisy qMT (Rician noise), with ...
    * vartissue_qmt_noisyrice_snr15_denoised.nii.gz -> denoised version
    * vartissue_qmt_noisyrice_snr15_nsig.nii.gz -> number of significant signal components above the Marchenko-Pastur noise distribution
    * vartissue_qmt_noisyrice_snr15_res.nii.gz -> residuals
    * vartissue_qmt_noisyrice_snr15_sigma.nii.gz -> estimate of noise standard deviation

* vartissue_dwiirse_noisyrice_snr15.nii.gz -> noisy concatenation of DWI and IR (Rician noise), with ...
    * vartissue_dwiirse_noisyrice_snr15_denoised.nii.gz -> denoised version
    * vartissue_dwiirse_noisyrice_snr15_nsig.nii.gz -> number of significant signal components above the Marchenko-Pastur noise distribution
    * vartissue_dwiirse_noisyrice_snr15_res.nii.gz -> residuals
    * vartissue_dwiirse_noisyrice_snr15_sigma.nii.gz -> estimate of noise standard deviation

* vartissue_dwimese_noisyrice_snr15.nii.gz -> noisy concatenation of DWI and mTE (Rician noise), with ...
    * vartissue_dwimese_noisyrice_snr15_denoised.nii.gz -> denoised version
    * vartissue_dwimese_noisyrice_snr15_nsig.nii.gz -> number of significant signal components above the Marchenko-Pastur noise distribution
    * vartissue_dwimese_noisyrice_snr15_res.nii.gz -> residuals
    * vartissue_dwimese_noisyrice_snr15_sigma.nii.gz -> estimate of noise standard deviation

* vartissue_dwiqmt_noisyrice_snr15.nii.gz -> noisy concatenation of DWI and qMT (Rician noise), with ...
    * vartissue_dwiqmt_noisyrice_snr15_denoised.nii.gz -> denoised version
    * vartissue_dwiqmt_noisyrice_snr15_nsig.nii.gz -> number of significant signal components above the Marchenko-Pastur noise distribution
    * vartissue_dwiqmt_noisyrice_snr15_res.nii.gz -> residuals
    * vartissue_dwiqmt_noisyrice_snr15_sigma.nii.gz -> estimate of noise standard deviation

* vartissue_dwiqmtirsemese_noisyrice_snr15.nii.gz -> noisy concatenation of DWI, qMT, IR, mTE (Rician noise), with ...
    * vartissue_dwiqmtirsemese_noisyrice_snr15_denoised.nii.gz -> denoised version
    * vartissue_dwiqmtirsemese_noisyrice_snr15_nsig.nii.gz -> number of significant signal components above the Marchenko-Pastur noise distribution
    * vartissue_dwiqmtirsemese_noisyrice_snr15_res.nii.gz -> residuals
    * vartissue_dwiqmtirsemese_noisyrice_snr15_sigma.nii.gz -> estimate of noise standard deviation


