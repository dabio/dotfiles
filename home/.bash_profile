platform=`uname -s`

# Load platform specific profile
if [ -f ~/.bash_profile_$platform ]; then
    . ~/.bash_profile_$platform
fi

# Load platform specific aliases
if [ -f ~/.bash_aliases_$platform ]; then
    . ~/.bash_aliases_$platform
fi
