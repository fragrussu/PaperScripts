# Information
Code for simulations in "Multi-parametric quantitative spinal cord MRI with unified signal readout and image denoising". Grussu F, Battiston M, Veraart J, Schneider T, Cohen-Adad J, Shepherd TM, Alexander DC, Novikov DS, Fieremans E, Gandini Wheeler-Kingshott CAM; biorxiv 2019 (DOI: 10.1101/859538). Link to preprint [here](http://doi.org/10.1101/859538).


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

* `syn00_preliminary_unzipNIFTIGZ.sh`               ->  unzip .nii.gz files as some NIFTI readers require unzipped NIFTIs
* `syn01_CreateTissuePar.m`                         ->  synthesise tissue properties
* `syn02_SynDwiIrseMese.m`                          ->  syntehsise diffusion-weighted, inversion recovery and multi-TE imaging
* `syn03_SynQmt.m`                                  ->  synthesise qMT imaging
* `syn04_MergeScans.sh`                             ->  create multi-contrast 4D NIFTI files
* `syn05_DenoiseOneGaussNoiseReal.m`                ->  denoise one Gaussian noise realisation
* `syn06_DenoiseOneGaussNoiseReal_plot_figure1.m`   ->  plot residuals obtained after denoising one Gaussian noise realisation (used to generate Figure 1)
* `syn07_EvaluateAccPrecGaussian.m`                 ->  evaluate performances of denoising in terms of accuracy and precision
* `syn07_EvaluateAccPrecGaussian.mat`               ->  output of syn06_EvaluateAccPrecGaussian.m
* `syn08_EvaluateAccPrecGauss_plot_figure2.m`       ->  plot performances of denoising in terms of accuracy and precision (loads `syn06_EvaluateAccPrecGaussian.mat`; 
                                                      used to generate Figure 2)
* `syn09_CompareEstimatedNoiseLevel.m`              ->  compare noise estimates of different denoising strategies (for supplementary material S2)



