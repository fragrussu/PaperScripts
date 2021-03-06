# Information
Code for in vivo analyses in "Multi-parametric quantitative in vivo spinal cord MRI with unified signal readout and image denoising". Grussu F, Battiston M, Veraart J, Schneider T, Cohen-Adad J, Shepherd TM, Alexander DC, Fieremans E, Novikov DS, Gandini Wheeler-Kingshott CAM; [NeuroImage 2020, 217: 116884](http://doi.org/10.1016/j.neuroimage.2020.116884) (DOI: 10.1016/j.neuroimage.2020.116884).


Contact: Francesco Grussu, `<f.grussu@ucl.ac.uk>`


# License
All files in this project are released under a BSD 2-Clause License.
See file [LICENSE](http://github.com/fragrussu/PaperScripts/blob/master/LICENSE) or go to http://github.com/fragrussu/PaperScripts/blob/master/LICENSE for full license details.


# Dependencies

* Niftimatlib                -> http://sourceforge.net/projects/niftilib/files/niftimatlib/ (to be downloaded to ../dependencies)
* MP-PCA code                -> http://github.com/NYU-DiffusionMRI/mppca_denoise (to be downloaded to ../dependencies)
* qMT code                   -> available upon request, please contact Dr Francesco Grussu <f.grussu@ucl.ac.uk> or Dr Marco Battiston <marco.battiston@ucl.ac.uk> (to be placed when available to ../dependencies)
* FSL                        -> http://fsl.fmrib.ox.ac.uk/fsl/fslwiki
* NiftyReg                   -> http://cmictig.cs.ucl.ac.uk/wiki/index.php/NiftyReg
* NifTK                      -> http://cmiclab.cs.ucl.ac.uk/CMIC/NifTK
* MyRelax                    -> http://github.com/fragrussu/MyRelax (to be downloaded to ../dependencies)
* MRItools                   -> http://github.com/fragrussu/MRItools (to be downloaded to ../dependencies)
* DiPy                       -> http://dipy.org/
* SciPy                      -> http://www.scipy.org/
* NumPy                      -> https://numpy.org/
* Nibabel                    -> http://nipy.org/nibabel/
* Scikit-learn               -> http://scikit-learn.org/stable/
* Python standard library    -> available in any python distribution such as Anaconda (http://www.anaconda.com/distribution/)
* unzip command              -> available as `sudo apt install unzip` for Linux

Please also see folder [`dependencies`](https://github.com/fragrussu/PaperScripts/blob/master/sc_unireadout/dependencies/README.md).


# Summary description of scripts

* `scr01_segment_dwi_philips.sh`                  ->  segment the spinal cord to denoise only within the spinal cord (Philips)
* `scr01_segment_dwi_prisma.sh`                   ->  segment the spinal cord to denoise only within the spinal cord (Prisma)
* `scr02_denoiserice_london.m`                    ->  denoise the London data
* `scr02_denoise_prisma.m`                        ->  denoise the NYU and Montreal data
* `scr03_create_bvec_allmultimod.m`               ->  create useful information to use sct_dmri_moco to all EPI volumes
* `scr04_RunMoco.sh`                              ->  motion correction of all data (estimate transformations)
* `scr05_ApplyMoco_london.sh`                     ->  motion correction of London data (apply transformations to all denoising strategies)
* `scr05_ApplyMoco_montreal.sh`                   ->  motion correction of Montreal data (apply transformations to all denoising strategies)
* `scr05_ApplyMoco_nyu.sh`                        ->  motion correction of NYU data (apply transformations to all denoising strategies)
* `scr06_FitRelaxometry_london.sh`                ->  fit relaxometry on London data
* `scr06_FitRelaxometry_montreal.sh`              ->  fit relaxometry on Montreal data
* `scr06_FitRelaxometry_nyu.sh`                   ->  fit relaxometry on NYU data
* `scr07_FitDKI_london.sh`                        ->  fit DKI on London data
* `scr07_FitDKI_montreal.sh`                      ->  fit DKI on Montreal data
* `scr07_FitDKI_nyu.sh`                           ->  fit DKI on NYU data
* `scr08_RegEPI2FFE_london.sh`                    ->  register anatomical scan and EPI, London data
* `scr08_RegEPI2FFE_montreal.sh`                  ->  register anatomical scan and EPI, Montreal data
* `scr08_RegEPI2FFE_nyu.sh`                       ->  register anatomical scan and EPI, NYU data
* `scr09_GetFieldMapsToEPI_london.sh`             ->  warp field maps defined in anatomical space to EPI, London data
* `scr10_fitqmt.m`                                ->  fit qMT, London data
* `scr11_deepseggm_london.sh`                     ->  segment grey matter, London data
* `scr11_deepseggm_montreal.sh`                   ->  segment grey matter, Montreal data
* `scr11_deepseggm_nyu.sh`                        ->  segment grey matter, NYU data
* `scr12_cov_gm_london.m`                         ->  evaluate coefficient of variations (COVs) of metrics, grey matter, London data
* `scr12_cov_gm_prisma.m`                         ->  evaluate coefficient of variations (COVs) of metrics, grey matter, Prisma data
* `scr12_cov_wm_london.m`                         ->  evaluate coefficient of variations (COVs) of metrics, white matter, London data
* `scr12_cov_wm_prisma.m`                         ->  evaluate coefficient of variations (COVs) of metrics, white matter, Prisma data
* `scr12_med_gm_london.m`                         ->  evaluate medians of metrics, grey matter, London data
* `scr12_med_gm_prisma.m`                         ->  evaluate medians of metrics, grey matter, Prisma data
* `scr12_med_wm_london.m`                         ->  evaluate medians of metrics, white matter, London data
* `scr12_med_wm_prisma.m`                         ->  evaluate medians of metrics, white matter, Prisma data
* `scr13_OneSubjectImagesPhil.m`                  ->  plot examples of images from London data
* `scr13_OneSubjectResidualsPhil.m`               ->  plot examples of residuals from London data
* `scr14_OneSubjectImagesSiem.m`                  ->  plot examples of images from NYU and Montreal data
* `scr14_OneSubjectResidualsSiem.m`               ->  plot examples of residuals from NYU and Montreal data
* `scr15_OneSubjectMetricsPhil.m`                 ->  plot examples of metrics from London data
* `scr16_OneSubjectMetricsSiemNY.m`               ->  plot examples of metrics from NYU data
* `scr17_OneSubjectMetricsSiemMon.m`              ->  plot examples of metrics from Montreal data
* `scr18_PlotSigmaNoise_london.m`                 ->  plot estimates of noise levels from London data
* `scr18_PlotSigmaNoise_prisma.m`                 ->  plot estimates of noise levels from NYU and Montreal data
* `scr19_diffmap_philips_rv202001.m`              ->  calculate difference maps for all parametric metrics (with denoising - without denoising), London data
* `scr19_diffmap_siemens_mon_rv202001.m`          ->  calculate difference maps for all parametric metrics (with denoising - without denoising), Montreal data
* `scr19_diffmap_siemens_nyu_rv202001.m`          ->  calculate difference maps for all parametric metrics (with denoising - without denoising), New York data
* `scr20_coreg_scanrescan_rv202001.sh`            ->  co-register scan and rescan (rescan warped to scan) with NiftyReg, London data
* `scr21_scanrescancov_gm_london_rv202001.m`      ->  calculate intrinsic metric variability without denoising from scan-rescan, London data (grey matter) 
* `scr21_scanrescancov_wm_london_rv202001.m`      ->  calculate intrinsic metric variability without denoising from scan-rescan, London data (white matter) 
* `scr22_estimatesnr_london_rv202001.m`           ->  estimate signal-to-noise ratio (SNR) on vendor 1 (Philips Achieva, London)
* `scr22_estimatesnr_prisma_rv202001.m`           ->  estimate signal-to-noise ratio (SNR) on vendor 2 (Siemens Prisma, Montreal and New York)
* `scr23_cnr_london_rv202001.m`                   ->  evaluate contrast-to-noise ration (CNR) on vendor 1 (Philips Achieva, London)
* `scr23_cnr_prisma_rv202001.m`                   ->  evaluate contrast-to-noise ration (CNR) on vendor 2 (Siemens Prisma, Montreal and New York)
* `cnr.m`                                         ->  function evaluationg contrast-to-noise ratio (CNR)

