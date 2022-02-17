# BioConductor repositories 

This document summarizes various use cases for working with BioConductor repositories and its packages.

* Installing packages via `BiocManager::install()` and `install.packages()` only
* Publishing content to RStudio Connect
* Repeat the same with `renv`


## Prerequisites

* A version of R installed
* CRAN repository configured and reported by `options()$repos`
* `BiocManager` package installed, either at user level or as part of the system default packages
* Subsequently, any reference to "R profile" implies that the setting can be put either in `Rprofile.site` (global setting) or `.Rprofile` (user or project level setting). 


## Installing and working with packages

### Public CRAN and BioConductor repositories

#### The "BioConductor" way

As per [BioConductor](https://www.bioconductor.org/install/), any BioConductor **and** CRAN package can be installed via

```bash
BiocManager::install("PackageName")
```

#### The "CRAN" way

`install.packages()` by default is restricted to CRAN repositories only. BioConductor packages can be installed via `install.packages()` when setting
```
options(repos=c(BiocManager::repositories()))
```
in the R profile. Note: The above setting is independent of the R version and will always use the most recent BioConductor release [compatible](https://bioconductor.org/about/release-announcements/#release-versions) with your R Version. Users that want to use a specific BioConductor release need to set this version as `version` parameter in `BiocManager::repositories()`, e.g. `version="3.13"`. 

#### Using `renv`

The general workflow is described on the [renv webpage](https://rstudio.github.io/renv/). By default `renv::init()` will only pick up packages from CRAN. In order to make it also use BioConductor packages, you need to add `bioconductor=TRUE` as an parameter, i.e. 

```
renv::init(bioconductor=TRUE)
```

which will use the most recent BioConductor release [compatible](https://bioconductor.org/about/release-announcements/#release-versions) with your R Version. In case you would like to use a different BioConductor release, replace `TRUE` with the BioConductor version string, e.g. `bioconductor="3.13"`. 

Any `renv` initialized in such a way can be restored with `renv::restore()` and only uses the information in `renv.lock`. Users that are interested in the details will realize that the BioConductor version is defined in `renv.lock`, e.g. 
```
  "Bioconductor": {
    "Version": "3.14"
  },
```

### Public RSPM

The public [RStudio Package Manager (RSPM)](https://packagemanager.rstudio.com) is a service provided by RStudio. It mirrors both CRAN and BioConductor repositories. In addition it provides time-based snapshots for CRAN similar to [MRAN](https://mran.microsoft.com/) but in addition offers package binaries for many Enterprise Linux distributions. Additionally the repository URLs can be made immutable against any future change in package metadata for maximum reproducibility.

In order to repeat the same procedures as outlined [above](#public-cran-and-bioconductor-repositories), you will need to point both the CRAN repo definition and the BioConductor mirror to the one from public RSPM via

```
options(repos=c(CRAN="https://packagemanager.rstudio.com/cran/latest"))
options(BioC_mirror = "https://packagemanager.rstudio.com/bioconductor")
```

in your R profile. The above will make the latest package versions from CRAN and BioConductor available. 

#### Use of time-based CRAN snapshots

Time-based snapshots can be used for increased reproducibility, especially in environments where the users do not make use of `renv` for fixing their R package versions. By setting a time-based snapshot, any R package installation without a specific package version definition will install the most recent version available at the given snapshot. Such snapshots and their respective URL can be selected by clicking on a calendar date in the Section "Repository URL" of the "Setup" page for CRAN and selecting "Freeze". For the snapshot of Nov 26th, 2021, the URL is "https://packagemanager.rstudio.com/cran/2021-11-26". 

If time-based CRAN snapshots are used, it is advisable to set the dates  to a time when the BioConductor version compatible](https://bioconductor.org/about/release-announcements/#release-versions) with the R version was released to ensure compatibility. 

#### Immutability/Lock of of CRAN Package Data

In addition to plain time-based snapshots, the package data available for a given date can be locked against future changes by selecting "Lock Package Data" in the "Repository URL" section of the Setup Page for the CRAN repo. For Nov 26th, 2021, the URL is "https://packagemanager.rstudio.com/cran/2021-11-26+MTo2NTMyOTYwOzhBNzEyRTVE". 

#### Use of binary CRAN packages

RSPM only supports binary packages for CRAN. In order to make use of those, the Client OS needs to be set accordingly. In the Setup page for the CRAN Repo the respective URL containing the binaries can be selected in the subsection of "Repository URL` with title "Use source or binary packages". For latest CRAN packages built for "Ubuntu 20.04 LTS (Focal)" this would lead to "https://packagemanager.rstudio.com/cran/\_\_linux__/focal/latest". 

### Private RSPM

If a private RSPM is used, the largest freedom is possible. In principle, nothing changes from what was described [before](#public-rstudio-package-manager) for public RSPM except that the hostname changes. 

Additional capabilities come into play via the creation of custom CRAN-like repositories that can mix BioConductor releases with latest or time-based snapshots of CRAN.  

Such an approach is described in detail in the [RSPM admin guide](https://docs.rstudio.com/rspm/admin/appendix/source-details/#bioc-cran-like-repo) and in the [Quickstart of the same](https://docs.rstudio.com/rspm/admin/getting-started/configuration/#quickstart-bioconductor-r-repos). The basic idea is to create repo named to the liking of the organisation using the private RSPM (bioconductor-3.11 in the referenced example) and then subscribe the source of the appropriate BioConductor release and a selected CRAN snapshot to this repo (latest CRAN can be subscribed as well but see the comments about [BioConductor-CRAN compatibility](#use-of-time-based-cran-snapshots). Of course additional package sources (e.g. local, git based) can be subscribed to this repo, too. 

Once such a setup is in place, this custom repo only can be set in the repo definition using the same approach as outlined for [public RSPM](#public-rspm) - only `install.packages()` or `renv::install()` can be used. The use of `BiocManager::install()` is no longer needed. 

For a custom repo named "bioconductor-3.14" that contains both latest CRAN and BioConductor release 3.14, the appropriate repo setting would be 
```
options(repos=c(pRSPM="https://hostname-of-private-rspm/bioconductor-3.14/latest"))
```
where `hostname-of-private-rspm` corresponds to the DNS name of your local/private RSPM. 

## Publishing to RStudio Connect

### 
