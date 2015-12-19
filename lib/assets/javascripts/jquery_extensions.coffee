$ = jQuery
$.fn.extend
	rebind: (events, handler) -> 
		this.off(events, handler).on(events, handler)

	bindOnLoad: (handler) -> 
		this.ready(handler)
		this.on('page:load', handler)