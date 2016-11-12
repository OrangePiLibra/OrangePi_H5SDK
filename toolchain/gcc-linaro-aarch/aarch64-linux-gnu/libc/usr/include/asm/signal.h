/*
 * Copyright (C) 2012 ARM Ltd.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#ifndef __ASM_SIGNAL_H
#define __ASM_SIGNAL_H

#include <asm/posix_types.h>

/* Required for AArch32 compatibility. */
#define SA_RESTORER	0x04000000

/*
 * Since sigset is a bitmask, we need the same size fields for ILP32
 * and LP64.  With big-endian, 32bit bitmask does not match up to
 * 64bit bitmask (unlike with little-endian).
 */
#ifdef __ILP32__

#define __SIGSET_INNER_TYPE __kernel_ulong_t
#define _NSIG_BPW 64

# ifdef __AARCH64EB__
#  define __SIGNAL_INNER(type, field)		\
		int __pad_##field;		\
		type field;
# else
#  define __SIGNAL_INNER(type, field)		\
		type field;			\
		int __pad_##field;
# endif

# define __SIGACTION_HANDLER(field)		\
	__SIGNAL_INNER(__sighandler_t, field)


#define __SIGACTION_FLAGS(field)		\
	__kernel_ulong_t field

#define __SIGACTION_RESTORER(field)		\
	__SIGNAL_INNER(__sigrestore_t, field)

#endif

#include <asm-generic/signal.h>

#endif
