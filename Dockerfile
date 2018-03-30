FROM rustlang/rust:nightly
EXPOSE 8080
ENV ROCKET_ENV=stage
WORKDIR /source
COPY Cargo.toml /source
COPY Rocket.toml /source
COPY src/main.rs /source/src/
RUN cargo install
CMD ["server"]