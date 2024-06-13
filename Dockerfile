FROM adoptopenjdk/openjdk11
MAINTAINER huangjie huangjielg@gmail.com

# Install Python and Jupyter Notebook/Labs
RUN apt-get update && apt-get install -y python3-pip
RUN pip3 install --no-cache-dir notebook


# Setup user environment
ENV NB_USER rapid
ENV NB_UID 1000
ENV HOME /home/$NB_USER

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid $NB_UID \
    $NB_USER

COPY . $HOME
RUN chown -R $NB_UID $HOME

USER $NB_USER

RUN pip3 install rapidwright

# Launch the notebook server
WORKDIR $HOME

# Bootstrap RapidWright files
RUN python3 -c "import rapidwright; from com.xilinx.rapidwright.examples import Lesson1; Lesson1.main([])"
RUN python3 -c "import rapidwright; from com.xilinx.rapidwright.util import FileTools;FileTools.ensureDataFilesAreStaticInstallFriendly(\"xc7a35t\", \"xc7k70t\", \"xc7k160t\", \"xc7k325t\")

CMD ["jupyter", "notebook", "--ip", "0.0.0.0", "--no-browser"]
