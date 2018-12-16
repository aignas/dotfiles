.PHONY: bin clean

plugins:=git_prompt

bin:
	mkdir -p bin
	for i in $(plugins); do \
		echo "=== Building $$i ==="; \
		pushd $$i; \
		cargo -Z unstable-options build --release --out-dir ../bin; \
		popd; \
	done

clean:
	rm -rf bin
