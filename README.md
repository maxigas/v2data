# v2data

Datamining the archive of the V2_ lab for unstable media.

# Install dependencies/prerequisites

Dependencies/prerequisites:

- Bash shell
- Git
- GNU tools
- wget

On a Debian-based system (such as Ubuntu, etc.):

`apt install wget git`

The Bash shell and GNU tools are installed by default.

## Install 

git clone https://github.com/maxigas/v2data

## Usage

Enter the installation directory:

`cd v2data`

Make sure bash scripts are executable:

`chmod a+x *.sh`

To get the archives:

`./load.sh`

To parse the archives:

`cd v2.nl/archive/works`

`../../../parse.sh`

To make a Git repository from the archived works:

`../../../parse.sh`

Display commits of the new Git repository:

`cd gitrepo`

`git log`






