# libsodium

---

https://download.libsodium.org/libsodium/content/

---

# generic hashing

+ BLAKE2b

+ computes a fixed-length fingerprint for an arbitrary long message

+ File integrity checking
+ Creating unique identifiers to index arbitrary long data

---

# short-input hashing

+ SipHash-2-4

+ optimized for short inputs
+ 64 bits output

+ Hash tables
+ Probabilistic data structures such as Bloom filters
+ Integrity checking in interactive protocols

---

# password hashing

+ CPU intensive and intentionally requires a fair amount of memory

+ Argon2
+ Scrypt

+ Password storage
+ Deriving a secret key from a password

---

# Diffie-Hellman function (key exchange)

+ X25519 (ECDH over Curve25519)

---

# One-time authentication

+ Poly1305

+ for online protocols, exchanging many small messages,
	rather than for authenticating very large files
+ not a replacement for a hash function

---

# Generating random data

+ RtlGenRandom / window
+ arc4random / openbsd
+ getrandom / linux
+ /dev/urandom / others

---

# public-key authenticated encryption

+ Key exchange: X25519
+ Encryption: XSalsa20 stream cipher
+ Authentication: Poly1305 MAC

+ B encrypt message using A's public-key
+ A verify message using B's public-key, decrypt message using A's secret-key

# public-key signatures

+ Signature: Ed25519

+ use secret key, append signature to messages
+ use public key, verify signature is issued by creator of public key

+ different from authenticated encryption. Appending a signature
	does not change the representation of the message itself.

# Sealed boxes

+ X25519, XSalsa20-Poly1305

+ send messages, anonymously
+ encrypt by recipient's public key
+ recipient can verify the integrity of the message
+ recipient cannot verify the identity of the sender

---

# secret-key authenticated encryption

+ Encryption: XSalsa20 stream cipher
+ Authentication: Poly1305 MAC

+ Encrypts a message
+ Computes an authentication tag

+ key is used both to encrypt/sign and verify/decrypt messages
+ it is critical to keep the key confidential

# secret-key authentication

+ HMAC-SHA512256

+ computes an authentication tag for a message and a secret key
+ verify that a given tag is valid for a given message and a key
+ the same (message, key) tuple will always produce the same output

+ not encrypt, only authentication

---

# AEAD (Authenticated Encryption with Additional Data)

+ Encrypts a message
+ Computes an authentication tag

+ Decryption will never be performed, even partially, before verification

## AES256-GCM

+ AES256-GCM is the fastest option (with hardware-accelerated)

## ChaCha20-Poly1305

+ Encryption: ChaCha20 stream cipher
+ Authentication: Poly1305 MAC

+ ChaCha20 is considerably faster than AES in software-only implementations
