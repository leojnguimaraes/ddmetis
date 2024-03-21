      Module DDMod

      use metis_interface, only: idx_t, METIS_SetDefaultOptions, 
     *METIS_PartMeshNodal, METIS_MeshToNodal, METIS_Free, 
     *METIS_NOPTIONS, METIS_OK, METIS_OPTION_NUMBERING, 
     *METIS_OPTION_CONTIG,METIS_OBJTYPE_CUT

      Implicit none

      character(len=30) :: filename

      Integer(idx_t),allocatable :: eptr(:)
      Integer(idx_t),allocatable :: eind(:)
      Integer(idx_t),allocatable :: epart(:)
      Real(16),allocatable :: InfNodes(:,:)
      Integer,allocatable :: InfEle(:,:)

      Integer(idx_t) :: d,ne,nn,npel,np

      contains

c **********************************************************************
c This subroutine imports the information about the nodes pertaining
c to the i-th element from an input file, and produces the arrays 
c "eind" and "eptr", necessary for FMetis to generate the partitions.
c In addition, it generates two arrays: InfNodes and InfEle, containing
c relevant information about nodes and elements, respectively.

c ne = Number of elements.
c nn = Number of nodes.
c npel = Number of nodes per element.
c d = physical dimensionality of the grid.

c **********************************************************************

      Subroutine Imp_Data
      
      Integer :: i,j

      Open (10,file=filename, status='old')


      Read (10,*)                                                     

      Do i=1,nn
         Read(10,20)(InfNodes(i,j),j=1,d+1)                  
      Enddo
      
      Do i=1,ne
         Read(10,22)(InfEle(i,j),j=1,npel+3)                 
      Enddo

      eptr(1)=0                                                   ! By default.

      Do i=1,ne
         Do j=1,npel
            eind(npel*(i-1)+j)=InfEle(i,3+j)-1                  ! Construction of "eind" array (for Metis).
         Enddo
         eptr(i+1)=npel*i                                        ! Construction of "eptr" array (for Metis).
      enddo

20    Format ((F5.0),10(F10.0))                                ! Format associated to the nodes.
21    Format ((F6.0),' ',3(F13.6))                             ! Auxiliary format for visualization.
22    Format (11(I5))                                          ! Format associated to the elements.

      Return
      End Subroutine

c **********************************************************************
c This subroutine separates a set of elements into a set of np 
c c contiguous partitions using the Fmetis interface.
c This code is an adaptation of the examples shown in:
c https://ivan-pi.github.io/fmetis/sourcefile/metis_interface.f90.html
c **********************************************************************

      Subroutine Partition_Mesh

      Integer(idx_t) :: options(0:METIS_NOPTIONS-1)
      Integer(idx_t) :: ios, objval
      Integer(idx_t) :: npart(nn)

      Integer :: i

      Open (10,file='epart_array.out')                 

      ios = METIS_SetDefaultOptions(options)
      if (ios /= METIS_OK) then
         write(*,*) "METIS_SetDefaultOptions failed with error: ", ios
         error stop 1
      end if
      options(METIS_OPTION_NUMBERING) = 0
      options(METIS_OPTION_CONTIG) = 1     

      ios=METIS_PartMeshNodal(ne,nn,eptr,eind,nparts=np,options=options,
     *objval=objval,epart=epart,npart=npart)
      if (ios /= METIS_OK) then
            write(*,*) "METIS_PartMeshNodal failed with error: ", ios
      error stop 1
      end if

      Do i=1,ne
         epart(i)=epart(i)+1
      Enddo

      write(10,20)epart

20    Format ((I5))

      Return
      End Subroutine

c **********************************************************************
c This subroutine is employed to give a list of the nodes located
c at the "border" of the partitions and the total amount of 
c elements involved.
c 
c ne = Number of elements.
c nn = Number of nodes.
c npel = Number of nodes per element.
c np  = Number of partitions.
c 
c **********************************************************************

      Subroutine New_Mesh

      Implicit None

      Integer(idx_t) :: i,j,l,ia,ja,ka

      Integer(idx_t) :: N(np,nn)
      Integer(idx_t) :: Q(np,ne)
      Integer(idx_t) :: N2(np,nn)
      Integer(idx_t) :: Nnp(np)                   
      Integer(idx_t) :: Nep(np)                   

      Open (11,file='coords.out')                 
      Open (12,file='nconnect.out')               
      Open (13,file='connect.out')                
      Open (14,file='domain.out')                 
      Open (15,file='lnods.out')                  
      Open (16,file='mat.out')                    
      Open (17,file='domain.out')                 
      Open (18,file='partele.out')   
      
      Do i=1,np
         Do j=1,nn
            N(i,j)=0
         Enddo
         Do j=1,ne
            Q(i,j)=0
         Enddo
      Enddo

c **********************************************************************
c Matrix N
c **********************************************************************

      Do i=1,ne
         ia=epart(i)
         Do j=1,npel
            ja=eind((i-1)*npel+j)+1
            N(ia,ja)=1
         Enddo
      Enddo

c **********************************************************************
c Matrix Q
c **********************************************************************

      Do i=1,ne
         Q(epart(i),i)=1
      Enddo
c
c **********************************************************************
c Generation of new nodes and relabeling - Matrix N_2
c **********************************************************************

      ja=0
      Do j=1,Np
         ia=0
         Do i=1,Nn
            ja=ja+N(j,i)
            N2(j,i)=N(j,i)*ja                                       
            If(N2(j,i).gt.0)then
               Write(11,23)(InfNodes(i,l),l=2,d+1)                 
               ia=ia+1
            Endif
         Enddo
         Nnp(j)=ia                                                   

         ia=0
         Do i=1,Ne
            If(Q(j,i).gt.0)then
               Write(15,22)(N2(j,InfEle(i,3+l)),l=1,npel)          
               Write(16,21)InfEle(i,3)                             
               Write(18,21)j                                       
               ia=ia+1                                             
            Endif        
         Enddo 
         Nep(j)=ia                                                   
      Enddo
 
      Do i=1,Nn
         ka=0
         Do j=1,np
            ka=ka+N(j,i)                                            
         Enddo
         If(ka.gt.1)then
            Write(12,21)ka                                          
            Write(13,22)Pack(N2(:,i),N2(:,i)/=0)                    
         Endif
      Enddo                                                           

      Do i=1,Np
         Write(17,22)Nep(i),Nnp(i)
      Enddo                                                           

20    Format ((I10),10(F16.8))
21    Format ((I10))
22    Format (10(I10))
23    Format (10(F16.8))
24    Format (10(I10))
25    Format (10(F16.8))

      Return
      End Subroutine

      End Module DDMod
