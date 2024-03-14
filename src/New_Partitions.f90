! *******************************************************************
! This subroutine is employed to give a list of the nodes located
! at the "border" of the partitions and the total amount of 
! elements involved.
! 
! ne = Number of elements.
! nn = Number of nodes.
! npel = Number of nodes per element.
! np  = Number of partitions.
! 
! *******************************************************************
! 
Subroutine New_Mesh(ne,nn,npel,d,np,eind,epart,InfNodes,InfEle)
! 
Use metis_interface, only: idx_t
Implicit None
! 
Integer(idx_t) :: ne,nn,npel,np
Integer(idx_t) :: i,j,k,l,ia,ja,ka,la,d
! 
Integer(idx_t) :: eind(ne*npel)
Integer(idx_t) :: epart(ne)
Integer(idx_t) :: N(np,nn)
Integer(idx_t) :: Q(np,ne)
Integer(idx_t) :: N2(np,nn)
Integer(idx_t) :: Nnp(np)                   ! Number of nodes per partition.
Integer(idx_t) :: Nep(np)                   ! Number of elements per partition.
! 
Real(16) :: InfNodes(1:nn,1:d+1)
Integer(idx_t) :: InfEle(1:ne,1:npel+3)
! 
Open (11,file='coords.out')                 ! Data new coordinates.
Open (12,file='nconnect.out')               ! Data quantity of nodal connections between different partitions.
Open (13,file='connect.out')                ! Data of nodes involved in the connections.
Open (14,file='domain.out')                 ! Data Domain.
Open (15,file='lnods.out')                  ! Data LNodes
Open (16,file='mat.out')                    ! Data Mat
Open (17,file='domain.out')                 ! Data Domain
Open (18,file='partele.out')                ! Data Partitions - Elements
! 
! *******************************************************************
! 
Do i=1,np
    Do j=1,nn
        N(i,j)=0                            ! Initialization Matrix N
    Enddo
!     
! **************************************
! 
    Do j=1,ne
        Q(i,j)=0                            ! Initialization Matrix Q
    Enddo
Enddo
! 
! *******************************************************************
! Matrix N
! *******************************************************************
! 
Do i=1,ne
    ia=epart(i)
    Do j=1,npel
        ja=eind((i-1)*npel+j)+1
        N(ia,ja)=1
    Enddo
Enddo
!
! *******************************************************************
! Matrix Q
! *******************************************************************
! 
Do i=1,ne
    Q(epart(i),i)=1
Enddo
!
! *******************************************************************
! Generation of new nodes and relabeling - Matrix N_2
! *******************************************************************
!
ja=0
Do j=1,Np
    ia=0
    Do i=1,Nn
        ja=ja+N(j,i)
        N2(j,i)=N(j,i)*ja                                       ! Matrix M_2.
        If(N2(j,i).gt.0)then
            Write(11,23)(InfNodes(i,l),l=2,d+1)                 ! New node label and associated coordinates.
            ia=ia+1
        Endif
    Enddo
    Nnp(j)=ia                                                   ! Counter for the number of nodes per partition.
!     
! **************************************
!   
    ia=0
    Do i=1,Ne
        If(Q(j,i).gt.0)then
            Write(15,22)(N2(j,InfEle(i,3+l)),l=1,npel)          ! New element label.
            Write(16,21)InfEle(i,3)                             ! New element associated material.
            Write(18,21)j                                       ! Auxiliar array for visualization.            
            ia=ia+1                                             ! Counter for the number of elements per partition.
        Endif        
    Enddo 
    Nep(j)=ia                                                   
Enddo
! 
! ******************************************************
! 
Do i=1,Nn
    ka=0
    Do j=1,np
        ka=ka+N(j,i)                                            ! Detection of duplicated nodes (nodes in more than one partition).
    Enddo
    If(ka.gt.1)then
        Write(12,21)ka                                          ! Quantity of nodes involved in the connection (between different partitions).
        Write(13,22)Pack(N2(:,i),N2(:,i)/=0)                    ! Nodes involved in the connection (between different partitions).
    Endif
Enddo                                                           
!
! ******************************************************************* 
! 
Do i=1,Np
    Write(17,22)Nep(i),Nnp(i)                                   ! Writting "Domain.dat" file.
Enddo                                                           
!
! *******************************************************************
! 
20 Format ((I10),10(F16.8))                     ! Format associated to the nodes.
21 Format ((I10))                               ! Format associated to "NConnect.dat" file.
22 Format (10(I10))                             ! Format associated to "Connect.dat" file.
23 Format (10(F16.8))                           ! Format associated to the coordinates.
24 Format (10(I10))                             ! Auxiliary format 1.
25 Format (10(F16.8))                           ! Auxiliary format 2.
! 
Return
End Subroutine
