#!/bin/bash
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%33s%s%-12s\n' "Mudar data de expiração" ; tput sgr0
echo ""
echo -e "\033[1;33m Lista de usuários e datas de expiração:\033[0m "
echo ""
tput setaf 7 ; tput bold 
database="/root/usuarios.db"
i=0
while read users
   do
    user="$(echo $users | cut -d' ' -f1)"
    i=$(expr $i + 1)
    oP+=$i
    [[ $i == [1-9] ]] && oP+=" 0$i" && i=0$i
    oP+=":$user\n"
	expire="$(chage -l $user | grep -E "Account expires" | cut -d ' ' -f3-)"
	if [[ $expire == "never" ]]
	then
		echo -e "\033[1;33m[\033[1;31m$i\033[1;33m] \033[1;37m- \033[1;32m$user             Nunca\033[0m"
	else
		databr="$(date -d "$expire" +"%Y%m%d")"
		hoje="$(date -d today +"%Y%m%d")"
		if [ $hoje -ge $databr ]
		then
			_user=$(echo -e "\033[1;33m[\033[1;31m$i\033[1;33m] \033[1;37m- \033[1;32m$user\033[1;37m")
			datanormal="$(date -d"$expire" '+%d/%m/%Y')"
			expired=$(echo -e "\033[1;31mVENCEU\033[0m")
			printf '%-60s%-14s%s\n' "$_user" "$datanormal" "$expired"
			echo "exp" > /tmp/exp
		else
			_user=$(echo -e "\033[1;33m[\033[1;31m$i\033[1;33m] \033[1;37m- \033[1;32m$user\033[1;37m")
			datanormal="$(date -d"$expire" '+%d/%m/%Y')"
			ative=$(echo -e "\033[1;32mVALIDO\033[0m")
			printf '%-60s%-14s%s\n' "$_user" "$datanormal" "$ative"
		fi
	fi
   done < "$database"
tput sgr0
echo ""
if [ -a /tmp/exp ]
then
	rm /tmp/exp
fi
num_user=$(cat $database | wc -l)
echo -ne "\033[1;32mSelecione um usuario \033[1;33m[\033[1;37m1\033[1;31m-\033[1;37m$num_user\033[1;33m]\033[1;37m: " ; read option
if [[ -z $option ]]
then
	echo ""
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "Erro,  Nome de usuário vazio ou inválido! " ; tput sgr0
	exit 1
fi
usuario=$(echo -e "$oP" | grep -E "\b$option\b" | cut -d: -f2)
if [[ -z $usuario ]]
then
	echo ""
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "Erro,  Nome de usuário vazio ou inválido! " ; tput sgr0
	echo ""
	exit 1
else
	if [[ `grep -c /$usuario: /etc/passwd` -ne 0 ]]
	then
	    echo ""
	    echo -e "\033[1;31mEX:\033[1;33m(\033[1;37mDIA/MÊS/ANO\033[1;33m)"
	    echo ""
	    echo -ne "\033[1;32mNova data para o usuario \033[1;33m$usuario: \033[1;37m"; read inputdate
		sysdate="$(echo "$inputdate" | awk -v FS=/ -v OFS=- '{print $3,$2,$1}')"
		if (date "+%Y-%m-%d" -d "$sysdate" > /dev/null  2>&1)
		then
			if [[ -z $inputdate ]]
			then
				echo ""
				tput setaf 7 ; tput setab 1 ; tput bold ;	echo "Você digitou uma data inválida ou inexistente!" ; echo "Digite uma data válida no formato DIA/MÊS/ANO " ; echo "Por exemplo: 21/04/2018" ; tput sgr0 ; tput sgr0
				echo ""
				exit 1	
			else
				if (echo $inputdate | egrep [^a-zA-Z] &> /dev/null)
				then
					today="$(date -d today +"%Y%m%d")"
					timemachine="$(date -d "$sysdate" +"%Y%m%d")"
					if [ $today -ge $timemachine ]
					then
						echo ""
						tput setaf 7 ; tput setab 1 ; tput bold ;	echo "Você digitou uma data passada ou o dia atual!" ; echo "Digite uma data futura e válida no formato DIA/MÊS/ANO" ; echo "Por exemplo: 21/04/2018" ; tput sgr0
						echo ""
						exit 1
					else
						chage -E $sysdate $usuario
						echo ""
						tput setaf 7 ; tput setab 4 ; tput bold ; echo "Sucesso Usuário $usuario nova data: $inputdate " ; tput sgr0
						echo ""
						exit 1
					fi
				else
					echo ""
					tput setaf 7 ; tput setab 1 ; tput bold ;	echo "Você digitou uma data inválida ou inexistente!" ; echo "Digite uma data válida no formato DIA/MÊS/ANO" ; echo "Por exemplo: 21/04/2018" ; tput sgr0
					echo ""
					exit 1
				fi
			fi
		else
			echo ""
			tput setaf 7 ; tput setab 1 ; tput bold ;	echo "Você digitou uma data inválida ou inexistente!" ; echo "Digite uma data válida no formato DIA/MÊS/ANO" ; echo "Por exemplo: 21/04/2018" ; tput sgr0
			echo ""
			exit 1
		fi
	else
		echo " "
		tput setaf 7 ; tput setab 1 ; tput bold ;	echo "O usuário $usuario não existe!" ; tput sgr0
		echo " "
		exit 1
	fi
fi