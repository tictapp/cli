FROM denoland/deno:1.31.2

# The port that your application listens to.
#EXPOSE 1993

# COPY ./_entry.sh /usr/local/bin/docker-entrypoint.sh
# RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

WORKDIR /app

# Prefer not to run as root.
USER deno

# Cache the dependencies as a layer (the following two steps are re-run only when deps.ts is modified).
# Ideally cache deps.ts will download and compile _all_ external files used in main.ts.
COPY deps.js .
RUN deno cache deps.js

# These steps will be re-run upon each file change in your working directory:
COPY . .
# Compile the main app so that it doesn't need to be compiled each startup/entry.
RUN deno cache tt.js
#RUN deno install --allow-all --no-check -r -f https://deno.land/x/tictapp/tt.js

# COPY ./_entry.sh /usr/local/bin/docker-entrypoint.sh
# RUN chmod 755 /usr/local/bin/docker-entrypoint.sh

#RUN chmod 755 ./_entry.sh

ENTRYPOINT ["./_entry.sh"]

CMD ["--help"]

# docker build -t tt . && docker run -it tt