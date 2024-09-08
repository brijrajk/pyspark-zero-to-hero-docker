# Base Python 3.12 image
FROM python:3.12

# Expose Ports
EXPOSE 8888 4040

# Change shell to /bin/bash
SHELL ["/bin/bash", "-c"]

# Install dependencies including bash-completion and direxpand
RUN apt-get update && \
    apt-get install -y \
    openjdk-17-jdk \
    ca-certificates-java \
    nano \
    vim \
    wget \
    git \
    git-lfs \
    bash-completion \
    && apt-get clean \
    && update-ca-certificates -f \
    && git lfs install

# Install direxpand
RUN apt-get install -y direnv

# Setup JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/

# Download and setup Spark
WORKDIR /tmp
RUN wget https://archive.apache.org/dist/spark/spark-3.5.1/spark-3.5.1-bin-hadoop3.tgz && \
    tar -xvf spark-3.5.1-bin-hadoop3.tgz && \
    mv spark-3.5.1-bin-hadoop3 /spark && \
    rm spark-3.5.1-bin-hadoop3.tgz

# Set environment variables
ENV SPARK_HOME=/spark
RUN export SPARK_HOME
ENV PYSPARK_PYTHON=/usr/local/bin/python
RUN export PYSPARK_PYTHON
ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.9.5-src.zip
RUN export PYTHONPATH
ENV PATH=$PATH:$SPARK_HOME/bin
RUN export PATH

# Fix Spark configuration files
RUN mv $SPARK_HOME/conf/log4j2.properties.template $SPARK_HOME/conf/log4j2.properties && \
    mv $SPARK_HOME/conf/spark-defaults.conf.template $SPARK_HOME/conf/spark-defaults.conf && \
    mv $SPARK_HOME/conf/spark-env.sh.template $SPARK_HOME/conf/spark-env.sh

# Install Python packages
RUN pip install jupyterlab pyspark==3.5.1 kafka-python==2.0.2 delta-spark==3.2.0 boto3

# Clone git repositories
WORKDIR /home/jupyter
RUN git clone https://github.com/subhamkharwal/ease-with-apache-spark.git && \
    git clone https://github.com/subhamkharwal/pyspark-zero-to-hero.git

# Setup datasets
WORKDIR /home/jupyter/pyspark-zero-to-hero
RUN mkdir -p /data/input/datasets && \
    cp -r datasets /data/input/

WORKDIR /home/jupyter/

# Fix Jupyter logging issue
RUN ipython profile create && \
    echo "c.IPKernelApp.capture_fd_output = False" >> "/root/.ipython/profile_default/ipython_kernel_config.py"

# Configure bash for command history and direxpand
RUN echo 'export DIREXPAND_MODE=auto' >> /root/.bashrc && \
    echo 'source /usr/share/bash-completion/bash_completion' >> /root/.bashrc && \
    echo 'eval "$(direnv hook bash)"' >> /root/.bashrc && \
    echo 'export HISTCONTROL=ignoredups:erasedups' >> /root/.bashrc && \
    echo 'export HISTSIZE=10000' >> /root/.bashrc && \
    echo 'export HISTFILESIZE=20000' >> /root/.bashrc && \
    echo 'shopt -s histappend' >> /root/.bashrc && \
    echo 'PROMPT_COMMAND="history -a"' >> /root/.bashrc

# Start Jupyter Lab
CMD ["python3", "-m", "jupyterlab", "--ip", "0.0.0.0", "--allow-root"]
