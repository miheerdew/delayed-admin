function log {
   local msg="$1"
   if [ $? -gt 0 ]; then
     echo -e "[\xE2\x9D\x8C] $msg" 1>&2
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
