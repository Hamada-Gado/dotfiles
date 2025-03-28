#### Make alacritty toggle the opacity ####

# Constants
window_id=$(xdotool getactivewindow)
opacity_dir="/tmp/alacritty-opacity-controller"
opacity_file="$opacity_dir/$window_id"
base_opacity=$(grep "opacity: " ~/.config/alacritty/alacritty.yml | sed 's/[^0-9.]//g')
current_opacity=$(cat $opacity_file 2>/dev/null || echo $base_opacity)

# create the directory if it doesn't exist
mkdir -p $opacity_dir

# if the file doesn't exist, create it
if [ ! -f "$opacity_file" ]; then
    echo $base_opacity > $opacity_file
fi

# if the current opacity is 1, set it to the base value, otherwise, set it to 1
if [ "$current_opacity" = "1" ]; then
    echo $base_opacity > $opacity_file
else
    echo "1" > $opacity_file
fi

# get the new opacity
new_opacity=$(cat $opacity_file)

# set the opacity
alacritty msg config window.opacity=$new_opacity
