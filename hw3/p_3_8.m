tab1 = [1. -1. 1. 0. 2. ;
           1. 1. 0. 1. 6.  ;
           1. -1. 0. 0. 0. ]

tab1 =

     1    -1     1     0     2
     1     1     0     1     6
     1    -1     0     0     0

tab1(1,:) = tab1(1,:) + tab1(2,:)

tab1 =

     2     0     1     1     8
     1     1     0     1     6
     1    -1     0     0     0

tab1(3,:) = tab1(3,:) + tab1(2,:)

tab1 =

     2     0     1     1     8
     1     1     0     1     6
     2     0     0     1     6

diary off
