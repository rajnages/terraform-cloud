# Use count when you need to create a fixed number of identical resources.
# Use for_each when you need to create resources from a more complex data structure, especially if each resource may have different configurations or values.

list => for_each(toset())
map => each.key,each.value=> flatten,zipmap
