# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.txt INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM madriga1/selenium-base
LABEL authors=madriga1@msn.com

# Here we change to root due to seuser in the base image
USER root
ENV YUMCONFIG=/etc/yum.repos.d/google-chrome.repo
COPY google-chrome.repo $YUMCONFIG
#--------------------------------------------------------
# Update the image with the latest packages (recommended)
#--------------------------------------------------------
RUN yum update -y; yum clean all
RUN yum -y install google-chrome-stable
# Clean up guy
RUN rm -rf /var/cache/yum
