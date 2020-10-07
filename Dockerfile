FROM amazon/aws-sam-cli-build-image-python3.8 as fonts

WORKDIR /usr/src/build

COPY fonts .

RUN ./layer_builder.sh

FROM amazon/aws-sam-cli-build-image-python3.8

RUN yum install -y gdk-pixbuf2

WORKDIR /usr/src/build

COPY weasyprint .

RUN ./extract_lib.sh

RUN ls -l

RUN ./configure.sh

RUN ./build_layer.sh

RUN mv -f ./layer.zip ./weasyprint-no-fonts-layer.zip

COPY --from=fonts /usr/src/build/layer.zip ./fonts-layer.zip

RUN rm -rf ./opt && mkdir opt \
	    && unzip fonts-layer.zip -d opt \
	    && unzip weasyprint-no-fonts-layer.zip -d opt \
	    && cd opt && zip -r9 weasyprint-layer.zip . \
        && cp weasyprint-layer.zip /usr/src/build

WORKDIR /usr/src/app

CMD [ "tail", "-f", "/dev/null" ]