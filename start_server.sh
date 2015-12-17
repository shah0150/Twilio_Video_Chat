#!/bin/bash

PORT=8000

function message {
	echo "Attempting to start a local web server using $1. View your Twilio Conversations Quickstart at http://localhost:$PORT/quickstart.html"
}
	
# try PYTHON3
python3 -V 2> /dev/null
if [ $? -eq 0 ]; then
	message Python3
	python3 -m http.server $PORT
else
    # try PYTHON
	python -V 2> /dev/null
	if [ $? -eq 0 ]; then
		message Python
		python -m SimpleHTTPServer $PORT
	else
	# try PHP
		php -v > /dev/null 2>&1
		if [ $? -eq 0 ]; then
			message PHP
			php -S 127.0.0.1:$PORT
		else
			# try RUBY
			ruby -v > /dev/null 2>&1
			if [ $? -eq 0 ]; then
				message Ruby
				ruby -run -ehttpd . -p$PORT
			else
				echo "Unable to launch a local web server. Please try the Heroku deployment option from the Twilio portal."
			fi
		fi
	fi
fi