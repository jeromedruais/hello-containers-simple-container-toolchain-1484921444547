#  Copyright 2014 IBM
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

FROM node
MAINTAINER Robbie Minshall "rjminsha@us.ibm.com"

# Install the CF and BX CLIs
ENV BXVERSION=0.4.6_amd64 BXREPORT_HOME=/opt/bluemix-report
RUN apt-get update && apt-get install -y wget
RUN wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add - && echo "deb http://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list
RUN wget https://s3-us-west-1.amazonaws.com/cf-cli-releases/releases/v6.23.1/cf-cli-installer_6.23.1_x86-64.deb && dpkg -i cf-cli-*.deb && apt-get install -f
RUN wget http://public.dhe.ibm.com/cloud/bluemix/cli/bluemix-cli/Bluemix_CLI_$BXVERSION.tar.gz -O Bluemix_CLI.tar.gz && tar -xvf Bluemix_CLI.tar.gz && cd Bluemix_CLI && ./install_bluemix_cli


# Install the application
ADD package.json /app/package.json 
RUN cd /app && npm install  
ADD app.js /app/app.js
ENV WEB_PORT 80
EXPOSE  80

# Define command to run the application when the container starts
CMD ["node", "/app/app.js"] 

