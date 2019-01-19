#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
TARGET="$DIR/target/"

cd "$TARGET"
for file in *_original
do
	mv "$file" "${file%_original}" >/dev/null 2>/dev/null
done
cd "$DIR"