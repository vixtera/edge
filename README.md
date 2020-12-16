# What is Vixtera Edge?

> Vixtera Edge (ViEdge) is architected as an intelligent connector, a gateway - a synergetic framework of content plane to ANY control plane-based solution. It facilitates cohesive “physical to logical” interconnectivity, including composing of uniformly formatted MQTT payload, unifying OT and IT processes across a single data plane while overcoming burdens of integrating disparate devices, applications and data-driven services.
When deep analyses or connection to incumbent platform is required, the ViEdge workflow engine collects and analyzes the data and seamlessly, in a snap, feeds the relevant aggregated data to external analytics platforms without needs for frequent patches, additional software and endless integration.

https://vixtera.com/

# Prerequisites

To run this application you need:

[Docker Engine](https://www.docker.com/products/docker-engine) >= `1.10.0`

[Docker Compose](https://www.docker.com/products/docker-compose) is recommended with a version `1.6.0` or later.

[Git](https://git-scm.com) minimum required git version is 2.18

Installation script will install Docker Engine and Docker Compose prerequisites automatically.

User must be root or have sudo rights.

Also you need request login/password by [vixtera.com](https://vixtera.com/contact-us/) for docker-registry.cmlatitude.com and for distributed version of applicaton (require authentication)

#### Open ports on server

Next ports should be open on server:
 
* Analytics service (for both monolith or distributed)- 3322

* Monolith version - 8080

* Distributed version - 80

# Hardware and OS requirements

## Vixtera Edge monolith version

* Operating system = Ubuntu 18.04 or Ubuntu 20.04 (recommended)

* System Memory >= 4 GB

* CPU >= 2 cores

* HDD free space >= 10 GB

* Internet access

## Vixtera Edge distributed version

* Operating system = Ubuntu 18.04 or Ubuntu 20.04 (recommended)

* System Memory >= 16 GB

* CPU >= 4 cores

* HDD free space >= 30 GB

* Internet access

# Starting Vixtera Edge

Execute next commands:

#### Install git

* apt-get update

* apt-get -y install git

#### Clone Vixtera Edge repository

* git clone https://github.com/vixtera/edge.git

#### Configure environment variables

Replace NETWORK_IP_DOCKER_HOST environment variable with your server IP or hostname in .env file

File location: edge/monolith/.env or edge/distributed/.env

Example: NETWORK_IP_DOCKER_HOST=54.88.37.71 or NETWORK_IP_DOCKER_HOST=vixtera-edge.domain.com

#### Choose Vixtera Edge version - Monolith or Distributed

#### Navigate to cloned edge folder:

* cd edge

#### To start Monolith version:

Start script:
  
* ./vixtera-edge-monolith-start.sh
  
#### To start Distributed version execute:

* ./vixtera-edge-distributed-start.sh
  
#### To stop Monolith version execute:

* ./vixtera-edge-monolith-stop.sh
  
#### To stop Distributed version execute:

* ./vixtera-edge-distributed-stop.sh

## Open Vixtera Edge application in your browser:

#### Monolith version - http://[ip or hostname]:8080 (without authentication)

#### Distributed version - http://[ip or hostname]

Use credentials that you received from vixtera support
