#!/bin/bash


# First, go to the https://github.com/epics-modules web page 
# and create a new repository for the $1 module
# give it a comment, such as: synApps $1 module
# (substituting the module name for $1)

# requires installation of git-svn package
# for users.txt, see: https://github.com/nirvdrum/svn2git#authors
#Allow SYNAPPSSVNURL to be a local mirror on disk
if test -z "$SYNAPPSSVNURL"; then
  SYNAPPSSVNURL=https://subversion.xray.aps.anl.gov/synApps
fi
git svn clone $SYNAPPSSVNURL/$1 --authors-file=users.txt --no-metadata -s $1

if test -z "$GITHUB_TARGET_ORG"; then
  export GITHUB_TARGET_ORG=epics-modules
  #export GITHUB_TARGET_ORG=EPICS-synApps
  #export GITHUB_TARGET_ORG=BCDA-APS
fi

cd $1
cp -Rf .git/refs/remotes/tags/* .git/refs/tags/
rm -Rf .git/refs/remotes/tags/
rm -Rf .git/refs/remotes/trunk
cp -Rf .git/refs/remotes/* .git/refs/heads/
rm -Rf .git/refs/remotes/
cp ../template.gitignore ./.gitignore
cp ../LICENSE ./

touch README.md
echo "# $1"		                         2>&1 >  README.md
echo "APS BCDA synApps module: $1"		 2>&1 >> README.md
echo "" 					 2>&1 >> README.md
echo "For more information, see" 		 2>&1 >> README.md
echo "   http://www.aps.anl.gov/bcda/synApps" 	 2>&1 >> README.md
echo "" 					 2>&1 >> README.md
echo "converted from APS SVN repository: `date`" 2>&1 >> README.md
echo "" 					 2>&1 >> README.md
echo "Regarding the license of tagged versions prior to synApps 4-5," 2>&1 >> README.md
echo "refer to http://www.aps.anl.gov/bcda/synApps/license.php"       2>&1 >> README.md

cp README.md ./.git/description

git add README.md
git add .gitignore
git add LICENSE
git commit -m "initial commit after move from APS SVN"

# ----------------------------------------------------------------------
# see: http://stackoverflow.com/questions/22368123/create-new-repo-by-git-remote-add-origin-and-push
# creates a new project on GitHub with the name of current directory
# requires: https://hub.github.com/
#   and then git is made an alias for hub
#   git create does not exist
#   hub create exists
#git create -d "synApps $1 module"
#
# this method is not working either:
#curl -u 'prjemian' https://api.github.com/user/repos -d '{"name":"$1","description":"synApps $1 module"}'
# ----------------------------------------------------------------------

#https://www.kernel.org/pub/software/scm/git/docs/gitattributes.html
echo '#Which files need CRLF handling' >.gitattributes
echo '* text=auto'      >>.gitattributes
echo '*.sh eol=lf'    >>.gitattributes
echo '*.bat eol=crlf' >>.gitattributes
echo '*.cmd -text' >>.gitattributes
rm .git/index     # Remove the index to force Git to
git reset         # re-scan the working directory
git add -u
git add .gitattributes
git commit -m "Introduce end-of-line normalization"

git remote add origin git@github.com:$GITHUB_TARGET_ORG/$1.git

# for this next step to succeed, you need:
# 1. your ssh password to be entered (in the pop-up GUI)
# 2. to have the $1 repo already created (but empty) on https://github.com
git push origin --all
git push origin --tags

# do not forget to add this new repo to one or more of the GitHub "teams"
