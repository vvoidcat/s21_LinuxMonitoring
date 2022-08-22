sysinfo_flag=0
filesinfo_flag=0

color_flag=0
status_flag=0
delete_flag=0
params_flag=0
path_flag=0
outflag=0

colored=1
plain=0

path=0
path_type=0

status_folder="status_files"

inputre='^[1-2]$'
colorre='^[0-6]$'

color_bg1_user=7
color_font1_user=7
color_font2_user=7

color_bg1_default=6
color_font1_default=4
color_font2_default=3

color_white_txt="(white)"           ## 0
color_red_txt="(red)"               ## 1
color_cyan_txt="(cyan)"             ## 2
color_blue_txt="(blue)"             ## 3
color_purple_txt="(purple)"         ## 4
color_black_txt="(black)"           ## 5
color_none_txt="(none)"             ## 6

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

color_none=""                       ## 6
reset="\e[0m"

bold=$(tput bold)
normal=$(tput sgr0)
