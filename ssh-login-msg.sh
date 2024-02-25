#!/usr/bin/env bash
#set -vux
#
# ssh-login-msg.sh
# send message on ssh login via messenger bot
# © Olivetti 2020-2024
#
# dependencies: curl
#
# recommended: telegram, matrix
#
# messenger credentials in ~/.ssh-login-msg.env

version="v1.0"

[[ "${1}" = "-d" ]] && SSH_CLIENT="23.123.123.123" && SSH_CONNECTION="23.123.123.123 00 127.0.0.1 22" # debug / for testing

#_curl()  { curl -s --connect-timeout 15 -w '\n%{response_code}\n' "${@}"; }
_curl()  { curl -s --connect-timeout 15 "${@}"; }
_error() { echo "Error: ${1}" && return ${2}; }
_line()	 { inp=${1}; for f in $(eval echo {1..${inp}}); do echo -n "_"; done; [[ -n ${2} ]] && echo; }

#init() { $EDITOR "${envfile}"; exit; }

ip_padding() { echo "${1}" | sed -r \
				-e 's/^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$/00\1.00\2.00\3.00\4/' \
				-e 's/0*([0-9]{3})/\1/g'; } # ipv4 only

url_encode() { echo "${1}" | sed -e 's/+/%2b/g' -e 's/&/%26/g' -e 's/</%3c/g' -e 's/>/%3e/g'; }

prepare_for_msg() {
	envfile=~/".${myname%.sh}.env"
	[[ -f "${envfile}" ]] && source "${envfile}" || _error "No env file - ${envfile}" 1
	ip_srv_pad=$(ip_padding "${ip_srv}")
	ip_usr_pad=$(ip_padding "${ip_usr}")
}

send_telegram() {
	isodate=$(url_encode "${isodate}")
	 ipinfo=$(url_encode "${ipinfo}")

	[[ -n "${telegram_id}" ]] && [[ -n "${telegram_token}" ]]				&& \
		telegram_url="https://api.telegram.org/bot${telegram_token}/sendMessage"	|| \
			_error "Telegram - No id/token" 2

	header="<b>SSH Login: ${myuser}</b>%0a%0a"
	  data="<code>Date: ${isodate}%0aUser: ${myuser}%0aHost: ${ip_srv_pad}%0aFrom: ${ip_usr_pad}</code>%0a%0a"
	footer="<pre>${ipinfo}</pre>"
	msg="${header}${data}${footer}"
	#echo -e "telegram:\n${msg}"

	_curl -d "disable_web_page_preview=1&parse_mode=HTML&chat_id=${telegram_id}&text=${msg}" \
		"${telegram_url}" >/dev/null
}

send_matrix() {
	ipinfo=$(echo $(echo "${ipinfo}" | sed -e 's/$/<br>/'))

	[[ -n "${matrix_room}" ]] && [[ -n "${matrix_token}" ]] && [[ -n "${matrix_server}" ]]	&& \
		matrix_url="https://${matrix_server}/_matrix/client/r0/rooms/${matrix_room}/send/m.room.message?access_token=${matrix_token}" || \
			_error "Matrix - No room/token/server" 3

	header="<b><font color=red>SSH Login: ${myuser}</font></b><br>"
	  data="<span>Date: ${isodate}<br>User: ${myuser}<br>Host: ${ip_srv_pad}<br>From: ${ip_usr_pad}</span><br><br>"
	footer="<details><blockquote>${ipinfo}</blockquote></details>"
	msg="${header}${data}${footer}"
	#echo -e "matrix:\n${msg}"

	_curl -d '{"msgtype":"m.text", "body":"SSH Login", "format":"org.matrix.custom.html", "formatted_body":"'"${msg}"'"}' \
		"${matrix_url}" >/dev/null
}


[[ -n "${SSH_CLIENT}" ]] && {

    myname="${BASH_SOURCE[0]##*/}"
    myuser="${USER}@${HOSTNAME}"
   isodate=$(date +'%FT%T%z')
   logfile=~/"${myname%.sh}.log"

    ip_srv=$(echo "${SSH_CONNECTION}" | cut -d' ' -f3)
    ip_usr=$(echo "${SSH_CONNECTION}" | cut -d' ' -f1)

 tokenfile=~/".config/ipinfo/config.json"
 [[ -f "${tokenfile}" ]] && token=$(sed -Ee 's/.*,"token":"(.*)",.*/\1/' "${tokenfile}")

    ipinfo=$(curl -s "https://ipinfo.io/${ip_usr}?token=${token}")

    ipinfo=$(echo "${isodate}" && \
    	echo "${ipinfo}" | sed -e '/^[{}]/d' -e 's/^  //' -e '/readme.*missingauth/d' -e 's/"//g' -e 's/,$//g')
       log=$(echo $(echo "${ipinfo}"))

 echo "${log}" >>"${logfile}" # writing logfile ~/ssh-login-msg.log

 prepare_for_msg
 [[ "${telegram_send,,}" = "yes" ]] && send_telegram	&
 [[ "${matrix_send,,}"   = "yes" ]] && send_matrix	&

}
