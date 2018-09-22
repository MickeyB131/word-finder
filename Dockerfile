FROM perl:5.28
COPY wordfinder.pl /opt
COPY words /usr/share/dict/
RUN cpanm Dancer File::Slurp
EXPOSE 3000
WORKDIR /opt

CMD ["perl", "/opt/wordfinder.pl" ]
