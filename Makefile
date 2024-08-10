.PHONY: all sums

all: sums copy-pubkey
sums: compute-sums sign-sums verify-sums

compute-sums:
	rm docs/SHA256SUMS.txt || true
	cd docs && find . -maxdepth 1 -type f  -exec sha256sum -b {} \; \
		> SHA256SUMS.txt
	sed -i '/SHA256SUMS.txt/d' docs/SHA256SUMS.txt

sign-sums:
	openssl pkeyutl -sign -inkey privkey.pem \
		-out docs/SHA256SUMS.txt.sig \
		-rawin -in docs/SHA256SUMS.txt

verify-sums:
	openssl pkeyutl -verify -pubin -inkey pubkey.pem \
		-rawin -in docs/SHA256SUMS.txt -sigfile docs/SHA256SUMS.txt.sig

copy-pubkey:
	cp pubkey.pem docs

# only for documentation how keys were generated
gen-keys: copy-pubkey
	if [-f privkey.pem]; then $(error Existing keys would be overwritten); fi
	openssl genpkey -algorithm Ed25519 -out privkey.pem
	openssl pkey -in privkey.pem -pubout -out pubkey.pem
