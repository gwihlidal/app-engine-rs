FROM rustlang/rust:nightly AS builder
WORKDIR /app

ENV ROCKET_ENV=stage

# Avoid having to install/build all dependencies by copying
# the Cargo files and making a dummy src/main.rs
COPY Cargo.toml .
COPY Cargo.lock .
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release

# We need to touch our real main.rs file or
# else docker will use the cached one.
COPY src src
RUN touch src/main.rs
RUN cargo build --release

# Size optimization
RUN strip target/release/server

# Start building the final image
# Ideally would use `scratch` as a base image, but this would require
# fully static compilation by linking against musl instead of glibc
# (i.e. emk/rust-musl-builder) but it's a bit restrictive.
# This isn't a 5mb image, but 100mb is still better than 2gb ;)
FROM ubuntu
WORKDIR /app
COPY --from=builder /app/target/release/server .
COPY Rocket.toml Rocket.toml
COPY static static
COPY templates templates
EXPOSE 8080
ENV ROCKET_ENV=stage
ENTRYPOINT ["./server"]