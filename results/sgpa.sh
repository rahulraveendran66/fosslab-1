pdftotext -layout $1 - | grep -A 1 16CS | sed 's/--//;s/\o14//g;/^\s*$/d' >cs
lcount=0
case $2 in
 1) credits=( 4 4 3 3 3 3 1 1 1 );sc=23;l=2;;
 2) credits=( 4 4 3 1 1 4 3 3 1 );sc=24;l=2;;
 3) credits=( 4 3 4 4 4 3 1 1 );sc=24;l=1;;
 *) credits=( 4 3 4 4 4 3 1 1 );sc=24;l=1;;
esac
while read -r line
do
   lcount=$(( $lcount+1 ))
   for word in $line; do
     if [[ $word == *16CS* ]];then reg=$word;sbcount=0;scg=0;cgp=0;scr=0;
     else
          grade=$( echo $word | cut -d "(" -f2 | cut -d ")" -f1 )
          case $grade in
            O)  gp=10   ;;
            A+) gp=9    ;;
            A)  gp=$(bc -l <<< 8.5)    ;;
            B+) gp=8    ;;
            B)  gp=7    ;;
            C)  gp=6    ;;
            P)  gp=5    ;;
            *)  gp=0    ;;
          esac
          cr=${credits[$(( sbcount++ ))]}
          scr=$(( $scr+$cr ))
          scg=$(bc -l <<< $scg+$gp*$cr )
          cgp=$(bc <<< 'scale=2;'$scg/$scr );
    fi
   done
  if [[ $(( $lcount%$l )) -eq 0 ]];then echo $reg $cgp >> res;fi 
done < cs
#cat res
echo "SNO REGNO SGPA NAME" | awk '{printf"%-3s %-10s %-4s %s\n",$1,$2,$3,$4}'
sort res | uniq > tmpres
sort c4b.txt -k 6 > tmpc4a
join -1 1 -2 6 tmpres tmpc4a | awk '{printf "%-3s %s %s %s %s %s \n",$3,$1,$2,$8,$9,$10}'
rm res cs tmp*
