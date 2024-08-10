.PHONY: all sums

all:

sums:
	rm docs/SHA256SUMS.txt || true
	cd docs && find . -maxdepth 1 -type f  -exec sha256sum -b {} \; \
		> SHA256SUMS.txt
	sed -i '/SHA256SUMS.txt/d' docs/SHA256SUMS.txt
