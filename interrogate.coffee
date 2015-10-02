_ = require("underscore")
asciimo = require("asciimo").Figlet
shell = require('child_process').exec
questions = _(require("./questions")).shuffle()

progressBarWidth = 60
clear = ->
	console.log '\u001B[2J\u001B[0;0f'

intervalTimer = (seconds, fn) ->
	secondsElapsed = 0
	renderTimer = ->
		fraction = Math.round progressBarWidth*(secondsElapsed/seconds)
		
		asciimo.write "  #{seconds-secondsElapsed}", 'colossal', (art) ->
			clear()
			console.log Array(4).join("\n")
			console.log art
			for b in [0..2]
				console.log Array(fraction).join("*")+Array(progressBarWidth-fraction).join(" ")+"|"
		secondsElapsed += 1
		if secondsElapsed >= seconds
			fn.call()
			clearInterval(timerInterval)
			console.log Array(progressBarWidth).join("*")
	clear()
	renderTimer.call()
	timerInterval = setInterval renderTimer, 1000


# voices = ['Alex', 'Bruce', 'Fred', 'Victoria', 'Vicki', 'Kathy']
# -v #{_(voices).sample()}
speak = (questions) ->
	console.log question = questions.pop()
	setTimeout ->
		clear()
	, 500
	shell "say \"#{question}\"", (err, stdout, stderr) ->
		console.log err if err?
		intervalTimer (Math.floor(Math.random()*12)+2)*8, ->
			speak(questions) if questions.length > 0

setTimeout ->
	speak(questions)	
, 500
