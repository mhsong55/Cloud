# Linux Direct I/O 와 Buffered I/O

## Direct IO 란?

> [Linux Direct I/O 의 이해](https://onecellboy.tistory.com/185)

    OS buffer (File system buffer)를 거치지 않고 (Bypass), 직접 I/O를 수행하는 것

<-> 일반적인 I/O = Buffered I/O

※ 기본적으로 I/O는 성능 향상을 위해 OS level에서 buffered I/O로 진행된다.