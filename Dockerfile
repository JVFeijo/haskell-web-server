FROM haskell:9.2.8

WORKDIR /app

RUN cabal update

COPY ./app.cabal /app

RUN cabal build --only-dependencies -j4

COPY . /app

RUN cabal install

EXPOSE 8080

CMD ["cabal", "run"]