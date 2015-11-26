#!/usr/bin/env python

'''
show chronology of tags for all EPICS synApps modules in a table

mine the GitHub EPICS synApps module repositories for data

:see: http://jacquev6.net/PyGithub/v1/introduction.html
'''

import datetime
import github
import pprint
import pyRestTable
import sys
from synApps import _DB_


REPOSITORY = 'epics-modules/motor'
#REPOSITORY = 'BCDA-APS/motor'
CREDS_FILE = 'creds.txt'


def unique_list(items):
    '''eliminate redundant items, sort'''
    return sorted({_:_ for _ in items}.keys())


def iso8601(ts):
    '''reformat the datetime string into iso8601'''
    timestamp = ' '.join(ts.split()[:5])
    dts = datetime.datetime.strptime(timestamp, '%a, %d %b %Y %X')
    timestamp = datetime.datetime.strftime(dts, '%Y-%m-%d %X')
    return timestamp


def tagDates(account, repository_name):
    '''return a dictionary of all tags by iso8601 date'''
    gh_repo = account.get_repo(repository_name)
    db = {}
    for t in gh_repo.get_tags():
        # print t.commit.commit.last_modified, t.commit.sha, t.name
	db[iso8601(t.commit.commit.last_modified)] = t.name
    return db


def report(db):
     '''report the results in a table to stdout'''
     pprint.pprint(db)
     dates = []
     for m in db.values():
    	 dates += m.keys()
     dates = unique_list(dates)
     modules = sorted(db.keys())
     table = pyRestTable.Table()
     table.addLabel('released')
     for m in sorted(modules):
    	 table.addLabel(m)

     # get unique list of datetimes
     for ts in sorted(dates):
 	 row = [ts]
 	 for module in sorted(modules):
 	     if ts in db[module]:
 	 	 row.append(db[module][ts])
 	     else:
 	 	 row.append('')
 	 table.addRow(row)
     try:
    	 print table.reST()
     except Exception, why:
    	 pass


def main():
    '''read the tag history from GitHub and make a report'''

    def process_modules(org, modules):
 	for module in sorted(modules):
 	    repo = org + '/' + module
 	    print repo
 	    sys.stdout.flush()
 	    db[module] = tagDates(gh, repo)

    # my GH credentials, do not upload CREDS_FILE to any server
    user, passwd = open(CREDS_FILE, 'r').read().strip().splitlines()
    gh = github.Github(user, passwd)
    db = {}

    dates = []
    org = 'epics-modules'
    modules = unique_list('''
   	     alive calc caputRecorder motor ip std xxx optics vac vme love
   	     quadEM iocStats sscan softGlue measComp asyn delaygen mca
   	     autosave busy dxp camac ip330 dac128V ipUnidig modbus stream
   	     '''.strip().split())
    process_modules(org, modules)

    org = 'EPICS-synApps'
    modules = unique_list('''
   	     support configure utils documentation
   	     '''.strip().split())
    process_modules(org, modules)

    #org = 'BCDA-APS'
    #modules = ['motor']
    #process_modules(org, modules)

    report(db)


def read_db():
    '''read the tag history from a file and make a report'''
    from synApps import db
    report(db)

if __name__ == '__main__':
    main()
    #read_db()
