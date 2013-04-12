scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


let s:hook = {
\	"name" : "santi_pinch",
\	"index_counter" : -2,
\	"config" : {
\		"aa_list" : ['＼(・ω・＼)　SAN値！', '　(／・ω・)／ピンチ！',],
\		"santi" : 10,
\		"priority_output" : 0,
\		"redraw" : 0,
\		"keyword" : "",
\		"rate" : 1.0,
\		"min" : 1
\	}
\}

function! s:matchcount(expr, pat, ...)
	let start = get(a:, "1", 0)
	let result = match(a:expr, a:pat, start)
	return result == -1 ? 0 : s:matchcount(a:expr, a:pat, result+1) + 1
endfunction


function! s:hook.on_output(session, context)
	let santi = self.config.santi
	if self.config.santi > self.config.min
\	&& len(self.config.keyword)
\	&& has_key(a:session, "outputter")
\	&& has_key(a:session.outputter, "_outputters")
		let output = get(get(filter(copy(a:session.outputter._outputters), "has_key(v:val, '_result')"), 0, {}), "_result", "")
		let santi = self.config.santi - s:matchcount(output, self.config.keyword)
		if santi < self.config.min
			let santi = self.config.min
			let self.config.santi = self.config.min
		endif
	endif

	let self.index_counter += 1
	if self.index_counter < 0
		return
	endif
	echo self.config.aa_list[ self.index_counter / santi % len(self.config.aa_list) ]
	if self.config.redraw
		redraw
	endif
endfunction

function! s:hook.priority(point)
	return a:point ==# "output"
\		? self.config.priority_output
\		: 0
endfunction


function! quickrun#hook#santi_pinch#new()
	return deepcopy(s:hook)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
