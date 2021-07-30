FROM openjdk:8-jre
MAINTAINER Frankie Fan "hustakin@gmail.com"
ENV REFRESHED_AT 2019-7-3
VOLUME /tmp
ADD web/target/test.jar test.jar
ENTRYPOINT ["java","-XX:-BytecodeVerificationLocal","-XX:-BytecodeVerificationRemote","-XX:CICompilerCount=3","-XX:InitialHeapSize=268435456","-XX:+ManagementServer","-XX:MaxHeapSize=4263510016","-XX:MaxNewSize=2147483648","-XX:MinHeapDeltaBytes=524288","-XX:NewSize=89128960","-XX:OldSize=179306496","-XX:TieredStopAtLevel=1","-XX:+UseCompressedClassPointers","-XX:+UseCompressedOops","-XX:-UseLargePagesIndividualAllocation","-XX:+UseParallelGC","-Djava.security.egd=file:/dev/./urandom","-Dspring.profiles.active=dev","-jar","/test.jar"]
EXPOSE 80 443
