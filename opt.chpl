require "cobyla2c/cobyla.h", "cobyla2c/cobyla.c", "cobyla2c/example.c";

extern proc example() : int;



writeln("========== Non-linear optimization solver =================");

writeln("========== C program output ===============================");


var x = example();


writeln("========= End of C program output =========================");
