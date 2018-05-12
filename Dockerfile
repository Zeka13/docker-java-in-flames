FROM openjdk:9
RUN git clone https://github.com/jvm-profiling-tools/perf-map-agent.git
RUN apt update
RUN apt install build-essential cmake -y
RUN sed -i 's/#message/message/g' ./perf-map-agent/CMakeLists.txt
RUN cat ./perf-map-agent/CMakeLists.txt
RUN cd perf-map-agent && cmake --debug-output . && make
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN javac RandomImage.java
CMD ["java", "-XX:+PreserveFramePointer" ,"RandomImage"]
