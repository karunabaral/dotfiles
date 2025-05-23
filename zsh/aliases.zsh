alias reload!='. ~/.zshrc'

alias cls='clear' # Good 'ol Clear Screen command

# Directory navigation
alias ..='function navigate() {
    CMD="";
    if [ ! $1 ]
    then
        X=1
    elif [ "$1" = "w" ]
    then
        X=$(($(pwd | grep -o "/" | grep -c "/")-4));
    else
        X=$1
    fi;

    if [ "$1" = "b" ]
    then
        CMD="cd -"
    else
        for ((I = 0; I < $X; I++));
        do
            CMD="$CMD../";
        done;
    fi;

    echo "$CMD";
    eval $CMD;
}; navigate'
alias x='function whereami() {
    DEEP=$(pwd | grep -o "/" | grep -c "/");

    pwd;
    echo "To root:\t$DEEP dirs";
    echo "To home:\t$(($DEEP-2)) dirs";
    echo "To workspace:\t$(($DEEP-4)) dirs";
}; whereami'

# Network bounce
alias networkbounce='sudo networksetup -setv4off Wi-Fi;sudo  networksetup -setdhcp Wi-Fi'

#
# My aliases
#
alias repos='cd ~/repos';
alias dot='cd ~/.dotfiles';
alias la='ls -laFGh'
alias ld='echo "ls -flFGhd --color=always test\n" && ls -flFGhd --color=always'
alias f='echo "grep -IrisHn -C 3 --color=always test ./\n" && grep -IrisHn -C 3 --color=always'

alias get='echo "curl -o \"#1.jpg\" http://www.url.com/images/[001-100].jpg \n" && curl -o'
alias ytd='echo "youtube-dl https://www.youtube.com/watch\?v=VIDEO_ID\nRemember to put a \ before the ? when you paste the Youtube URL\n(for Mac, Windows doesn’t need)\n" && youtube-dl'
alias ytda='echo "youtube-dl -x --audio-format mp3 https://www.youtube.com/watch\?v=VIDEO_ID\nRemember to put a \ before the ? when you paste the Youtube URL\n(for Mac, Windows doesn’t need)\n" && youtube-dl -x --audio-format mp3'

alias flushdns='dscacheutil -flushcache'
alias showlib='chflags nohidden ~/Library'
alias maintain='sudo periodic daily weekly monthly'

alias cm='echo "rm -rf node_modules package-lock.json\n" && rm -rf node_modules package-lock.json'
alias ss='http-server .'
alias arti='echo "AD Username: " && read AD_LOGIN && echo "AD Password: " && read -s AD_PASSWORD && curl -u "$AD_LOGIN:$AD_PASSWORD" https://artifactory.foxsports.com.au/api/npm/auth | sed -n "1p" | sed -e "s,_auth = ,,g" | read authstr && printf "{\n  \"auths\" : {\n    \"https://artifactory.foxsports.com.au:5003\" : {\n      \"auth\" : \"" >! ~/.docker/config.json && printf "$authstr" >> ~/.docker/config.json && printf "\"\n    },\n    \"artifactory.foxsports.com.au:5001\" : {\n      \"auth\" : \"" >> ~/.docker/config.json && printf "$authstr" >> ~/.docker/config.json && printf "\"\n    },\n    \"https://artifactory.foxsports.com.au:5001\" : {\n      \"auth\" : \"" >> ~/.docker/config.json && printf "$authstr" >> ~/.docker/config.json && printf "\"\n    },\n    \"artifactory.foxsports.com.au:5003\" : {\n      \"auth\" : \"" >> ~/.docker/config.json && printf "$authstr" >> ~/.docker/config.json && printf "\"\n    }\n  }\n}" >> ~/.docker/config.json && unset -v authstr && unset -v AD_LOGIN AD_PASSWORD authstr'

# alias sydtime='sudo systemsetup -settimezone Australia/Sydney'

purge() {
    echo "Purge a file (Reminder: did you turn VPN on?)\nUsage: purge [f]";
    echo "([f]oxsports is hawk only really)\n"

    if [ $1 ]
    then
        ACC="foxsports";
    else
        ACC="streamotion";
    fi

    echo "Comma-separated files to purge:"
    read FILESTRING;
    if [ ! $FILESTRING ]
    then
        echo "You must specify at least one file! Exiting ...";
    else
        echo "Purging on account:\n  $ACC \nFiles:";
        FILEARRAY=(${(s/,/)FILESTRING});
        FILES="";

        for VAL in "${FILEARRAY[@]}"; do
            TRIMVAL="${VAL// /}";
            echo "  ${TRIMVAL}";
            FILES+="\"${TRIMVAL}\", ";
        done

        FILES="${FILES%??}";

        curl -k -X POST \
            https://fsdevfe01.foxsports.com.au/akamai/fast-purge \
            -H 'Content-Type: application/json' \
            -H 'access-header: service-developer' \
            -d "{\"account\":\"$ACC\", \"files\":[$FILES]}" \
            --silent \
            | python3 -m json.tool
    fi
}

alias stagepurge='echo "Purging Staging Fiso Version\n" && purge https://resources.streamotion.com.au/staging/common/web-server/fiso-versions.json'
alias prodpurge='echo "Purging Staging Fiso Version\n" && purge https://resources.streamotion.com.au/production/common/web-server/fiso-versions.json'

alias nw='npm-why'

alias porto='echo "sudo lsof -PiTCP -sTCP:LISTEN\n" && sudo lsof -PiTCP -sTCP:LISTEN'
alias porti='echo "sudo lsof -i :8080\n" && sudo lsof -i'
alias portk='echo "kill PID, kill -2/-1/-9 PID\n" && kill'

alias nrb='echo "npm run build\n" && npm run build'
alias nrbw='echo "npm run build && npm run watch\n" && npm run build && echo "\n\n\n\n\n\n\n\n\n\n----- RUNNING WATCH NOW ------\n\n\n\n\n\n\n\n\n\n" && npm run watch'
alias nrw='echo "npm run watch\n" && npm run watch'
alias niw='echo "npm ci && npm run watch\n" && npm ci && npm run watch'

alias addmui='echo "deprecated, use addrepo\n" && addrepo'
alias addrepo='function addrepo() {
    echo "Add a bitbucket repo\n\nCommit hash: ";
    read COMMIT;

    if [ ! $COMMIT ]
    then
        echo "Please enter a valid commit hash";
    else
        REPO=${1:-mui};
        PROJECT=${3:-mar};
        PACKAGE="@kayo/$REPO@git+ssh://git@bitbucket.foxsports.com.au:7999/$PROJECT/$REPO.git#$COMMIT";

        if [ ! $2 ]
        then
            SAVE_TYPE="save";
        else
            SAVE_TYPE="save-dev"
        fi;

        echo "npm i --$SAVE_TYPE \"$PACKAGE\"\n";
        npm i --$SAVE_TYPE \"$PACKAGE\";
    fi;
}; addrepo'

alias viz='function viz() {
    echo "npm run viz:golden OR npm run viz:specified TEST_NAME\n";
    if [ ! $1 ]
    then
        npm run viz:golden
    else
        npm run viz:specified $1
    fi;
}; viz'

alias et='function e2etest() {
    if [ ! $1 ]
    then
        echo "Package version [$1]:";
        read READ_PACKAGE_VER;
    fi;
    PACKAGE_VER=${READ_PACKAGE_VER:-$1};

    if [ ! $2 ]
    then
        echo "QA build number [$2]:"
        read READ_QA_BUILD_NUM;
    fi;
    QA_BUILD_NUM=${READ_QA_BUILD_NUM:-$2};

    if [ ! $3 ]
    then
        echo "Local [y]:"
        read READ_IS_LOCAL;
    fi;
    IS_LOCAL=${READ_IS_LOCAL:-y};
    TEST_TYPE="local";

    if [ "$IS_LOCAL" != "y" ]
    then
        TEST_TYPE="docker";
    fi;

    CMD="FISO_ENV=staging MARTIAN_CTV_WIDGETS_VERSION=$PACKAGE_VER-qa$QA_BUILD_NUM npm run e2e:$TEST_TYPE";

    echo "$CMD\n";
    eval $CMD;
}; e2etest'

alias getperms='echo "stat -f \"%OLp\"\n" && stat -f "%OLp"'

alias killsym='~/bin/sep stop'

# See what ports are used
alias portcheck="lsof -nP +c 15 | grep LISTEN"

# When docker misbehaves... kill everything!
alias diedockerdie="docker kill $(docker ps -q); docker rm $(docker ps --filter=status=exited --filter=status=created -q); docker rmi $(docker images -a -q) -f"

# On changing AD password, artifactory password update on docker file
# alias dockerartifactory="docker login https://artifactory.foxsports.com.au:5001"

# unused
# alias runtests='echo "grunt build-tests && testem ci -f test/testem-ci.json -R tap"; grunt build-tests && testem ci -f test/testem-ci.json -R tap'
# alias grw='echo "grunt watcher\n" && grunt watcher'
# alias grd='echo "grunt default\n" && grunt default'
# alias grdw='echo "grunt default && grunt watcher\n" && grunt default && echo "\n\n\n\n\n\n\n\n\n\n----- RUNNING WATCHER NOW ------\n\n\n\n\n\n\n\n\n\n" && grunt watcher'

function v {
    if [ -f package.json ]; then
        echo `npm version`
    else
        print "No package.json detected in this directory"
        return 1;
    fi

    if (($# == 0))
        then
            echo 'Please specify npm version (patch, minor, major) or specific version'
            echo 'e.g. "v 1.12.1" or "v major"'
            return 1;
    fi

    echo "Updating version: `npm version` to version: $1"
    echo 'Going to run the following commands:'
    echo '```'
    echo '    git fetch'
    echo '    git checkout develop && git reset --hard origin/develop'
    echo "    npm version $1"
    echo '    git checkout master && git reset --hard origin/master'
    echo '    git merge develop'
    echo '```'

    echo "I'll ask again before pushing anything to remote. Go ahead and do it? (y/n)"
    while true; do
        read doit
        case $doit in
            [Yy]* )
                git fetch && git checkout develop && git reset --hard origin/develop && npm version $1 && git checkout master && git reset --hard origin/master && git merge develop
                break;;
            [Nn]* )
                echo 'Aborting...';
                return 1;;
            * )
                echo 'Please choose y or n';;
        esac
    done

    echo "New version: `npm version` tagged. Push develop & master to remote? (y/n)"
    while true; do
        read yn
        case $yn in
            [Yy]* )
                git push --tags && git push && git checkout develop && git push
                break;;
            [Nn]* )
                echo 'Try to reset changes on local master/develop using:';
                echo 'git co develop && git tag -l | xargs git tag -d && git fetch --tags'; # reset tags on develop
                echo 'git co master && git reset --hard origin/master && git tag -l | xargs git tag -d && git fetch --tags'; # reset master to origin and reset tags
                return 1;;
            * )
                echo 'Please choose y or n';;
        esac
    done
}