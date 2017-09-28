FROM ubuntu:xenial
MAINTAINER Pin <pinfake@hotmail.com>
EXPOSE 5037 5554 5555
RUN apt-get update && \
    apt-get install -y curl default-jre-headless libgl1-mesa-glx && \
    apt-get clean
ENV ANDROID_HOME="/opt/android-sdk-linux"
ENV LD_LIBRARY_PATH="${ANDROID_HOME}/tools/lib64"
ENV ANDROID_SDK_HOME="${ANDROID_HOME}"
ENV PATH="${PATH}:${ANDROID_SDK_HOME}/tools"
RUN cd /tmp && \
    curl -O https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && \
    cd /opt && tar xzf /tmp/*.tgz && rm /tmp/*.tgz
#RUN echo "y" | android update sdk --no-ui --force -a --filter android-23,sys-img-x86-android-23
#RUN echo "n" | android create avd --force -n nexus -t android-23 -b default/x86

RUN echo "y" | android update sdk --no-ui --force -a --filter android-24,sys-img-x86_64-android-24,extra-google-simulators,extra-google-webdriver,extra-google-m2repository,extra-google-auto,source-24,addon-google_apis-google-24,sys-img-x86_64-google_apis-24
#,build-tools-24.0.3
RUN echo "n" | android create avd --force -n nexus -t android-24 -b google_apis/x86_64

 
#RUN echo "y" | android update sdk --no-ui --force -a --filter android-23,sys-img-x86-android-23
#RUN echo "n" | android create avd --force -n nexus -t android-23 -b default/x86

COPY avd/config.ini $ANDROID_HOME/.android/avd/nexus.avd/
ENTRYPOINT ["emulator64-x86","@nexus"]