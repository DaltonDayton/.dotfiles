find $HOME/Pictures/Backgrounds/. -type f | shuf -n1
swaybg -i "$(find $HOME/Pictures/Backgrounds/. -type f | shuf -n1)" -m fill &
OLD_PID=$!
#while true; do
#	sleep 5s
#	swaybg -i "$(find $HOME/Pictures/Backgrounds/. -type f | shuf -n1)" -m fill &
#	NEXT_PID=$!
#	sleep 5
#	kill $OLD_PID
#	OLD_PID=$NEXT_PID
#done
