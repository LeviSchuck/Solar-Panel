var socket = io.connect('http://localhost:1997');
var lastTailName = "";
socket.on('tail', function (data) {
	var tailout = $('.tail-outputs')[0];
	var doscroll = false;
	if(Math.abs(tailout.scrollTop - (tailout.scrollHeight - tailout.offsetHeight)) < 5){
		doscroll = true;
	}
	if(lastTailName != data.name && data.name){
		$(tailout).append("<em>"+data.name+"</em>\n");
		lastTailName = data.name;
	}
	if(data.text){
		$(tailout).append(data.text);
	}
	
	if(doscroll){
		tailout.scrollTop = tailout.scrollHeight;
	}
	$(tailout).addClass('shadowed').delay(400).queue(function(next){
		$(this).removeClass('shadowed');
		next();
	});
});