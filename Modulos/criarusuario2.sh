#!/bin/bash
IP=$(cat /etc/IP)
# Gerar client.ovpn
newclient () {
	cp /etc/openvpn/client-common.txt ~/$1.ovpn
	echo "<ca>" >> ~/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/ca.crt >> ~/$1.ovpn
	echo "</ca>" >> ~/$1.ovpn
	echo "<cert>" >> ~/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/issued/$1.crt >> ~/$1.ovpn
	echo "</cert>" >> ~/$1.ovpn
	echo "<key>" >> ~/$1.ovpn
	cat /etc/openvpn/easy-rsa/pki/private/$1.key >> ~/$1.ovpn
	echo "</key>" >> ~/$1.ovpn
	echo "<tls-auth>" >> ~/$1.ovpn
	cat /etc/openvpn/ta.key >> ~/$1.ovpn
	echo "</tls-auth>" >> ~/$1.ovpn
}
if [[ -e /etc/openvpn/server.conf ]]; then
_Port=$(sed -n '1 p' /etc/openvpn/server.conf | cut -d' ' -f2)
hst=$(sed -n '7 p' /etc/openvpn/client-common.txt | awk {'print $2'})
hst2=$(sed -n '7 p' /etc/openvpn/client-common.txt | awk {'print $1'})
vivo1="portalrecarga.vivo.com.br/recarga"
vivo2="portalrecarga.vivo.com.br/controle/"
vivo3="navegue.vivo.com.br/pre/"
vivo4="portalrecarga.vivo.com.br/noCredit/vitrine/controle"
vivo5="navegue.vivo.com.br/controle/"
vivoR="remote-random"
oi="d1n212ccp6ldpw.cloudfront.net"
cert01="/etc/openvpn/client-common.txt"
if [[ "$hst" == "$vivo1" ]]; then
	Host="Portal Recarga"
elif [[ "$hst" == "$vivo2" ]]; then
	Host="Recarga contole"
elif [[ "$hst" == "$vivo3" ]]; then
	Host="Portal Navegue"
elif [[ "$hst" == "$vivo4" ]]; then
	Host="Portal RG Vitrine"
elif [[ "$hst" == "$vivo5" ]]; then
	Host="Nav Controle"
elif [[ "$hst2" == "$vivoR" ]]; then
	Host="Vivo 4 Hosts"
elif [[ "$hst" == "$oi" ]]; then
	Host="Oi"
else
	Host="Desconhecido"
fi
fi
fun_bar () {
comando[0]="$1"
comando[1]="$2"
 (
[[ -e $HOME/fim ]] && rm $HOME/fim
[[ ! -d /etc/SSHPlus ]] && rm -rf /bin/menu
${comando[0]} > /dev/null 2>&1
${comando[1]} > /dev/null 2>&1
touch $HOME/fim
 ) > /dev/null 2>&1 &
 tput civis
echo -ne "\033[1;33mAGUARDE \033[1;37m- \033[1;33m["
while true; do
   for((i=0; i<18; i++)); do
   echo -ne "\033[1;31m#"
   sleep 0.1s
   done
   [[ -e $HOME/fim ]] && rm $HOME/fim && break
   echo -e "\033[1;33m]"
   sleep 1s
   tput cuu1
   tput dl1
   echo -ne "\033[1;33mAGUARDE \033[1;37m- \033[1;33m["
done
echo -e "\033[1;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
tput cnorm
}
fun_edithost () {
	clear
	echo -e "\E[44;1;37m         ALTERAR HOST OVPN           \E[0m"
	echo ""
	echo -e "\033[1;33mHOST EM USO\033[1;37m: \033[1;32m$Host"
	echo ""
	echo -e "\033[1;33m[\033[1;31m1\033[1;33m] \033[1;33mVIVO RECARGA"
	echo -e "\033[1;33m[\033[1;31m2\033[1;33m] \033[1;33mVIVO RG CONTRLOLE"
	echo -e "\033[1;33m[\033[1;31m3\033[1;33m] \033[1;33mVIVO NAVEGUE PRE"
	echo -e "\033[1;33m[\033[1;31m4\033[1;33m] \033[1;33mVIVO 4 HOSTS \033[1;32m(\033[1;37mRandom\033[1;32m)\033[1;33m"
	echo -e "\033[1;33m[\033[1;31m5\033[1;33m] \033[1;33mHOST OI"
	echo -e "\033[1;33m[\033[1;31m6\033[1;33m] \033[1;33mEDITAR MANUALMENTE"
	echo -e "\033[1;33m[\033[1;31m0\033[1;33m] \033[1;33mVOLTAR"
	echo ""
	echo -ne "\033[1;32mQUAL HOST DESEJA ULTILIZAR \033[1;33m?\033[1;37m "; read respo
	if [[ -z "$respo" ]]; then
		echo ""
		echo -e "\033[1;31mOpcao invalida!"
		sleep 2
		fun_edithost
	fi
	if [[ "$respo" = '1' ]]; then
		echo ""
		echo -e "\033[1;32mALTERANDO HOST!\033[0m"
		echo ""
		fun_althost () {
			if [[ "$hst2" == "$vivoR" ]]; then
				sed -i "7,11"d /etc/openvpn/client-common.txt
				sed -i "7i\remote $vivo1 $_Port" /etc/openvpn/client-common.txt
			else
				sed -i "s;$hst;$vivo1;" /etc/openvpn/client-common.txt
				sleep 1
				if grep -w "CUSTOM-HEADER" /etc/openvpn/client-common.txt > /dev/null 2>&1; then
					sed -i "8"d  /etc/openvpn/client-common.txt
				fi
			fi
		}
		fun_bar 'fun_althost'
		echo ""
		echo -e "\033[1;32mHOST ALTERADO COM SUCESSO!\033[0m"
		sleep 2
	elif [[ "$respo" = '2' ]]; then
		echo ""
		echo -e "\033[1;32mALTERANDO HOST!\033[0m"
		echo ""
		fun_althost2 () {
			if [[ "$hst2" == "$vivoR" ]]; then
				sed -i "7,11"d /etc/openvpn/client-common.txt
				sed -i "7i\remote $vivo2 $_Port" /etc/openvpn/client-common.txt
			else
				sed -i "s;$hst;$vivo2;" /etc/openvpn/client-common.txt
				sleep 1
				if grep -w "CUSTOM-HEADER" /etc/openvpn/client-common.txt > /dev/null 2>&1; then
					sed -i "8"d  /etc/openvpn/client-common.txt
				fi
			fi
		}
		fun_bar 'fun_althost2'
		echo ""
		echo -e "\033[1;32mHOST ALTERADO COM SUCESSO!\033[0m"
		sleep 2
	elif [[ "$respo" = '3' ]]; then
		echo ""
		echo -e "\033[1;32mALTERANDO HOST!\033[0m"
		echo ""
		fun_althost3 () {
			if [[ "$hst2" == "$vivoR" ]]; then
				sed -i "7,11"d /etc/openvpn/client-common.txt
				sed -i "7i\remote $vivo3 $_Port" /etc/openvpn/client-common.txt
			else
				sed -i "s;$hst;$vivo3;" /etc/openvpn/client-common.txt
				sleep 1
				if grep -w "CUSTOM-HEADER" /etc/openvpn/client-common.txt > /dev/null 2>&1; then
					sed -i "8"d  /etc/openvpn/client-common.txt
				fi
			fi
		}
		fun_bar 'fun_althost3'
		echo ""
		echo -e "\033[1;32mHOST ALTERADO COM SUCESSO!\033[0m"
		sleep 2
	elif [[ "$respo" = '4' ]]; then
		echo ""
		echo -e "\033[1;32mALTERANDO HOST!\033[0m"
		echo ""
		fun_althosth () {
			if [[ "$hst" = "$oi" ]]; then
				sed -i "7,8"d /etc/openvpn/client-common.txt
				sed -i "7i\remote-random\nremote $vivo1 $_Port\nremote $vivo3 $_Port\nremote $vivo2 $_Port\nremote $vivo5 $_Port" /etc/openvpn/client-common.txt
			elif [[ "$hst2" != "$vivoR" ]]; then
				sed -i "7"d /etc/openvpn/client-common.txt
				sed -i "7i\remote-random\nremote $vivo1 $_Port\nremote $vivo3 $_Port\nremote $vivo2 $_Port\nremote $vivo5 $_Port" /etc/openvpn/client-common.txt
			else
				echo ""
			fi
		}
		fun_bar 'fun_althosth'
		echo ""
		echo -e "\033[1;32mHOST ALTERADO COM SUCESSO!\033[0m"
		sleep 2
	elif [[ "$respo" = '5' ]]; then
		echo ""
		echo -e "\033[1;32mALTERANDO HOST!\033[0m"
		echo ""
		fun_althost4 () {
			if [[ "$hst2" == "$vivoR" ]]; then
				sed -i "7,11"d /etc/openvpn/client-common.txt
				sed -i "7i\remote $oi $_Port\nhttp-proxy-option CUSTOM-HEADER Host $oi" /etc/openvpn/client-common.txt
			else
				sed -i "s;$hst;$oi;" /etc/openvpn/client-common.txt
				sleep 1
				sed -i "s/$_Port/$_Port\nhttp-proxy-option CUSTOM-HEADER Host d1n212ccp6ldpw.cloudfront.net/g" /etc/openvpn/client-common.txt
			fi
		}
		fun_bar 'fun_althost4'
		echo ""
		echo -e "\033[1;32mHOST ALTERADO COM SUCESSO!\033[0m"
		sleep 2
	elif [[ "$respo" = '6' ]]; then
		echo ""
		echo -e "\033[1;32mALTERANDO ARQUIVO OVPN!\033[0m"
		echo ""
		echo -e "\033[1;31mATENCAO!\033[0m"
		echo ""
		echo -e "\033[1;33mPARA SALVAR USE AS TECLAS \033[1;32mctrl x y\033[0m"
		sleep 4
		clear
		nano /etc/openvpn/client-common.txt
		echo ""
		echo -e "\033[1;32mALTERADO COM SUCESSO!\033[0m"
		sleep 2
	elif [[ "$respo" = '0' ]]; then
		echo ""
		echo -e "\033[1;31mRetornando...\033[0m"
		sleep 2
	else
		echo ""
		echo -e "\033[1;31mOpcao invalida !\033[0m"
		sleep 2
		fun_edithost
	fi
}
[[ ! -d /etc/SSHPlus ]] && rm -rf /bin/versao /bin/menu
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%30s%s%-15s\n' "Criar usuário SSH" ; tput sgr0
echo ""
echo -ne "\033[1;32mNome do usuário:\033[1;37m "; read username
awk -F : ' { print $1 }' /etc/passwd > /tmp/users 
if grep -Fxq "$username" /tmp/users
then
	tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Este usuário já existe. tente outro nome." ; echo "" ; tput sgr0
	exit 1	
else
	if (echo $username | egrep [^a-zA-Z0-9.-_] &> /dev/null)
	then
		tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Você digitou um nome de usuário inválido!" ; tput setab 1 ; echo "Use apenas letras, números, pontos e traços." ; tput setab 4 ; echo "Não use espaços, acentos ou caracteres especiais!" ; echo "" ; tput sgr0
		exit 1
	else
		sizemin=$(echo ${#username})
		if [[ $sizemin -lt 2 ]]
		then
			tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Você digitou um nome de usuário muito curto," ; echo "use no mínimo dois caracteres!" ; echo "" ; tput sgr0
			exit 1
		else
			sizemax=$(echo ${#username})
			if [[ $sizemax -gt 10 ]]
			then
				tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Você digitou um nome de usuário muito grande," ; echo "use no máximo 10 caracteres!" ; echo "" ; tput sgr0
				exit 1
			else
				if [[ -z $username ]]
				then
					tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Você digitou um nome de usuário vazio!" ; echo "" ; tput sgr0
					exit 1
				else	
				   echo -ne "\033[1;32mSenha:\033[1;37m "; read password
					if [[ -z $password ]]
					then
						tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Você digitou uma senha vazia!" ; echo "" ; tput sgr0
						exit 1
					else
						sizepass=$(echo ${#password})
						if [[ $sizepass -lt 4 ]]
						then
							tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Senha curta!, use no mínimo 4 caracteres" ; echo "" ; tput sgr0
							exit 1
						else	
						    echo -ne "\033[1;32mDias Para Expirar:\033[1;37m "; read dias
							if (echo $dias | egrep '[^0-9]' &> /dev/null)
							then
								tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Você digitou um número de dias inválido!" ; echo "" ; tput sgr0
								exit 1
							else
								if [[ -z $dias ]]
								then
									tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Você deixou o número de dias para a conta expirar vazio!" ; echo "" ; tput sgr0
									exit 1
								else	
									if [[ $dias -lt 1 ]]
									then
										tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Você deve digitar um número de dias maior que zero!" ; echo "" ; tput sgr0
										exit 1
									else
									    echo -ne "\033[1;32mLimite De Conexões:\033[1;37m "; read sshlimiter
										if (echo $sshlimiter | egrep '[^0-9]' &> /dev/null)
										then
											tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Você digitou um número de conexões inválido!" ; echo "" ; tput sgr0
											exit 1
										else
											if [[ -z $sshlimiter ]]
											then
												tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Você deixou o limite de conexões vazio!" ; echo "" ; tput sgr0
												exit 1
											else
												if [[ $sshlimiter -lt 1 ]]
												then
													tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Número de conexões simultâneas deve ser maior que zero!" ; echo "" ; tput sgr0
													exit 1
												else
													final=$(date "+%Y-%m-%d" -d "+$dias days")
													gui=$(date "+%d/%m/%Y" -d "+$dias days")
													pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
													sleep 0.5s
													useradd -e $final -M -s /bin/false -p $pass $username
													echo "$password" > /etc/SSHPlus/senha/$username
													echo "$username $sshlimiter" >> /root/usuarios.db
													if [[ -e /etc/openvpn/server.conf ]]; then
													    echo -ne "\033[1;32mGerar Arquivo Ovpn \033[1;31m? \033[1;33m[s/n]:\033[1;37m "; read resp
													    if [[ "$resp" = 's' ]]; then
													    	rm $username.zip $username.ovpn > /dev/null 2>&1
													    	echo -ne "\033[1;32mGerar Com usuário e Senha \033[1;31m? \033[1;33m[s/n]:\033[1;37m "; read respost
													    	if [[ "$respost" = 's' ]]; then
													            gerarovpn () {
													            cd /etc/openvpn/easy-rsa/
													            ./easyrsa build-client-full $username nopass
													            newclient "$username"
													            sed -e "s;auth-user-pass;<auth-user-pass>\n$username\n$password\n</auth-user-pass>;g" /root/$username.ovpn > /root/tmp.ovpn && mv -f /root/tmp.ovpn /root/$username.ovpn
													            zip /root/$username.zip /root/$username.ovpn
													            rm /root/$username.ovpn
													            sleep 2
													            if [ -d /var/www/html/openvpn ]; then
													    	        cp $HOME/$username.zip /var/www/html/openvpn/$username.zip
													            fi
													            }
													        else
													            gerarovpn () {
													            cd /etc/openvpn/easy-rsa/
													            ./easyrsa build-client-full $username nopass
													            newclient "$username"
													            zip /root/$username.zip /root/$username.ovpn
													            rm /root/$username.ovpn
													            sleep 2
													            if [ -d /var/www/html/openvpn ]; then
													    	        cp $HOME/$username.zip /var/www/html/openvpn/$username.zip
													            fi
													            }
													        fi
													        echo -ne "\033[1;32mHost Atual\033[1;37m: \033[1;31m(\033[1;37m$Host\033[1;31m) \033[1;37m- \033[1;32mAlterar \033[1;31m? \033[1;33m[s/n]:\033[1;37m "; read oprc
													        if [[ "$oprc" = 's' ]]; then
													        	fun_edithost
													        fi
													        clear
													        echo -e "\E[44;1;37m       CONTA SSH CRIADA !      \E[0m"
													        [ $? -eq 0 ] && tput setaf 2 ; tput bold ; echo ""; echo -e "\033[1;32mIP: \033[1;37m$IP" ; echo -e "\033[1;32mUsuário: \033[1;37m$username" ; echo -e "\033[1;32mSenha: \033[1;37m$password" ; echo -e "\033[1;32mExpira em: \033[1;37m$gui" ; echo -e "\033[1;32mLimite de conexões: \033[1;37m$sshlimiter" ; echo "" || echo "Não foi possível criar o usuário!" ; tput sgr0
													        sleep 1
													        function aguarde {
													        	helice () {
													        		gerarovpn > /dev/null 2>&1 & 
													        		tput civis
													        		while [ -d /proc/$! ]
													        		do
													        			for i in / - \\ \|
													        			do
													        				sleep .1
													        				echo -ne "\e[1D$i"
													        			done
													        		done
													        		tput cnorm
													        	}
													        	echo -ne "\033[1;31mCRIANDO OVPN\033[1;33m.\033[1;31m. \033[1;32m"
													        	helice
													        	echo -e "\e[1DOK"
													        }
													        aguarde
													        VERSION_ID=$(cat /etc/os-release | grep "VERSION_ID")
													        echo ""
													        if [ -d /var/www/html/openvpn ]; then
													        	if [[ "$VERSION_ID" = 'VERSION_ID="14.04"' ]]; then
													        		echo -e "\033[1;32mLINK\033[1;37m: \033[1;36m$IP:81/html/openvpn/$username.zip"
													        	else
													        		echo -e "\033[1;32mLINK\033[1;37m: \033[1;36m$IP:81/openvpn/$username.zip"
													        	fi
													        else
													        	echo -e "\033[1;32mDisponivel em\033[1;31m" ~/"$username.zip\033[0m"
													        	sleep 1
													        fi
													    else
													    	clear
													        echo -e "\E[44;1;37m       CONTA SSH CRIADA !      \E[0m"
													        [ $? -eq 0 ] && tput setaf 2 ; tput bold ; echo ""; echo -e "\033[1;32mIP: \033[1;37m$IP" ; echo -e "\033[1;32mUsuário: \033[1;37m$username" ; echo -e "\033[1;32mSenha: \033[1;37m$password" ; echo -e "\033[1;32mExpira em: \033[1;37m$gui" ; echo -e "\033[1;32mLimite de conexões: \033[1;37m$sshlimiter" ; echo "" || echo "Não foi possível criar o usuário!" ; tput sgr0
													    fi
													else
														clear
														echo -e "\E[44;1;37m       CONTA SSH CRIADA !      \E[0m"
														[ $? -eq 0 ] && tput setaf 2 ; tput bold ; echo ""; echo -e "\033[1;32mIP: \033[1;37m$IP" ; echo -e "\033[1;32mUsuário: \033[1;37m$username" ; echo -e "\033[1;32mSenha: \033[1;37m$password" ; echo -e "\033[1;32mExpira em: \033[1;37m$gui" ; echo -e "\033[1;32mLimite de conexões: \033[1;37m$sshlimiter" ; echo "" || echo "Não foi possível criar o usuário!" ; tput sgr0
													fi
												fi
											fi
										fi
									fi
								fi
							fi
						fi
					fi
				fi
			fi
		fi
	fi	
fi