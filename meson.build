project('TComb', 'c',
        version: '3',
        default_options: ['c_std=c99', 'buildtype=release'],
        meson_version: '>=0.46')


warnings = [
  '-Wall',
  '-Wextra',
  '-Wshadow',
  '-Wno-unused-parameter',
]

cflags = [
  warnings,
  '-fvisibility=hidden',
]

ldflags = [
]


sources = [
  'src/tcomb.c',
]


host_cpu_family = host_machine.cpu_family()

if host_cpu_family.startswith('x86')
  cflags += ['-mfpmath=sse', '-msse2', '-DTCOMB_X86=1']
  
  sources += ['src/simd_sse2.c']
endif


host_system = host_machine.system()

if host_system == 'windows' or host_system == 'cygwin'
  if host_cpu_family == 'x86'
    cflags += '-mstackrealign'
    ldflags += '-Wl,--kill-at'
  endif
endif


cc = meson.get_compiler('c')


deps = [
  dependency('vapoursynth').partial_dependency(includes: true, compile_args: true),
]

shared_module('tcomb',
              sources,
              dependencies: deps,
              link_args: ldflags,
              c_args: cflags,
              install: true)
