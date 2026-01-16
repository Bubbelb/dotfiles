function _tide_item_yazi
  set -l upid (string trim (ps -o ppid= $fish_pid))
  echo "UPID: $upid" >> $HOME/FFF
  ps -o comm= $upid >> $HOME/FFF
  basename (ps -o comm= $upid) >> $HOME/FFF
  while ps -o comm= $upid | string match -qr '^.*/?fish$'
    echo "UPNEW: $upid" >> $HOME/FFF
    set upid (string trim (ps -o ppid= $upid))
  end
    if ps -o comm= $upid | string match -qr '^.*/?yazi$'
      _tide_print_item yazi $tide_yazi_icon
    end
end
