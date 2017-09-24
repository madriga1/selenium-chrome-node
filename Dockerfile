# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.txt INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM madriga1/selenium-base
LABEL authors=madriga1@msn.com

# Here we change to root due to seuser in the base image
USER root
ENV YUMCONFIG=/etc/yum.repos.d/google-chrome.repo
ENV SELDIR=/opt/selenium
COPY google-chrome.repo $YUMCONFIG
#--------------------------------------------------------
# Update the image with the latest packages (recommended)
#--------------------------------------------------------
RUN yum update -y; yum clean all
RUN yum -y install google-chrome-stable
# Clean up guy
RUN rm -rf /var/cache/yum
#============================================
# Chrome webdriver
#============================================
# can specify versions by CHROME_DRIVER_VERSION
# Latest released version will be used by default
#============================================
USER seluser
ARG CHROME_DRIVER_VERSION="latest"
RUN CD_VERSION=$(if [ ${CHROME_DRIVER_VERSION:-latest} = "latest" ]; then echo $(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE); else echo $CHROME_DRIVER_VERSION; fi) \
  && echo "Using chromedriver version: "$CD_VERSION \
  && wget --no-verbose -O /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CD_VERSION/chromedriver_linux64.zip \
  && rm -rf $SELDIR/chromedriver \
  && unzip /tmp/chromedriver_linux64.zip -d $SELDIR \
  && rm /tmp/chromedriver_linux64.zip \
  && mv $SELDIR/chromedriver $SELDIR/chromedriver-$CD_VERSION \
  && chmod 755 $SELDIR/chromedriver-$CD_VERSION \
  && sudo ln -fs /opt/selenium/chromedriver-$CD_VERSION /usr/bin/chromedriver

# Copy files
COPY generate_config $SELPATH
RUN sudo chown seluser:seluser $SELPATH/generate_config
RUN chmod 755 $SELPATH/generate_config
# Chrome Launch Script Modification
COPY chrome_launcher.sh /opt/google/chrome/google-chrome
# Generating a default config during build time
RUN $SELDIR/generate_config > $SELDIR/config.json
