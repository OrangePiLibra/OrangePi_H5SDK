#ifndef __ASM_POSIX_TYPES_H
#define __ASM_POSIX_TYPES_H

typedef unsigned short __kernel_old_uid_t;
typedef unsigned short __kernel_old_gid_t;
#define __kernel_old_uid_t __kernel_old_uid_t

#ifdef __ILP32__
typedef long long __kernel_long_t;
typedef unsigned long long __kernel_ulong_t;
#define __kernel_long_t __kernel_long_t
#endif

#include <asm-generic/posix_types.h>

#endif /* __ASM_POSIX_TYPES_H */
