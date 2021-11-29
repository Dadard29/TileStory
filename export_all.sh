echo "VERSION IS SET TO $1"
read -n 1

godot --no-window --export "linux"
godot --no-window --export "win"
godot --no-window --export "html"
zip .export/tile_story.html.zip .export/html/*
butler push .export/tile_story.html.zip dadard/tile-story:html5 --userversion $1
