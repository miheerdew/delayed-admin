function gexists { gentent group "$1" &> /dev/null; }
function gdel { groupdel "$1"; }
function gadd { groupadd "$1"; }
