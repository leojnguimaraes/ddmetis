!  *******************************************************************
! This subroutine imports the information about the nodes pertaining
! to the i-th element from an input file, and produces the arrays 
! "eind" and "eptr", necessary for FMetis to generate the partitions.
! In addition, it generates two arrays: InfNodes and InfEle, containing
! relevant information about nodes and elements, respectively.
! 
! ne = Number of elements.
! nn = Number of nodes.
! npel = Number of nodes per element.
! d = physical dimensionality of the grid.
! 
!  *******************************************************************
! 
Subroutine Imp_Data(ne,nn,npel,d,eind,eptr,InfNodes,InfEle)
! 
Use metis_interface, only: idx_t
Implicit None
! 
Integer ne,nn,npel,d
Integer :: i,j
! 
Integer(idx_t), parameter :: dan = 2                            ! Aditional node information stored in "dan" columns.
Integer(idx_t), parameter :: den = 0                            ! Aditional element information stored in "den" columns (different from type and material).
! 
Integer(idx_t) :: eind(ne*npel)
Integer(idx_t) :: eptr(ne+1)
Real(16) :: InfNodes(1:nn,1:d+dan+1)                            ! Node label + cartesian coordinates + "da" aditional node information.
Integer :: InfEle(1:ne,1:npel+3+den)                            ! Element label + type + material + component nodes.
! 
! Open (10,file='Input_Data_Simple.dat',status='old')             ! Data from the simplest case.
! 
Open (10,file='Input_Data_Salgas.dat', status='old')            ! Data from "Salgas" case.
! 
! Open (10,file='terz_gri_2.dat', status='old')                     ! Data from "Terz_gri" case.
! 
! *******************************************************************
! 
Read (10,*)                                                     ! Skip first line, with metadata (usually 0 ... 0).
! 
!*******************************************
! 
Do i=1,nn
    Read(10,20)(InfNodes(i,j),j=1,d+1+dan)                  ! Information about nodes stored in the array "InfNodes".
Enddo
!
Do i=1,ne
    Read(10,22)(InfEle(i,j),j=1,npel+3+den)                 ! Information about elements stored in the array "InfEle".
Enddo
! 
!*******************************************
! 
eptr(1)=0                                                   ! By default.
!     
Do i=1,ne
!     
    Do j=1,npel
        eind(npel*(i-1)+j)=InfEle(i,3+j)-1                  ! Construction of "eind" array (for Metis).
    Enddo
! 
    eptr(i+1)=npel*i                                        ! Construction of "eptr" array (for Metis).
!     
enddo
! 
!  *******************************************************************
! 
20 Format ((F5.0),10(F10.0))                                ! Format associated to the nodes.
21 Format ((F6.0),' ',3(F13.6))                             ! Auxiliary format for visualization.
22 Format (11(I5))                                          ! Format associated to the elements.
! 
Return
End Subroutine
