exit_flag=0
outflag=0

path=""
num_subdirs=0
num_files=0
mask_dirname=""
mask_filename=""
mask_fileext=""
filesize=0
filesize_type=""

cleaner_mode=""
cleaner_param=""

log="files.log"

numre='^[0-9]+$'
engre='^[a-zA-Z]+$'
inputre='^[1-2]$'
cleanre='^[1-3]$'

color_white_font="\e[38;0;37m"      ## 0
color_red_font="\e[38;0;31m"        ## 1
color_cyan_font="\e[38;0;36m"       ## 2
color_blue_font="\e[38;0;34m"       ## 3
color_purple_font="\e[38;0;35m"     ## 4
color_black_font="\e[38;0;30m"      ## 5

color_white_bg="\e[48;0;47m"        ## 0
color_red_bg="\e[48;0;41m"          ## 1
color_cyan_bg="\e[48;0;46m"         ## 2
color_blue_bg="\e[48;0;44m"         ## 3
color_purple_bg="\e[48;0;45m"       ## 4
color_black_bg="\e[48;0;40m"        ## 5

bold=$(tput bold)
reset="\e[0m"