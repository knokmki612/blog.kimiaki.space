if \
	[ -n "$formatted_date" ] &&
	[ -n "$datetime" ]       &&
	[ -n "$title_encoded" ]; then
	cat <<- +
		<aside class="clearfix">
		  <div class="social-icon">
		  <a href="http://twitter.com/share?url=${URL}post/$post&text=$title_encoded$TITLE_TAIL_ENCODED"><span class="icon-">twitter</span></a>
		  <a href="http://www.facebook.com/sharer.php?u=${URL}post/$post"><span class="icon-">facebook</span></a>
		  <a href="http://b.hatena.ne.jp/entry/${URL}post/$post"><span class="icon-">hatebu</span></a>
		  </div>
		  <div class="date">
		  <time datetime="$datetime">$formatted_date</time>
		  </div>
		  <div class="labels">
		  $labels_string
		  </div>
		</aside>
		<article>
		<h2><a href="${URL}post/$post">$title</a></h2>
		$sentence
		</article>
	+
else
	cat <<- +
		<article>
		$sentence
		</article>
	+
fi
