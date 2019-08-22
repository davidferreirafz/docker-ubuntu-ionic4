###############################################################################
#   Este Dockerfile cria uma imagem com base na imagem beevelop/ionic         #
# contendo Ionic 4, Cordova 8, node 11.10.0, android api 25, java 8 oracle    #
# Referencias                                                                 #
#     https://hub.docker.com/r/beevelop/ionic/tags                            #
###############################################################################
FROM beevelop/ionic:v4.10.0

ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/platform-tools_r29.0.1-linux.zip" \
    ANDROID_BUILD_TOOLS_VERSION=29.0.1 \
    ANDROID_APIS="platform-tools,platforms;android-28" \
    ANDROID_HOME="/opt/android" \
                ANDROID_SDK_ROOT="/opt/android" \            
                GRADLE_HOME="/opt/gradle/gradle-5.5.1" \
                CORDOVA_ANDROID_GRADLE_DISTRIBUTION_URL="file:///opt/gradle-5.5.1-bin.zip"
              

ENV PATH $GRADLE_HOME/bin:$ANDROID_HOME/tools::$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/$ANDROID_BUILD_TOOLS_VERSION:/bin:$PATH:

WORKDIR /opt/android

#Instalando ANDROID SDK
RUN  echo y | android update sdk -a -u -t "platform-tools,android-28,build-tools-29.0.1" && \
     chmod a+x -R $ANDROID_HOME/platform-tools && \
     chown -R root:root $ANDROID_HOME/platform-tools && \
     chmod a+x -R $ANDROID_HOME/platforms/android-28 && \
     chown -R root:root $ANDROID_HOME/platforms/android-28 && \
     rm -rf $ANDROID_HOME/build-tools/27.0.0 && \
     chmod a+x -R $ANDROID_HOME/build-tools/29.0.1 && \
     chown -R root:root $ANDROID_HOME/build-tools/29.0.1  

#copiando gradle
#COPY --chown=root:root gradle/gradle-5.5.1-bin.zip /opt/gradle-5.5.1-bin.zip

WORKDIR /opt/android

#Instalando node e removendo gradle antigo
RUN wget -qO- https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs && \
    apt-get remove -y gradle  && \
    wget https://services.gradle.org/distributions/gradle-5.5.1-bin.zip -P /opt && \
    unzip -d /opt/gradle /opt/gradle-5.5.1-bin.zip && \
    rm -rf /opt/android/platforms/android-10 && \
    rm -rf /opt/android/platforms/android-15 && \
    rm -rf /opt/android/platforms/android-16 && \
    rm -rf /opt/android/platforms/android-17 && \
    rm -rf /opt/android/platforms/android-18 && \
    rm -rf /opt/android/platforms/android-20 && \
    rm -rf /opt/android/platforms/android-21 && \
    rm -rf /opt/android/platforms/android-22 && \         
    rm -rf /opt/android/platforms/android-23 && \         
    rm -rf /opt/android/platforms/android-24 && \         
    rm -rf /opt/android/platforms/android-25 && \         
    npm config set strict-ssl=false && \
    npm config set sslVerify=false && \
    npm install -g ionic@4.10 node-gyp node-sass cordova @angular/cli --unsafe-perm=true --allow-root


#Criando diretorio para o codigo fonte
VOLUME ["/opt/source"]

EXPOSE 8100/tcp 

WORKDIR /opt/source