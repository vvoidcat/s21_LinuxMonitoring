color_flag=0
status_flag=0
delete_flag=0
params_flag=0
path_flag=0
outflag=0

path=0
path_type=0

status_folder="status_files"

inputre='^[1-2]$'
colorre='^[1-7]$'

column1_background=3
column1_font_color=3
column2_background=5
column2_font_color=1

color_font1_default=2
color_font2_default=1
color_bg1_default=7
color_bg2_default=5

color_white_txt="(white)"           ## 1
color_red_txt="(red)"               ## 2
color_cyan_txt="(cyan)"             ## 3
color_blue_txt="(blue)"             ## 4
color_purple_txt="(purple)"         ## 5
color_black_txt="(black)"           ## 6
color_none_txt="(none)"             ## 7

color_white_font="\e[38;0;37m"      ## 1
color_red_font="\e[38;0;31m"        ## 2
color_cyan_font="\e[38;0;36m"       ## 3
color_blue_font="\e[38;0;34m"       ## 4
color_purple_font="\e[38;0;35m"     ## 5
color_black_font="\e[38;0;30m"      ## 6

color_white_bg="\e[48;0;47m"        ## 1
color_red_bg="\e[48;0;41m"          ## 2
color_cyan_bg="\e[48;0;46m"         ## 3
color_blue_bg="\e[48;0;44m"         ## 4
color_purple_bg="\e[48;0;45m"       ## 5
color_black_bg="\e[48;0;40m"        ## 6

color_none=""                       ## 7
reset="\e[0m"

bold=$(tput bold)
normal=$(tput sgr0)

headers=("HOSTNAME" "TIMEZONE" "USER" "OS" "DATE"
         "UPTIME" "UPTIME_SEC" "IP" "MASK" "GATEWAY"
         "RAM_TOTAL" "RAM_USED" "RAM_FREE" "SPACE_ROOT"
         "SPACE_ROOT_USED" "SPACE_ROOT_FREE")
