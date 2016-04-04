title=$(echo $list | sed 's/\/html$/\/title/')
post=$(echo $list | cut -d '/' -f 2)
date=$(echo $post | grep -oE '[0-9]{8}' | date -f - +%Y/%m/%d)
cat << +
<p>$date <a href="${URL}post/$post">$(cat $title)</a></p>
+
