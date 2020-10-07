#!/bin/bash
cd /opt
echo "Zipping up files"
zip -yr9 /usr/src/build/layer.zip lib/* python/*
