#CC       ?= arm-linux-gnueabi-gcc
CC       ?= gcc

OPTFLAGS ?= -O3 -g

CFLAGS   += $(OPTFLAGS) \
            -std=gnu99 \
            -W \
            -Wextra \
            -Wimplicit-function-declaration \
            -Wredundant-decls \
            -Wstrict-prototypes \
            -Wundef \
            -Wshadow \
            -Wpointer-arith \
            -Wformat \
            -Wreturn-type \
            -Wsign-compare \
            -Wmultichar \
            -Wformat-nonliteral \
            -Winit-self \
            -Wuninitialized \
            -Wformat-security \
            -Werror

VALGRIND ?= 1

CFLAGS += -I.
CFLAGS += -DVALGRIND=$(VALGRIND)
CFLAGS += -DUSE_ETHEREUM=0
CFLAGS += -DUSE_GRAPHENE=1
CFLAGS += -DUSE_KECCAK=1
CFLAGS += -DUSE_MONERO=0
CFLAGS += -DUSE_NEM=1
CFLAGS += -DUSE_CARDANO=1
CFLAGS += $(shell pkg-config --cflags openssl)

# disable certain optimizations and features when small footprint is required
ifdef SMALL
CFLAGS += -DUSE_PRECOMPUTED_CP=0
endif

SRCS   = bignum.c ecdsa.c curves.c secp256k1.c nist256p1.c rand.c hmac.c bip32.c bip39.c bip32_bip39.c pbkdf2.c base58.c base32.c
SRCS  += address.c
SRCS  += script.c
SRCS  += ripemd160.c
SRCS  += sha2.c
SRCS  += sha3.c
SRCS  += hasher.c
SRCS  += aes/aescrypt.c aes/aeskey.c aes/aestab.c aes/aes_modes.c
SRCS  += ed25519-donna/curve25519-donna-32bit.c ed25519-donna/curve25519-donna-helpers.c ed25519-donna/modm-donna-32bit.c
SRCS  += ed25519-donna/ed25519-donna-basepoint-table.c ed25519-donna/ed25519-donna-32bit-tables.c ed25519-donna/ed25519-donna-impl-base.c
SRCS  += ed25519-donna/ed25519.c ed25519-donna/curve25519-donna-scalarmult-base.c ed25519-donna/ed25519-sha3.c ed25519-donna/ed25519-keccak.c
SRCS  += blake256.c
SRCS  += blake2b.c blake2s.c
SRCS  += groestl.c
SRCS  += nem.c
SRCS  += memzero.c
SRCS  += hexutils.c
SRCS  += main.c


all: coinaddress

%.o: %.c %.h options.h
	$(CC) $(CFLAGS) -o $@ -c $<

coinaddress: $(SRCS)
	$(CC) $(CFLAGS) -o $@ $^


clean:
	rm -f *.o aes/*.o ed25519-donna/*.o coinaddress
