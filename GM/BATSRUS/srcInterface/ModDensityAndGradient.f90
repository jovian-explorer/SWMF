!  Copyright (C) 2002 Regents of the University of Michigan, portions used with permission 
!  For more information, see http://csem.engin.umich.edu/tools/swmf
!This code is a copyright protected software (c) 2002- University of Michigan
!BOP
!MODULE: ModDensityAndGradient - provide the density and gradients at SC_Xyz_DI
!INTERFACE:
module ModDensityAndGradient
  !USES:
  use MH_domain_decomposition
  use CON_global_message_pass
  use ModMain, ONLY: MaxDim
  use ModProcMH, ONLY:iComm
  use ModMpi
  use ModAdvance, ONLY: State_VGB
  use ModVarIndexes, ONLY: Rho_
  implicit none
  private !Except
  logical,save :: DoInit=.true., DoInitDensityArr = .true.
  character(LEN=10),save::NameVector
  type(RouterType),save::Router
  type(GridDescriptorType),save::LineGrid,MhGrid
  type(DomainDecompositionType),save::LineDD
  real,allocatable,save,dimension(:)::Density_I,DeltaSNew_I
  real,allocatable,save,dimension(:,:)::GradDensity_DI
  real, allocatable, save :: GradDensity_DGB(:,:,:,:,:)
  real, allocatable,save, dimension(:,:,:,:)::Density_GB, DensityAux_GB
  !PUBLIC MEMBERS:
  public::get_plasma_density,NameVector,GradDensity_DI,Density_I,DeltaSNew_I,&
       GradDensity_DGB, Density_GB, DensityAux_GB, DoInitDensityArr
  !EOP

contains
  !==========================
  subroutine get_plasma_density(nRay)
    !
    ! Calculates plasma density, Density_I, and its gradient, 
    ! GradDensity_DI(3,nRay), at specified locations Position_DI(3,nRay)
    ! Also, it provides appropriate step, DeltaSNew_I, conceivably dependent
    ! on the numeric grid size
    !
    integer,intent(in)::nRay
    !\
    !Misc
    integer :: nU_I(2), iError

    call timing_start('get_plasma_density')
    if(DoInit)then
       DoInit=.false.
       call set_standard_grid_descriptor(&
            MH_DomainDecomposition,GridDescriptor=MhGrid)

       nU_I=ubound_vector(NameVector)
       call init_decomposition(LineDD,&
            compid_grid(MhGrid%DD%Ptr),1,&
            IsLocal=.true.)
       call get_root_decomposition(&
            LineDD,&                 !GridDescroptor to be constructed
            iRootMapDim_D=(/1/),&!The block amount, along each direction(D)
            XyzMin_D=(/cHalf/),&      !Minimal gen. coordinates, along each D 
            XyzMax_D=(/cHalf+nU_I(2)/),& !Maximal gen. coordinates, along each D
            nCells_D=(/nU_I(2)/))
       call set_standard_grid_descriptor(LineDD,&
            GridDescriptor=LineGrid)
       call init_router(&
            MhGrid,& !GridDesctriptor for the source field (in) 
            LineGrid,&   !GirdDescriptor,save,intent(out)
            Router,&   !resulting router, intent(out)
            nIndexTarget=1)
       DoInit=.false.
    end if

    call set_router(& 
         GridDescriptorSource=MhGrid,&
         GridDescriptorTarget=LineGrid,&
         Router=Router,&
         NameMappingVector=NameVector,&
         interpolate=interpolation_amr_gc)

    call global_message_pass(Router=Router,&
         nVar=MaxDim+1+1,&
         fill_buffer=get_density_local,&
         apply_buffer=put_density_value)

    call MPI_BCAST(GradDensity_DI(1,1),3*nRay,MPI_REAL,0,iComm,iError)
    call MPI_BCAST(Density_I(1),         nRay,MPI_REAL,0,iComm,iError)
    call MPI_BCAST(DeltaSNew_I(1),       nRay,MPI_REAL,0,iComm,iError)
    call timing_stop('get_plasma_density')
  end subroutine get_plasma_density
  !================================================
  subroutine get_density_local(&
       nPartial,iGetStart,Get,W,State_V,nVar)
    !USES:
    use ModGeometry,ONLY: CellSize_DB, x_, y_, z_
    use ModPhysics, ONLY: No2Si_V, UnitRho_
    use CON_router
    !INPUT ARGUMENTS:
    integer,intent(in)::nPartial,iGetStart,nVar
    type(IndexPtrType),intent(in)::Get
    type(WeightPtrType),intent(in)::W
    real,dimension(nVar),intent(out)::State_V

    integer::iGet, i, j, k, iBlock
    real :: Weight
    !----------------------------------------------------------
    i      = Get%iCB_II(1,iGetStart)
    j      = Get%iCB_II(2,iGetStart)
    k      = Get%iCB_II(3,iGetStart)
    iBlock = Get%iCB_II(4,iGetStart)
    Weight = W%Weight_I(iGetStart)
    State_V(1:MaxDim)= Weight*GradDensity_DGB(1:MaxDim,i,j,k,iBlock)
    State_V(MaxDim+1)= Weight*&
         State_VGB(rho_,i,j,k,iBlock)
    State_V(MaxDim+1+1)=Weight*&
         minval(CellSize_DB(:,iBlock))

    do iGet=iGetStart+1,iGetStart+nPartial-1
       i      = Get%iCB_II(1,iGet)
       j      = Get%iCB_II(2,iGet)
       k      = Get%iCB_II(3,iGet)
       iBlock = Get%iCB_II(4,iGet)
       Weight = W%Weight_I(iGet)
       State_V(1:MaxDim)= State_V(1:MaxDim) + Weight*&
            GradDensity_DGB(1:MaxDim,i,j,k,iBlock)
       State_V(MaxDim+1)  = State_V(MaxDim+1)+Weight*&
            State_VGB(rho_,i,j,k,iBlock)
       State_V(MaxDim+1+1)= State_V(MaxDim+1+1)+Weight*&
            minval(CellSize_DB(:,iBlock))

    end do
    !Convert density to SI
    State_V(1:MaxDim+1) = State_V(1:MaxDim+1) * No2Si_V(UnitRho_)
  end subroutine get_density_local

  !====================================================================

  subroutine put_density_value(nPartial,&
       iPutStart,&
       Put,&
       W,&
       DoAdd,&
       Buff_I,nVar)
    implicit none
    integer,intent(in)::nPartial,iPutStart,nVar
    type(IndexPtrType),intent(in)::Put
    type(WeightPtrType),intent(in)::W
    logical,intent(in)::DoAdd
    real,dimension(nVar),intent(in)::Buff_I
    integer::iCell

    iCell=Put%iCB_II(1,iPutStart)
    !Convert densities from kg/m3 to g/cm3, 
    !the transformation coefficient is 1.0e-3
    if(DoAdd)then
       GradDensity_DI(:,iCell)= GradDensity_DI(:,iCell)+&
            Buff_I(1:MaxDim) * 1.0e-3
       Density_I(iCell)= Density_I(iCell)+&
            Buff_I(MaxDim+1) * 1.0e-3
       DeltaSNew_I(iCell) = DeltaSNew_I(iCell)+&
            Buff_I(MaxDim+1+1)
    else
       GradDensity_DI(:,iCell)= &
            Buff_I(1:MaxDim)  * 1.0e-3
       Density_I(iCell)= &
            Buff_I(MaxDim+1)  * 1.0e-3
       DeltaSNew_I(iCell) = &
            Buff_I(MaxDim+1+1)
    end if
  end subroutine put_density_value
end module ModDensityAndGradient
subroutine update_grad_density
  use ModDensityAndGradient
  use BATL_lib, ONLY: &
       MaxDim, nDim, jDim_, kDim_, Unused_B, &
       CellSize_DB, Xyz_DGB, CellVolume_GB, &
       MinI,MinJ,MinK, MaxI,MaxJ,MaxK, MaxBlock, nI, nJ, nK, nBlock
  use BATL_pass_cell, ONLY: message_pass_cell
  use ModCellGradient, ONLY: calc_gradient
  use ModFaceGradient, ONLY: set_block_field2
  use ModAdvance, ONLY: State_VGB
  use ModVarIndexes, ONLY: Rho_
  integer, parameter :: nG = 1
  integer:: iBlock
  !------------------
  if(DoInitDensityArr)then
     DoInitDensityArr = .false.
     allocate(GradDensity_DGB(nDim,1-nG:nI+nG,1-nG*jDim_:nJ+nG*jDim_,&
          1-nG*kDim_:nK+nG*kDim_,MaxBlock))
     GradDensity_DGB = 0.0
     allocate(Density_GB(MinI:MaxI,MinJ:MaxJ,MinK:MaxK,1:MaxBlock))
     Density_GB = 0.0
     allocate(DensityAux_GB(MinI:MaxI,MinJ:MaxJ,MinK:MaxK,1:MaxBlock))
     DensityAux_GB = 0.0       
  end if
  do iBlock = 1, nBlock
     if(Unused_B(iBlock))CYCLE
     Density_GB(1:nI,1:nJ,1:nK,iBlock) = &
          State_VGB(Rho_,1:nI,1:nJ,1:nK,iBlock)
  end do
  ! fill ghost celss via message pass
  call message_pass_cell(&
                                !           nG              = 1, &
       State_GB        = Density_GB, &
       nProlongOrderIn = 1)

  do iBlock = 1, nBlock
     if(Unused_B(iBlock))CYCLE
     ! correct ghost cells
     call set_block_field2(&
          iBlock    = iBlock, &
          nVar      = 1, &
          Field1_VG = DensityAux_GB, &
          Field_VG  = Density_GB)
     ! compute gradient
     call calc_gradient(iBlock, Density_GB(:,:,:,iBlock), nG, &
          GradDensity_DGB(:,:,:,:,iBlock))
  end do
  ! fill ghost cells for gradient via message pass
  call message_pass_cell(&
       nVar            = nDim,&
       nG              = 1, &
       State_VGB       = GradDensity_DGB, &
       nProlongOrderIn = 1)
end subroutine update_grad_density
