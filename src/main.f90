! *******************************************************************
! Funcionamiento interno usando formato "tipo C" (desde 0). Sin 
! embargo, todos los datos de entrada y salida se encuentran en 
! formato "Fortran" (desde 1). Esto debido a problemas con FMetis 
! para dejar particiones contiguas, usando formato Fortran.
! *******************************************************************
! 
Program Main
! 
Use metis_interface, Only: idx_t
Implicit none 
! 
! *******************************************************************
! 
! Integer(idx_t), parameter :: d = 2        ! Dimensionality of the grid      ! Simplest case.
! Integer(idx_t), parameter :: ne = 25      ! number of elements
! Integer(idx_t), parameter :: nn = 36      ! number of nodes
! Integer(idx_t), parameter :: npel = 4     ! nodes per element
! Integer(idx_t), parameter :: np = 3       ! number of partitions
!
Integer(idx_t), parameter :: d = 2        ! Dimensionality of the grid           ! "Salgas" case.
Integer(idx_t), parameter :: ne = 31362   ! number of elements
Integer(idx_t), parameter :: nn = 16845   ! number of nodes    
Integer(idx_t), parameter :: npel = 3     ! nodes per element
Integer(idx_t), parameter :: np = 4       ! number of partitions
!
! Integer(idx_t), parameter :: d = 2        ! Dimensionality of the grid      ! terz_gri case.
! Integer(idx_t), parameter :: ne = 402     ! number of elements
! Integer(idx_t), parameter :: nn = 230     ! number of nodes
! Integer(idx_t), parameter :: npel = 3     ! nodes per element
! Integer(idx_t), parameter :: np = 2       ! number of partitions
!
! Integer(idx_t), parameter :: d = 2        ! Dimensionality of the grid      ! terz_gri case.
! Integer(idx_t), parameter :: ne = 106     ! number of elements
! Integer(idx_t), parameter :: nn = 68      ! number of nodes
! Integer(idx_t), parameter :: npel = 3     ! nodes per element
! Integer(idx_t), parameter :: np = 2       ! number of partitions
!
! *******************************************************************
! 
Integer(idx_t) :: eptr(ne+1)
Integer(idx_t) :: eind(ne*npel)
Integer(idx_t) :: epart(ne)
Real(16) :: InfNodes(1:nn,1:d+1)
Integer :: InfEle(1:ne,1:npel+3)
! 
Real(8) t1,t2
! 
Call cpu_time(t1)    
! 
!*******************************************
! 
Call Imp_Data(ne,nn,npel,d,eind,eptr,InfNodes,InfEle)
! 
Call Partition_Mesh(ne,nn,npel,np,eind,eptr,epart)
! 
Call New_Mesh(ne,nn,npel,d,np,eind,epart,InfNodes,InfEle)
! 
!*******************************************
!  
Call cpu_time(t2)
! 
write(*,*) ' '
write(*,*) 'time=',t2-t1,'seconds'  ! Writes the time used by this program.
write(*,*) ' '
! 
!*******************************************
! 
End
