function log {
   local err="${2-$?}"
   local msg="$1"
   if [ $err -gt 0 ]; then
     echo -e "[\xE2\x9D\x8C] $msg" 1>&2
     exit $err
   else
     echo -e "[\xE2\x9C\x94] $msg"
   fi
}

case $OSTYPE in
    darwin*) . ./lib/macos.sh
             ;;
    linux*) . ./lib/linux.sh
            ;;
    *) echo "Unknown OS."
       exit 1;
esac
