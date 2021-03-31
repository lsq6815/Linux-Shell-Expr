#!/usr/bin/env bash

##########################
# Functions defined here #
##########################

################################################################################
# Function to print help info
# Globals:
#     None
# Arguments:
#     None
# Outputs:
#     None
# Returns:
#     None
################################################################################
printUsage () {
    cat <<EOF
classify -- Classify directory by file-extension

Usage: ./classify.sh [OPTION]... [traget]

Options:
    -h --help    : print help information
    -s --source  : specify the source directory, default to current directory
    -v --verbose : print processing information

Note: if argument or option argument is duplicated, the last one will be taken
EOF
}

# Function to get file extension
# if no extension, return ""
EXT=""
################################################################################
# Function to get file extension
# Globals:
#     EXT: return extension in EXT
# Arguments:
#     $1: path/to/file
# Outputs:
#     None
# Returns:
#     None
################################################################################
getExt() {
    EXT=$(echo -n "$1" | sed -E 's/^.*\/(.*)/\1/g' | sed -E '/^[^.]+$/d' | sed -E '/^\..+$/d' | sed -E '/^.+\.$/d' | sed -E 's/^.+\.(.+)/\1/g')
}

# Copy file with numbered backup
START=2
################################################################################
# Copy file with numbered backup
# Globals:
#     START: count start from number START
# Arguments:
#     $1: path/to/file
#     $2: path/to/copyfile
# Outputs:
#     None
# Returns:
#     None
################################################################################
cpWithBak() {
    bname=$(basename -- "$1")
    fname="${bname%.*}"
    ext="${bname##*.}"
    flag=""
    num=${START}
    while [ -z "$flag" ]; do
        if [ -e "${2}/${bname}" ]; then
            bname="${fname}.${num}.${ext}"
            ((num++))
        else
            flag="true"
        fi
    done

    if [[ $num -gt ${START} && -n $ver ]]; then 
        echo "${2}/${fname}.${ext} already exist, ${1} saved as ${2}/${bname}"
    fi
    # append to analysis.txt
    echo "${1} ${2}/${bname} ${ext}" >> "${analysis}"
    cp "${1}" "${2}/${bname}"
}

################################################################################
# Copy function like cpWithBak
# But used for no extension file
# Globals:
#     START: count start with number START
# Arguments:
#     $1: path/to/file
#     $2: path/to/copyfile
# Outputs:
#     None
# Returns:
#     None
################################################################################
cpAddBak() {
    bname=$(basename -- "$1")
    fname="${bname}"
    flag=""
    num=${START}
    while [ -z "$flag" ]; do
        if [ -e "${2}/${bname}" ]; then
            bname="${fname}_${num}"
            ((num++))
        else
            flag="true"
        fi
    done

    if [[ $num -gt ${START} && -n $ver ]]; then 
        echo "${2}/${fname} already exist, ${1} saved as ${2}/${bname}"
    fi

    # append to analysis.txt
    echo "${1} ${2}/${bname} NULL" >> "${analysis}"
    cp "${1}" "${2}/${bname}"
}

######################
# Parsing parameters #
######################

# Default parameters
src="."
dst="/tmp/classified"
ver=""

[[ $# -eq 1 ]] && { src="."; dst="$1"; };
while [[ $# -gt 0 ]]; do
    para="$1"
    case $para in
        -h|--help)
            printUsage
            exit 1
            ;;
        -s|--source)
            src="$2"
            shift 2
            ;;
        -v|--verbose)
            ver="true"
            shift
            ;;
        *) 
            dst="$1"
            shift
            ;;
    esac
done

###########################
# Verify target directory #
###########################

if [ -e "$dst" ]; then 
    echo -n "${dst} already exist, "
    dst="${dst}_${RANDOM}"
    echo "target changed to ${dst}"
fi

echo "source: ${src}"
echo "target: ${dst}"

#########################
# Make target directory #
#########################

mkdir "${dst}"

############################
# Create analysis.txt file #
############################

analysis="${dst}/analysis.txt"
touch "${analysis}"

############################
# Collect file information #
############################

file_info="${src}/.file_info"
find "$src" -type f > "$file_info"

##########################
# Collect extension list #
##########################

ext_info="${src}/.ext_info"
find "$src" -type f | sed -E 's/^.*\/(.*)/\1/g' | sed -E '/^[^.]+$/d' | sed -E '/^\..+$/d' | sed -E '/^.+\.$/d' | sed -E 's/^.+\.(.+)/\1/g' | sort | uniq > "$ext_info"

##################
# Make directory #
##################

while read -r ext; do
    mkdir "${dst}/${ext}"
done < "$ext_info"

if [ $ver ]; then
    echo "Total: $(wc -l < "${ext_info}") directory are created"
fi

#############
# Copy file #
#############

while read -r file; do
    getExt "$file"
    if [ -z "$EXT" ]; then
        # echo "${file} has no extension"
        cpAddBak "$file" "${dst}"
    else
        # echo "${file} has extension: ${EXT}"
        cpWithBak "$file" "${dst}/${EXT}"
    fi
done < "$file_info"

#########################
# Generate analysis.txt #
#########################

sort -k 3 < "${analysis}" | column -t > "${dst}/tmp_analysis.txt"
# Add Table Headers
sed -i '1 iFROM TO EXT' "${dst}/tmp_analysis.txt"
column -t < "${dst}/tmp_analysis.txt" > "${analysis}" 
echo "analysis: ${analysis}"

###################
# Delete tmp file #
###################

rm "${dst}/tmp_analysis.txt" "${ext_info}" "${file_info}"
