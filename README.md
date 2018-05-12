
# docker-java-in-flames

**Host installation (Ubuntu):**
sudo apt-get install linux-tools-common linux-tools-generic linux-tools-`uname -r` -y
sudo curl https://raw.githubusercontent.com/brendangregg/FlameGraph/master/stackcollapse-perf.pl -o /usr/local/bin/stackcollapse-perf.pl
sudo curl https://raw.githubusercontent.com/brendangregg/FlameGraph/master/flamegraph.pl -o /usr/local/bin/flamegraph.pl

**Collectian perf-data (On Host):**
sudo perf record -F 99 -a -g -- sleep 10

**Run dockerized Java app:**
docker-compose up -d

**Collect perf-map inside container:**
docker-compose exec java-app bash
cd /perf-map-agent/out/ && java -cp attach-main.jar:$JAVA_HOME/lib/tools.jar net.virtualvoid.perf.AttachOnce $(pidof java)
cp /tmp/perf-$(pidof java).map /tmp/perf-map/
exit

**Draw Flame Graph on Host:**
sudo mv perf-map/perf-*.map /tmp/perf-$(pidof java).map 
sudo perf script | stackcollapse-perf.pl | flamegraph.pl --color=java --hash > flamegraph.svg
