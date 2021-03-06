PROGRAM main

INTERFACE
   SUBROUTINE BVLS (A, B, BND, X, RNORM, NSETP, W, INDEX, IERR)
    REAL(KIND(1D0)) A(:,:), B(:), BND(:,:), X(:), RNORM, W(:)
    INTEGER NSETP, INDEX(:), IERR
   END SUBROUTINE
END INTERFACE

logical :: debug = .FALSE., verif = .true., zer=.false.
integer, parameter :: width = 401
integer, parameter :: height = 142388

!raw -> 74 x 141970 
real(kind=8), dimension(:),allocatable :: tmp

real(kind=8) :: CHI2, check, abserr, errmax = 0.000000000001, fact = 1
real :: minn = 10e-3
integer :: NSETP
real(kind=8), dimension(:,:),allocatable :: BND
real(kind=8), dimension(:,:),allocatable :: A
real(kind=8), dimension(:),allocatable :: B
real(kind=8), dimension(:),allocatable :: W, X
integer, dimension(:),allocatable :: INDEX
integer :: err, start, stop, repeats = 1,h, tot=0, change = 0, toto = 0


allocate(A(height, width))
allocate(BND(2,width))
allocate(B(height))
allocate(W(width))
allocate(X(width))
allocate(INDEX(height))
allocate(tmp(width))

BIGLOOP : do h=1, repeats

open(1, file='../../transfert/cas_complet/040520/BND.out', status='old', action='read')

  do i = 1, width
    read (1, *) BND(1,i), BND(2,i)
  end do

close(1)

if (debug) then
  do i = 1, width
    print *, BND(1,i), BND(2,i)
    exit
  end do
end if

open(2, file='../../transfert/cas_complet/040520/RAW.out.412', status='old', iostat=err, action='read')
if (err > 0) then
  print *, "an error has occur trying to oen RAW", err
end if

if (debug) then
  print *, err
end if

do i=1,height
  
    read(2, *, iostat=err) tmp(:)

    !print *, size(tmp)
    B(i) = tmp(3)

    !do k = 1,width
    !  A(k,i) = tmp(k+3,i)
    !end do

    A(i,:) = tmp(4:size(tmp))
    
    if (debug) then
      print *, "step : ", i
      print *, tmp
    end if
end do
close(2)

if(zer) then
  !i = 63, width
  do i=1, width
    !j = 69346, height
    do j=1, height
    toto = toto + 1
      if (abs(A(j, i)) < minn) then
        A(j, i) = 0
        change = change + 1
      endif
    end do
  end do
end if
!print *, "true value of B(1) : 0.39322173244225497868E+01"
!print *, "B first value in initialisation and A(1,1)", B(1), A(1,1)

!print *, A(1,1), A(1,2), A(1,3)
!do i=1,width
!  X(i) = 424242
!end do

!lire les fichiers RAW et BND pour pouvoir lancer la suite
if (.true.) then
  print *, "size of B X BND1 BND2 W INDEX A1 A2:"
  print *, size(B), size(x), size(BND,1), SIZE(BND,2), size(W), size(INDEX), "M",size(A,1), "N",size(A,2)
endif

A(1:height,1:width) = A(1:height, 1:width) * fact
B(1:height) = B(1:height) * fact
!BND(1:2,1:width) = BND(1:2,1:width) * fact

!print *, "values in run : ", B(2), A(2,2)

call system_clock(start)

  call bvls(A, B, BND, X, CHI2, NSETP, W, INDEX, IEER) 

call system_clock(stop)
tot = tot+(stop-start)

if (IEER /= 0) then
  print *, "IEER value : ", IEER, " if different than 0 --> problem"
endif
if (debug) then
  do i=1,width
    print *, X(i)
  end do
end if

if(debug) then
  print *, "B vector : "
  do i=1,width
    print *,"this is B : ", BND(1,i), BND(2,i)
    print *, "this is A : ",A(i,:)
  end do
end if 


!open(3, file='RAW_20.out', status='old', action='read', iostat=err)
!if (err > 0) then
!  print *, "error openning RAW_20"
!end if
!
!if (verif) then
!  print *, "true value --- calculated value --- difference"
!  do i=1,75
!      read(3,*) check
!      if (i /= 1) then
!        abserr = max(check, X(i-1))/min(check, X(i-1))
!        print*, check * fact, X(i-1), abserr
!        if (abserr > errmax) then
!          errmax = abserr
!        endif
!      else
!        print*, "valeur chi2 :", check, CHI2/141970, (CHI2/141970)-check
!      end if
!  end do
!print *, "err max is : ", errmax
!print *, "elapsed time in tick : ", (stop-start), start, stop
!end if
!close (3)

open(5, file="./output.txt", status="new")

do i = 1, width
  write(5,*) X(i)
end do
print*, "chi2", CHI2
print*, "time : ", (stop-start)
close(5)
end do BIGLOOP

!print *, tot/repeats
print *, change, "changements dans la patrice A sur ", toto, "donc ", &
real(real(change)/real(toto) * 100),"%"

END PROGRAM main
