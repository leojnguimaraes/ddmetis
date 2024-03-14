! *******************************************************************
! This subroutine separates a set of elements into a set of np 
! contiguous partitions using the Fmetis interface.
! This code is an adaptation of the examples shown in:
! https://ivan-pi.github.io/fmetis/sourcefile/metis_interface.f90.html
! *******************************************************************
! 
Subroutine Partition_Mesh(ne,nn,npel,np,eind,eptr,epart)
! 
use, intrinsic :: iso_c_binding, only: c_ptr, c_f_pointer
use metis_interface, only: idx_t, METIS_SetDefaultOptions, METIS_PartMeshNodal, &
    METIS_MeshToNodal, METIS_Free, METIS_NOPTIONS, METIS_OK, &
    METIS_OPTION_NUMBERING, METIS_OPTION_CONTIG,METIS_OBJTYPE_CUT
implicit none    
! 
Integer ne,nn,npel,np
!
! *******************************************************************
! 
Integer(idx_t) :: eptr(ne+1)
Integer(idx_t) :: eind(ne*npel)
Integer(idx_t) :: epart(ne), npart(nn)
Integer(idx_t) :: options(0:METIS_NOPTIONS-1)
Integer(idx_t) :: ios, objval, nparts
!         
Integer :: i,j
! 
Open (10,file='epart_array.out')                 
! 
! *******************************************************************
!             
ios = METIS_SetDefaultOptions(options)
if (ios /= METIS_OK) then
    write(*,*) "METIS_SetDefaultOptions failed with error: ", ios
    error stop 1
end if
options(METIS_OPTION_NUMBERING) = 0     ! C-style numbering
options(METIS_OPTION_CONTIG) = 1        ! Force contigous partitions   
! 
ios = METIS_PartMeshNodal(ne,nn,eptr,eind,nparts=np,options=options,&
    objval=objval,epart=epart,npart=npart)
if (ios /= METIS_OK) then
    write(*,*) "METIS_PartMeshNodal failed with error: ", ios
    error stop 1
end if
! 
! *******************************************************************
! 
Do i=1,ne
    epart(i)=epart(i)+1
Enddo
!
! *******************************************************************
! 
write(10,20)epart
! 
! *******************************************************************
! 
20 Format ((I5))
! 
Return
End Subroutine
