#!/bin/bash
clear
IP=$(wget -qO- ipv4.icanhazip.com)
echo -e "\E[44;1;37m          FIREWALL BLOQUEIO TORRENT          \E[0m"
echo ""
if [[ -e /etc/openvpn/openvpn-status.log ]]; then
	echo -e "\033[1;31mNAO PERMITIDO COM \033[1;32mOPENVPN \033[1;31mEM USO!\033[0m"
	sleep 2
	menu
fi
if iptables -L |grep 'ESTABLISHED' > /dev/null; then
	fun_fireoff () {
		iptables -P INPUT ACCEPT
		iptables -P OUTPUT ACCEPT
		iptables -P FORWARD ACCEPT
		iptables -t mangle -F
		iptables -t mangle -X
		iptables -t nat -F
		iptables -t nat -X
		iptables -t filter -F
		iptables -t filter -X
		iptables -F
		iptables -X
		sleep 4
	}
fun_spn1 () {
	helice () {
		fun_fireoff > /dev/null 2>&1 & 
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
	echo -ne "\033[1;31mREMOVENDO FIREWALL\033[1;32m.\033[1;33m.\033[1;31m. \033[1;32m"
	helice
	echo -e "\e[1DOk"
}
echo -ne "\033[1;32mDESEJA REMOVER REGRAS FIREWALL \033[1;31m? \033[1;33m[s/n]:\033[1;37m "; read -e -i n resp
if [[ "$resp" = 's' ]]; then
echo ""	
fun_spn1
echo ""
echo -e "\033[1;33mTORRENT LIBERADO !\033[0m"
echo ""
echo -e "\033[1;32mFIREWALL REMOVIDO COM SUCESSO !"
sleep 4
menu
else
	sleep 1
	menu
fi
else
echo -ne "\033[1;32mDESEJA APLICAR REGRAS FIREWALL \033[1;31m? \033[1;33m[s/n]:\033[1;37m "; read -e -i n resp
if [[ "$resp" = 's' ]]; then
echo ""
echo -ne "\033[1;33mPARA CONTINUAR CONFIRME SEU IP: \033[1;37m"; read -e -i $IP ip
if [[ -z "$ip" ]];then
echo ""
echo -e "\033[1;31mIP invalido\033[1;32m"
sleep 1
echo ""
read -p "Digite seu IP: " ip
fi
echo ""
sleep 1
fun_fireon () {
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t filter -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp -d $ip --dport 443 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp -d $ip --dport 80 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p tcp --dport 67 -m state --state NEW -j ACCEPT
iptables -A OUTPUT -p udp --dport 67 -m state --state NEW -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 3128 -j ACCEPT
iptables -A INPUT -p tcp --dport 8799 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 8080 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 3128 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 8799 -j ACCEPT
iptables -A FORWARD -p tcp --dport 8080 -j ACCEPT
iptables -A FORWARD -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp --dport 3128 -j ACCEPT
iptables -A FORWARD -p tcp --dport 8799 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
iptables -A INPUT -p tcp --dport 10000 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 10000 -j ACCEPT
sleep 3
}
fun_spn2 () {
	helice () {
		fun_fireon > /dev/null 2>&1 & 
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
	echo -ne "\033[1;32mAPLICANDO FIREWALL\033[1;32m.\033[1;33m.\033[1;31m. \033[1;32m"
	helice
	echo -e "\e[1DOk"
}
fun_spn2
echo ""
echo -e "\033[1;33mBLOQUEIO\033[1;37m TORRENT \033[1;33mAPLICADO !\033[0m"
echo ""
echo -e "\033[1;32mFIREWALL APLICADO COM SUCESSO !"
sleep 4
menu
else
	sleep 1
	menu
fi
fi