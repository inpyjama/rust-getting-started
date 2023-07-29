# rust-getting-started
A very bare minimum rust startup and linker

# Debugging
The codebase contains a preconfigured launch.json that can be used to attach to the gdb session

To launch gdb session use the command

```
qemu-system-arm -cpu cortex-m3 -machine lm3s6965evb -nographic -semihosting-config enable=on,target=native -gdb tcp::3333 -S -kernel ./target/thumbv7em-none-eabihf/debug/myrustyprogram
```