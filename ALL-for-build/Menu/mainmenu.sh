#!/bin/bash
# http://www.thegeekstuff.com/2010/07/bash-case-statement/

source /ALL/Downloads/envvars.sh

# provide defaults
export OUR_IMAGE=${OUR_IMAGE:-t3docs/render-documentation}
export OUR_IMAGE_SHORT=${OUR_IMAGE_SHORT:-t3rd}
export OUR_IMAGE_SLOGAN=${OUR_IMAGE_SLOGAN:-t3rd_TYPO3_render_documentation}

# export of site-packages requested?
if [[ -w "/RESULT/Cache/site-packages/EXPORT_TO_HERE" ]]; then true
   rsync -a --delete \
      "/usr/local/lib/python2.7/site-packages" \
      "/RESULT/Cache/"
fi

function mm-minimalhelp(){
   cat <<EOT
$OUR_IMAGE_SLOGAN (${OUR_IMAGE_VERSION})
For help:
   docker run --rm $OUR_IMAGE --help
   ${DOCKRUN_PREFIX}$OUR_IMAGE_SHORT --help

... did you mean '${DOCKRUN_PREFIX}$OUR_IMAGE_SHORT makehtml'?

EOT
}

function mm-usage() {
   cat <<EOT
Usage:
    Prepare:
        Define function '${DOCKRUN_PREFIX}$OUR_IMAGE_SHORT' on the commandline of your system:
            source <(docker run --rm $OUR_IMAGE show-shell-commands)
        Inspect function:
            declare -f ${DOCKRUN_PREFIX}${OUR_IMAGE_SHORT}"
    Usage:
        ${DOCKRUN_PREFIX}$OUR_IMAGE_SHORT [ARGS]
            ARGUMENT             DESCRIPTION
            --help               Show this menu
            makeall              Run for production - create ALL
            makehtml             Run for production - create only HTML
            tct                  Run TCT, the toolchain runner
            show-howto           Show howto
            show-faq             Show questions and answers
            show-shell-commands  Show useful shell commands and functions
            /bin/bash            Enter the container's Bash shell

    Examples:
        ${DOCKRUN_PREFIX}$OUR_IMAGE_SHORT
        ${DOCKRUN_PREFIX}$OUR_IMAGE_SHORT --help
        ${DOCKRUN_PREFIX}$OUR_IMAGE_SHORT show-faq
        ${DOCKRUN_PREFIX}$OUR_IMAGE_SHORT /bin/bash
        ...

End of usage.
EOT
}

function mm-show-howto() {
   $(dirname $0)/show-howto.sh
}

function mm-show-faq() {
   $(dirname $0)/show-faq.sh
}

function mm-show-shell-commands() {
   $(dirname $0)/show-shell-commands.sh
}

function mm-tct() {
   shift
   tct $@
}

function tell-about-results() {
local exitstatus=$1
if [ $exitstatus -eq 0 ]
then
   cat <<EOT

Final exit status: 0 (completed)

Find the (possible) results. For example:
   ./Documentation-GENERATED-temp/.../Index.html
   ./Documentation-GENERATED-temp/.../singlehtml/Index.html
   ./Documentation-GENERATED-temp/.../_pdf/
   ./Documentation-GENERATED-temp/.../_buildinfo/
   ./Documentation-GENERATED-temp/.../_buildinfo/warnings.txt
EOT
else
   cat <<EOT

Final exit status: $exitstatus (aborted)

Check for results:
   ./Documentation-GENERATED-temp/
EOT
fi
}

function mm-makeall() {
   local cmd
   shift

# make sure nothing is left over from previous run
if [[ -f /tmp/RenderDocumentation/Todo/ALL.source-me.sh ]]
then
   rm -f /tmp/RenderDocumentation/Todo/ALL.source-me.sh
fi
cmd="tct --cfg-file=/ALL/Rundir/tctconfig.cfg -v"
cmd="$cmd run RenderDocumentation -c makedir /ALL/Makedir"
cmd="$cmd -c make_latex 1 -c make_package 1 -c make_pdf 1 -c make_singlehtml 1"
cmd="$cmd $@"
eval $cmd

local exitstatus=$?

# do localizations
if [[ -f /tmp/RenderDocumentation/Todo/ALL.source-me.sh ]]
then
   source /tmp/RenderDocumentation/Todo/ALL.source-me.sh
fi

if [[ ( $exitstatus -eq 0 ) \
   && ( -d /ALL/dummy_webroot/typo3cms/drafts/project ) \
   && ( -d /RESULT ) ]]
then
rsync -a /ALL/dummy_webroot/typo3cms/drafts/project /RESULT/Result/ --delete
exitstatus=$?
fi

tell-about-results $exitstatus
}

function mm-makehtml() {
   local cmd
   shift

# make sure nothing is left over from previous run
if [[ -f /tmp/RenderDocumentation/Todo/ALL.source-me.sh ]]
then
   rm -f /tmp/RenderDocumentation/Todo/ALL.source-me.sh
fi
cmd="tct --cfg-file=/ALL/Rundir/tctconfig.cfg -v"
cmd="$cmd run RenderDocumentation -c makedir /ALL/Makedir"
cmd="$cmd -c make_latex 0 -c make_package 0 -c make_pdf 0 -c make_singlehtml 0"
cmd="$cmd $@"
eval $cmd

local exitstatus=$?

# do localizations
if [[ -f /tmp/RenderDocumentation/Todo/ALL.source-me.sh ]]
then
   source /tmp/RenderDocumentation/Todo/ALL.source-me.sh
fi

if [[ ( $exitstatus -eq 0 ) \
   && ( -d /ALL/dummy_webroot/typo3cms/drafts/project ) \
   && ( -d /RESULT ) ]]
then
rsync -a /ALL/dummy_webroot/typo3cms/drafts/project /RESULT/Result/ --delete
exitstatus=$?
fi

tell-about-results $exitstatus
}

case "$1" in
--help)              mm-usage $@ ;;
makeall)             mm-makeall $@ ;;
makehtml)            mm-makehtml $@ ;;
show-shell-commands) mm-show-shell-commands $@ ;;
show-faq)            mm-show-faq $@ ;;
show-howto)          mm-show-howto $@ ;;
tct)                 mm-tct $@ ;;
*)                   mm-minimalhelp $@ ;;
esac
