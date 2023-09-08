# * https://jtway.co/dockerfile-for-a-crystal-application-1e9db24efbc2

# Build image
FROM crystallang/crystal:1-alpine as builder

WORKDIR /app

# Cache dependencies
COPY . .
RUN \
	shards install --production -v && \
	shards build --static --no-debug --release --production -v && \
	strip ./bin/bootstrap

# ===============
# Result image with one layer
FROM alpine:latest

WORKDIR /

COPY --from=builder /app/bin/bootstrap .

CMD ["/bootstrap"]
