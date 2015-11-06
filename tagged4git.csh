#!/bin/csh

# report for each synApps module if it has been tagged as ready to copy to GitHub

# For file access
#setenv SVN file:///home/joule/SVNSYNAP/svn

# For https access
setenv SVN https://subversion.xray.aps.anl.gov/synApps

setenv APS_ITEMS ""
setenv GIT_DRIVERS ""
setenv GIT_ADMIN ""

### define where each module is located now
setenv APS_ITEMS "${APS_ITEMS} ebrick"
setenv APS_ITEMS "${APS_ITEMS} optics"
setenv APS_ITEMS "${APS_ITEMS} softGlue"
setenv APS_ITEMS "${APS_ITEMS} sscan"
setenv APS_ITEMS "${APS_ITEMS} stream"
setenv APS_ITEMS "${APS_ITEMS} xxx"

setenv GIT_DRIVERS "${GIT_DRIVERS} alive"
setenv GIT_DRIVERS "${GIT_DRIVERS} autosave"
setenv GIT_DRIVERS "${GIT_DRIVERS} busy"
setenv GIT_DRIVERS "${GIT_DRIVERS} calc"
setenv GIT_DRIVERS "${GIT_DRIVERS} camac"
setenv GIT_DRIVERS "${GIT_DRIVERS} caputRecorder"
setenv GIT_DRIVERS "${GIT_DRIVERS} dac128V"
setenv GIT_DRIVERS "${GIT_DRIVERS} delaygen"
setenv GIT_DRIVERS "${GIT_DRIVERS} dxp"
setenv GIT_DRIVERS "${GIT_DRIVERS} ip"
setenv GIT_DRIVERS "${GIT_DRIVERS} ip330"
setenv GIT_DRIVERS "${GIT_DRIVERS} ipUnidig"
setenv GIT_DRIVERS "${GIT_DRIVERS} love"
setenv GIT_DRIVERS "${GIT_DRIVERS} mca"
setenv GIT_DRIVERS "${GIT_DRIVERS} measComp"
setenv GIT_DRIVERS "${GIT_DRIVERS} modbus"
setenv GIT_DRIVERS "${GIT_DRIVERS} motor"
setenv GIT_DRIVERS "${GIT_DRIVERS} quadEM"
setenv GIT_DRIVERS "${GIT_DRIVERS} std"
setenv GIT_DRIVERS "${GIT_DRIVERS} vac"
setenv GIT_DRIVERS "${GIT_DRIVERS} vme"

setenv GIT_ADMIN "${GIT_ADMIN} utils"
setenv GIT_ADMIN "${GIT_ADMIN} configure"
setenv GIT_ADMIN "${GIT_ADMIN} documentation"


foreach i ( ${APS_ITEMS} )
    echo -n $i
    set item=`svn log $SVN/$i | grep -i git | grep -vi igit`
    echo -n " $item"
    echo
end
