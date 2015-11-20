#!/bin/sh

shellfileOne=/tmp/$$svn-remove-keywordsOne.sh
shellfileAll=/tmp/$$svn-remove-keywordsAll.sh


cat <<EOF >$shellfileOne
#!/bin/sh

filename=\$1
git checkout "\$filename" &&
sed <"\$filename" \
  -e 's%Version:.*Revision%XXXXXXXXXXXXXXXXXX\$%' \
  -e 's%Modified [bB]y:.*Author%XXXXXXXXXXXXXXXXXX\$%' \
  -e 's%Last Modified:.*Date%XXXXXXXXXXXXXXXXXX\$%' \
  -e 's%HeadURL:.*URL%XXXXXXXXXXXXXXXXXX\$%' \
>"\$filename.new" &&
if grep XXXXXXXXXXXXXXXXXX "\$filename.new" >/dev/null; then
	grep -v XXXXXXXXXXXXXXXXXX "\$filename.new" >"\$filename" &&
	git diff "\$filename"
fi
rm "\$filename.new"
EOF

git ls-files | xargs egrep -l "Version:.*Revision|Modified [bB]y:.*Author|Last Modified:.*Date|HeadURL:.*URL%" | sed -e "s%^%$shellfileOne %" >"$shellfileAll" &&
chmod +x $shellfileAll $shellfileOne &&
$shellfileAll
