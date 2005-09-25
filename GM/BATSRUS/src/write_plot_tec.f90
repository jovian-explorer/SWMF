!^CFG COPYRIGHT UM
subroutine write_plot_tec(ifile,nplotvar,plotvarnodes,unitstr_TEC,&
     xmin,xmax,ymin,ymax,zmin,zmax)
  !
  !NOTE: This routine assumes that the blocks are sorted on PEs by their global
  !       block number, ie blocks 1 to n on PE 0, blocks n+1 to n+m on PE 1,
  !       etc.
  !
  use ModProcMH
  use ModMain, ONLY : nI,nJ,nK,globalBLK,global_block_number, nBlock, &
       nBlockALL,nBlockMax, StringTimeH4M2S2,time_accurate,n_step,&
       nOrder, limiter_type,betalimiter, UseRotatingBc, &
       TypeCoordSystem, problem_type, StringProblemType_I, CodeVersion
  use ModMain, ONLY: boris_correction                     !^CFG IF BORISCORR
  use ModParallel, ONLY : iBlock_A, iProc_A
  use ModPhysics, ONLY : unitUSER_x, thetaTilt, Rbody, boris_cLIGHT_factor, &
       Body_rho_dim, g
  use ModAdvance, ONLY : FluxType, iTypeAdvance_B, SkippedBlock_
  use ModIO
  use ModNodes
  use ModNumConst, ONLY : cRadToDeg
  use ModMpi
  implicit none

  ! Arguments  
  integer, intent(in) :: ifile, nplotvar
  character (LEN=500), intent(in) :: unitstr_TEC
  real, intent(in) :: PlotVarNodes(0:nI,0:nJ,0:nK,nBLK,nplotvarmax)
  real, intent(in) :: xmin,xmax,ymin,ymax,zmin,zmax

  ! Local Variables
  integer :: i,j,k, cut1,cut2, iPE,iBLK, iBlockALL, nBlockCuts, iError
  real :: CutValue, factor1,factor2
  logical :: oktest,oktest_me
  integer, allocatable, dimension(:) :: BlockCut
  character (len=22) :: textNandT
  character (len=23) :: textDateTime0,textDateTime
  character (len=80) :: format

  integer :: iTime0_I(7),iTime_I(7)

  integer ic,ic1,ic2, jc,jc1,jc2, kc,kc1,kc2, nCuts, nCutsTotal
  real :: XarbP,YarbP,ZarbP, XarbNormal,YarbNormal,ZarbNormal, Xp,Yp,Zp
  real, dimension(0:nI,0:nJ,0:nK,3) :: NodeXYZ_III
  logical :: okdebug
  !----------------------------------------------------------------------------

  call set_oktest('write_plot_tec',oktest,oktest_me)
  if(oktest_me)write(*,*) plot_type1,plot_type1(1:3)  

  ! Create text string for zone name like 'N=0002000 T=0000:05:00'
  if(time_accurate)then
     call get_time_string
     write(textNandT,'(a,i7.7,a)') "N=",n_step," T="// &
          StringTimeH4M2S2(1:4)//":"// &
          StringTimeH4M2S2(5:6)//":"// &
          StringTimeH4M2S2(7:8)
  else
     write(textNandT,'(a,i7.7)') &
          "N=",n_step
  end if

  write(format,*)'(i4.4,"/",i2.2,"/",i2.2," ",i2.2,":",i2.2,":",i2.2,".",i3.3)'
  call get_date_time_start(iTime0_I)
  call get_date_time(iTime_I)
  write(textDateTime0,format) iTime0_I
  write(textDateTime ,format) iTime_I

  select case(plot_type1(1:3))
  case('3d_')
     if(iProc==0)then
        ! Write file header
        write(unit_tmp,'(a)')'TITLE="BATSRUS: 3D Data, '//textDateTime//'"'
        write(unit_tmp,'(a)')trim(unitstr_TEC)
        write(unit_tmp,'(a,a,i8,a,i8,a)') &
             'ZONE T="3D   '//textNandT//'"', &
             ', N=',nNodeALL, &
             ', E=',nBlockALL*((nI  )*(nJ  )*(nK  )), &
             ', F=FEPOINT, ET=BRICK'
        call write_auxdata
     end if
     !================================= 3d ============================
     do iBLK = 1, nBlock
        if(iTypeAdvance_B(iBlk) == SkippedBlock_) CYCLE
        ! Write point values
        do k=0,nK; do j=0,nJ; do i=0,nI
           if(NodeUniqueGlobal_IIIB(i,j,k,iBLK))then
              if (plot_dimensional(ifile)) then
                 write(unit_tmp,fmt="(30(E14.6))") &
                      NodeX_IIIB(i,j,k,iBLK)*unitUSER_x, &
                      NodeY_IIIB(i,j,k,iBLK)*unitUSER_x, &
                      NodeZ_IIIB(i,j,k,iBLK)*unitUSER_x, &
                      PlotVarNodes(i,j,k,iBLK,1:nplotvar)
              else
                 write(unit_tmp,fmt="(30(E14.6))") &
                      NodeX_IIIB(i,j,k,iBLK), &
                      NodeY_IIIB(i,j,k,iBLK), &
                      NodeZ_IIIB(i,j,k,iBLK), &
                      PlotVarNodes(i,j,k,iBLK,1:nplotvar)
              end if
           end if
        end do; end do; end do
        ! Write point connectivity
        do k=1,nK; do j=1,nJ; do i=1,nI
           write(unit_tmp2,'(8(i8,1x))') &
                NodeNumberGlobal_IIIB(i-1,j-1,k-1,iBLK), &
                NodeNumberGlobal_IIIB(i  ,j-1,k-1,iBLK), &
                NodeNumberGlobal_IIIB(i  ,j  ,k-1,iBLK), &
                NodeNumberGlobal_IIIB(i-1,j  ,k-1,iBLK), &
                NodeNumberGlobal_IIIB(i-1,j-1,k  ,iBLK), &
                NodeNumberGlobal_IIIB(i  ,j-1,k  ,iBLK), &
                NodeNumberGlobal_IIIB(i  ,j  ,k  ,iBLK), &
                NodeNumberGlobal_IIIB(i-1,j  ,k  ,iBLK)
        end do; end do; end do
     end do
  case('cut','x=0','y=0','z=0')
     !================================ cut ============================
     ! Allocate memory for storing the blocks that are cut
     allocate( BlockCut(nBlockALL), stat=iError ); call alloc_check(iError,"BlockCut")
     BlockCut=0
     nBlockCuts=0

     if((xmax-xmin)<(ymax-ymin) .and. (xmax-xmin)<(zmax-zmin))then
        !X Slice
        CutValue = 0.5*(xmin+xmax)
        ! First loop to count nodes and cells
        do iBlockALL  = 1, nBlockALL
           iBLK = iBlock_A(iBlockALL)
           iPE  = iProc_A(iBlockALL)
           if(iProc==iPE)then
              if ( CutValue> NodeX_IIIB(0 ,0,0,iBLK) .and. &
                   CutValue<=NodeX_IIIB(nI,0,0,iBLK) )then
                 nBlockCuts=nBlockCuts+1
                 BlockCut(iBlockALL)=nBlockCuts
              end if
           end if
           call MPI_Bcast(nBlockCuts,1,MPI_Integer,iPE,iComm,iError)
        end do
        if(iProc==0)then
           ! Write file header
           write(unit_tmp,'(a)')'TITLE="BATSRUS: Cut X Data, '//textDateTime//'"'
           write(unit_tmp,'(a)')trim(unitstr_TEC)
           write(unit_tmp,'(a,a,i8,a,i8,a)') &
                'ZONE T="2D X '//textNandT//'"', &
                ', N=',nBlockCuts*((nJ+1)*(nK+1)), &
                ', E=',nBlockCuts*((nJ  )*(nK  )), &
                ', F=FEPOINT, ET=QUADRILATERAL'
           call write_auxdata
        end if
        ! Now loop to write values
        do iBlockALL  = 1, nBlockALL
           iBLK = iBlock_A(iBlockALL)
           iPE  = iProc_A(iBlockALL)
           if(iProc==iPE)then
              if ( CutValue> NodeX_IIIB(0 ,0,0,iBLK) .and. &
                   CutValue<=NodeX_IIIB(nI,0,0,iBLK) )then
                 ! Find cut interpolation factors
                 do i=1,nI
                    if ( CutValue> NodeX_IIIB(i-1,0,0,iBLK) .and. &
                         CutValue<=NodeX_IIIB(i  ,0,0,iBLK)  )then
                       cut1=i-1
                       cut2=i
                       factor2=(CutValue-NodeX_IIIB(i-1,0,0,iBLK))/ &
                            (NodeX_IIIB(i,0,0,iBLK)-NodeX_IIIB(i-1,0,0,iBLK))
                       factor1=1.-factor2
                       EXIT
                    end if
                 end do
                 ! Write point values
                 do k=0,nK; do j=0,nJ
                    if (plot_dimensional(ifile)) then
                       write(unit_tmp,fmt="(30(E14.6))") &
                            (factor1*NodeX_IIIB(cut1,j,k,iBLK)+ &
                             factor2*NodeX_IIIB(cut2,j,k,iBLK))*unitUSER_x, &
                            (factor1*NodeY_IIIB(cut1,j,k,iBLK)+ &
                             factor2*NodeY_IIIB(cut2,j,k,iBLK))*unitUSER_x, &
                            (factor1*NodeZ_IIIB(cut1,j,k,iBLK)+ &
                             factor2*NodeZ_IIIB(cut2,j,k,iBLK))*unitUSER_x, &
                            (factor1*PlotVarNodes(cut1,j,k,iBLK,1:nplotvar)+ &
                             factor2*PlotVarNodes(cut2,j,k,iBLK,1:nplotvar))
                    else
                       write(unit_tmp,fmt="(30(E14.6))") &
                            (factor1*NodeX_IIIB(cut1,j,k,iBLK)+ &
                             factor2*NodeX_IIIB(cut2,j,k,iBLK)), &
                            (factor1*NodeY_IIIB(cut1,j,k,iBLK)+ &
                             factor2*NodeY_IIIB(cut2,j,k,iBLK)), &
                            (factor1*NodeZ_IIIB(cut1,j,k,iBLK)+ &
                             factor2*NodeZ_IIIB(cut2,j,k,iBLK)), &
                            (factor1*PlotVarNodes(cut1,j,k,iBLK,1:nplotvar)+ &
                             factor2*PlotVarNodes(cut2,j,k,iBLK,1:nplotvar))
                    end if
                 end do; end do
                 ! Write point connectivity
                 do k=1,nK; do j=1,nJ
                    write(unit_tmp2,'(4(i8,1x))') &
                         ((BlockCut(iBlockALL)-1)*(nJ+1)*(nK+1)) + (k-1)*(nJ+1)+j, &
                         ((BlockCut(iBlockALL)-1)*(nJ+1)*(nK+1)) + (k-1)*(nJ+1)+j+1, &
                         ((BlockCut(iBlockALL)-1)*(nJ+1)*(nK+1)) + (k  )*(nJ+1)+j+1, &
                         ((BlockCut(iBlockALL)-1)*(nJ+1)*(nK+1)) + (k  )*(nJ+1)+j
                 end do; end do
              end if
           end if
        end do
     elseif((ymax-ymin)<(zmax-zmin))then
        !Y Slice
        CutValue = 0.5*(ymin+ymax)
        ! First loop to count nodes and cells
        do iBlockALL  = 1, nBlockALL
           iBLK = iBlock_A(iBlockALL)
           iPE  = iProc_A(iBlockALL)
           if(iProc==iPE)then
              if ( CutValue> NodeY_IIIB(0,0 ,0,iBLK) .and. &
                   CutValue<=NodeY_IIIB(0,nJ,0,iBLK) )then
                 nBlockCuts=nBlockCuts+1
                 BlockCut(iBlockALL)=nBlockCuts
              end if
           end if
           call MPI_Bcast(nBlockCuts,1,MPI_Integer,iPE,iComm,iError)
        end do
        if(iProc==0)then
           ! Write file header
           write(unit_tmp,'(a)')'TITLE="BATSRUS: Cut Y Data, '//textDateTime//'"'
           write(unit_tmp,'(a)')unitstr_TEC(1:len_trim(unitstr_TEC))
           write(unit_tmp,'(a,a,i8,a,i8,a)') &
                'ZONE T="2D Y '//textNandT//'"', &
                ', N=',nBlockCuts*((nI+1)*(nK+1)), &
                ', E=',nBlockCuts*((nI  )*(nK  )), &
                ', F=FEPOINT, ET=QUADRILATERAL'
           call write_auxdata
        end if
        ! Now loop to write values
        do iBlockALL  = 1, nBlockALL
           iBLK = iBlock_A(iBlockALL)
           iPE  = iProc_A(iBlockALL)
           if(iProc==iPE)then
              if ( CutValue> NodeY_IIIB(0,0 ,0,iBLK) .and. &
                   CutValue<=NodeY_IIIB(0,nJ,0,iBLK) )then
                 ! Find cut interpolation factors
                 do j=1,nJ
                    if ( CutValue> NodeY_IIIB(0,j-1,0,iBLK) .and. &
                         CutValue<=NodeY_IIIB(0,j  ,0,iBLK)  )then
                       cut1=j-1
                       cut2=j
                       factor2=(CutValue-NodeY_IIIB(0,j-1,0,iBLK))/ &
                            (NodeY_IIIB(0,j,0,iBLK)-NodeY_IIIB(0,j-1,0,iBLK))
                       factor1=1.-factor2
                       EXIT
                    end if
                 end do
                 ! Write point values
                 do k=0,nK; do i=0,nI
                    if (plot_dimensional(ifile)) then
                       write(unit_tmp,fmt="(30(E14.6))") &
                            (factor1*NodeX_IIIB(i,cut1,k,iBLK)+ &
                             factor2*NodeX_IIIB(i,cut2,k,iBLK))*unitUSER_x, &
                            (factor1*NodeY_IIIB(i,cut1,k,iBLK)+ &
                             factor2*NodeY_IIIB(i,cut2,k,iBLK))*unitUSER_x, &
                            (factor1*NodeZ_IIIB(i,cut1,k,iBLK)+ &
                             factor2*NodeZ_IIIB(i,cut2,k,iBLK))*unitUSER_x, &
                            (factor1*PlotVarNodes(i,cut1,k,iBLK,1:nplotvar)+ &
                             factor2*PlotVarNodes(i,cut2,k,iBLK,1:nplotvar))
                    else
                       write(unit_tmp,fmt="(30(E14.6))") &
                            (factor1*NodeX_IIIB(i,cut1,k,iBLK)+ &
                             factor2*NodeX_IIIB(i,cut2,k,iBLK)), &
                            (factor1*NodeY_IIIB(i,cut1,k,iBLK)+ &
                             factor2*NodeY_IIIB(i,cut2,k,iBLK)), &
                            (factor1*NodeZ_IIIB(i,cut1,k,iBLK)+ &
                             factor2*NodeZ_IIIB(i,cut2,k,iBLK)), &
                            (factor1*PlotVarNodes(i,cut1,k,iBLK,1:nplotvar)+ &
                             factor2*PlotVarNodes(i,cut2,k,iBLK,1:nplotvar))
                    end if
                 end do; end do
                 ! Write point connectivity
                 do k=1,nK; do i=1,nI
                    write(unit_tmp2,'(4(i8,1x))') &
                         ((BlockCut(iBlockALL)-1)*(nI+1)*(nK+1)) + (k-1)*(nI+1)+i, &
                         ((BlockCut(iBlockALL)-1)*(nI+1)*(nK+1)) + (k-1)*(nI+1)+i+1, &
                         ((BlockCut(iBlockALL)-1)*(nI+1)*(nK+1)) + (k  )*(nI+1)+i+1, &
                         ((BlockCut(iBlockALL)-1)*(nI+1)*(nK+1)) + (k  )*(nI+1)+i
                 end do; end do
              end if
           end if
        end do
     else
        !Z Slice
        CutValue = 0.5*(zmin+zmax)
        ! First loop to count nodes and cells
        do iBlockALL  = 1, nBlockALL
           iBLK = iBlock_A(iBlockALL)
           iPE  = iProc_A(iBlockALL)
           if(iProc==iPE)then
              if ( CutValue> NodeZ_IIIB(0,0, 0,iBLK) .and. &
                   CutValue<=NodeZ_IIIB(0,0,nK,iBLK) )then
                 nBlockCuts=nBlockCuts+1
                 BlockCut(iBlockALL)=nBlockCuts
              end if
           end if
           call MPI_Bcast(nBlockCuts,1,MPI_Integer,iPE,iComm,iError)
        end do
        if(iProc==0)then
           ! Write file header
           write(unit_tmp,'(a)')'TITLE="BATSRUS: Cut Z Data, '//textDateTime//'"'
           write(unit_tmp,'(a)')unitstr_TEC(1:len_trim(unitstr_TEC))
           write(unit_tmp,'(a,a,i8,a,i8,a)') &
                'ZONE T="2D Z '//textNandT//'"', &
                ', N=',nBlockCuts*((nI+1)*(nJ+1)), &
                ', E=',nBlockCuts*((nI  )*(nJ  )), &
                ', F=FEPOINT, ET=QUADRILATERAL'
           call write_auxdata
        end if
        ! Now loop to write values
        do iBlockALL  = 1, nBlockALL
           iBLK = iBlock_A(iBlockALL)
           iPE  = iProc_A(iBlockALL)
           if(iProc==iPE)then
              if ( CutValue> NodeZ_IIIB(0,0, 0,iBLK) .and. &
                   CutValue<=NodeZ_IIIB(0,0,nK,iBLK) )then
                 ! Find cut interpolation factors
                 do k=1,nK
                    if ( CutValue> NodeZ_IIIB(0,0,k-1,iBLK) .and. &
                         CutValue<=NodeZ_IIIB(0,0,k  ,iBLK)  )then
                       cut1=k-1
                       cut2=k
                       factor2=(CutValue-NodeZ_IIIB(0,0,k-1,iBLK))/ &
                            (NodeZ_IIIB(0,0,k,iBLK)-NodeZ_IIIB(0,0,k-1,iBLK))
                       factor1=1.-factor2
                       EXIT
                    end if
                 end do
                 ! Write point values
                 do j=0,nJ; do i=0,nI
                    if (plot_dimensional(ifile)) then
                       write(unit_tmp,fmt="(30(E14.6))") &
                            (factor1*NodeX_IIIB(i,j,cut1,iBLK)+ &
                             factor2*NodeX_IIIB(i,j,cut2,iBLK))*unitUSER_x, &
                            (factor1*NodeY_IIIB(i,j,cut1,iBLK)+ &
                             factor2*NodeY_IIIB(i,j,cut2,iBLK))*unitUSER_x, &
                            (factor1*NodeZ_IIIB(i,j,cut1,iBLK)+ &
                             factor2*NodeZ_IIIB(i,j,cut2,iBLK))*unitUSER_x, &
                            (factor1*PlotVarNodes(i,j,cut1,iBLK,1:nplotvar)+ &
                             factor2*PlotVarNodes(i,j,cut2,iBLK,1:nplotvar))
                    else
                       write(unit_tmp,fmt="(30(E14.6))") &
                            (factor1*NodeX_IIIB(i,j,cut1,iBLK)+ &
                             factor2*NodeX_IIIB(i,j,cut2,iBLK)), &
                            (factor1*NodeY_IIIB(i,j,cut1,iBLK)+ &
                             factor2*NodeY_IIIB(i,j,cut2,iBLK)), &
                            (factor1*NodeZ_IIIB(i,j,cut1,iBLK)+ &
                             factor2*NodeZ_IIIB(i,j,cut2,iBLK)), &
                            (factor1*PlotVarNodes(i,j,cut1,iBLK,1:nplotvar)+ &
                             factor2*PlotVarNodes(i,j,cut2,iBLK,1:nplotvar))
                    end if
                 end do; end do
                 ! Write point connectivity
                 do j=1,nJ; do i=1,nI
                    write(unit_tmp2,'(4(i8,1x))') &
                         ((BlockCut(iBlockALL)-1)*(nI+1)*(nJ+1)) + (j-1)*(nI+1)+i, &
                         ((BlockCut(iBlockALL)-1)*(nI+1)*(nJ+1)) + (j-1)*(nI+1)+i+1, &
                         ((BlockCut(iBlockALL)-1)*(nI+1)*(nJ+1)) + (j  )*(nI+1)+i+1, &
                         ((BlockCut(iBlockALL)-1)*(nI+1)*(nJ+1)) + (j  )*(nI+1)+i
                 end do; end do
              end if
           end if
        end do
     end if
     deallocate(BlockCut)
  case('slc','dpl')
     !================================ arbitrary slices ===============
     okdebug=.false.

     ! XarbP,YarbP,ZarbP                    point on plane
     ! XarbNormal,YarbNormal,ZarbNormal     normal for cut
     ! ic1,jc1,kc1,ic2,jc2,kc2              two opposite corner indices

     if (plot_type1(1:3)=='slc')then
        !Point-Normal cut plot
        XarbP=plot_point(1,ifile); XarbNormal=plot_normal(1,ifile)
        YarbP=plot_point(2,ifile); YarbNormal=plot_normal(2,ifile)
        ZarbP=plot_point(3,ifile); ZarbNormal=plot_normal(3,ifile)
     else
        !Dipole cut plot
        XarbP=0.; XarbNormal=-sin(ThetaTilt)
        YarbP=0.; YarbNormal=0.
        ZarbP=0.; ZarbNormal= cos(ThetaTilt)
     end if

     ! First loop to count cuts
     nBlockCuts=0
     do iBLK = 1, nBlock
        if(iTypeAdvance_B(iBlk) == SkippedBlock_) CYCLE
        ic1=0; ic2=nI 
        jc1=0; jc2=nJ
        kc1=0; kc2=nK
        call find_cuts(-1)
        if ( nCuts>0 )then
           !count up number of cuts
           do i=1,nI; do j=1,nJ; do k=1,nK
              ic1=i-1; ic2=i 
              jc1=j-1; jc2=j
              kc1=k-1; kc2=k
              call find_cuts(0)
              nBlockCuts=nBlockCuts+nCuts
           end do; end do; end do
        end if
     end do
     call MPI_reduce(nBlockCuts, nCutsTotal, 1, MPI_INTEGER, MPI_SUM, 0, &
          iComm, iError)

     ! Write file header
     if(iProc==0)then
        if (plot_type1(1:3)=='slc')then
           write(unit_tmp,'(a)')'TITLE="BATSRUS: Slice, '//textDateTime//'"'
           write(unit_tmp,'(a)')trim(unitstr_TEC)
           write(unit_tmp,'(a,i8,a)') &
                'ZONE T="Slice '//textNandT//'", I=', nCutsTotal,&
                ', J=1, K=1, F=POINT'
        else
           write(unit_tmp,'(a)')'TITLE="BATSRUS: Dipole Cut, '// &
                textDateTime//'"'
           write(unit_tmp,'(a)')trim(unitstr_TEC)
           write(unit_tmp,'(a,i8,a)') &
                'ZONE T="Dipole Cut '//textNandT//'", I=', nCutsTotal,&
                ', J=1, K=1, F=POINT'
        end if
        call write_auxdata
     end if

     ! Now loop to write values
     do iBLK = 1, nBlock
        if(iTypeAdvance_B(iBlk) == SkippedBlock_) CYCLE
        ic1=0; ic2=nI 
        jc1=0; jc2=nJ
        kc1=0; kc2=nK
        call find_cuts(-1)
        if ( nCuts>0 )then
           if (plot_dimensional(ifile)) then
              NodeXYZ_III(:,:,:,1)=NodeX_IIIB(:,:,:,iBLK)*unitUSER_x
              NodeXYZ_III(:,:,:,2)=NodeY_IIIB(:,:,:,iBLK)*unitUSER_x
              NodeXYZ_III(:,:,:,3)=NodeZ_IIIB(:,:,:,iBLK)*unitUSER_x
           else
              NodeXYZ_III(:,:,:,1)=NodeX_IIIB(:,:,:,iBLK)
              NodeXYZ_III(:,:,:,2)=NodeY_IIIB(:,:,:,iBLK)
              NodeXYZ_III(:,:,:,3)=NodeZ_IIIB(:,:,:,iBLK)
           end if
           ! write the cuts
           do i=1,nI; do j=1,nJ; do k=1,nK
              ic1=i-1; ic2=i 
              jc1=j-1; jc2=j
              kc1=k-1; kc2=k
              call find_cuts(1)
           end do; end do; end do
        end if
     end do
  case default
     write(*,*)'Error in write_plot_tec: Unknown plot_type='//plot_type1
  end select

contains

  ! iopt =-1 check all edges to see if cut
  !      = 0 count cuts only
  !      = 1 find cuts and write to disk
  subroutine find_cuts(iopt)
    integer, intent(in) :: iopt
    integer :: ic,jc,kc

    nCuts=0

    !Check edges.
    ! X edges
    if (XarbNormal>0.01) then
       ic=ic1; jc=jc1; kc=kc1
       do jc=jc1,jc2,jc2-jc1; do kc=kc1,kc2,kc2-kc1
          if(iopt>-1 .and. (jc==jc1 .or. kc==kc1) .and. (jc/=0 .and. kc/=0)) CYCLE
          Yp=NodeY_IIIB(ic,jc,kc,iBLK)
          Zp=NodeZ_IIIB(ic,jc,kc,iBLK)
          Xp=XarbP-( YarbNormal*(Yp-YarbP) + ZarbNormal*(Zp-ZarbP) )/XarbNormal
          if ( Xp> NodeX_IIIB(ic1,jc,kc,iBLK) .and. &
               Xp<=NodeX_IIIB(ic2,jc,kc,iBLK) )then
             if(okdebug)write(*,*)'x-cut:',iopt,Xp,Yp,Zp
             if(iopt==-1)then
                nCuts=1; RETURN
             end if
             ! Cycle if outside of clipping box
             if ( Xp<xmin .or. Yp<ymin .or. Zp<zmin .or. &
                  Xp>xmax .or. Yp>ymax .or. Zp>zmax) CYCLE
             nCuts=nCuts+1
             if (iopt>0) then
                ! Write point values
                factor2=(Xp-NodeX_IIIB(ic1,jc,kc,iBLK))/ &
                     (NodeX_IIIB(ic2,jc,kc,iBLK)-NodeX_IIIB(ic1,jc,kc,iBLK))
                factor1=1.-factor2
                write(unit_tmp,fmt="(30(E14.6))") &
                     (factor1*NodeXYZ_III( ic1,jc,kc,:)+ &
                      factor2*NodeXYZ_III( ic2,jc,kc,:)), &
                     (factor1*PlotVarNodes(ic1,jc,kc,iBLK,1:nplotvar)+ &
                      factor2*PlotVarNodes(ic2,jc,kc,iBLK,1:nplotvar))
                if(okdebug)write(*,*)'  i=',ic1,'-',ic2,' j=',jc,' k=',kc
             end if
          end if
       end do; end do
    end if
    ! Y edges
    if (YarbNormal>0.01) then
       ic=ic1; jc=jc1; kc=kc1
       do ic=ic1,ic2,ic2-ic1; do kc=kc1,kc2,kc2-kc1
          if(iopt>-1 .and. (ic==ic1 .or. kc==kc1) .and. (ic/=0 .and. kc/=0)) CYCLE
          Xp=NodeX_IIIB(ic,jc,kc,iBLK)
          Zp=NodeZ_IIIB(ic,jc,kc,iBLK)
          Yp=YarbP-( XarbNormal*(Xp-XarbP) + ZarbNormal*(Zp-ZarbP) )/YarbNormal
          if ( Yp> NodeY_IIIB(ic,jc1,kc,iBLK) .and. &
               Yp<=NodeY_IIIB(ic,jc2,kc,iBLK) )then
             if(okdebug)write(*,*)'y-cut:',iopt,Xp,Yp,Zp
             if(iopt==-1)then
                nCuts=1; RETURN
             end if
             ! Cycle if outside of clipping box
             if ( Xp<xmin .or. Yp<ymin .or. Zp<zmin .or. &
                  Xp>xmax .or. Yp>ymax .or. Zp>zmax) CYCLE
             nCuts=nCuts+1
             if (iopt>0) then
                ! Write point values
                factor2=(Yp-NodeY_IIIB(ic,jc1,kc,iBLK))/ &
                     (NodeY_IIIB(ic,jc2,kc,iBLK)-NodeY_IIIB(ic,jc1,kc,iBLK))
                factor1=1.-factor2
                write(unit_tmp,fmt="(30(E14.6))") &
                     (factor1*NodeXYZ_III( ic,jc1,kc,:)+ &
                      factor2*NodeXYZ_III( ic,jc2,kc,:)), &
                     (factor1*PlotVarNodes(ic,jc1,kc,iBLK,1:nplotvar)+ &
                      factor2*PlotVarNodes(ic,jc2,kc,iBLK,1:nplotvar))
                if(okdebug)write(*,*)'  i=',ic,' j=',jc1,'-',jc2,' k=',kc
             end if
          end if
       end do; end do
    end if
    ! Z edges
    if (ZarbNormal>0.01) then
       ic=ic1; jc=jc1; kc=kc1
       do ic=ic1,ic2,ic2-ic1; do jc=jc1,jc2,jc2-jc1
          if(iopt>-1 .and. (ic==ic1 .or. jc==jc1) .and. (ic/=0 .and. jc/=0)) CYCLE
          Xp=NodeX_IIIB(ic,jc,kc,iBLK)
          Yp=NodeY_IIIB(ic,jc,kc,iBLK)
          Zp=ZarbP-( XarbNormal*(Xp-XarbP) + YarbNormal*(Yp-YarbP) )/ZarbNormal
          if ( Zp> NodeZ_IIIB(ic,jc,kc1,iBLK) .and. &
               Zp<=NodeZ_IIIB(ic,jc,kc2,iBLK) )then
             if(okdebug)write(*,*)'z-cut:',iopt,Xp,Yp,Zp
             if(iopt==-1)then
                nCuts=1; RETURN
             end if
             ! Cycle if outside of clipping box
             if ( Xp<xmin .or. Yp<ymin .or. Zp<zmin .or. &
                  Xp>xmax .or. Yp>ymax .or. Zp>zmax) CYCLE
             nCuts=nCuts+1
             if (iopt>0) then
                ! Write point values
                factor2=(Zp-NodeZ_IIIB(ic,jc,kc1,iBLK))/ &
                     (NodeZ_IIIB(ic,jc,kc2,iBLK)-NodeZ_IIIB(ic,jc,kc1,iBLK))
                factor1=1.-factor2
                write(unit_tmp,fmt="(30(E14.6))") &
                     (factor1*NodeXYZ_III( ic,jc,kc1,:)+ &
                      factor2*NodeXYZ_III( ic,jc,kc2,:)), &
                     (factor1*PlotVarNodes(ic,jc,kc1,iBLK,1:nplotvar)+ &
                      factor2*PlotVarNodes(ic,jc,kc2,iBLK,1:nplotvar))
                if(okdebug)write(*,*)'  i=',ic,' j=',jc,' k=',kc1,'-',kc2
             end if
          end if
       end do; end do
    end if

  end subroutine find_cuts

  subroutine write_auxdata
    character(len=8)  :: real_date
    character(len=10) :: real_time
    character(len=80) :: stmp

    !BLOCKS
    write(stmp,'(i12,3(a,i2))')nBlockALL,'  ',nI,' x',nJ,' x',nK
    write(unit_tmp,'(a,a,a)') 'AUXDATA BLOCKS="',trim(adjustl(stmp)),'"'

    !BODYDENSITY
    write(stmp,'(f12.2)')Body_rho_dim
    write(unit_tmp,'(a,a,a)') 'AUXDATA BODYDENSITY="',trim(adjustl(stmp)),'"'

    !^CFG IF BORISCORR BEGIN
    !BORIS
    if(boris_correction)then
       write(stmp,'(a,f8.4)')'T ',boris_cLIGHT_factor
    else
       write(stmp,'(a)')'F'
    end if
    write(unit_tmp,'(a,a,a)') 'AUXDATA BORIS="',trim(adjustl(stmp)),'"'
    !^CFG END BORISCORR

    !BTHETATILT
    write(stmp,'(f12.4)')ThetaTilt*cRadToDeg
    write(unit_tmp,'(a,a,a)') 'AUXDATA BTHETATILT="',trim(adjustl(stmp)),'"'

    !CELLS
    write(stmp,'(i12)')nBlockALL*nI*nJ*nK
    write(unit_tmp,'(a,a,a)') 'AUXDATA CELLS="',trim(adjustl(stmp)),'"'

    !CODEVERSION
    write(stmp,'(a,f5.2)')'BATSRUS',CodeVersion
    write(unit_tmp,'(a,a,a)') 'AUXDATA CODEVERSION="',trim(adjustl(stmp)),'"'

    !COORDSYSTEM
    write(stmp,'(a)')TypeCoordSystem
    write(unit_tmp,'(a,a,a)') 'AUXDATA COORDSYSTEM="',trim(adjustl(stmp)),'"'

    !COROTATION
    if(UseRotatingBc)then
       write(stmp,'(a)')'T'
    else
       write(stmp,'(a)')'F'
    end if
    write(unit_tmp,'(a,a,a)') 'AUXDATA COROTATION="',trim(adjustl(stmp)),'"'

    !FLUXTYPE
    write(stmp,'(a)')FluxType
    write(unit_tmp,'(a,a,a)') 'AUXDATA FLUXTYPE="',trim(adjustl(stmp)),'"'

    !GAMMA
    write(stmp,'(f14.6)')g
    write(unit_tmp,'(a,a,a)') 'AUXDATA GAMMA="',trim(adjustl(stmp)),'"'

    !ITER
    write(stmp,'(i12)')n_step
    write(unit_tmp,'(a,a,a)') 'AUXDATA ITER="',trim(adjustl(stmp)),'"'

    !NPROC
    write(stmp,'(i12)')nProc
    write(unit_tmp,'(a,a,a)') 'AUXDATA NPROC="',trim(adjustl(stmp)),'"'

    !ORDER
    if(nORDER==2)then
       if(limiter_type=='beta')then
          write(stmp,'(i12,a,e13.5)')nOrder,', beta=',BetaLimiter
       else
          write(stmp,'(i12,a)')nORDER,' '//trim(limiter_type)
       end if
    else
       write(stmp,'(i12)')nORDER
    end if
    write(unit_tmp,'(a,a,a)') 'AUXDATA ORDER="',trim(adjustl(stmp)),'"'

    !PROBLEMTYPE
    write(stmp,'(i12,a)')problem_type,' '//trim(StringProblemType_I(problem_type))
    write(unit_tmp,'(a,a,a)') 'AUXDATA PROBLEMTYPE="',trim(adjustl(stmp)),'"'

    !RBODY
    write(stmp,'(f12.2)')rBody
    write(unit_tmp,'(a,a,a)') 'AUXDATA RBODY="',trim(adjustl(stmp)),'"'

    !SAVEDATE
    call Date_and_time (real_date, real_time)
    write(stmp,'(a11,a4,a1,a2,a1,a2, a4,a2,a1,a2,a1,a2)') &
         'Save Date: ', real_date(1:4),'/',real_date(5:6),'/',real_date(7:8), &
         ' at ',  real_time(1:2),':',real_time(3:4),':',real_time(5:6)
    write(unit_tmp,'(a,a,a)') 'AUXDATA SAVEDATE="',trim(adjustl(stmp)),'"'

    !TIMEEVENT
    write(stmp,'(a)')textDateTime
    write(unit_tmp,'(a,a,a)') 'AUXDATA TIMEEVENT="',trim(adjustl(stmp)),'"'

    !TIMEEVENTSTART
    write(stmp,'(a)')textDateTime0
    write(unit_tmp,'(a,a,a)') 'AUXDATA TIMEEVENTSTART="',trim(adjustl(stmp)),'"'

    !TIMESIM
    if(time_accurate)then
       write(stmp,'(a)')'T='// &
            StringTimeH4M2S2(1:4)//":"// &
            StringTimeH4M2S2(5:6)//":"// &
            StringTimeH4M2S2(7:8)
    else
       write(stmp,'(a)')'T= N/A'
    end if
    write(unit_tmp,'(a,a,a)') 'AUXDATA TIMESIM="',trim(adjustl(stmp)),'"'

  end subroutine write_auxdata

end subroutine write_plot_tec
