      Program Domain_Decomposition

      use metis_interface, Only: idx_t
      use DDMod

      implicit none

      Open (1,file='ddmetis.dat', status='old')           

c **********************************************************************      

      Read (1,*)
      Read (1,*)filename
      Read (1,*)
      Read (1,*)d
      Read (1,*)
      Read (1,*)ne
      Read (1,*)
      Read (1,*)nn
      Read (1,*)
      Read (1,*)npel      
      Read (1,*)
      Read (1,*)np

      allocate(eptr(ne+1))
      allocate(eind(ne*npel))
      allocate(epart(ne))
      allocate(InfNodes(1:nn,1:d+1))
      allocate(InfEle(1:ne,1:npel+3))

      Call Imp_Data
      Call Partition_Mesh
      Call New_Mesh

c **********************************************************************      

      End Program
