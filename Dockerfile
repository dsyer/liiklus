FROM openjdk:8u151-jdk AS workspace

COPY . /root/project

WORKDIR /root/project

RUN ./gradlew --no-daemon build -x check

FROM openjdk:8u151-jre

WORKDIR /app

COPY --from=workspace /root/project/app/build/libs/app.jar app.jar
COPY --from=workspace /root/project/plugins/*/build/libs/*.jar plugins/

ENV JAVA_OPTS=""
ENV JAVA_MEMORY_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:+UseG1GC"

CMD ["sh", "-c", "java $JAVA_OPTS $JAVA_MEMORY_OPTS -jar /app.jar"]
