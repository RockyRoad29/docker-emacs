# non-interactively sets a password
# if provided, argument should be of the form
#   login:password
if [ -n "$1" ] ; then
    echo $1 | chpasswd
fi
