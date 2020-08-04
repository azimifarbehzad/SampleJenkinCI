FROM jenkins/jenkins

USER root

# Install .NET CLI dependencies
RUN apt-get update \

    && apt-get install -y --no-install-recommends \
    libc6 \
    libcurl3 \
    libgcc1 \
    libgssapi-krb5-2 \
    libicu57 \
    liblttng-ust0 \
    libssl1.0.2 \
    libstdc++6 \
    libunwind8 \
    libuuid1 \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Install .NET Core SDK
ENV DOTNET_SDK_VERSION 2.2.207
ENV DOTNET_SDK_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-sdk-$DOTNET_SDK_VERSION-linux-x64.tar.gz
ENV DOTNET_SDK_DOWNLOAD_SHA 026021818E0B18D414229E6DF94ED4EC34390A435A990F03C6A9C36341FA33C92DAA703B154E5E6F1B2EA36702508B5A464AB3856C0D368F7450027AB72320A8

RUN curl -SL $DOTNET_SDK_DOWNLOAD_URL --output dotnet.tar.gz \
    && echo "$DOTNET_SDK_DOWNLOAD_SHA dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Enable detection of running in a container
ENV DOTNET_RUNNING_IN_CONTAINER=true \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps perfomance
    NUGET_XMLDOC_MODE=skip

# Trigger the population of the local package cache
RUN mkdir warmup \

    && cd warmup \
    && dotnet new \
    && cd .. \
    && rm -rf warmup \
    && rm -rf /tmp/NuGetScratch

# Workaround for https://github.com/Microsoft/DockerTools/issues/87. This instructs NuGet to use 4.5 behavior in which
# all errors when attempting to restore a project are ignored and treated as warnings instead. This allows the VS
# tooling to use -nowarn:MSB3202 to ignore issues with the .dcproj project
ENV RestoreUseSkipNonexistentTargets false


# #Install Mono
# RUN apt-get update
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6B05F25D762E3157
# RUN apt install apt-transport-https
# RUN echo "deb https://download.mono-project.com/repo/debian stable-jessie main" |  tee /etc/apt/sources.list.d/mono-official-stable.list
# RUN apt-get install mono-complete -y  && rm -rf /var/lib/apt/lists/*

#add nuget for mono 
RUN mkdir .nuget
ADD https://dist.nuget.org/win-x86-commandline/latest/nuget.exe ./nuget.exe

USER jenkins