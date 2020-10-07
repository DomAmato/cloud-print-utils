#!/bin/bash
set -e
cd /tmp
# pixbuf need list loaders cache
# https://developer.gnome.org/gdk-pixbuf/stable/gdk-pixbuf-query-loaders.html
PIXBUF_BIN=$(find /tmp -name gdk-pixbuf-query-loaders-64)
export GDK_PIXBUF_MODULEDIR=$(find /opt/lib/gdk-pixbuf-2.0/ -name loaders)
echo "Setting up pixbuf cache $PIXBUF_BIN"
$PIXBUF_BIN > /opt/lib/loaders.cache
# pixbuf need mime database
# https://www.linuxtopia.org/online_books/linux_desktop_guides/gnome_2.14_admin_guide/mimetypes-database.html
echo "copying pixbuf"
cp -r /usr/share/mime /opt/lib/mime

echo "Installing weasyprint"
AWS_EXECUTION_ENV="python3.8"
export RUNTIME=$(echo $AWS_EXECUTION_ENV | cut -d _ -f 3)
mkdir -p /opt/python/lib/$RUNTIME/site-packages
python -m pip install weasyprint -t /opt/python/lib/$RUNTIME/site-packages

# fix dlopen(3) calls
cd /opt/python/lib/$RUNTIME/site-packages
sed -i "s/'libgdk_pixbuf-2.0.so'/'libgdk_pixbuf-2.0.so.0'/" cairocffi/pixbuf.py
sed -i "s/'libgobject-2.0.so'/'libgobject-2.0.so.0'/" cairocffi/pixbuf.py
sed -i "s/'libglib-2.0.so'/'libglib-2.0.so.0'/" cairocffi/pixbuf.py
sed -i "s/'libcairo.so'/'libcairo.so.2'/" cairocffi/__init__.py
sed -i "s/'libfontconfig.so'/'libfontconfig.so.1'/" weasyprint/fonts.py
sed -i "s/'libpangoft2-1.0.so'/'libpangoft2-1.0.so.0'/" weasyprint/fonts.py
sed -i "s/'libgobject-2.0.so'/'libgobject-2.0.so.0'/" weasyprint/fonts.py
sed -i "s/'libpango-1.0.so'/'libpango-1.0.so.0'/" weasyprint/fonts.py
sed -i "s/'libpangocairo-1.0.so'/'libpangocairo-1.0.so.0'/" weasyprint/fonts.py
sed -i "s/'libgobject-2.0.so'/'libgobject-2.0.so.0'/" weasyprint/text.py
sed -i "s/'libpango-1.0.so'/'libpango-1.0.so.0'/" weasyprint/text.py
sed -i "s/'libpangocairo-1.0.so'/'libpangocairo-1.0.so.0'/" weasyprint/text.py
