# Overview
Additional code used for "Multi-parametric quantitative spinal cord MRI with unified signal readout and image denoising". Grussu F, Battiston M, Veraart J, Schneider T, Cohen-Adad J, Shepherd TM, Alexander DC, Novikov DS, Fieremans E, Gandini Wheeler-Kingshott CAM; biorxiv 2019 (DOI: 10.1101/859538). Link to preprint [here](http://doi.org/10.1101/859538).

Contact: Francesco Grussu, `<f.grussu@ucl.ac.uk>`


# License
All files in this project are released under a BSD 2-Clause License.
See file [LICENSE](http://github.com/fragrussu/PaperScripts/blob/master/LICENSE) or go to http://github.com/fragrussu/PaperScripts/blob/master/LICENSE for full license details.



# Description
This folder contains various routines called by scripts in the [`invivo`](https://github.com/fragrussu/PaperScripts/tree/master/sc_unireadout/invivo) and [`simulations`](https://github.com/fragrussu/PaperScripts/tree/master/sc_unireadout/simulations) folders.

Additionally, before running the code in the [`invivo`](https://github.com/fragrussu/PaperScripts/tree/master/sc_unireadout/invivo) and [`simulations`](https://github.com/fragrussu/PaperScripts/tree/master/sc_unireadout/simulations) folders, you should make sure to have Matlab (The MathWorks, Inc., Natick, MA) and a Python 3 installation such as [Anaconda](http://www.anaconda.com/distribution) that includes:
* [DiPy](http://dipy.org);
* [SciPy](http://www.scipy.org);
* [NumPy](https://numpy.org);
* [Nibabel](http://nipy.org/nibabel);
* [Scikit-learn](http://scikit-learn.org/stable).


You should also download/clone here:
* [MyRelax](http://github.com/fragrussu/MyRelax);
* [MRItools](http://github.com/fragrussu/MRItools);
* [MP-PCA](http://github.com/NYU-DiffusionMRI/mppca_denoise)


and install on your machine:
* [SCT](http://github.com/neuropoly/spinalcordtoolbox);
* [NiftyReg](http://cmictig.cs.ucl.ac.uk/wiki/index.php/NiftyReg);
* [NifTK](http://github.com/NifTK/NifTK);
* [FSL](http://fsl.fmrib.ox.ac.uk/fsl/fslwiki).


You would also need some additional code for quantitative magnetisation transfer synthesis/fitting, which is available upon request. If you are interested, please contact Francesco Grussu at `<f.grussu@ucl.ac.uk>`.





