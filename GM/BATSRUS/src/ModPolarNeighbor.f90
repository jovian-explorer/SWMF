!^CFG COPYRIGHT UM
!
!==========================================================================!

module ModPolarNeighbor
  use ModNumConst
  implicit none
  save
  integer, dimension(26,8) :: iSubfSpher_IC
  integer, dimension(26,8) :: iSubfCyl_IC


  !//////////////////////////////////////////////////////////////////////////////
  !
  !    North                      8--------------7
  !    Phi,j  Top               / |            / |
  !     ^     z,k,Theta       /   | face iZ=1/   |
  !     |   /               /     |        /     |
  !     | /     West      5-------+------6       |
  !     |-----> R,i       |   e -1|      |       |
  !                       |  c =  1------+-------2
  !                       | a iX/        |     /
  !                       |f  /          |   /
  !                       | /            | /
  !                       4--------------3 --(front, right, and bottom 3D box corner)
  !
  !  Point 7 is:  +x, +y, +z, West, North, Top
  !
  !  Point 4 is:  -x, -y, -z, East, South, Bottom
  !==============================================CYLINDRICAL=============================================================!
  !  This array (see message_pass_cells) establishes the relation between ix,iy,iz and index iDir=1:26           !       |
  !    1, -1,  0,  0,  0,  0,   1, -1,  1, -1,  0,  0,  0,  0,  1, -1, -1,  1,   1, -1,  1, -1,  1, -1,  1, -1, &!  iX   !
  !    0,  0,  1, -1,  0,  0,   1, -1, -1,  1,  1, -1,  1, -1,  0,  0,  0,  0,   1, -1,  1, -1, -1,  1, -1,  1, &!  iY   !
  !    0,  0,  0,  0,  1, -1,   0,  0,  0,  0,  1, -1, -1,  1,  1, -1,  1, -1,   1, -1, -1,  1,  1, -1, -1,  1 / !  iZ   !
  !"subface number" establishes the relationship between the position of child in the array ChildOut created by  !       |
  !subroutine treeNeighbor for direction iX,iY,iZ=>iDir (used in message_pass_cells                              !       |
  !Dir:1   2   3   4   5   6    7   8   9  10  11  12  13  14  15  16  17  18   19  20  21  22  23  24  25  26   !       |
  !    W   E   N   S   T   B   WN  ES  WS  EN  NT  SB  NB  ST  TW  BE  TE  BW  WNT ESB WNB EST WST ENB WSB ENT   !       |
  !--------------------------------------------------------------------------------------------------------------!       |
  !    0,  2,  0,  2,  1,  0,   0,  2,  0,  0,  0,  0,  0,  1,  0,  0,  1,  0,   0,  0,  0,  1,  0,  0,  0,  0, &! C     |
  !    2,  0,  0,  4,  2,  0,   0,  0,  2,  0,  0,  0,  0,  2,  1,  0,  0,  0,   0,  0,  0,  0,  1,  0,  0,  0, &! H     |
  !    1,  0,  0,  3,  0,  2,   0,  0,  1,  0,  0,  2,  0,  0,  0,  0,  0,  1,   0,  0,  0,  0,  0,  0,  1,  0, &! I     |
  !    0,  1,  0,  1,  0,  1,   0,  1,  0,  0,  0,  1,  0,  0,  0,  1,  0,  0,   0,  1,  0,  0,  0,  0,  0,  0, &! L     |
  !    0,  3,  1,  0,  0,  3,   0,  0,  0,  1,  0,  0,  1,  0,  0,  2,  0,  0,   0,  0,  0,  0,  0,  1,  0,  0, &! D     |
  !    3,  0,  3,  0,  0,  4,   1,  0,  0,  0,  0,  0,  2,  0,  0,  0,  0,  2,   0,  0,  1,  0,  0,  0,  0,  0, &! R     |
  !    4,  0,  4,  0,  4,  0,   2,  0,  0,  0,  2,  0,  0,  0,  2,  0,  0,  0,   1,  0,  0,  0,  0,  0,  0,  0, &! E     |
  !    0,  4,  2,  0,  3,  0,   0,  0,  0,  2,  1,  0,  0,  0,  0,  0,  2,  0,   0,  0,  0,  0,  0,  0,  0,  1 / ! N     |
  !For cylindrical geometry, the coulumn for iX(iR)=-1  is constructed from the target coulumn with iX=0 by      !       |
  !leaving children 1,4-5,8. For each non-zero column (iX=-1)provide a reference number for target coloumn (iX=0)!       |
  data iSubFCyl_IC / & !Z e r o s                    target coulum:/6   5           12      14      13      11   !=======|
       0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,   0,  0,  0,  1,  0,  0,  0,  0, &!\iX=-1 |
       !---------------------|------------------------------------|-----------|---------------------------------&!=======|
       0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0, &!\Zeros |
       0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0, &!/Zeros |
       !---------------------|------------------------------------|-----------|---------------------------------&!=======|
       0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,   0,  1,  0,  0,  0,  0,  0,  0, &!\      |
       0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0,  0,  2,  0,  0,   0,  0,  0,  0,  0,  1,  0,  0, &!/iX=-1 |
       !---------------------|------------------------------------|-----------|---------------------------------&!=======|
       0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0, &!\Zeros |
       0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0, &!/Zeros |
       !---------------------|------------------------------------|-----------|---------------------------------&!=======|
       0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  2,  0,   0,  0,  0,  0,  0,  0,  0,  1 / !/iX=-1 |
  !=========faces============|==========edges=====================|===========|=========corners==================!=======!


  !================================================SPHERICAL=====================================================!=======|
  !iLoop_ID / & This array (see message_pass_cells) establishes the relation between ix,iy,iz and index iDir=1:26!       |
  !    1, -1,  0,  0,  0,  0,   1, -1,  1, -1,  0,  0,  0,  0,  1, -1, -1,  1,   1, -1,  1, -1,  1, -1,  1, -1, &! iX    |
  !    0,  0,  1, -1,  0,  0,   1, -1, -1,  1,  1, -1,  1, -1,  0,  0,  0,  0,   1, -1,  1, -1, -1,  1, -1,  1, &! iY    |
  !    0,  0,  0,  0,  1, -1,   0,  0,  0,  0,  1, -1, -1,  1,  1, -1,  1, -1,   1, -1, -1,  1,  1, -1, -1,  1 / ! iZ    |
  !"subface number" establishes the relationship between the position of child in the array ChildOut created by  !       |
  !subroutine treeNeighbor for direction iX,iY,iZ=>iDir (used in message_pass_cells                              !       |
  !Dir:1   2   3   4   5   6    7   8   9  10  11  12  13  14  15  16  17  18   19  20  21  22  23  24  25  26   !       |
  !    W   E   N   S   T   B   WN  ES  WS  EN  NT  SB  NB  ST  TW  BE  TE  BW  WNT ESB WNB EST WST ENB WSB ENT   !       |
  !--------------------------------------------------------------------------------------------------------------!       |
  !    0,  2,  0,  2,  1,  0,   0,  2,  0,  0,  0,  0,  0,  1,  0,  0,  1,  0,   0,  0,  0,  1,  0,  0,  0,  0, &! C     |
  !    2,  0,  0,  4,  2,  0,   0,  0,  2,  0,  0,  0,  0,  2,  1,  0,  0,  0,   0,  0,  0,  0,  1,  0,  0,  0, &! H     |
  !    1,  0,  0,  3,  0,  2,   0,  0,  1,  0,  0,  2,  0,  0,  0,  0,  0,  1,   0,  0,  0,  0,  0,  0,  1,  0, &! I     |
  !    0,  1,  0,  1,  0,  1,   0,  1,  0,  0,  0,  1,  0,  0,  0,  1,  0,  0,   0,  1,  0,  0,  0,  0,  0,  0, &! L     |
  !    0,  3,  1,  0,  0,  3,   0,  0,  0,  1,  0,  0,  1,  0,  0,  2,  0,  0,   0,  0,  0,  0,  0,  1,  0,  0, &! D     |
  !    3,  0,  3,  0,  0,  4,   1,  0,  0,  0,  0,  0,  2,  0,  0,  0,  0,  2,   0,  0,  1,  0,  0,  0,  0,  0, &! R     |
  !    4,  0,  4,  0,  4,  0,   2,  0,  0,  0,  2,  0,  0,  0,  2,  0,  0,  0,   1,  0,  0,  0,  0,  0,  0,  0, &! E     |
  !    0,  4,  2,  0,  3,  0,   0,  0,  0,  2,  1,  0,  0,  0,  0,  0,  2,  0,   0,  0,  0,  0,  0,  0,  0,  1 / ! N     |
  !For spherical geometry, the for iR(iTheta)=-1 leave  children 3-6,  for  iZ=1 leave children 1,2,7,8, in the  !       |
  !target coulumn with iZ=0. For each non-zero column (iZ=+-1) provide a reference for target coloumn (iZ=0)     !       |
  !______________________________________________________________________________________________________________!_______|
  !    Zeros  : faces or iZ=0,or iX=0                       iz:/1  -1   1  -1    1  -1  -1   1   1  -1  -1   1   !=======|
  data iSubFSpher_IC / & !                      !target coulum:/1   2   2   1    7   8   7   8   9  10   9  10   !=======|
       0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,   0,  0,  0,  1,  0,  0,  0,  0, &!\iZ=+1 |
       0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,   0,  0,  0,  0,  1,  0,  0,  0, &!/      |
       !------------------------------------------------------!--------------------------------------------------!=======|
       0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,   0,  0,  0,  0,  0,  0,  1,  0, &!\      !
       0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,   0,  1,  0,  0,  0,  0,  0,  0, &!       !
       0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0,  0,  2,  0,  0,   0,  0,  0,  0,  0,  1,  0,  0, &! iZ=-1 !
       0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  2,   0,  0,  1,  0,  0,  0,  0,  0, &!/      !
       !------------------------------------------------------!--------------------------------------------------!=======!
       0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0,  2,  0,  0,  0,   1,  0,  0,  0,  0,  0,  0,  0, &!\      !
       0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  2,  0,   0,  0,  0,  0,  0,  0,  0,  1 / !/iZ=+1 !
  !=========faces============|==========edges=================|===============|=========corners==================!=======!
  interface check_pole_inside_b
     module procedure check_pole_inside_blk
     module procedure check_pole_inside_blkpe
     module procedure check_pole_inside_octreeblk
  end interface
contains
  !===============================finding polar neighbors================================================================!
  !=====tree_neighbor_fixed: inoptimal, provided here to demonstrate the way to apply tree_neighbor_across_pole==========! 
  subroutine tree_neighbor_fixed(iProc,iBlock,iX,iY,iZ,&
       iPE_I, iBLK_I, iChild_I, iLevel)
    integer,intent(in)::iProc,iBlock,iX,iY,iZ
    integer,intent(out),dimension(4)::iPE_I, iBLK_I, iChild_I
    integer,intent(out)::iLevel
    !--------------------------------------------------------!
    integer::iDir_D(3),iDirPole,iLoopPole
    logical::IsPole
    !--------------------------------------------------------!
    call check_pole_inside_b(iBlock,iProc,IsPole,iDirPole,iLoopPole)
    iDir_D=(/iX,iY,iZ/)
    if(IsPole.and.iDir_D(iDirPole)==iLoopPole)then
       call tree_neighbor_across_pole(iProc,iBlock,iX,iY,iZ,iDirPole,&
       iPE_I, iBLK_I, iChild_I, iLevel)
    else
       call treeNeighbor(iBlock,iProc,IsPole,iDirPole,iLoopPole)
    end if
  end subroutine tree_neighbor_fixed
  !=====tree_neighbor_across_pole, requires that the direction of iX,iY,iZ is towards the pole=!
  subroutine tree_neighbor_across_pole(iProc,iBlock,iX,iY,iZ,iDirPole,&
       iPE_I, iBLK_I, iChild_I, iLevel)
    use ModParallel
    integer,intent(in)::iProc,iBlock,iX,iY,iZ,iDirPole
    integer,intent(out),dimension(4)::iPE_I, iBLK_I, iChild_I
    integer,intent(out)::iLevel
    logical::IsPole
    integer::iDirPoleCheck,iLoopPole,iDir_D(3)
    integer::i,iPut
    
    iDir_D=(/iX,iY,iZ/)
    !Check if the direction to the neighbor is across the pole
    call check_pole_inside_blkpe(iBlock,iProc,IsPole,iDirPoleCheck,iLoopPole)
    if(.not.(IsPole.and.iDirPoleCheck==iDirPole&
         .and.iDir_D(iDirPole)==iLoopPole))call stop_mpi(&
         'tree_neighbor_across_pole:no pole from a given BLK to a given dir')
    iDir_D(iDirPole)=0
    call treeNeighbor(iProc,iBlock, iDir_D(1), iDir_D(2), iDir_D(3), &
         iPE_I, iBLK_I, iChild_I,iLevel)
    select case(iLevel)
    case(NOBLK)
       return !The neighbor is out of tree
    case(0,1)
       call find_axial_neighbor(iPE_I(1),iBLK_I(1),iPE_I(1),iBLK_I(1))
       return
    case(-1)
       iDir_D=(/iX,iY,iZ/)
       !In spherical geometry (iDirPole==3) finer block may only occur at
       !iX=+-1, in axial one (iDirPole==1) at iZ==+-1
       if(.not.iDir_D(4-iDirPole)**2==1)call stop_mpi(&
            'Failed:  tree_neighbor_across_pole')
       !Sort out subfaces of the blocks which do not touch the pole
       
       do i=1,4
          if(iBLK_I(i)==NOBLK)exit
          call check_pole_inside_blkpe(&
               iBLK_I(i),iPE_I(i),IsPole,iDirPoleCheck,iLoopPole)
          if(.not.(IsPole.and.iDirPoleCheck==iDirPole&
               .and.iDir_D(iDirPole)==iLoopPole))then
             iPE_I(i)=NOBLK; iBLK_I(i)=NOBLK; iChild_I(i)=NOBLK
          else
             call find_axial_neighbor(iPE_I(i),iBLK_I(i),iPE_I(i),iBLK_I(i))
             !Move the earlier created NOBLK lines to top position,if needed
             iPut=i
             do while(iPut>1)
                if(iBLK_I(iPut-1)==NOBLK)iPut=iPut-1
             end do
             if(iPut/=i)then
                iPE_I(iPut)=iPE_I(i)
                iBLK_I(iPut)=iBLK_I(i)
                iChild_I(iPut)=iChild_I(i)
                iPE_I(i)=NOBLK; iBLK_I(i)=NOBLK; iChild_I(i)=NOBLK
             end if
          end if
       end do
       call test_refined_polar_neighbor(iX,iY,iZ,iDirPole,iChild_I)
    end select
  end subroutine tree_neighbor_across_pole
  !=test verifies that subfaces arrays constructed above is in accordance with tree_neighbors_across_pole=!
  subroutine test_refined_polar_neighbor(iX,iY,iZ,iDirPole,iChild_I)
    use ModParallel,ONLY:NOBLK
    integer,intent(in)::iX,iY,iZ,iDirPole,iChild_I(4)
    integer::iDir,i
    integer, dimension(26) :: nSubF_I
    data nSubF_I / &
         0,  0,  0,  0,  0,  0,   0,  0,  0,  0,  0,  0,  0,  0,  2,  2,  2,  2,   1,  1,  1,  1,  1,  1,  1,  1 /
    !------------------------------------------------------------------------------------------------------------!
    iDir=i_dir(iX,iY,iZ)
    if(count(iChild_I/=NOBLK)/=nSubF_I(iDir))then
       write(*,*)'Wrong refined children list in tree_neighbor_across_pole'
       write(*,*)'iX,iY,iZ=',iX,iY,iZ
       write(*,*)'Children list',iChild_I
       call stop_mpi('Failed')
    end if
    select case(iDirPole)
    case(3)
       do i=1,nSubF_I(iDir)
          if(iSubfSpher_IC( iDir, iChild_I(i))/=i)then
             write(*,*)'Wrong refined children list in tree_neighbor_across_pole'
             write(*,*)'The positions of children in the list should be:',iSubfSpher_IC( iDir,:)
             write(*,*)'Actual children list',iChild_I
             call stop_mpi('Failed')
          end if
       end do
    case(1)
       do i=1,nSubF_I(iDir)
          if(iSubfSpher_IC( iDir, iChild_I(i))/=i)then
             write(*,*)'Wrong refined children list in tree_neighbor_across_pole'
             write(*,*)'The positions of children in the list should be:',iSubfSpher_IC( iDir,:)
             write(*,*)'Actual children list',iChild_I
             call stop_mpi('Failed')
          end if
       end do
    end select
  contains
    integer function i_dir(iX,iY,iZ)
      integer, dimension(26,3) :: iLoop_ID
      integer,intent(in)::iX,iY,iZ
      integer::iLoop,iDir_D(3),i2
      data iLoop_ID / &                                                                                              
           1, -1,  0,  0,  0,  0,   1, -1,  1, -1,  0,  0,  0,  0,  1, -1, -1,  1,   1, -1,  1, -1,  1, -1,  1, -1, &
           0,  0,  1, -1,  0,  0,   1, -1, -1,  1,  1, -1,  1, -1,  0,  0,  0,  0,   1, -1,  1, -1, -1,  1, -1,  1, &
           0,  0,  0,  0,  1, -1,   0,  0,  0,  0,  1, -1, -1,  1,  1, -1,  1, -1,   1, -1, -1,  1,  1, -1, -1,  1 / 
      !-----------------------------------------------------------------!
      i2=iX**2+iY**2+iZ**2
      if(i2>3.or.i2==0)then
         write(*,*)'i_dir: wrong input parameters:',iX,iY,iZ
         call stop_mpi('Failed')
      end if
      iDir_D=(/iX,iY,iZ/)
      do iLoop=1,26
         if(all(iDir_D==iLoop_ID(i,:)))then
            i_dir=iLoop
            return
         end if
      end do
    end function i_dir
  end subroutine test_refined_polar_neighbor
  !=============================================================================================!
  !Simplified version, gives only iPEOut and iBLKOut for the block which has the common section !
  !of the pole with iPEIn,iBLKIn (face neighbor, the face being degenerated and having zero area!
  !=============================================================================================! 
  subroutine find_axial_neighbor(iPEIn,iBLKIn,iPEOut,iBLKout)
    use ModParallel, ONLY : proc_dims
    use ModOctree
    implicit none
    integer,intent(in)::iPEIn,iBLKIn
    integer,intent(out)::iPEOut,iBLKOut
    integer,dimension(99)::iChild_I
    integer::i,j,k,iRoot,jRoot,kRoot,iLevel,iLevelIn
    type (adaptive_block_ptr) :: InBlkPtr,OutBlkPtr

    nullify (InBlkPtr % ptr)
    InBlkPtr%ptr=> global_block_ptrs(iBlkIn,iPEIn+1)%ptr
    iLevelIn=InBlkPtr%ptr%LEV

    do iLevel=iLevelIn,1,-1
       iChild_I(iLevel)=InBlkPtr%ptr%child_number
       InBlkPtr%ptr=>InBlkPtr%ptr%parent
    end do
    !Found root cell, find neighbor root cell
    do i=1,proc_dims(1)
       do j=1,proc_dims(2)
          do k=1,proc_dims(3)
             if (associated(InBlkPtr%ptr,octree_roots(i,j,k)%ptr)) then
                iRoot=i
                jRoot=j
                kRoot=k
             end if
          end do
       end do
    end do
    jRoot=1+mod(jRoot-1+proc_dims(2)/2,proc_dims(2))

    nullify (OutBlkPtr%ptr)

    OutBlkPtr%ptr=>octree_roots(iRoot,jRoot,kRoot)%ptr
    do iLevel=1,iLevelIn
       call  neighborAssignment(OutBlkPtr,OutBlkPtr,iChild_I(iLevel))
       if (.not.associated(OutBlkPtr%ptr))&
            call stop_mpi('Wrong Axial Neighbor is found') ! ensure block is allocated
    end do
    iPEOut  = outBlkPtr%ptr%PE
    iBlkOut = outBlkPtr%ptr%BLK
  end subroutine find_axial_neighbor
  !================================CHECK if block is polar===================================!
  logical function is_pole_inside_b(iBlock)
    use ModGeometry,ONLY:IsPole_B=>DoFixExtraBoundary_B,is_axial_geometry
    implicit none
    integer,intent(in)::iBlock
    if(.not.is_axial_geometry())then
       is_pole_inside_b=.false.
       return
    end if
    is_pole_inside_b=IsPole_B(iBlock)
  end function is_pole_inside_b
  !==========================================================================================!
  subroutine check_pole_inside_blk(iBlock,IsPole,iDir,iLoop)
    use ModOctree
    use ModGeometry,ONLY:dz_BLK,XyzStart_BLK,TypeGeometry
    use ModMain,ONLY:Theta_
    implicit none
    integer,intent(in) ::iBlock
    logical,intent(out)::IsPole   !True if the pole is inside
    integer,intent(out)::iDir     !iDir=1 pole is in the direction 'i'
    integer,intent(out)::iLoop    !iLoop=+1(-1) in positive (negative) 
    !direction, from a given block
    !--------------------------------------------------------------!
    real::dTheta

    IsPole=is_pole_inside_b(iBlock)
    if(IsPole)then
       if(index(TypeGeometry,'spherical')>0)then
          !calculate a minimal non-zero face area squared along theta direction
          dTheta=dz_BLK(iBlock); iDir=3
          if(XyzStart_BLK(Theta_,iBlock)-dTheta < -cHalfPi)then
             iLoop=-1
          else
             iLoop=+1
          end if
       else !Axial geometry
          iDir=1;iLoop=-1
       end if
    else
       iDir=2;iLoop=0  !no pole
    end if
  end subroutine check_pole_inside_blk
  !==========================================================================================!
  subroutine check_pole_inside_blkpe(iBlock,iProc,IsPole,iDir,iLoop)
    use ModOctree
    implicit none
    integer,intent(in)::iBlock,iProc
    logical,intent(out)::IsPole   !True if the pole is inside
    integer,intent(out)::iDir     !iDir=1 pole is in the direction 'i'
    integer,intent(out)::iLoop    !iLoop=+1(-1) in positive (negative) 
    !direction, from a given block
    if(.not.associated(global_block_ptrs(iBlock, iProc+1) % ptr))then
       write(*,*)'Not associated global block pointer for iBlock=',iBlock,&
            ' at PE=',iProc
       call stop_mpi('Stop in check_pole_inside_blk')
    end if
    call check_pole_inside_octreeblk(global_block_ptrs(iBlock,iProc+1),&
         IsPole,iDir,iLoop)
  end subroutine check_pole_inside_blkpe
  !=========================================================================!
  subroutine check_pole_inside_octreeblk(OctreeBlk,IsPole,iDir,iLoop)
    use ModCovariant,ONLY:TypeGeometry,is_axial_geometry
    use ModParallel, ONLY : proc_dims
    use ModOctree
    implicit none
    type(adaptive_block_ptr),intent(in)::OctreeBlk
    type(adaptive_block_ptr)::BlkAux
    logical,intent(out)::IsPole   !True if the pole is inside
    integer,intent(out)::iDir     !iDir=1 pole is in the direction 'i'
    integer,intent(out)::iLoop    !iLoop=+1(-1) in positive (negative) 
    !direction, from a given block

    if(.not.OctreeBlk%ptr % used)&
         call stop_mpi('Attempt to check pole inside unused octree block')
    IsPole=.false.;iDir=2;iLoop=0
    if(.not.is_axial_geometry())return
    if(.not.OctreeBlk%ptr%IsExtraBoundaryOrPole)return
    if(index(TypeGeometry,'spherical')>0)then
       if(proc_dims(3)==1.and.OctreeBlk%ptr%LEV==0)call stop_mpi(&
            'Can not check pole: the block covers both hemispheres')

       !idir = 1+ (iz+1) + 3*(iy+1) + 9*(ix+1)
       !for        iz=-1      iy=0       ix=0   iDir=13

       call findTreeNeighbor(OctreeBlk,BlkAux,13,IsPole)
       if(IsPole)iDir=3; iLoop=-1; return


       !idir = 1+ (iz+1) + 3*(iy+1) + 9*(ix+1)
       !for        iz=+1      iy=0       ix=0   iDir=15

       call findTreeNeighbor(OctreeBlk,BlkAux,15,IsPole)   
       if(IsPole)iDir=3; iLoop=+1; return
    elseif(index(TypeGeometry,'cylindrical')>0.or.&
         index(TypeGeometry,'axial')>0)then
       !idir = 1+ (iz+1) + 3*(iy+1) + 9*(ix+1)
       !for        iz=0       iy=0       ix=-1   iDir=5

       call findTreeNeighbor(OctreeBlk,BlkAux,5,IsPole)   
       if(IsPole)iDir=1; iLoop=-1; return
    else
       call stop_mpi('Failed check_pole_inside_octreeblk')
    end if
  end subroutine check_pole_inside_octreeblk
  !=============================================================
end module ModPolarNeighbor
