FROM ubuntu:xenial
MAINTAINER Pin <pinfake@hotmail.com>
EXPOSE 5037 5554 5555
EXPOSE 8484
RUN apt-get update && \
    apt-get install -y curl default-jre-headless libgl1-mesa-glx unzip libpulse0 && \
    apt-get clean

RUN cd /tmp && \
    curl -O https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
    cd /opt && mkdir android-sdk-linux && cd android-sdk-linux  && unzip /tmp/*.zip && rm /tmp/*.zip 

#RUN ln -sv /opt/tools/bin/sdkmanager /usr/bin/sdkmanager
#RUN ln -sv /opt/tools/bin/avdmanager /usr/bin/avdmanager
#RUN ln -sv /opt/tools/emulator /usr/bin/emulator

ENV ANDROID_HOME="/opt/android-sdk-linux"
ENV LD_LIBRARY_PATH="${ANDROID_HOME}/tools/lib"
ENV ANDROID_SDK_HOME="${ANDROID_HOME}"
ENV PATH="${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}"
ENV LD_LIBRARY_PATH="${ANDROID_HOME}/tools/lib:${ANDROID_HOME}/emulator/lib64:${ANDROID_HOME}/emulator/lib64/qt/lib:${ANDROID_HOME}/emulator/lib/libstdc++"
#ENV PATH="${PATH}:${ANDROID_SDK_HOME}/tools"
#ENV ANDROID_EMULATOR_FORCE_32BIT="true"

#RUN echo "y" | sdkmanager --list --verbose
COPY avd/repositories.cfg $ANDROID_HOME/.android/
RUN echo "y" | sdkmanager "tools"
RUN echo "y" | sdkmanager "emulator"
RUN echo "y" | sdkmanager "sources;android-24"
RUN echo "y" | sdkmanager "platforms;android-24"
RUN echo "y" | sdkmanager "system-images;android-24;google_apis;x86_64"
RUN echo "n" | avdmanager create avd --force -n nexus  -b google_apis/x86_64 -k "system-images;android-24;google_apis;x86_64"

COPY avd/config.ini $ANDROID_HOME/.android/avd/nexus.avd/


ENV ANDROID_HOME="/opt/android-sdk-linux"

RUN echo "y" | apt-get install pulseaudio
ENV PULSE_SERVER /run/pulse/native


#run emulator -netdelay none -netspeed full -avd Galaxy_Nexus_API_24

ENTRYPOINT ["emulator","@nexus"]
#ENTRYPOINT  /bin/bash

