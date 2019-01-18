
===========================
docker-render-documentation
===========================

.. default-role:: code
.. highlight:: shell

This is the official recipe to build the Docker image
't3docs/render-documentation'.

:Authors:         TYPO3 Documentation Team
:Repository:      https://github.com/t3docs/docker-render-documentation
:Branch:          master
:Docker image:    t3docs/render-documentation,
                  https://hub.docker.com/r/t3docs/render-documentation/
:Docker tags:     https://hub.docker.com/r/t3docs/render-documentation/tags/
:Documentation:   Is being moved to https://github.com/t3docs/t3docs-documentation
                  and maintained separately
:Read more:       https://docs.typo3.org/typo3cms/RenderTYPO3DocumentationGuide/UsingDocker/
:See also:        Toolchain 'RenderDocumentation'
                  https://github.com/marble/Toolchain_RenderDocumentation
:Date:            2018-07-04
:Version:         Docker image version 'latest'='v1.6.11-full', from
                  repository branch 'master'
:Capabilites:     html, singlehtml, package, latex, pdf;
                  can read and convert ./doc/manual.sxw


Contribute
==========

Please use the `issue tracker
<https://github.com/t3docs/docker-render-documentation/issues>`__ for
contributing and reporting.


Prepare Docker
==============

You must do this only once on your system.

1. `Install Docker <https://docs.docker.com/engine/installation/>`__

2. Verify Docker is working::

      docker run --rm hello-world

   You should see::

      Hello from Docker.
      This message shows that ...

Download t3docs Docker Image
============================

You must do this once on you system. You can repeat any time to get a new version
of the Docker image.

1. Download t3docs Docker image::

      docker pull t3docs/render-documentation

2. Optional: Verify::

      docker run --rm t3docs/render-documentation

   You should see::

      t3rdf - TYPO3 render documentation full (v1.6.11-full)
      For help:
         docker run --rm t3docs/render-documentation --help
         dockrun_t3rdf --help

      ... did you mean 'dockrun_t3rdf makehtml'?


Prepare Your Documentation Project
==================================

To render something, you must have an existing documentation project.
Once you downloaded, cloned
or created your documentation project, in order to render, you
must go to the **start folder** of your PROJECT. **It should have a subfolder
Documentation**.

To create a project or download an existing project, do one of the following:

1. Clone one of the existing manuals from https://github.com/TYPO3-Documentation

   For example, for the "Getting Started" tutorial::

      git clone https://github.com/TYPO3-Documentation/TYPO3CMS-Tutorial-GettingStarted.git
      cd TYPO3CMS-Tutorial-GettingStarted


2. Or, to render the core documentation (including Changelog)::

      cd typo3/sysext/core

3. Or, to create extension documentation from scratch::

      git clone https://github.com/TYPO3-Documentation/TYPO3CMS-Example-ExtensionManual.git
      cd TYPO3CMS-Example-ExtensionManual

Quickstart on Linux
===================

Prerequisites: You have successfully installed Docker, pulled the t3docs/render-documentation
Docker image and prepared your documentation project, as described in previous
sections.

Make Function dockrun_t3rdf Available
-------------------------------------

You will run a shell script from inside the Docker container and thus make the
function dockrun_t3rdf available in your current terminal.

You must call this once every time you open a new terminal.

1. Optional: Show content of shell script::

      # just show
      docker run --rm t3docs/render-documentation show-shell-commands

2. Make function dockrun_t3rdf available in current terminal::

      # actually define - no blanks between '<('
      source <(docker run --rm t3docs/render-documentation show-shell-commands)

      # In case line `source <(...)` doesn't work on your OS use these three
        lines::

           docker run --rm t3docs/render-documentation show-shell-commands > tempfile.sh
           source tempfile.sh
           rm tempfile.sh

3. Verify and show help::

      dockrun_t3rdf --help


Render your documentation
-------------------------

1. Do the rendering

   Usually, creating html is sufficient::

      dockrun_t3rdf makehtml           # only html

   Or build all::

      dockrun_t3rdf makeall            # html, singlehtml, ...

2. Find the results::

      # html
      Documentation-GENERATED-temp/Result/project/0.0.0/Index.html

   The following will not be available, if you built with makehtml, but with makeall::

      # singlehtml (all in one file)
      Documentation-GENERATED-temp/Result/project/0.0.0/singlehtml/Index.html

   You can find the buildinfo (containing errors and warnings) here::

      # build information
      Documentation-GENERATED-temp/Result/project/0.0.0/_buildinfo/

      # Sphinx warnings and errors - should be empty!
      Documentation-GENERATED-temp/Result/project/0.0.0/_buildinfo/warnings.txt

3. Open the results in your browser

   On Linux, this should usually open the generated Index.html in your browser::

      xdg-open "Documentation-GENERATED-temp/Result/project/0.0.0/Index.html"


Quickstart on Windows
=====================

Please contribute.

The Docker image will run just fine on Windows and do the all the rendering.
What's missing is the text in this README file and the corresponding helper
functions.


Advanced
========

Run control
-----------
Select just HTML rendering and add more selectively::

   dockrun_t3rdf makehtml \                 # html is always being built
         -c make_singlehtml 1 \             # enable singlehtml
         -c make_package    1 \             # enable standalone package
         -c make_latex      1 \             # enable latex + pdf
         -c make_pdf        1               # enable pdf - on by default

Or select ALL and turn off what you don't need::

   dockrun_t3rdf makeall \                  # html is always being built
         -c make_singlehtml 0 \             # disable singlehtml
         -c make_package 0 \                # disable standalone package
         -c make_pdf 0 \                    # disable pdf
         -c make_latex 0                    # disable latex + pdf

Specifying folders
------------------
Read through the output of `docker run --rm
t3docs/render-documentation show-shell-commands` to learn about the details.

**ATTENTION:** Use absolute paths. Do not use '/' at the end.

You can render a project that's located somewhere else. Set the environment
variable `T3DOCS_PROJECT` accordingly::

   T3DOCS_PROJECT=/abs/path/to/project
   dockrun_t3rdf makehtml

or::

   T3DOCS_PROJECT=/abs/path/to/project  dockrun_t3rdf makehtml

Specify a result folder to send the result somewhere else. The final output
folder `$T3DOCS_RESULT/Documentation-GENERATED-temp` will be created::

   T3DOCS_RESULT=/abs/path/to/result
   dockrun_t3rdf makehtml

Specify a path to a temp folder if you want to expose all those many
intermediate temp files for inspection. `$T3DOCS_RESULT/tmp-GENERATED-temp`
will be used::

   T3DOCS_TMP=/tmp
   dockrun_t3rdf makehtml


Rename to default tag 'latest'
------------------------------
If you omit the tag it defaults to 'latest'. So you may want to rename the
downloaded image to 'latest' if what you downloaded was not 'latest'::

   # remove
   docker rmi t3docs/render-documentation:latest
   # pull
   docker pull t3docs/render-documentation:v1.6.11-full
   # rename
   docker tag t3docs/render-documentation:v1.6.11-full \
              t3docs/render-documentation:latest
   # use the generic name without tag, for example in ~/.bashrc
   source <(docker run --rm t3docs/render-documentation show-shell-commands)


Caching
=======

Caching information will be generated automatically and stored in
`$T3DOCS_RESULT/Cache`. Simply leave that folder untouched to make use of
the caching mechanism. With caching, for example, a `makehtml` for the TYPO3
core ChangeLog may take only 15 seconds instead of 20 minutes.

The cache information is built while `html` processing. Other writers like
`singlehtml` make use of that same caching information and are working rather
fast. Therefore in general it should not be necessary to turn them off.


Caching for ./Documentation files of a repository
=================================================

The caching mechanism considers a file to be changed when the file modification
time (mtime) has changed. Revision control systems like Git usually don't
preserve file modification times.

**Tip:** You may want to look at the https://github.com/MestreLion/git-tools
Add the script `git-restore-mtime` to your path. Then, for example, do::

   # go to repo
   cd ~Repositories/git.typo3.org/Packages/TYPO3.CMS.git
   git-restore-mtime

It only takes a few seconds to set the mtime of more than 12.500 files to a
constant and meaningful value. Each file's mtime will be set to the value of
the most recent commit that changed that file.

Repeat the `git-restore-mtime` procedure after Git operations like branch
switches and checking out files.

NEW since version version 1.6.10: If you start the container via the `dockrun_...`
command `git-restore-mtime` will be run automatically if it is an executable
and can be found.


What to ignore in GIT
=====================

**Advice:** Add a line to your *global* GIT ignore file::

   echo "*GENERATED*" >>~/.gitignore_global


Finally
=======

Enjoy!
