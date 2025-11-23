
#!/bin/bash

while true; do
    conky -c ~/.config/conky/conky.conf -o -u 1 -q | feh --bg-fill - &
    sleep 1
done

