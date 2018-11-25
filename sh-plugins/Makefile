.PHONY: bin clean

bin: git_prompt
	mkdir -p bin
	for i in $^; do \
		echo "=== Building $$i ==="; \
		pushd $$i; \
		cargo -Z unstable-options build --release --out-dir ../bin; \
		popd; \
	done

clean:
	rm -rf bin
