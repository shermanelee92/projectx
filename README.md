# Project X WIP
Sorry it's still quite manual, will find a way to script it

# Setup
1. Download <a href="https://www.apache.org/dyn/closer.lua/spark/spark-2.4.4/spark-2.4.4-bin-hadoop2.7.tgz">Spark</a>
2. Download binary version of <a href="https://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-3.1.2/hadoop-3.1.2.tar.gz">Hadoop</a>
3. Create 3 folders 'prog-files-1', 'prog-files-2', 'prog-files'
4. Extract Spark in to prog-files folder


# Hadoop Setup
1. Extract Hadoop file first
2. Set core-site.xml
    ```
    <configuration>
        <property>
            <name>fs.defaultFS</name>
            <value>hdfs://hadoop-slave1:9000</value>
        </property>
    </configuration>
3. Add this to hadoop-env.sh
    ```
    export JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64
4. Set hdfs-site.xml
    ```
    <configuration>
        <property>
            <name>dfs.replication</name>
            <value>3</value>
        </property>
        <property>
            <name>dfs.namenode.name.dir</name>
            <value>/usr/local/hadoop/dfs/name</value>
        </property>
        <property>
            <name>dfs.datanode.data.dir</name>
            <value>/usr/local/hadoop/dfs/data</value>
        </property>
        <property>
            <name>dfs.namenode.secondary.http-address</name>
            <value>localhost:9001</value>
        </property>
        <property>
            <name>dfs.webhdfs.enabled</name>
            <value>true</value>
        </property>
    </configuration>
5. Set mapred-site.xml
    ```
    <configuration>
        <property>
            <name>mapreduce.framework.name</name>
            <value>yarn</value>
        </property>
    </configuration>
6. Set workers file
    ```
    hadoop-slave1
    hadoop-slave2
7. Add these to yarn-env.sh
   ```
   export YARN_RESOURCEMANAGER_OPTS="--add-modules=ALL-SYSTEM"
   export YARN_NODEMANAGER_OPTS="--add-modules=ALL-SYSTEM"
8. Add this to yarn-site.xml
    ```
    <configuration>
        <property>
            <name>yarn.nodemanager.aux-services</name>
            <value>mapreduce_shuffle</value>
        </property>
        <property>
          <name>yarn.resourcemanager.hostname</name>
          <value>hadoop-master</value>
      </property>
      <property>
        <name>yarn.resourcemanager.scheduler.class</name>
        <value>org.apache.hadoop.yarn.server.resourcemanager.scheduler.fair.FairScheduler</value>
      </property>
    </configuration>
9. Copy hadoop into 'prog-files-1', 'prog-files-2', 'prog-files'

# Setting up containers
    docker-compose up
    ./run.sh
Press enter all the way when running run.sh
   ```
   docker exec -it hadoop-master bash
   ssh-copy-id -i ~/.ssh/id_rsa.pub root@hadoop-slave1
   ssh-copy-id -i ~/.ssh/id_rsa.pub root@hadoop-slave2
   hadoop/sbin/start-all.sh
   ```
Go to localhost:8088, you should see 2 active nodes

In the bash terminal for hadoop-master, run  
   ```
   ./spark/bin/spark-submit --class org.apache.spark.examples.SparkPi \
       --master yarn \
       --deploy-mode cluster \
       --driver-memory 4g \
       --executor-memory 2g \
       --executor-cores 1 \
       examples/jars/spark-examples*.jar \
       10
   ```
You will be able to see it running on localhost:8088
