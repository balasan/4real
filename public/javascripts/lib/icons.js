document.addEventListener('DOMContentLoaded', function() {
	// iconmelon.com
	var url = '/javascripts/lib/icons.svg',
		c = new XMLHttpRequest();
	c.open('GET', url, false);
	c.setRequestHeader('Content-Type', 'text/xml');
	c.send();
	document.body.insertBefore(c.responseXML.firstChild, document.body.firstChild);
});