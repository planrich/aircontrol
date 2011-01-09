#!/bin/bash

#
# pinboard widget installer by hamstiglue
#
# install widgets on your wetab pinboard:
#
# starter icons:
# ~~~~~~~~~~~~~~
# add-widget.sh [ -f ] <widgetname> <picture.png 168x105> <binary> [<arguments>]
#
# * -f          forces to overwrite an existing widget with the same widgetname
# * widgetname: just a name for internal use, must be unique
# * picture:    path to picture shown on your pinboard, must be of size 168x105 pixels
# * binary:     name of program to be executed
# * aguments:   optional arguments to program
#
#
# real widgets:
# ~~~~~~~~~~~~~
# add-widget.sh [ -f | -u ] <libwidget.so>
#
# * -f            forces to overwrite an existing widget with the same widgetname
# * -u            uninstalls the widget
# * libwidget.so: name of the widget library to be installed or uninstalled
#

if [ $UID -gt 0 ] ; then
  USERNAME=$USER
else
  source /var/tiitoo/registration/device_registered
fi

APPPATH=/home/$USERNAME/.appdata/tiitoo-pinnwand/tiitoo-localbookmarks
LIBPATH=/usr/lib/tiitoo/apps
	
SQLITEDB=/var/tiitoo/pinnwand/pinnwand.db.sqlite
SQLITEBIN=/usr/bin/sqlite3

if [ "$1" == "-f" ] ; then
  FORCE_OVERWRITE=1
  shift
else
  FORCE_OVERWRITE=0
fi

if [ "$1" == "-u" ] ; then
  UNINSTALL=1
  shift
else
  UNINSTALL=0
fi

WIDGETNAME="$1"
WIDGETPIC="$2"
WIDGETBIN="$3"
WIDGETARGS="$4"
WIDGETEXISTS=0

if [ -z "$WIDGETNAME" ] ; then
  echo "usage: add-widget.sh [ -f ] <widgetname> <picture.png 168x105> <binary> [<arguments>]"
  echo "   or: add-widget.sh [ -f | -u ] <libwidget.so>"
  exit 1;
fi

if echo "$WIDGETNAME" | egrep "lib.+\.so" >/dev/null 2>&1 ; then
  LIBMODE=1
else
  LIBMODE=0
fi

if [ $LIBMODE -eq 1 ] ; then

  if [ $UID -gt 0 ] ; then
    echo "please run as root"
    exit 1;
  fi

  WIDGETFILE="$WIDGETNAME"
  WIDGETLIB="$(basename "$WIDGETFILE")"
  WIDGETNAME="$(basename "$WIDGETLIB" .so)"
  WIDGETNAME="$(echo "$WIDGETNAME" | cut -c4-)"
  WIDGETPRE="4tiitoo"
  WIDGETPATH="$LIBPATH/$WIDGETPRE-$WIDGETNAME"
  WIDGETDEST="$WIDGETPATH/$WIDGETLIB"
  WIDGETUUID="$(echo "$WIDGETDEST" | md5sum | perl -pe 's/(.{8})(.{4})(.{4})(.{4})(.{12}) .+/$1-$2-$3-$4-$5/')"

  if [ $UNINSTALL -eq 1 ] ; then

    $SQLITEBIN $SQLITEDB "delete from apprecord where userId = '$USERNAME' and PkgName = '$WIDGETPRE-$WIDGETNAME';"
    $SQLITEBIN $SQLITEDB "delete from widgetrecord where userId = '$USERNAME' and appPkgName = '$WIDGETPRE-$WIDGETNAME';"

    if [ -e "$WIDGETDEST" ] ; then
      rm -f "$WIDGETDEST"
      rmdir "$WIDGETPATH"
      killall tiitoo-pinnwand
    fi
    
    exit 0;
  fi

  if [ ! -e "$WIDGETFILE" ] ; then
    echo "file '$WIDGETFILE' doesn't exist"
    exit 1;
  fi
  
  if [ -e "$WIDGETDEST" ] ; then
    WIDGETEXISTS=1
  fi

else # LIBMODE=0

  if [ -z "$WIDGETPIC" ] ; then
    echo "need widgetpicture (168x105 png file)"
    exit 1;
  fi
  
  if [ ! -r "$WIDGETPIC" ] ; then
    echo "file '$WIDGETPIC' doesn't exist"
    exit 1;
  fi
  
  WIDGETBIN="$(which "$WIDGETBIN")"
  
  if [ -z "$WIDGETBIN" ] ; then
    echo "need widgetbinary"
    exit 1;
  fi
  
  if [ ! -e "$WIDGETBIN" ] ; then
    echo "file '$WIDGETBIN' doesn't exist"
    exit 1;
  fi
  
  if [ ! -x "$WIDGETBIN" ] ; then
    echo "file '$WIDGETBIN' isn't executable"
    exit 1;
  fi
  
  if [ -s "$WIDGETARGS" ] ; then
    WIDGETBIN="$WIDGETBIN "
  fi
  
  if [ -e "$APPPATH/$WIDGETNAME.desktop" ] ; then
    WIDGETEXISTS=1
  fi
  
fi
  
if [ $WIDGETEXISTS -gt 0 ] && [ $FORCE_OVERWRITE -eq 0 ] ; then
  echo "widget '$WIDGETNAME' already exists, use -f to overwrite"
  exit 1;
fi

if [ $LIBMODE -eq 1 ] ; then

  mkdir -p "$WIDGETPATH"
  chmod 755 "$WIDGETPATH"
  cp -p "$WIDGETFILE" "$WIDGETDEST"
  chmod 644 "$WIDGETDEST"
  chown -R root.root "$WIDGETPATH"
  
  ID_OLD=$($SQLITEBIN -list $SQLITEDB "select max(id) from widgetrecord;")
  ID_NEW="$ID_OLD"
  TRIES=100
  
  su - $USERNAME -c "dbus-send --session --type=method_call --dest=com.tiitoo.Pinnwand /com/tiitoo/Pinnwand com.tiitoo.Pinnwand.CreateBookmark string: string: string:"

  while [ "$ID_OLD" == "$ID_NEW" ] ; do

    usleep 100000

    ID_NEW=$($SQLITEBIN -list $SQLITEDB "select max(id) from widgetrecord;")

    if [ ! -e "$APPPATH/bookmark--$ID_NEW.pprop" ] || \
       [ ! -e "$APPPATH/bookmark--$ID_NEW.desktop" ] ; then
      ID_NEW="$ID_OLD"
    fi

    TRIES=$(($TRIES - 1))
    if [ $TRIES -eq 0 ] ; then
      ID_NEW=0
    fi

  done

  usleep 100000
  
  if [ "$ID_NEW" -gt 0 ] ; then
    POSX=$($SQLITEBIN -list $SQLITEDB "select posX from widgetrecord where id = $ID_NEW;")
    POSY=$($SQLITEBIN -list $SQLITEDB "select posY from widgetrecord where id = $ID_NEW;")
    $SQLITEBIN $SQLITEDB "delete from widgetrecord where id = $ID_NEW;"
    rm -f "$APPPATH/bookmark--$ID_NEW.*"
  else
    POSX=0
    POSY=0
  fi
  
  $SQLITEBIN $SQLITEDB "insert into widgetrecord (userId, appPkgName, posX, posY, isChild) values ('$USERNAME', '$WIDGETPRE-$WIDGETNAME', $POSX, $POSY, 0);"
  $SQLITEBIN $SQLITEDB "insert into apprecord (uuid, userId, PkgName, naturalName) values ('$WIDGETUUID', '$USERNAME', '$WIDGETPRE-$WIDGETNAME', '$WIDGETPRE-$WIDGETNAME');"

else # LIBMODE=0

  cp $WIDGETPIC $APPPATH/$WIDGETNAME.png
  
  echo "[Desktop Entry]"                 > $APPPATH/$WIDGETNAME.desktop
  echo "Type=Application"               >> $APPPATH/$WIDGETNAME.desktop
  echo "Icon=$WIDGETNAME.png"           >> $APPPATH/$WIDGETNAME.desktop
  echo "Exec=\"$WIDGETBIN$WIDGETARGS\"" >> $APPPATH/$WIDGETNAME.desktop
  
  chmod 664 $APPPATH/$WIDGETNAME.*
  chown $USERNAME.$USERNAME $APPPATH/$WIDGETNAME.*

fi

killall tiitoo-pinnwand
