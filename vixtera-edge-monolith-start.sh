#!/bin/bash

# Requremens variables:
# Operating system
OS="Ubuntu"
OS_VER=18.04
# System Memory in GB
MIN_SYSTEM_MEMORY=4
#CPU minimum number of cores
MIN_CORES=2
#CPU minimum frequency
MIN_FREQ=2000
#Free HDD space in GB
HDD_SPACE=10
DOCKER_MINVER=1.13.1
DOCKER_MAXVER=19.4.2
#Internet access

#Check if swap is disabled

# Operating system
CUR_OS=$(lsb_release -i | sed 's/Distributor ID://' | sed s/'\s'//g)
CUR_OS_VER=$(lsb_release -r | sed 's/Release://' | sed s/'\s'//g)
# System Memory in GB
CUR_SYSTEM_MEMORY=$(cat /proc/meminfo | awk 'NR==1{print $2}')
CUR_SYSTEM_MEMORY=$((CUR_SYSTEM_MEMORY/1000000))
#CPU
#CUR_CPU_CORES=$(cat /proc/cpuinfo|grep processor|wc -l)
CUR_CPU_CORES=$(nproc)
CUR_CPU_FREQ=$(cat /proc/cpuinfo | grep MHz | awk 'NR==1{print $4}' | cut -d'.' -f 1)
#Free HDD space in GB
CUR_HDD_SPACE=$(df / | awk 'NR==2{print $4}')
CUR_HDD_SPACE=$((CUR_HDD_SPACE/1000000))
#CUR_DOCKER_VER=$(docker -v | awk 'NR==1{print $3}' | sed 's/,//')
#Swap size
SWAP_SIZE=$(cat /proc/meminfo | grep SwapTotal | awk 'NR==1{print $2}')
INST_D=true

#Print info
echo Detected OS and hardware
echo "Detected OS: $CUR_OS"
echo "Detected OS version: $CUR_OS_VER"
# System Memory in GB
echo "Detected RAM $CUR_SYSTEM_MEMORY GB"
#CPU
echo "Detected CPU cores: $CUR_CPU_CORES"
echo "Detected CPU frequency $CUR_CPU_FREQ MHz"
#Free HDD space in GB
echo "Free space on / $CUR_HDD_SPACE GB"
#echo "Docker version: $CUR_DOCKER_VER"
echo "Swap size: $SWAP_SIZE"

if [ "$OS" = "$CUR_OS" ]
then
echo "OS OK"
else
echo "OS FAIL, requirement $OS"
INST_D=false
fi

if  (dpkg --compare-versions "$OS_VER" le "$CUR_OS_VER")
then
echo "OS version OK"
else
echo "OS version FAIL, requirement >= $OS_VER"
INST_D=false
fi

if [ "$CUR_SYSTEM_MEMORY" -ge "$MIN_SYSTEM_MEMORY" ]
then
echo "RAM size OK"
else
echo "RAM size FAIL, requirement >= $MIN_SYSTEM_MEMORY GB"
INST_D=false
fi

if [ "$CUR_CPU_CORES" -ge "$MIN_CORES" ]
then
echo "Number of Cores OK"
else
echo "Number of Cores FAIL, requirement >= $MIN_CORES"
INST_D=false
fi

if [ "$CUR_HDD_SPACE" -ge "$HDD_SPACE" ]
then
echo "Free space on / OK"
else
echo "Free space on / FAIL, requirement >= $HDD_SPACE GB"
INST_D=false
fi

wget -q --spider http://google.com
if [ $? -eq 0 ]; then
echo "Online OK"
else
echo "Offline FAIL"
INST_D=false
fi

if [ $INST_D = true ]; then
echo "Updating OS packages"
{
apt-get update
} > /dev/null
else
	echo "Your system is not compatible, please check hardware requirements"
exit 1
fi

if [ -x "$(command -v docker)" ]; then
    echo "Docker is installed"
else
    echo "Installing Docker"
	apt-get -y install docker.io >/dev/null
fi

if [ -x "$(command -v docker-compose)" ]; then
    echo "Docker Compose is installed"
else
    echo "Installing Docker Compose"
	apt-get -y install docker-compose >/dev/null
fi

echo Please enter username and password for https://docker-registry.cmlatitude.com/
docker login docker-registry.cmlatitude.com
cd monolith/
docker-compose up -d --build --remove-orphans --scale simulator=10

if [ $? -eq 0 ]; then
    echo "Vixtera Edge is starting up, please wait..."
else
    echo "Vixtera Edge failed to start"
	exit 1
fi

url='http://localhost:8080'
attempts=40
timeout=10
online=false

for (( i=1; i<=$attempts; i++ ))
do
  code=`curl -sL --connect-timeout 20 --max-time 30 -w "%{http_code}\\n" "$url" -o /dev/null`

  if [ "$code" = "200" ]; then
    echo "Website $url is online."
    online=true
    break
  else
    echo "Vixtera Edge is starting up. Waiting $timeout seconds."
    sleep $timeout
  fi
done

if $online; then
  echo "Vixtera Edge started successfully. Please open http://localhost:8080"
  exit 0
else
  echo "Vixtera Edge failed to start"
  exit 1
fi
