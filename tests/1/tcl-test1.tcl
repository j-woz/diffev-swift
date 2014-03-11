
package require test 0.0
package require turbine 0.0

set a_ptr [ blobutils_cast_to_int_ptr [ blobutils_malloc [blobutils_sizeof_int]   ] ]
set b_ptr [ blobutils_cast_to_dbl_ptr [ blobutils_malloc [blobutils_sizeof_float] ] ]
set c_ptr [ blobutils_cast_to_dbl_ptr [ blobutils_malloc [blobutils_sizeof_float] ] ]

FortFuncs_setup $a_ptr $b_ptr $c_ptr

set a [ blobutils_get_int   $a_ptr 0 ]
set b [ blobutils_get_float $b_ptr 0 ]
set c [ blobutils_get_float $c_ptr 0 ]

puts "a: $a"
puts "b: $b"
puts "c: $c"

