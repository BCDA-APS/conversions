#!/bin/csh

# report for each synApps module if it has been tagged as ready to copy to GitHub

# For file access
#setenv SVN file:///home/joule/SVNSYNAP/svn

# For https access
setenv SVN https://subversion.xray.aps.anl.gov/synApps



foreach i ( alive autosave busy calc camac caputRecorder configure dac128V delaygen documentation dxp ebrick ip ip330 ipUnidig love mca measComp modbus motor optics quadEM sscan softGlue std stream utils vac vme xxx )
    echo -n $i
    set item=`svn log $SVN/$i | grep -i git | grep -vi igit`
    echo -n " $item"
    echo
end
