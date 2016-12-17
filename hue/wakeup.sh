#!/bin/bash
set -e;
DEBUG=false;

# your API username / light config
# see: https://www.developers.meethue.com/documentation/getting-started
HOST='192.168.0.3';
USERNAME='LUWLnuHHjxgfEygn5PVoUphl8Dr0e2qAxVSoKO-C';
# RESOURCE='groups/2/action'; # for a group of lights
RESOURCE='lights/4/state'; # for a single light

# send command to bridge
function send(){
  if $DEBUG; then curl -s -XPUT -d "$1" 'https://httpbin.org/put';
  else curl -s -XPUT -d "$1" "http://$HOST/api/$USERNAME/$RESOURCE" &>/dev/null; fi
}

# simple on/off commands
function on(){ send '{ "on": true }'; }
function off(){ send '{ "on": false }'; }

# brightness (0-254) - saturation/intensity (0-254) - hue/colour (0-65535)
function update(){ send "{ \"on\": true, \"bri\": $1, \"sat\": $2, \"hue\": $3 }"; }

# update 0 0 0;
off; exit;

# sunrise settings
STEPS='127';
DURATION_MINS='30';
DURATION_SECS=$(echo "scale = 2; $DURATION_MINS * 60 / $STEPS" | bc);
HUE_MULTIPLIER='25';
HUE_OFFSET='+6375';

on; # turn light(s) on
for ((i=0;i<=$STEPS;i++)); do
  SAT=$(echo "scale = 0; 254 - $i" | bc);
  HUE=$(echo "scale = 0; $HUE_MULTIPLIER * $i $HUE_OFFSET" | bc);
  update $i $SAT $HUE;
  sleep $DURATION_SECS;
done;
