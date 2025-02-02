FROM lnls/epics-dist:base-3.15-synapps-lnls-R1-0-0-debian-9.5

ENV GIT_USER_ORG henrique-silva
ENV IOC_REPO rssmx100a-epics-ioc
ENV BOOT_DIR iocrssmx100a
ENV COMMIT ess-without-fm-cs

RUN git clone https://github.com/${GIT_USER_ORG}/${IOC_REPO}.git /opt/epics/${IOC_REPO} && \
    cd /opt/epics/${IOC_REPO} && \
    git checkout ${COMMIT} && \
    sed -i -e 's|^EPICS_BASE=.*$|EPICS_BASE=/opt/epics/base|' configure/RELEASE && \
    sed -i -e 's|^SUPPORT=.*$|SUPPORT=/opt/epics/synApps-lnls-R1-0-0/support|' configure/RELEASE && \
    sed -i -e 's|^STREAM=.*$|STREAM=$(SUPPORT)/stream-R2-7-7|' configure/RELEASE && \
    sed -i -e 's|^SNCSEQ=.*$|SNCSEQ=$(SUPPORT)/seq-2-2-6|' configure/RELEASE && \
    sed -i -e 's|^CALC=.*$|CALC=$(SUPPORT)/calc-R3-7|' configure/RELEASE && \
    sed -i -e 's|^ASYN=.*$|ASYN=$(SUPPORT)/asyn-R4-33|' configure/RELEASE && \
    sed -i -e 's|^AUTOSAVE=.*$|AUTOSAVE=$(SUPPORT)/autosave-R5-9|' configure/RELEASE && \
    make && \
    make install && \
    make clean

# Source environment variables until we figure it out
# where to put system-wide env-vars on docker-debian
RUN . /root/.bashrc

WORKDIR /opt/epics/startup/ioc/${IOC_REPO}/iocBoot/${BOOT_DIR}

ENTRYPOINT ["./runProcServ.sh"]
