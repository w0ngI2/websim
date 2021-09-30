#!/bin/bash

username="test"
password="test"
wlanuserip=$(ifconfig | grep inet | grep -v inet6 | grep -v 127 | cut -d ' ' -f2);
UserAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Safari/605.1.15"

function changePassword() {
    read -p "请输入账号" user
    sed -i '' '3s/".*"/'\"$user\"'/' $0;
    read -p "请输入密码" pawd
    sed -i '' '4s/".*"/'\"$pawd\"'/' $0;
    echo 可以登陆了
}

function login() {
  if [[ $username = "test" ]]; then
      changePassword
      echo 请重新登陆
  else
      url="http://27.129.43.18/portal3/portal.jsp"
      data="domain=&logintype=1&username="$1"&password="$2"&wlanuserip="$3"&page=index&func=Login&0MKKey=%B5%C7%C2%BC"
      res=$(curl -H "User-Agent:$4" -s ${url} -d ${data} -k)
  fi
}

function logout() {
  url="http://27.129.43.18/portal3/portal.jsp?func=Logout&wlanuserip="
  res=$(curl -s ${url}$1)
}


if [[ $1 = "" ]]; then
  logout $wlanuserip
  login $username $password $wlanuserip $UserAgent
  ping -c 1 114.114.114.114 > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo '网络已连接'
  else
    echo '网络未连接'
  fi
elif [[ $1 = q ]]; then
  logout $wlanuserip
  ping -c 1 114.114.114.114 > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo '网络未断开'
  else
    echo '网络已断开'
  fi
elif [[ $1 = c ]]; then
  changePassword
fi
