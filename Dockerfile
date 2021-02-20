FROM jupyter/datascience-notebook:lab-3.0.5 

USER root

# aptでインストール
RUN sed -i.bak -e "s/http:\/\/archive\.ubuntu\.com/http:\/\/jp\.archive\.ubuntu\.com/g" /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
    gosu \
    less \
    build-essential \
    curl \
    file \
    git \
    vim \
    language-pack-ja-base \
    language-pack-ja \
    tree \
&& apt-get clean \
&& rm -rf \
        /var/lib/apt/lists/* \
        /var/cache/apt/* \
        /usr/local/src/*

# install python library（必要にあわせてrequirements.txtに記載を）
COPY requirements.txt .
RUN pip3 install --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt \
    && rm -rf ~/.cache/pip


# デフォルトでインストールしておくpipライブラリ
RUN pip install --upgrade ipython beautifulsoup4 lxml html5lib seaborn jupytext ptvsd jupyterlab 
RUN pip install xonsh gnureadline xontrib-powerline2 xontrib-z xontrib-back2dir


# TA-LIBとpipiのインストール

RUN wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz && \
  tar -xvzf ta-lib-0.4.0-src.tar.gz && \
  cd ta-lib/ && \
  ./configure --prefix=/usr && \
  make && \
  make install
RUN pip install TA-Lib
RUN rm -R ta-lib ta-lib-0.4.0-src.tar.gz


# デフォルトのユーザー jovyan のホームディレクトリに note用のフォルダnotebooksを作成
# 無くてもいいが、作った。
# RUN chown jovyan:users -R /home/jovyan

RUN mkdir /home/jovyan/notebooks
RUN chown jovyan:users /home/jovyan/notebooks

#Docker 開始時のshell script設定
#今回は、シェルスクリプトでUIDとGIDを設定（ローカルに合わせる）
#docker-entrypoint.sh　を参照
COPY docker-entrypoint.sh /tmp
RUN chmod +x /tmp/docker-entrypoint.sh
ENTRYPOINT ["/tmp/docker-entrypoint.sh"]
CMD [ "/sbin/init" ]


# jovyan にpwを「hirake」に設定。またsudo pwなしを設定。
# すでに jovyan ユーザーは存在しているので、
# RUN useradd -m jovyan
RUN gpasswd -a jovyan sudo
RUN echo "jovyan:hirake" | chpasswd
RUN echo "jovyan ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

#USER jovyan
#WORKDIR /home/jovyan