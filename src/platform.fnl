(local platform {})

(local identifier (package.config:sub 1 1))

(fn platform.is-windows? []
  (= identifier "\\"))

(fn platform.is-unix? []
  (= identifier "/"))

platform
