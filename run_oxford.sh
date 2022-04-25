#!/bin/bash

# Parse arguments
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
   case $1 in
      --spatial)
         spatial="$2"
         shift # past argument
         shift # past value
         ;;
      --wp)
         wp="$2"
         shift # past argument
         shift # past value
         ;;
      --mc)
         mc="$2"
         shift # past argument
         shift # past value
         ;;
      --iaf)
         iaf="$2"
         shift # past argument
         shift # past value
         ;;
      --ibf)
         ibf="$2"
         shift # past argument
         shift # past value
         ;;
      --tis)
         tis="$2"
         shift # past argument
         shift # past value
         ;;
      --casl)
         casl"$2"
         shift # past argument
         shift # past value
         ;;
      --artoff)
         artoff="$2"
         shift # past argument
         shift # past value
         ;;
      --fixbolus)
         fixbolus="$2"
         shift # past argument
         shift # past value
         ;;
      --fixbolus)
         fixbolus="$2"
         shift # past argument
         shift # past value
         ;;
      --bolus)
         bolus="$2"
         shift # past argument
         shift # past value
         ;;
      --bat)
         bat="$2"
         shift # past argument
         shift # past value
         ;;
      --t1)
         t1="$2"
         shift # past argument
         shift # past value
         ;;
      --t1b)
         t1b="$2"
         shift # past argument
         shift # past value
         ;;
      --slicedt)
         slicedt="$2"
         shift # past argument
         shift # past value
         ;;
      --sliceband)
         sliceband="$2"
         shift # past argument
         shift # past value
         ;;
      --rpts)
         rpts="$2"
         shift # past argument
         shift # past value
         ;;
      --mni_reg)
         MNI_reg="$2"
         shift # past argument
         shift # past value
         ;;
      --tr)
         TR_calib="$2"
         shift # past argument
         shift # past value
         ;;
      --pvcorr)
         pvcorr="$2"
         shift # past argument
         shift # past value
         ;;
      -*|--*)
         echo "Unknown option $1"
         exit 1
         ;;
      *)
         POSITIONAL_ARGS+=("$1") # save positional arg
         shift # past argument
         ;;
   esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

# Only positional arg is input path
path=$1

# path=$1
# spatial=$2       #input as on or off
# wp=$3            # input as 1 or 0
# mc=$4           #input as 1 or 0
# iaf=$5          #input as diff, tc, ct
# ibf=$6          #input as rpt or tis
# tis=$7          # number of ti
# casl=$8         # input as 1 or 0
# artoff=$9        #input as 1 or 0
# fixbolus=${10}      #input as 1 or 0
# bolus=${11}     #bolus duration
# bat=${12}        # 0.7 pasl 1.3 casl
# t1=${13}         #t1 value
# t1b=${14}        #t1b value
# slicedt=${15}    #slice time difference
# sliceband=${16}  #number of slices per band in multi-band setup
# rpts=${17}       #number of reapeted measurements for each PLD

# MNI_reg=${18}    #1 for CBF in MNI space , 0 for structural only
# TR_calib=${19}   #Tr for calibration image
# #calib_method=${19}  
# pv_corr=${20}



if [[ $wp == "0" ]];then
wp_str=''
else
wp_str='--wp'
fi


if [[ $mc == "0" ]];then
mc_str=''
else
mc_str='--mc'
fi

if [[ $casl == "0" ]];then
casl_str=''
else
casl_str='--casl'
fi

if [[ $artoff == "0" ]];then
artoff_str=''
else
artoff_str='--artoff'
fi


if [[ $fixbolus == "0" ]];then
fixbolus_str=''
else
fixbolus_str='--fixbolus'
fi


if [[ $slicedt == "0" ]];then
slicedt_str=''
else
slicedt_str='--slicedt='$slicedt
fi

if [[ $sliceband == "0" ]];then
sliceband_str=''
else
sliceband_str='--sliceband='$sliceband
fi

if [[ $rpts == "0" ]];then
rpts_str=''
else
rpts_str='--rpts='$rpts
fi

if [[ $pvcorr == "0" ]];then
pvcorr_str=''
else
pvcorr_str='--pvcorr'
fi


cd $path

if [[ $MNI_reg == "1" ]];then


   array=$(ls)

   for i in $array; do 

  asl=$(find $i -name *asl.nii*)
  T1w=$(find $i -name *T1w.nii*)
  m0=$(find $i -name *m0.nii*)
  out=$(find $i -name *perf*)


      if [ -z "${asl}" ] | [ -z "${T1w}" ] | [ -z "${m0}" ]; then

       continue

       else

    fsl_anat -i $T1w

   anat_path=$(find $i -name *.anat*)

   oxford_asl -i $asl -o  $out --spatial=$spatial $wp_str $mc_str $artoff_str $fixbolus_str --iaf=$iaf --ibf=$ibf --tis $tis $casl_str --bolus $bolus --bat=$bat --t1=$t1 --t1b=$t1b  $slicedt_str $sliceband_str  $rpts_str --fslanat=$anat_path -c $m0 --tr=$TR_calib

      fi


    done


else

array=$(ls)

  for i in $array; do 

  asl=$(find $i -name *asl.nii*)
  T1w=$(find $i -name *T1w.nii*)
  m0=$(find $i -name *m0.nii*)
  out=$(find $i -name *perf*)

    if [ -z "${asl}" ] | [ -z "${T1w}" ] | [ -z "${m0}" ]; then

    continue

    else

       oxford_asl -i $asl -o  $out --spatial=$spatial $wp_str $mc_str $artsup_str $fixbolus_str --iaf=$iaf --ibf=$ibf --tis $tis $casl_str --bolus $bolus --bat=$bat --t1=$t1 --t1b=$t1b  $slicedt_str $sliceband_str  $rpts_str -s T1w -c $m0 --tr=$TR_calib

    fi 


   done

fi

