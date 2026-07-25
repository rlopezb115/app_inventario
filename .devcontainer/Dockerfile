FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias del sistema y Java
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa openjdk-17-jdk wget \
    && rm -rf /var/lib/apt/lists/*

# Configurar rutas y variables de entorno
ENV HOME=/root
ENV ANDROID_SDK_ROOT=${HOME}/android-sdk
ENV FLUTTER_HOME=${HOME}/flutter
ENV PATH=${PATH}:${FLUTTER_HOME}/bin:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools

# Descargar e instalar Command Line Tools de Android
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O cmdline-tools.zip && \
    unzip -q cmdline-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm cmdline-tools.zip

# Aceptar licencias de Android de forma automática
RUN yes | sdkmanager --licenses

# Instalar SDK de Android (Plataforma 34 y herramientas)
RUN sdkmanager "platforms;android-34" "build-tools;34.0.0" "platform-tools"

# Descargar Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable ${FLUTTER_HOME}

# Vincular Flutter con Android SDK y verificar
RUN flutter config --android-sdk ${ANDROID_SDK_ROOT}
RUN flutter doctor

WORKDIR /workspace