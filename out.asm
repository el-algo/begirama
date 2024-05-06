section .text
	global _start
	extern out
	extern in
	extern say
	extern exit

_start:
	call in
	push rbx
	call out
	call exit
