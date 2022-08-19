#!/usr/bin/env bash
# ==========================================================================================
# Automated Virtual Environment Setup
# ==========================================================================================
## DESCRIPTION
##      This is a generic script to simplify the setup of a Python Virtual Environment 
##      mainly for users without technical experience.  Also includes capabilities to set 
##      up a development work enviornment, execute scripts during runtime, and output 
##      detailed run instructions for the user to operate on their own.
##
##      NOTE: This script assumes you have a tar file packaged correctly and ready to go, 
##      containing a wheelhouse with all necessary packages.
##
## IMPLEMENTATION
##      version     1.0
##      author      Ashley Maynez
## =========================================================================================


# Newest tar file
tarFile=$(find "ENTER COMPLETE FOLDER PATH FOR TAR FILE HERE" -name "*.tar.gz" -printf "%f\n" | sort -V | tail -n1) 

# Removes file extension from tar file
trimmedTar=$(basename $tarFile .tar.gz)

# Used in print functions for center screen spacing
COLUMNS=$(tput cols)

# Repos and paths
DEFAULT_REPO= "ENTER DEFAULT REPO HERE.  REMINDER: ~ cannot be placed in quotes."
MAIN_REPO= # will be read from user input
TAR_PATH="ENTER COMPLETE FOLDER PATH FOR TAR FILE HERE"
EXEC_PATH="ENTER COMPLETE FOLDER PATH FOR REFERENCE DATA HERE"


# Green text output
green_print () {
    printf "%b\n" "\033[1;32m$1\033[0m"
}


# Red text output
red_print () {
    printf "%b\n" "\033[1;31m$1\033[0m"
}


# Bold underlined white text
bold_underlined_white_format () {
    echo "\033[4;1m$1\033[0m"
}


# Bold default text 
bold_default_format () {
    echo "\033[1m$1\033[0m"
}


# Bold yellow text
bold_yellow_format () {
    echo "\033[1;33m$1\033[0m"
}


# Bold red text
bold_red_format () {
    echo "\033[1;31m$1\033[0m"
}


# Calculate center for spacing
calc_screen_center () {
    echo $(((COLUMNS + $1) / 2))
}


# Sets up regular env
setup_env () {
    green_print "Starting setup.  This will take a minute..."
    mkdir -p $MAIN_REPO && green_print "Local folder created at $MAIN_REPO..."
    cd "$TAR_PATH"
    cp -u -p -- $tarFile $MAIN_REPO && green_print "tar file copied..."
    cd $MAIN_REPO
    tar -xzf $tarFile && green_print "tar file unpacked..."
    python -m venv env
    source env/bin/activate && green_print "Virtual environment active..."
    cd $trimmedTar
    green_print "Installing requirements..."
    # ENTER INSTALL COMMAND FOR REQUIREMENTS.TXT HERE 
    green_print "Setup complete."
}


# Sets up env for dev work
setup_env_dev () {
    green_print "Setting up virtual environment.  This will take a minute..."
    cd "$TAR_PATH"
    cp -u -p -- $tarFile $MAIN_REPO
    cd $MAIN_REPO
    tar -xzf $tarFile
    python -m venv env
    source env/bin/activate
    cd $trimmedTar
    # ENTER INSTALL COMMAND FOR REQUIREMENTS.TXT HERE
    green_print "Virtual environment is ready for use."
}


# Command to execute another script
exec_script_1 () {
    # ENTER COMMAND HERE
}


# Builds and outputs instructions
# $1 is text
# $2 is style/type
instruction_builder () {
    case $2 in
        title)
            title=$(bold_default_format "$1")
            titleSpan=$(calc_screen_center ${#title})

            printf "%${COLUMNS}s" " " | tr " " "*"
            printf "%${titleSpan}b\n" "$title"
            printf "%${COLUMNS}s" " " | tr " " "*"
            ;;

        warning)
            warning=$(bold_red_format "$1")
            warningSpan=$((($COLUMNS + ${#warning} + 3) / 2))
    
            printf "%${warningSpan}b\n" "$warning"
            printf "\n"
            ;;
             
        step)
            step=$(bold_underlined_white_format "$1")
            stepSpan=$(calc_screen_center ${#step})

            printf "\n"
            printf "%${stepSpan}b\n" "$step"
            ;;

        command)
            command1=$(bold_yellow_format "$1")
            command1Span=$(calc_screen_center ${#command1})
            
            # $3 defines a second command right after a first command
            if [[ "$3" = "1" ]]; then
                printf "%${command1Span}b\n" "$command1"
            else 
                printf "\n"
                printf "%${command1Span}b\n" "$command1"
                printf "\n"
            fi
            ;;

        info)
            info="$1"
            infoSpan=$(calc_screen_center ${#info})
            
            printf "\n"
            printf "%${infoSpan}b\n" "$info"
            printf "\n"
            ;;

        popup)
            popup="$1"
            popupSpan=$(calc_screen_center ${#popup})
                
            printf "%${popupSpan}b\n" "$popup"
            ;;

        footer)
            printf "\n"
            printf "%${COLUMNS}s" " " | tr " " "*"
            ;;
    esac
}


# Run instructions
print_run_instructions () {
    # --------------------------
    # Header
    # --------------------------
    instruction_builder "INSTRUCTIONS FOR SETTING UP VIRTUAL ENVIRONMENT AND RUNNING SCRIPTS MANUALLY" "title"
    instruction_builder "DO NOT CLOSE THIS WINDOW.  RUN EVERYTHING HERE." "warning"

    # --------------------------
    # Step 1
    # --------------------------
    instruction_builder "STEP 1: First, you must ensure that you are in the right directory.  To do this, copy and paste the following command on the command line and run it." "step"
    instruction_builder "cd $MAIN_REPO/$trimmedtar" "command" ""

    # --------------------------
    # Step 2
    # --------------------------
    instruction_builder "STEP 2: Now you need to create and activate your virtual environment.  To do this, copy and paste the following commands individually on the command line and run them independently." "step"
    instruction_builder "python -m venv env" "command" ""
    instruction_builder "source env/bin/activate" "command" "1"
    instruction_builder "***Once this step is completed, \"(env)\" will be at the bottom of every command you execute***" "info"

    # --------------------------
    # Step 3
    # --------------------------
    instruction_builder "STEP 3: Next, ENTER INSTRUCTIONS FOR RUNNING SCRIPT 1 HERE.  To do this, copy and paste the following command on the command line and run it." "step"
    instruction_builder "ENTER COMMAND HERE" "command" ""
    instruction_builder "Window 1: ENTER UI INSTRUCTIONS HERE IF SCRIPT OPENS ANOTHER WINDOW." "popup"
    instruction_builder "Window 2: ENTER UI INSTRUCTIONS HERE IF SCRIPT OPENS ANOTHER WINDOW." "popup" 
    instruction_builder "***Note: ADD ANY IMPORTANT INFO HERE.***" "info"

    # --------------------------
    # Footer
    # --------------------------
    instruction_builder "" "footer"
}


# Instructions only for popup windows
print_popup_instructions () {

    # --------------------------
    # Header
    # --------------------------
    instruction_builder "INSTRUCTIONS FOR POP-UP WINDOWS" "title"
    instruction_builder "DO NOT CLOSE THIS WINDOW. IF YOU CLOSE THE POP-UP WINDOWS YOU WILL HAVE TO START OVER." "warning"

    # --------------------------
    # Popup 1 and 2
    # --------------------------
    instruction_builder "Window 1: ENTER UI INSTRUCTIONS HERE IF SCRIPT OPENS ANOTHER WINDOW." "step"
    instruction_builder "Window 2: ENTER UI INSTRUCTIONS HERE IF SCRIPT OPENS ANOTHER WINDOW." "step"
    instruciton_builder "***Note: ADD ANY IMPORTANT INFO HERE.***" "info"

    # --------------------------
    # Footer
    # --------------------------
    instruction_builder "" "footer"
}


# Define main folder path
while [[ -z "$MAIN_REPO" ]]; do
    read -p "Where do you want the MAIN_REPO folder stored?  Press \"Enter\" to create the default folder at $DEFAULT_REPO, enter your own complete local path, or enter \"Q\" to quit:  " dirpath
    if [[ -z "$dirpath" ]]; then
        MAIN_REPO="$DEFAULT_REPO"
    elif [[ "$dirpath" =~ Q|q ]]; then
        green_print "Exited successfully."
        exit
    elif [[ -d "$dirpath" ]]; then
        MAIN_REPO="$dirpath/MAIN_REPO"
    else
        red_print "$dirpath either does not exist or is invalid.  Try again..."
    fi
done

green_print "Local location has been set to $MAIN_REPO"

answer=
while [[ ! $answer =~ Y|y|N|n|Q|q ]]; do
    read -p "Are you planning on doing dev work? Enter Y to clone REPONAME repo and create a virtual environment.  (Y)es/(N)o/(Q)uit " answer
    case $answer in
        Y|y)
            CLONED_REPO="$MAIN_REPO/REPONAME"
            mkdir -p $CLONED_REPO
            git clone "REMOVE THE QUOTES AND ADD THE REPO LINK HERE" "$CLONED_REPO"
            cd $CLONED_REPO
            green_print "Repo cloned successfully. Repo located at $CLONED_REPO"
            setup_env_dev
            print_run_instructions
            ;;
        N|n)
            docsAnswer=
            while [[ ! $docsAnswer =~ S|s|I|i|Q|q ]]; do
            read -p "Do you want to ENTER SCRIPT 1 OPERATION HERE or display instructions on how to manually run the script?  (S)cript1/(I)nstructions/(Q)uit " docsAnswer
	        case $docsAnswer in 
                S|s)
                    print_popup_instructions
                    setup_env
                    exec_script_1
                    print_run_instructions
                    ;;
                I|i)
                    setup_env
                    print_run_instructions
                    ;;
                Q|q)
                    green_print "Exited successfully."
                    exit
                    ;;
                *)
                    red_print "Invalid entry.  Try again..."
                    ;;
                esac
            done
            ;;
        Q|q)
            green_print "Exited successfully."
            exit
            ;;
        *)
            red_print "Invalid entry.  Try again..."
            ;;
    esac
done
