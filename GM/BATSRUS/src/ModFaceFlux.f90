module ModFaceFlux

  use ModProcMH, ONLY: iProc
  use ModMain,       ONLY: x_, y_, z_, nI, nJ, nK
  use ModMain,       ONLY: UseBorisSimple                 !^CFG IF SIMPLEBORIS
  use ModMain,       ONLY: UseBoris => boris_correction   !^CFG IF BORISCORR
  use ModVarIndexes, ONLY: nVar, NameVar_V, UseMultiSpecies, UseMultiIon, &
       nFluid, nIonFluid, iVarFluid_I, TypeFluid_I
  use ModGeometry,   ONLY: fAx_BLK, fAy_BLK, fAz_BLK, dx_BLK, dy_BLK, dz_BLK
  use ModGeometry,   ONLY: x_BLK, y_BLK, z_BLK

  use ModGeometry,   ONLY: UseCovariant, &                !^CFG IF COVARIANT 
       FaceAreaI_DFB, FaceAreaJ_DFB, FaceAreaK_DFB, &     !^CFG IF COVARIANT 
       FaceArea2MinI_B, FaceArea2MinJ_B, FaceArea2MinK_B  !^CFG IF COVARIANT 

  use ModAdvance, ONLY:&
       B0xFace_x_BLK, B0yFace_x_BLK, B0zFace_x_BLK, & ! input: face X B0
       B0xFace_y_BLK, B0yFace_y_BLK, B0zFace_y_BLK, & ! input: face Y B0
       B0xFace_z_BLK, B0yFace_z_BLK, B0zFace_z_BLK, & ! input: face Z B0
       LeftState_VX,  LeftState_VY,  LeftState_VZ,  & ! input: left  face state
       RightState_VX, RightState_VY, RightState_VZ, & ! input: right face state
       Flux_VX, Flux_VY, Flux_VZ,        & ! output: face flux
       VdtFace_x, VdtFace_y, VdtFace_z,  & ! output: cMax*Area for CFL
       EDotFA_X, EDotFA_Y, EDotFA_Z,     & ! output: E.Area for Boris !^CFG IF BORISCORR
       uDotArea_XI, uDotArea_YI, uDotArea_ZI,& ! output: U.Area for P source
       bCrossArea_DX, bCrossArea_DY, bCrossArea_DZ,& ! output: B x Area for J
       UseRS7
  use ModHallResist, ONLY: UseHallResist, HallCmaxFactor, IonMassPerCharge_G, &
       IsNewBlockHall, hall_factor, get_face_current, set_ion_mass_per_charge

  use ModResistivity, ONLY: UseResistivity, Eta_GB  !^CFG IF DISSFLUX
  use ModMultiFluid
  use ModNumConst
  implicit none

  ! Number of fluxes including pressure and energy fluxes
  integer, parameter :: nFlux=nVar+nFluid

  logical :: DoLf                !^CFG IF RUSANOVFLUX
  logical :: DoHll               !^CFG IF LINDEFLUX
  logical :: DoAw                !^CFG IF AWFLUX
  logical :: DoRoe               !^CFG IF ROEFLUX
  logical :: DORoeNew            !^CFG IF ROEFLUX

  logical :: DoTestCell

  integer :: iFace, jFace, kFace, iBlockFace

  real :: StateLeft_V(nVar), StateRight_V(nVar)
  real :: FluxLeft_V(nFlux), FluxRight_V(nFlux)
  real :: StateLeftCons_V(nFlux), StateRightCons_V(nFlux)
  real :: DissipationFlux_V(nFlux)
  real :: B0x, B0y, B0z
  real :: Area, Area2, AreaX, AreaY, AreaZ
  real :: CmaxDt, UnLeft, UnRight
  real :: Unormal_I(nFluid), UnLeft_I(nFluid), UnRight_I(nFluid)
  real :: bCrossArea_D(3)
  real :: Enormal                !^CFG IF BORISCORR

  ! Variables for normal resistivity
  real :: EtaJx, EtaJy, EtaJz, Eta = -1.0

  ! Variables needed for Hall resistivity
  real :: InvDxyz, HallCoeff, HallUnLeft, HallUnRight, &
       HallJx, HallJy, HallJz

  character(len=*), private, parameter :: NameMod="ModFaceFlux"
contains
  !===========================================================================
  subroutine calc_face_flux(DoResChangeOnly, iBlock)

    use ModAdvance,  ONLY: UseRS7,TypeFlux => FluxType
    use ModParallel, ONLY: &
         neiLtop, neiLbot, neiLeast, neiLwest, neiLnorth, neiLsouth
    use ModMain, ONLY: nI, nJ, nK, nIFace, nJFace, nKFace, &
         jMinFaceX, jMaxFaceX, kMinFaceX, kMaxFaceX, &
         iMinFaceY, iMaxFaceY, kMinFaceY,kMaxFaceY, &
         iMinFaceZ,iMaxFaceZ, jMinFaceZ, jMaxFaceZ, &
         iTest, jTest, kTest, ProcTest, BlkTest, DimTest
    use ModPhysics,  ONLY: Clight

    implicit none

    logical, intent(in) :: DoResChangeOnly
    integer, intent(in) :: iBlock
    logical :: DoTest, DoTestMe
    !--------------------------------------------------------------------------

    iBlockFace = iBlock

    if(iProc==PROCtest .and. iBlock==BLKtest)then
       call set_oktest('calc_face_flux', DoTest, DoTestMe)
    else
       DoTest=.false.; DoTestMe=.false.
    end if

    if(DoTestMe)call print_values

    DoLf  = TypeFlux == 'Rusanov'     !^CFG IF RUSANOVFLUX
    DoHLL = TypeFlux == 'Linde'       !^CFG IF LINDEFLUX
    DoAw  = TypeFlux == 'Sokolov'     !^CFG IF AWFLUX
    DoRoe = TypeFlux == 'Roe'.and.(.not.UseRS7)!^CFG IF ROEFLUX
    DoRoeNew= TypeFlux == 'Roe'.and.UseRS7     !^CFG IF ROEFLUX

    ! Make sure that Hall MHD recalculates the magnetic field 
    ! in the current block that will be used for the Hall term
    IsNewBlockHall = .true.

    if(UseResistivity) call set_resistivity(iBlock)      !^CFG IF DISSFLUX

    if(UseHallResist .and. UseMultiSpecies) &
         call set_ion_mass_per_charge(iBlock)
 
    if (DoResChangeOnly) then
       if(neiLeast(iBlock) == 1)call get_flux_x(1,1,1,nJ,1,nK)
       if(neiLwest(iBlock) == 1)call get_flux_x(nIFace,nIFace,1,nJ,1,nK)
       if(neiLsouth(iBlock)== 1)call get_flux_y(1,nI,1,1,1,nK)
       if(neiLnorth(iBlock)== 1)call get_flux_y(1,nI,nJFace,nJFace,1,nK)
       if(neiLbot(iBlock)  == 1)call get_flux_z(1,nI,1,nJ,1,1)
       if(neiLtop(iBlock)  == 1)call get_flux_z(1,nI,1,nJ,nKFace,nKFace)
    else
       call get_flux_x(1,nIFace,jMinFaceX,jMaxFaceX,kMinFaceX,kMaxFaceX)
       call get_flux_y(iMinFaceY,iMaxFaceY,1,nJFace,kMinFaceY,kMaxFaceY)
       call get_flux_z(iMinFaceZ,iMaxFaceZ,jMinFaceZ,jMaxFaceZ,1,nKFace)
    end if

  contains
    !=========================================================================
    subroutine print_values
      integer :: iVar
      !---------------------------------------------------------------------
      if(DoResChangeOnly)then
         write(*,*)'calc_facefluxes for DoResChangeOnly'
         RETURN
      end if

      if(DimTest==x_ .or. DimTest==0)then
         write(*,*)&
              'Calc_facefluxes, left and right states at i-1/2 and i+1/2:'

         do iVar=1,nVar
            write(*,'(2a,4(1pe13.5))')NameVar_V(iVar),'=',&
                 LeftState_VX(iVar,iTest,jTest,kTest),&
                 RightState_VX(iVar,iTest,  jTest,kTest),&
                 LeftState_VX(iVar,iTest+1,jTest,kTest),&
                 RightState_VX(iVar,iTest+1,jTest,kTest)
         end do
         write(*,'(a,1pe13.5,a13,1pe13.5)')'B0x:',&
              B0xFace_x_BLK(iTest,jTest,kTest,BlkTest),' ',&
              B0xFace_x_BLK(iTest+1,jTest,kTest,BlkTest)
         write(*,'(a,1pe13.5,a13,1pe13.5)')'B0y:',&
              B0yFace_x_BLK(iTest,jTest,kTest,BlkTest),' ',&
              B0yFace_x_BLK(iTest+1,jTest,kTest,BlkTest)
         write(*,'(a,1pe13.5,a13,1pe13.5)')'B0z:',&
              B0zFace_x_BLK(iTest,jTest,kTest,BlkTest),' ',&
              B0zFace_x_BLK(iTest+1,jTest,kTest,BlkTest)
      end if

      if(DimTest==y_ .or. DimTest==0)then
         write(*,*)&
              'Calc_facefluxes, left and right states at j-1/2 and j+1/2:'

         do iVar=1,nVar
            write(*,'(2a,4(1pe13.5))')NameVar_V(iVar),'=',&
                 LeftState_VY(iVar,iTest,jTest,kTest),&
                 RightState_VY(iVar,iTest,  jTest,kTest),&
                 LeftState_VY(iVar,iTest,jTest+1,kTest),&
                 RightState_VY(iVar,iTest,jTest+1,kTest)
         end do
         write(*,'(a,1pe13.5,a13,1pe13.5)')'B0x:',&
              B0xFace_y_BLK(iTest,jTest,kTest,BlkTest),' ',&
              B0xFace_y_BLK(iTest,jTest+1,kTest,BlkTest)
         write(*,'(a,1pe13.5,a13,1pe13.5)')'B0y:',&
              B0yFace_y_BLK(iTest,jTest,kTest,BlkTest),' ',&
              B0yFace_y_BLK(iTest,jTest+1,kTest,BlkTest)
         write(*,'(a,1pe13.5,a13,1pe13.5)')'B0z:',&
              B0zFace_y_BLK(iTest,jTest,kTest,BlkTest),' ',&
              B0zFace_y_BLK(iTest,jTest+1,kTest,BlkTest)
      end if

      if(DimTest==z_ .or. DimTest==0)then
         do iVar=1,nVar
            write(*,'(2a,4(1pe13.5))')NameVar_V(iVar),'=',&
                 LeftState_VZ(iVar,iTest,jTest,kTest),&
                 RightState_VZ(iVar,iTest,  jTest,kTest),&
                 LeftState_VZ(iVar,iTest,jTest,kTest+1),&
                 RightState_VZ(iVar,iTest,jTest,kTest+1)
         end do
         write(*,'(a,1pe13.5,a13,1pe13.5)')'B0x:',&
              B0xFace_z_BLK(iTest,jTest,kTest,BlkTest),' ',&
              B0xFace_z_BLK(iTest,jTest,kTest+1,BlkTest)
         write(*,'(a,1pe13.5,a13,1pe13.5)')'B0y:',&
              B0yFace_z_BLK(iTest,jTest,kTest,BlkTest),' ',&
              B0yFace_z_BLK(iTest,jTest,kTest+1,BlkTest)
         write(*,'(a,1pe13.5,a13,1pe13.5)')'B0z:',&
              B0zFace_z_BLK(iTest,jTest,kTest,BlkTest),' ',&
              B0zFace_z_BLK(iTest,jTest,kTest+1,BlkTest)
      end if

    end subroutine print_values

    !==========================================================================

    subroutine get_flux_x(iMin,iMax,jMin,jMax,kMin,kMax)
      integer, intent(in):: iMin,iMax,jMin,jMax,kMin,kMax
      !-----------------------------------------------------------------------
      call set_block_values(x_)

      do kFace = kMin, kMax; do jFace = jMin, jMax; do iFace = iMin, iMax
         
         call set_cell_values_x

         DoTestCell = DoTestMe &
              .and. (iFace == iTest .or. iFace == iTest+1) &
              .and. jFace == jTest .and. kFace == kTest

         B0x = B0xFace_x_BLK(iFace, jFace, kFace, iBlockFace)
         B0y = B0yFace_x_BLK(iFace, jFace, kFace, iBlockFace)
         B0z = B0zFace_x_BLK(iFace, jFace, kFace, iBlockFace)
         StateLeft_V  = LeftState_VX( :, iFace, jFace, kFace)
         StateRight_V = RightState_VX(:, iFace, jFace, kFace)

         call get_numerical_flux(x_, Flux_VX(:,iFace, jFace, kFace))

         VdtFace_x(iFace, jFace, kFace)        = CmaxDt
         uDotArea_XI(iFace, jFace, kFace, :)   = Unormal_I
         bCrossArea_DX(:, iFace, jFace, kFace) = bCrossArea_D
         EDotFA_X(iFace, jFace, kFace)         = Enormal !^CFG IF BORISCORR

      end do; end do; end do
    end subroutine get_flux_x

    !==========================================================================

    subroutine get_flux_y(iMin,iMax,jMin,jMax,kMin,kMax)
      integer, intent(in):: iMin,iMax,jMin,jMax,kMin,kMax
      !------------------------------------------------------------------------
      call set_block_values(y_)

      do kFace = kMin, kMax; do jFace = jMin, jMax; do iFace = iMin, iMax

         call set_cell_values_y

         DoTestCell = DoTestMe .and. iFace == iTest .and. &
              (jFace == jTest .or. jFace == jTest+1) .and. kFace == kTest

         B0x = B0xFace_y_BLK(iFace, jFace, kFace, iBlockFace)
         B0y = B0yFace_y_BLK(iFace, jFace, kFace, iBlockFace)
         B0z = B0zFace_y_BLK(iFace, jFace, kFace, iBlockFace)
         StateLeft_V  = LeftState_VY( :, iFace, jFace, kFace)
         StateRight_V = RightState_VY(:, iFace, jFace, kFace)

         call get_numerical_flux(y_, Flux_VY(:, iFace, jFace, kFace))

         VdtFace_y(iFace, jFace, kFace)        = CmaxDt
         uDotArea_YI(iFace, jFace, kFace, :)   = Unormal_I
         bCrossArea_DY(:, iFace, jFace, kFace) = bCrossArea_D
         EDotFA_Y(iFace, jFace, kFace)         = Enormal !^CFG IF BORISCORR

      end do; end do; end do

    end subroutine get_flux_y

    !==========================================================================

    subroutine get_flux_z(iMin, iMax, jMin, jMax, kMin, kMax)
      integer, intent(in):: iMin, iMax, jMin, jMax, kMin, kMax
      !------------------------------------------------------------------------
      call set_block_values(z_)

      do kFace = kMin, kMax; do jFace = jMin, jMax; do iFace = iMin, iMax

         call set_cell_values_z

         DoTestCell = DoTestMe .and. iFace == iTest .and. &
              jFace == jTest .and. (kFace == kTest .or. kFace == kTest+1)

         B0x = B0xFace_z_BLK(iFace, jFace, kFace,iBlockFace)
         B0y = B0yFace_z_BLK(iFace, jFace, kFace,iBlockFace)
         B0z = B0zFace_z_BLK(iFace, jFace, kFace,iBlockFace)
         StateLeft_V  = LeftState_VZ( :, iFace, jFace, kFace)
         StateRight_V = RightState_VZ(:, iFace, jFace, kFace)

         call get_numerical_flux(z_, Flux_VZ(:, iFace, jFace, kFace))

         VdtFace_z(iFace, jFace, kFace)        = CmaxDt
         uDotArea_ZI(iFace, jFace, kFace, :)   = Unormal_I
         bCrossArea_DZ(:, iFace, jFace, kFace) = bCrossArea_D
         EDotFA_Z(iFace, jFace, kFace)         = Enormal !^CFG IF BORISCORR

      end do; end do; end do
    end subroutine get_flux_z

  end subroutine calc_face_flux

  !===========================================================================
  subroutine set_block_values(iDim)
    integer, intent(in) :: iDim

    if(UseCovariant) RETURN    !^CFG IF COVARIANT

    AreaX = 0.0; AreaY = 0.0; AreaZ = 0.0
    select case(iDim)
    case(x_)
       Area    = fAx_BLK(iBlockFace)
       AreaX   = Area
       InvDxyz = 1./dx_BLK(iBlockFace)
    case(y_)
       Area    = fAy_BLK(iBlockFace)
       AreaY   = Area
       InvDxyz = 1./dy_BLK(iBlockFace)
    case(z_)
       Area    = fAz_BLK(iBlockFace)
       AreaZ   = Area
       InvDxyz = 1./dz_BLK(iBlockFace)
    end select
    Area2 = Area**2

  end subroutine set_block_values
  !===========================================================================
  subroutine set_cell_values_x

    HallCoeff = -1.0
    if(UseHallResist) HallCoeff =                           &
         0.5*hall_factor(x_, iFace, jFace, kFace, iBlockFace)* &
         ( IonMassPerCharge_G(iFace  ,jFace,kFace)          &
         + IonMassPerCharge_G(iFace-1,jFace,kFace) )

    Eta       = -1.0                                !^CFG IF DISSFLUX BEGIN
    if(UseResistivity) Eta = 0.5* &
         ( Eta_GB(iFace  ,jFace,kFace,iBlockFace) &
         + Eta_GB(iFace-1,jFace,kFace,iBlockFace))  !^CFG END DISSFLUX

    if(UseCovariant)then                   !^CFG IF COVARIANT BEGIN
       AreaX = FaceAreaI_DFB(x_, iFace, jFace, kFace, iBlockFace)
       AreaY = FaceAreaI_DFB(y_, iFace, jFace, kFace, iBlockFace)
       AreaZ = FaceAreaI_DFB(z_, iFace, jFace, kFace, iBlockFace)
       Area2 = max(AreaX**2 + AreaY**2 + AreaZ**2, &
            FaceArea2MinI_B(iBlockFace))
       Area = sqrt(Area2)

       if(HallCoeff > 0.0 .or. Eta > 0.0)&
            InvDxyz  = 1.0/sqrt(&
            ( x_BLK(iFace  , jFace, kFace, iBlockFace)       &
            - x_BLK(iFace-1, jFace, kFace, iBlockFace))**2 + &
            ( y_BLK(iFace  , jFace, kFace, iBlockFace)       &
            - y_BLK(iFace-1, jFace, kFace, iBlockFace))**2 + &
            ( z_BLK(iFace  , jFace, kFace, iBlockFace)       &
            - z_BLK(iFace-1, jFace, kFace, iBlockFace))**2 )
       
    end if                                 !^CFG END COVARIANT

  end subroutine set_cell_values_x

  !===========================================================================
  subroutine set_cell_values_y

    HallCoeff = -1.0
    if(UseHallResist) HallCoeff =                           &
         0.5*hall_factor(y_, iFace, jFace, kFace, iBlockFace)* &
         ( IonMassPerCharge_G(iFace,jFace  ,kFace)          &
         + IonMassPerCharge_G(iFace,jFace-1,kFace) )

    Eta       = -1.0                                !^CFG IF DISSFLUX BEGIN
    if(UseResistivity) Eta = 0.5* &
         ( Eta_GB(iFace,jFace  ,kFace,iBlockFace) &
         + Eta_GB(iFace,jFace-1,kFace,iBlockFace))  !^CFG END DISSFLUX

    if(UseCovariant)then                   !^CFG IF COVARIANT BEGIN
       AreaX = FaceAreaJ_DFB(x_, iFace, jFace, kFace, iBlockFace)
       AreaY = FaceAreaJ_DFB(y_, iFace, jFace, kFace, iBlockFace)
       AreaZ = FaceAreaJ_DFB(z_, iFace, jFace, kFace, iBlockFace)
       Area2 = max(AreaX**2 + AreaY**2 + AreaZ**2, &
            FaceArea2MinJ_B(iBlockFace))
       Area = sqrt(Area2)

       if(HallCoeff > 0.0 .or. Eta > 0.0)&
            InvDxyz  = 1.0/sqrt(&
            ( x_BLK(iFace, jFace  , kFace, iBlockFace)       &
            - x_BLK(iFace, jFace-1, kFace, iBlockFace))**2 + &
            ( y_BLK(iFace, jFace  , kFace, iBlockFace)       &
            - y_BLK(iFace, jFace-1, kFace, iBlockFace))**2 + &
            ( z_BLK(iFace, jFace  , kFace, iBlockFace)       &
            - z_BLK(iFace, jFace-1, kFace, iBlockFace))**2 )

    end if                                 !^CFG END COVARIANT

  end subroutine set_cell_values_y
  !===========================================================================

  subroutine set_cell_values_z

    HallCoeff = -1.0
    if(UseHallResist) HallCoeff =                           &
         0.5*hall_factor(z_, iFace, jFace, kFace, iBlockFace)* &
         ( IonMassPerCharge_G(iFace,jFace,kFace  )          &
         + IonMassPerCharge_G(iFace,jFace,kFace-1) )

    Eta       = -1.0                                !^CFG IF DISSFLUX BEGIN
    if(UseResistivity) Eta = 0.5* &
         ( Eta_GB(iFace,jFace,kFace  ,iBlockFace) &
         + Eta_GB(iFace,jFace,kFace-1,iBlockFace))  !^CFG END DISSFLUX

    if(UseCovariant)then                   !^CFG IF COVARIANT BEGIN
       AreaX = FaceAreaK_DFB(x_, iFace, jFace, kFace, iBlockFace)
       AreaY = FaceAreaK_DFB(y_, iFace, jFace, kFace, iBlockFace)
       AreaZ = FaceAreaK_DFB(z_, iFace, jFace, kFace, iBlockFace)
       Area2 = max(AreaX**2 + AreaY**2 + AreaZ**2, &
            FaceArea2MinK_B(iBlockFace))
       Area = sqrt(Area2)

       if(HallCoeff > 0.0 .or. Eta > 0.0)&
            InvDxyz  = 1.0/sqrt(&
            ( x_BLK(iFace, jFace, kFace  , iBlockFace)       &
            - x_BLK(iFace, jFace, kFace-1, iBlockFace))**2 + &
            ( y_BLK(iFace, jFace, kFace  , iBlockFace)       &
            - y_BLK(iFace, jFace, kFace-1, iBlockFace))**2 + &
            ( z_BLK(iFace, jFace, kFace  , iBlockFace)       &
            - z_BLK(iFace, jFace, kFace-1, iBlockFace))**2 )

    end if                                 !^CFG END COVARIANT

  end subroutine set_cell_values_z

  !=========================================================================
  subroutine get_numerical_flux(iDir, Flux_V)

    use ModVarIndexes, ONLY: U_, Bx_, By_, Bz_, &
         UseMultiSpecies, SpeciesFirst_, SpeciesLast_, Rho_
    use ModAdvance, ONLY: DoReplaceDensity
    use ModCharacteristicMhd,ONLY:dissipation_matrix

    integer, intent(in) :: iDir
    real,    intent(out):: Flux_V(nFlux)

    real :: State_V(nVar)

    real :: Cmax
    real :: DiffBn, DiffBx, DiffBy, DiffBz, DiffBb, DiffE
    real :: EnLeft, EnRight, Jx, Jy, Jz
    !-----------------------------------------------------------------------

    if(UseMultiSpecies .and. DoReplaceDensity)then
       StateLeft_V (Rho_)=sum( StateLeft_V(SpeciesFirst_:SpeciesLast_) )
       StateRight_V(Rho_)=sum( StateRight_V(SpeciesFirst_:SpeciesLast_) )
    end if

    if(DoRoeNew)call dissipation_matrix(iDir,&
         StateLeft_V,StateRight_V,B0x,B0y,B0z,DissipationFlux_V,cMax,UNormal_I(1),&
         is_boundary_face(),.false.)

    if(UseRS7 &
         .or. DoHll &               !^CFG IF LINDEFLUX
         .or. DoAw  &               !^CFG IF AWFLUX
         )then
       ! Sokolov's algorithm
       ! Calculate and store the jump in the normal magnetic field
       DiffBn    = 0.5* &
            ( (StateRight_V(Bx_) - StateLeft_V(Bx_))*AreaX &
            + (StateRight_V(By_) - StateLeft_V(By_))*AreaY &
            + (StateRight_V(Bz_) - StateLeft_V(Bz_))*AreaZ ) / Area2

       ! Calculate the Cartesian components
       DiffBx    = AreaX*DiffBn
       DiffBy    = AreaY*DiffBn
       DiffBz    = AreaZ*DiffBn

       ! Remove the jump in the normal magnetic field
       StateLeft_V(Bx_)  =  StateLeft_V(Bx_)  + DiffBx
       StateLeft_V(By_)  =  StateLeft_V(By_)  + DiffBy
       StateLeft_V(Bz_)  =  StateLeft_V(Bz_)  + DiffBz
       StateRight_V(Bx_) =  StateRight_V(Bx_) - DiffBx
       StateRight_V(By_) =  StateRight_V(By_) - DiffBy
       StateRight_V(Bz_) =  StateRight_V(Bz_) - DiffBz

       ! The energy jump is also modified by 
       ! 1/2(Br^2 - Bl^2) = 1/2(Br-Bl)*(Br+Bl)
       ! We store half of this in DiffE
       DiffE = 0.5*( &
            (StateRight_V(Bx_) + StateLeft_V(Bx_))*DiffBx + &
            (StateRight_V(By_) + StateLeft_V(By_))*DiffBy + &
            (StateRight_V(Bz_) + StateLeft_V(Bz_))*DiffBz )

       DiffBb=(DiffBx**2 + DiffBy**2 + DiffBz**2)

    end if

    ! Calculate current for the face
    if(HallCoeff > 0.0 .or. Eta > 0.0) &
         call get_face_current(iDir,iFace,jFace,kFace,iBlockFace,Jx,Jy,Jz)

    if(Eta > 0.0)then                  !^CFG IF DISSFLUX BEGIN
       EtaJx = Eta*Jx
       EtaJy = Eta*Jy
       EtaJz = Eta*Jz
    end if                             !^CFG END DISSFLUX

    if(HallCoeff > 0.0)then
       HallJx = HallCoeff*Jx
       HallJy = HallCoeff*Jy
       HallJz = HallCoeff*Jz
    end if

    call get_physical_flux(iDir, StateLeft_V, B0x, B0y, B0z,&
         StateLeftCons_V, FluxLeft_V, UnLeft_I, EnLeft, HallUnLeft)

    call get_physical_flux(iDir, StateRight_V, B0x, B0y, B0z,&
         StateRightCons_V, FluxRight_V, UnRight_I, EnRight, HallUnRight)

    if(UseRS7)then
       iFluid=1
       call modify_flux(FluxLeft_V,UnLeft_I(1))
       call modify_flux(FluxRight_V,UnRight_I(1))
    end if
    ! All the solvers below use the average state
    State_V = 0.5*(StateLeft_V + StateRight_V)

    if(DoLf)  call lax_friedrichs_flux       !^CFG IF RUSANOVFLUX
    if(DoHll) call harten_lax_vanleer_flux   !^CFG IF LINDEFLUX
    if(DoAw)  call artificial_wind           !^CFG IF AWFLUX
    if(DoRoe) call roe_solver(iDir, Flux_V)  !^CFG IF ROEFLUX
    if(DoRoeNew)call roe_solver_new          !^CFG IF ROEFLUX

    ! Increase maximum speed with resistive diffusion speed if necessary
    if(Eta > 0.0) CmaxDt = CmaxDt + 2*Eta*InvDxyz*Area !^CFG IF DISSFLUX

    if(DoTestCell)call write_test_info

  contains
    subroutine modify_flux(Flux_V,Un)
      use ModVarIndexes,ONLY:RhoUx_,RhoUz_,Energy_
      real,intent(in)::Un
      real,dimension(nVar+1),intent(inout)::Flux_V
      !----------------------------------------------------
      Flux_V(RhoUx_:RhoUz_) = Flux_V(RhoUx_:RhoUz_)+&
           cHalf*DiffBb*(/AreaX,AreaY,AreaZ/)
      Flux_V(Energy_)       = Flux_V(Energy_)+Un   * DiffBb
    end subroutine modify_flux
    logical function is_boundary_face()
      use ModGeometry, ONLY: true_cell
  
      is_boundary_face=&
           (iDir==1.and.(true_cell(iFace-1, jFace, kFace, iBlockFace) &
           .neqv.     true_cell(iFace  , jFace, kFace, iBlockFace)))&
           .or.&
           (iDir==2.and.(true_cell(iFace, jFace-1, kFace, iBlockFace) &
           .neqv.     true_cell(iFace, jFace  , kFace, iBlockFace)))&
           .or.&
           (iDir==3.and.(true_cell(iFace, jFace, kFace-1, iBlockFace) &
           .neqv.     true_cell(iFace, jFace, kFace  , iBlockFace)))
    end function is_boundary_face
    !==========================================================================
    subroutine roe_solver_new
      Flux_V = 0.5*(FluxLeft_V  + FluxRight_V) &
           +DissipationFlux_V*Area

      Unormal_I = UNormal_I*Area
      cMax    = cMax*Area
      cMaxDt = cMax
    end subroutine roe_solver_new
    !^CFG IF RUSANOVFLUX BEGIN
    !==========================================================================
    subroutine lax_friedrichs_flux

      call get_speed_max(iDir, State_V, B0x, B0y, B0z, Cmax = Cmax)

      Flux_V = 0.5*(FluxLeft_V + FluxRight_V &
           - Cmax*(StateRightCons_V - StateLeftCons_V))

      Unormal_I = 0.5*(UnLeft_I + UnRight_I)
      Enormal   = 0.5*(EnLeft + EnRight)                !^CFG IF BORISCORR

    end subroutine lax_friedrichs_flux
    !^CFG END RUSANOVFLUX
    !^CFG IF LINDEFLUX BEGIN
    !==========================================================================
    subroutine harten_lax_vanleer_flux

      use ModVarIndexes, ONLY: B_, Energy_

      real :: Cleft,  CleftStateLeft, CleftStateAverage
      real :: Cright, CrightStateRight, CrightStateAverage
      real :: WeightLeft, WeightRight, Diffusion
      !-----------------------------------------------------------------------

      call get_speed_max(iDir, StateLeft_V,  B0x, B0y, B0z, &
           Cleft =CleftStateLeft)
      call get_speed_max(iDir, StateRight_V, B0x, B0y, B0z, &
           Cright=CrightStateRight)
      call get_speed_max(iDir, State_V, B0x, B0y, B0z, &
           Cmax = Cmax, Cleft = CleftStateAverage, Cright = CrightStateAverage)

      Cleft  = min(0.0, CleftStateLeft,   CleftStateAverage)
      Cright = max(0.0, CrightStateRight, CrightStateAverage)

      WeightLeft  = Cright/(Cright - Cleft)
      WeightRight = 1.0 - WeightLeft
      Diffusion   = Cright*WeightRight

      Flux_V = &
           (WeightRight*FluxRight_V + WeightLeft*FluxLeft_V &
           - Diffusion*(StateRightCons_V - StateLeftCons_V))

      ! Linde's idea: use Lax-Friedrichs flux for Bn
      Flux_V(Bx_) = Flux_V(Bx_) - cMax*DiffBx
      Flux_V(By_) = Flux_V(By_) - cMax*DiffBy
      Flux_V(Bz_) = Flux_V(Bz_) - cMax*DiffBz

      ! Fix the energy diffusion
      Flux_V(Energy_) = Flux_V(Energy_) - cMax*DiffE

      ! Average the normal speed
      Unormal_I = WeightRight*UnRight_I + WeightLeft*UnLeft_I
      Enormal   = WeightRight*EnRight   + WeightLeft*EnLeft !^CFG IF BORISCORR

    end subroutine harten_lax_vanleer_flux
    !^CFG END LINDEFLUX
    !^CFG IF AWFLUX BEGIN
    !==========================================================================
    subroutine artificial_wind

      use ModVarIndexes, ONLY: B_, Energy_

      real :: Cleft, Cright, WeightLeft, WeightRight, Diffusion
      !-----------------------------------------------------------------------

      ! The propagation speeds are modified by the DoAw = .true. !
      call get_speed_max(iDir, State_V, B0x, B0y, B0z,  &
           Cleft = Cleft, Cright = Cright, Cmax = Cmax)

      Cleft  = min(0.0, Cleft)
      Cright = max(0.0, Cright)

      WeightLeft  = Cright/(Cright - Cleft)
      WeightRight = 1.0 - WeightLeft
      Diffusion   = Cright*WeightRight

      Flux_V = &
           (WeightRight*FluxRight_V + WeightLeft*FluxLeft_V &
           - Diffusion*(StateRightCons_V - StateLeftCons_V))

      ! Linde's idea: use Lax-Friedrichs flux for Bn
      Flux_V(Bx_) = Flux_V(Bx_) - cMax*DiffBx
      Flux_V(By_) = Flux_V(By_) - cMax*DiffBy
      Flux_V(Bz_) = Flux_V(Bz_) - cMax*DiffBz

      ! Sokolov's algorithm !!!
      ! Fix the energy diffusion
      Flux_V(Energy_) = Flux_V(Energy_) - cMax*DiffE

      ! Weighted average of the normal speed and electric field
      Unormal_I = WeightRight*UnRight_I + WeightLeft*UnLeft_I
      Enormal   = WeightRight*EnRight   + WeightLeft*EnLeft !^CFG IF BORISCORR

    end subroutine artificial_wind
    !^CFG END AWFLUX
    !=======================================================================

    subroutine write_test_info
      use ModVarIndexes
      integer :: iVar
      !--------------------------------------------------------------------
      write(*,*)'Hat state for face=',iDir,&
           ' at I=',iFace,' J=',jFace,' K=',kFace
      write(*,*)'rho=',0.5*(StateLeft_V(Rho_)+StateRight_V(Rho_))
      write(*,*)'Un =',0.5*(StateLeft_V(U_+iDir)+StateRight_V(U_+iDir))
      write(*,*)'P  =',0.5*(StateLeft_V(P_)+StateRight_V(P_))
      write(*,*)'B  =', &
           0.5*(StateLeft_V(Bx_:Bz_) + StateRight_V(Bx_:Bz_)) + (/B0x,B0y,B0z/)
      write(*,*)'BB =', &
           sum( (0.5*(StateLeft_V(Bx_:Bz_) + StateRight_V(Bx_:Bz_)) &
           + (/B0x,B0y,B0z/))**2)

      write(*,*)'Fluxes for dir=',iDir,' at I=',iFace,' J=',jFace,' K=',kFace

      write(*,*)'Eigenvalue_maxabs=', Cmax/Area
      write(*,*)'CmaxDt/Area      =', CmaxDt/Area
      do iVar = 1, nVar + 1
         write(*,'(a,i2,4(1pe13.5))') 'Var,F,F_L,F_R,dU=',&
              iVar ,&
              Flux_V(iVar), &
              FluxLeft_V(iVar)/Area, &
              FluxRight_V(iVar)/Area,&
              StateRightCons_V(iVar)-StateLeftCons_V(iVar)
      end do

    end subroutine write_test_info

  end subroutine get_numerical_flux

  !===========================================================================

  subroutine get_physical_flux(iDir, State_V, B0x, B0y, B0z, &
       StateCons_V, Flux_V, Un_I, En, HallUn)

    use ModMultiFluid

    integer, intent(in) :: iDir                ! direction of flux
    real,    intent(in) :: State_V(nVar)       ! input primitive state
    real,    intent(in) :: B0x, B0y, B0z       ! B0
    real,    intent(out):: StateCons_V(nFlux)  !conservative states with energy
    real,    intent(out):: Flux_V(nFlux)       ! fluxes for all states
    real,    intent(out):: Un_I(nFluid)        ! normal velocity
    real,    intent(out):: En                  ! normal electric field
    real,    intent(out):: HallUn              ! normal Hall/electron velocity

    real :: Un
    !--------------------------------------------------------------------------

    ! Calculate conservative state
    StateCons_V(1:nVar)  = State_V

    if(.not.UseMultiIon)then
       ! single ion fluid MHD (possibly with extra neutrals)
       iFluid = 1
       if(UseBoris)then           !^CFG IF BORISCORR BEGIN
          call get_boris_flux
       else                       !^CFG END BORISCORR
          call get_mhd_flux
          En = 0.0
       end if                     !^CFG IF BORISCORR
       Un_I(1) = Un
    end if

    if(nFluid > 1 .or. UseMultiIon)then
       if(UseMultiIon)call get_magnetic_flux
       do iFluid = 1, nFluid
          if(TypeFluid_I(iFluid) == 'ion') CYCLE
          call select_fluid
          ! multi-ion or neutral fluid
          call get_hd_flux
          Un_I(iFLuid) = Un
       end do
    end if

  contains

    !^CFG IF BORISCORR BEGIN
    subroutine get_boris_flux

      use ModPhysics, ONLY: g, inv_gm1, Inv_C2light, InvClight
      use ModMain,    ONLY: x_, y_, z_
      use ModVarIndexes

      ! Variables for conservative state and flux calculation
      real :: Rho, Ux, Uy, Uz, Bx, By, Bz, p, e, FullBx, FullBy, FullBz, FullBn
      real :: B2, FullB2, pTotal, pTotal2, UDotB
      real :: Ex, Ey, Ez, E2Half
      real :: Bn, B0n
      integer :: iVar
      !-----------------------------------------------------------------------

      ! Extract primitive variables
      Rho     = State_V(Rho_)
      Ux      = State_V(Ux_)
      Uy      = State_V(Uy_)
      Uz      = State_V(Uz_)
      Bx      = State_V(Bx_)
      By      = State_V(By_)
      Bz      = State_V(Bz_)
      p       = State_V(p_)

      B2      = Bx**2 + By**2 + Bz**2

      FullBx  = Bx + B0x
      FullBy  = By + B0y
      FullBz  = Bz + B0z

      ! Electric field divided by speed of light: 
      ! E= - U x B / c = (B x U)/c
      Ex      = (FullBy*Uz - FullBz*Uy) * InvClight
      Ey      = (FullBz*Ux - FullBx*Uz) * InvClight
      Ez      = (FullBx*Uy - FullBy*Ux) * InvClight

      ! Electric field squared/c^2
      E2Half  = 0.5*(Ex**2 + Ey**2 + Ez**2)

      ! Calculate energy
      e = inv_gm1*p + 0.5*(Rho*(Ux**2 + Uy**2 + Uz**2) + B2)

      ! The full momentum contains the ExB/c^2 term:
      ! rhoU_Boris = rhoU - ((U x B) x B)/c^2 = rhoU + (U B^2 - B U.B)/c^2
      UDotB   = Ux*FullBx + Uy*FullBy + Uz*FullBz
      FullB2  = FullBx**2 + FullBy**2 + FullBz**2
      StateCons_V(RhoUx_)  = Rho*Ux + (Ux*FullB2 - FullBx*UdotB)*inv_c2LIGHT
      StateCons_V(RhoUy_)  = Rho*Uy + (Uy*FullB2 - FullBy*UdotB)*inv_c2LIGHT
      StateCons_V(RhoUz_)  = Rho*Uz + (Uz*FullB2 - FullBz*UdotB)*inv_c2LIGHT

      ! The full energy contains the electric field energy
      StateCons_V(Energy_) = e + E2Half

      ! Calculate some intermediate values for flux calculations
      pTotal  = p + 0.5*B2 + B0x*Bx + B0y*By + B0z*Bz
      pTotal2 = pTotal + E2Half

      ! Normal direction
      Un     = Ux*AreaX  + Uy*AreaY  + Uz*AreaZ
      B0n    = B0x*AreaX + B0y*AreaY + B0z*AreaZ
      Bn     = Bx*AreaX  + By*AreaY  + Bz*AreaZ
      FullBn = B0n + Bn
      En     = Ex*AreaX + Ey*AreaY + Ez*AreaZ

      ! f_i[rho]=m_i
      Flux_V(Rho_)   = Rho*Un

      ! f_i[m_k]=m_i*m_k/rho - b_k*b_i -B0_k*b_i - B0_i*b_k - E_i*E_k
      !          +n_i*[p + B0_j*b_j + 0.5*(b_j*b_j + E_j*E_j)]
      Flux_V(RhoUx_) = Un*Rho*Ux - Bn*FullBx - B0n*Bx - En*Ex + pTotal2*Areax
      Flux_V(RhoUy_) = Un*Rho*Uy - Bn*FullBy - B0n*By - En*Ey + pTotal2*Areay
      Flux_V(RhoUz_) = Un*Rho*Uz - Bn*FullBz - B0n*Bz - En*Ez + pTotal2*Areaz

      ! f_i[b_k]=u_i*(b_k+B0_k) - u_k*(b_i+B0_i)
      Flux_V(Bx_) = Un*FullBx - Ux*FullBn
      Flux_V(By_) = Un*FullBy - Uy*FullBn
      Flux_V(Bz_) = Un*FullBz - Uz*FullBn

      ! f_i[p]=u_i*p
      Flux_V(p_)  = Un*p

      ! f_i[e]=(u_i*(ptotal+e+(b_k*B0_k))-(b_i+B0_i)*(b_k*u_k))
      Flux_V(Energy_) = &
           Un*(pTotal + e) - FullBn*(Ux*Bx + Uy*By + Uz*Bz)

      ! f_i[scalar] = Un*scalar
      do iVar = ScalarFirst_, ScalarLast_
         Flux_V(iVar) = Un*State_V(iVar)
      end do

    end subroutine get_boris_flux

    !==========================================================================
    !^CFG END BORISCORR

    subroutine get_mhd_flux

      use ModPhysics, ONLY: g, inv_gm1, inv_c2LIGHT
      use ModMain,    ONLY: x_, y_, z_
      use ModVarIndexes
      ! Variables for conservative state and flux calculation
      real :: Rho, Ux, Uy, Uz, Bx, By, Bz, p, e, FullBx, FullBy, FullBz, FullBn
      real :: HallUx, HallUy, HallUz, InvRho
      real :: FluxBx, FluxBy, FluxBz
      real :: Bn, B0n
      real :: B2, B0B1, pTotal
      real :: Gamma2                           !^CFG IF SIMPLEBORIS
      integer :: iVar
      !-----------------------------------------------------------------------

      ! Extract primitive variables
      Rho     = State_V(Rho_)
      Ux      = State_V(Ux_)
      Uy      = State_V(Uy_)
      Uz      = State_V(Uz_)
      Bx      = State_V(Bx_)
      By      = State_V(By_)
      Bz      = State_V(Bz_)
      p       = State_V(p_)

      B2      = Bx**2 + By**2 + Bz**2

      ! Calculate energy
      e = inv_gm1*p + 0.5*(Rho*(Ux**2 + Uy**2 + Uz**2) + B2)

      ! Calculate conservative state
      StateCons_V(RhoUx_)  = Rho*Ux
      StateCons_V(RhoUy_)  = Rho*Uy
      StateCons_V(RhoUz_)  = Rho*Uz
      StateCons_V(Energy_) = e

      ! Calculate some intermediate values for flux calculations

      FullBx  = Bx + B0x
      FullBy  = By + B0y
      FullBz  = Bz + B0z

      B0B1    = B0x*Bx + B0y*By + B0z*Bz
      pTotal  = p + 0.5*B2 + B0B1

      ! Normal direction
      Un     = Ux*AreaX  + Uy*AreaY  + Uz*AreaZ
      B0n    = B0x*AreaX + B0y*AreaY + B0z*AreaZ
      Bn     = Bx*AreaX  + By*AreaY  + Bz*AreaZ
      FullBn = B0n + Bn

      ! f_i[rho]=m_i
      Flux_V(Rho_)   = Rho*Un

      ! f_i[m_k]=m_i*m_k/rho - b_k*b_i -B0_k*b_i - B0_i*b_k + n_i*[ptotal]
      Flux_V(RhoUx_) = Un*Rho*Ux - Bn*FullBx - B0n*Bx + pTotal*AreaX
      Flux_V(RhoUy_) = Un*Rho*Uy - Bn*FullBy - B0n*By + pTotal*AreaY
      Flux_V(RhoUz_) = Un*Rho*Uz - Bn*FullBz - B0n*Bz + pTotal*AreaZ

      ! f_i[b_k]=u_i*(b_k+B0_k) - u_k*(b_i+B0_i)
      if(HallCoeff > 0.0)then
         InvRho = 1.0/Rho
         HallUx = Ux - HallJx*InvRho
         HallUy = Uy - HallJy*InvRho
         HallUz = Uz - HallJz*InvRho

         HallUn = AreaX*HallUx + AreaY*HallUy + AreaZ*HallUz

         Flux_V(Bx_) = HallUn*FullBx - HallUx*FullBn
         Flux_V(By_) = HallUn*FullBy - HallUy*FullBn
         Flux_V(Bz_) = HallUn*FullBz - HallUz*FullBn
      else
         Flux_V(Bx_) = Un*FullBx - Ux*FullBn
         Flux_V(By_) = Un*FullBy - Uy*FullBn
         Flux_V(Bz_) = Un*FullBz - Uz*FullBn
      end if

      ! f_i[p]=u_i*p
      Flux_V(p_)  = Un*p

      ! f_i[e]=(u_i*(ptotal+e+(b_k*B0_k))-(b_i+B0_i)*(b_k*u_k))
      if(HallCoeff > 0.0) then
         Flux_V(Energy_) = &
              Un*(pTotal + e) &
              - FullBn*(HallUx*Bx + HallUy*By + HallUz*Bz)  &
              + (HallUn-Un)*(B2 + B0B1)
      else
         Flux_V(Energy_) = &
              Un*(pTotal + e) - FullBn*(Ux*Bx + Uy*By + Uz*Bz)     
      end if

      if(Eta > 0.0)then                          !^CFG IF DISSFLUX BEGIN
         ! Add curl Eta.J to induction equation
         FluxBx = AreaY*EtaJz - AreaZ*EtaJy
         FluxBy = AreaZ*EtaJx - AreaX*EtaJz
         FluxBz = AreaX*EtaJy - AreaY*EtaJx

         Flux_V(Bx_) = Flux_V(Bx_) + FluxBx
         Flux_V(By_) = Flux_V(By_) + FluxBy
         Flux_V(Bz_) = Flux_V(Bz_) + FluxBz

         ! add B.dB/dt term to energy equation
         Flux_V(Energy_) = Flux_V(Energy_) + Bx*FluxBx + By*FluxBy + Bz*FluxBz
      end if                                     !^CFG END DISSFLUX

      ! f_i[scalar] = Un*scalar
      do iVar = ScalarFirst_, ScalarLast_
         Flux_V(iVar) = Un*State_V(iVar)
      end do

      !^CFG IF SIMPLEBORIS BEGIN
      if(UseBorisSimple)then
         ! Correct the momentum using the (1+VA2/c^2)
         Gamma2 = 1.0 + (FullBx**2 + FullBy**2 + FullBz**2)/Rho*inv_c2LIGHT
         StateCons_V(RhoUx_:RhoUz_) = StateCons_V(RhoUx_:RhoUz_)*Gamma2
      end if
      !^CFG END SIMPLEBORIS

    end subroutine get_mhd_flux

    !==========================================================================

    subroutine get_magnetic_flux

      use ModCoordTransform, ONLY: cross_product

      integer, parameter :: Rho_=1, Ux_=2, Uy_=3, Uz_=4

      ! Calculate magnetic flux for multi-ion equations

      integer :: iVarIon_I(nIonFluid)
      real :: NumDens_I(nIonFluid), InvNumDens
      real :: UxPlus, UyPlus, UzPlus
      real :: HallUx, HallUy, HallUz, HallUn
      real :: FullBx, FullBy, FullBz, FullBn
      !-----------------------------------------------------------------------

      iVarIon_I = iVarFluid_I(1:nIonFluid)

      ! calculate number densities
      NumDens_I  = State_V(iVarIon_I + Rho_) /  IonMass_I
      InvNumDens = 1.0/sum(NumDens_I)

      ! calculate positive charge velocity
      UxPlus = InvNumDens*sum(NumDens_I*State_V(iVarIon_I + Ux_))
      UyPlus = InvNumDens*sum(NumDens_I*State_V(iVarIon_I + Uy_))
      UzPlus = InvNumDens*sum(NumDens_I*State_V(iVarIon_I + Uz_))

      HallUx = UxPlus - HallJx*InvNumDens
      HallUy = UyPlus - HallJy*InvNumDens
      HallUz = UzPlus - HallJz*InvNumDens

      HallUn = AreaX*HallUx + AreaY*HallUy + AreaZ*HallUz

      FullBx  = State_V(Bx_) + B0x
      FullBy  = State_V(By_) + B0y
      FullBz  = State_V(Bz_) + B0z

      FullBn  = FullBx*AreaX + FullBy*AreaY + FullBz*AreaZ

      Flux_V(Bx_) = HallUn*FullBx - HallUx*FullBn
      Flux_V(By_) = HallUn*FullBy - HallUy*FullBn
      Flux_V(Bz_) = HallUn*FullBz - HallUz*FullBn

      if(DoTestCell)then
         write(*,*)'NumDens_I,InvNumDens=',NumDens_I,InvNumDens
         write(*,*)'UxyzPlus  =',UxPlus,UyPlus,UzPlus
         write(*,*)'HallUxyz  =',HallUx,HallUy,HallUz
         write(*,*)'FullBxyz  =',FullBx,FullBy,FullBz
         write(*,*)'Flux(Bxyz)=',Flux_V(Bx_:Bz_)
      end if

      if(Eta > 0.0)then                          !^CFG IF DISSFLUX BEGIN
         ! Add curl Eta.J to induction equation
         Flux_V(Bx_) = Flux_V(Bx_) + AreaY*EtaJz - AreaZ*EtaJy
         Flux_V(By_) = Flux_V(By_) + AreaZ*EtaJx - AreaX*EtaJz
         Flux_V(Bz_) = Flux_V(Bz_) + AreaX*EtaJy - AreaY*EtaJx
      end if                                     !^CFG END DISSFLUX

!!! add gradient of electron pressure here !!!

      ! Calculate bCrossArea_D to be used for J in the J x B source term
      ! in calc_sources.f90.
      ! The upwinded discretization of the current is J = sum(A x B) / V

      bCrossArea_D = cross_product(AreaX, AreaY, AreaZ, State_V(Bx_:Bz_))

    end subroutine get_magnetic_flux

    !==========================================================================
    subroutine get_hd_flux

      use ModPhysics, ONLY: g, inv_gm1
      use ModMain,    ONLY: x_, y_, z_
      use ModVarIndexes
      ! Variables for conservative state and flux calculation
      real :: Rho, Ux, Uy, Uz, p, e, RhoUn
      integer :: iVar
      !-----------------------------------------------------------------------

      ! Extract primitive variables
      Rho     = State_V(iRho)
      Ux      = State_V(iUx)
      Uy      = State_V(iUy)
      Uz      = State_V(iUz)
      p       = State_V(iP)

      ! Calculate energy
      e = inv_gm1*p + 0.5*Rho*(Ux**2 + Uy**2 + Uz**2)

      ! Calculate conservative state
      StateCons_V(iRhoUx)  = Rho*Ux
      StateCons_V(iRhoUy)  = Rho*Uy
      StateCons_V(iRhoUz)  = Rho*Uz
      StateCons_V(iEnergy) = e

      ! Normal velocity
      Un     = Ux*AreaX  + Uy*AreaY  + Uz*AreaZ
      RhoUn  = Rho*Un

      ! f_i[rho]=m_i
      Flux_V(iRho)   = RhoUn

      ! f_i[m_k]=u_i*rho*u_k + n_i*[ptotal]
      Flux_V(iRhoUx) = RhoUn*Ux + p*AreaX
      Flux_V(iRhoUy) = RhoUn*Uy + p*AreaY
      Flux_V(iRhoUz) = RhoUn*Uz + p*AreaZ

      ! f_i[p]=u_i*p
      Flux_V(iP)  = Un*p

      Flux_V(iEnergy) = Un*(p + e)

      ! f_i[scalar] = Un*scalar
      do iVar = ScalarFirst_, ScalarLast_
         Flux_V(iVar) = Un*State_V(iVar)
      end do

    end subroutine get_hd_flux

  end subroutine get_physical_flux

  !===========================================================================

  subroutine get_speed_max(iDir, State_V, B0x, B0y, B0z, cMax, cLeft, cRight)

    use ModMultiFluid, ONLY: select_fluid, iFluid, iRho, iUx, iUy, iUz, iP

    integer, intent(in) :: iDir
    real,    intent(in) :: State_V(nVar)
    real,    intent(in) :: B0x, B0y, B0z
    real, optional, intent(out) :: Cmax        ! maximum speed relative to lab
    real, optional, intent(out) :: Cleft       ! maximum left speed
    real, optional, intent(out) :: Cright      ! maximum right speed

    real :: CmaxFluid, CleftFluid, CrightFluid
    !--------------------------------------------------------------------------

    UnLeft = minval(UnLeft_I(1:nIonFluid))
    UnRight= maxval(UnRight_I(1:nIonFluid))
    if(UseBoris)then                             !^CFG IF BORISCORR BEGIN
       call get_boris_speed
    else                                         !^CFG END BORISCORR
       call get_mhd_speed
    endif                                        !^CFG IF BORISCORR    

    if(nFluid > 1)then
       if(present(Cmax))   CmaxFluid  =Cmax
       if(present(Cleft))  CleftFluid =Cleft
       if(present(Cright)) CrightFluid=Cright

       do iFluid = 2, nFluid
          if(TypeFluid_I(iFluid)/='neutral') CYCLE
          call select_fluid
          UnLeft = UnLeft_I(iFluid)
          UnRight= UnRight_I(iFluid)

          call get_hd_speed

          if(present(Cmax))   CmaxFluid  =max(CmaxFluid,  Cmax)
          if(present(Cleft))  CleftFluid =min(CleftFluid, Cleft)
          if(present(Cright)) CrightFluid=min(CrightFluid,Cright)
       end do

       if(present(Cmax))   Cmax  =CmaxFluid
       if(present(Cleft))  Cleft =CleftFluid
       if(present(Cright)) Cright=CrightFluid
    end if

  contains

    !^CFG IF BORISCORR BEGIN
    !========================================================================
    subroutine get_boris_speed

      use ModMain,    ONLY: x_, y_, z_
      use ModVarIndexes
      use ModPhysics, ONLY: g, inv_c2LIGHT

      real :: InvRho, Sound2, FullBx, FullBy, FullBz
      real :: Alfven2, Alfven2Normal, Un, Fast2, Discr, Fast, Slow
      real :: GammaA2, GammaU2
      real :: UnBoris, Sound2Boris, Alfven2Boris, Alfven2NormalBoris
      !-----------------------------------------------------------------------
      InvRho = 1.0/State_V(Rho_)
      Sound2 = g*State_V(p_)*InvRho
      FullBx = State_V(Bx_) + B0x
      FullBy = State_V(By_) + B0y
      FullBz = State_V(Bz_) + B0z
      Alfven2= (FullBx**2 + FullBy**2 + FullBz**2)*InvRho

      Un = State_V(Ux_)*AreaX + State_V(Uy_)*AreaY + State_V(Uz_)*AreaZ
      Alfven2Normal = &
           InvRho*(AreaX*FullBx + AreaY*FullBy + AreaZ*FullBz)**2/Area2

      ! "Alfven Lorentz" factor
      GammaA2 = 1.0/(1.0 + Alfven2*inv_c2LIGHT) 

      ! 1-gA^2*Un^2/c^2
      GammaU2 = max(0.0, 1.0 - GammaA2*Un**2/Area2*inv_c2LIGHT) 

      ! Modified speeds
      Sound2Boris        = Sound2        *GammaA2*(1+Alfven2Normal*inv_c2LIGHT)
      Alfven2Boris       = Alfven2       *GammaA2*GammaU2
      Alfven2NormalBoris = Alfven2Normal *GammaA2*GammaU2

      ! Approximate slow and fast wave speeds
      Fast2  = Sound2Boris + Alfven2Boris
      Discr  = sqrt(max(0.0, Fast2**2 - 4.0*Sound2*Alfven2NormalBoris))

      ! Get fast and slow speeds multiplied with the face area
      Fast = sqrt( Area2*0.5*(          Fast2 + Discr) )
      Slow = sqrt( Area2*0.5*( max(0.0, Fast2 - Discr) ) )

      ! In extreme cases "slow" wave can be faster than "fast" wave
      ! so take the maximum of the two

      if(DoAw)then                                       !^CFG IF AWFLUX BEGIN
         Un      = min(UnRight, UnLeft)
         Cleft   = min(Un*GammaA2 - Fast, Un - Slow)
         Un      = max(UnLeft, UnRight)
         Cright  = max(Un*GammaA2 + Fast, Un + Slow)
         CmaxDt  = max(Cright, -Cleft)
         Cmax    = CmaxDt
      else                                                !^CFG END AWFLUX
         UnBoris            = Un*GammaA2
         if(present(Cmax))then
            Cmax   = max(abs(UnBoris) + Fast, abs(Un) + Slow)
            CmaxDt = Cmax
         end if
         if(present(Cleft))  Cleft  = min(UnBoris - Fast, Un - Slow)
         if(present(Cright)) Cright = max(UnBoris + Fast, Un + Slow)
      end if                                              !^CFG IF AWFLUX

    end subroutine get_boris_speed
    !^CFG END BORISCORR
    !========================================================================

    subroutine get_mhd_speed

      use ModMain,    ONLY: x_, y_, z_, GlobalBlk,UseCurlB0
      use ModVarIndexes
      use ModPhysics, ONLY: g, Inv_C2Light
      use ModNumConst, ONLY: cPi
      use ModAdvance, ONLY: State_VGB

      integer :: iVar
      real :: RhoU_D(3)
      real :: Rho, p, InvRho, Sound2, FullBx, FullBy, FullBz, FullBn,FullB
      real :: Alfven2, Alfven2Normal, Un, Fast2, Discr, Fast, FastDt, cWhistler
      real :: dB1dB1                                     !^CFG IF AWFLUX

      real :: FullBt, Rho1, cDrift, cHall,B1B0L,B1B0R
      character(len=*), parameter:: NameSub=NameMod//'::get_mhd_speed'
      !------------------------------------------------------------------------

      if(DoTestCell)write(*,*) NameSub,' State_V, B0=',State_V, B0x, B0y, B0z

      Rho    = State_V(Rho_)
      p      = State_V(p_)
      RhoU_D = Rho*State_V(Ux_:Uz_)
      do iFluid = 2, nIonFluid
         iVar = iVarFluid_I(iFluid)
         Rho1= State_V(iVar + 1)
         Rho = Rho + Rho1
         p   = p   + State_V(iVar + 5)
         RhoU_D = RhoU_D + Rho1*State_V(iVar + 2: iVar +4)
      end do

      InvRho = 1.0/Rho
      Sound2 = g*p*InvRho
      Un     = InvRho*sum( RhoU_D*(/ AreaX, AreaY, AreaZ /) )

      FullBx = State_V(Bx_) + B0x
      FullBy = State_V(By_) + B0y
      FullBz = State_V(Bz_) + B0z
      if(DoAw)then                                       !^CFG IF AWFLUX BEGIN
         ! According to I. Sokolov adding (Bright-Bleft)^2/4 to
         ! the average field squared (Bright+Bleft)^2/4 results in 
         ! an upper estimate of the left and right Alfven speeds 
         ! max(Bleft^2/RhoLeft, Bright^2/RhoRight)/
         !
         ! For B0=Bleft=0 and Bright=1 RhoLeft=RhoRight=1 
         ! this is clearly not true.
         !
         dB1dB1 = 0.25*sum((StateRight_V(Bx_:Bz_)-StateLeft_V(Bx_:Bz_))**2)
         Alfven2= (FullBx**2 + FullBy**2 + FullBz**2 + dB1dB1)*InvRho
      else                                               !^CFG END AWFLUX
         Alfven2= (FullBx**2 + FullBy**2 + FullBz**2)*InvRho
      end if                                             !^CFG IF AWFLUX
      if(UseCurlB0)then
         B1B0L = StateLeft_V(Bx_)*B0x + StateLeft_V(By_)*B0y + StateLeft_V(Bz_)*B0z
         B1B0R = StateRight_V(Bx_)*B0x + StateRight_V(By_)*B0y + StateRight_V(Bz_)*B0z
         Alfven2 = Alfven2 +(abs(B1B0L)-B1B0L+abs(B1B0R)-B1B0R)*InvRho
      end if

      FullBn = AreaX*FullBx + AreaY*FullBy + AreaZ*FullBz
      Alfven2Normal = InvRho*FullBn**2/Area2
      Fast2  = Sound2 + Alfven2
      Discr  = sqrt(max(0.0, Fast2**2 - 4*Sound2*Alfven2Normal))

      ! Fast speed multipled by the face area
      if(UseBorisSimple)then                         !^CFG IF SIMPLEBORIS BEGIN
         Fast = sqrt( Area2*0.5*(Fast2 + Discr) &
              /       (1.0 + Alfven2*Inv_C2light) )
      else                                           !^CFG END SIMPLEBORIS
         Fast = sqrt( Area2*0.5*(Fast2 + Discr) )
      end if                                         !^CFG IF SIMPLEBORIS

      ! Add whistler wave speed for the shortest wavelength 2 dx
      if(HallCoeff > 0.0) then
         ! Tangential component of B (*Area)
         FullBt = sqrt(max(0.0, &
              Area2*(FullBx**2+FullBy**2+FullBz**2) - FullBn**2))
         ! Calculate Ln = d ln(Rho)/dx = (dRho/dx) / Rho
         select case(iDir)
         case(1)
            Rho1 = State_VGB(Rho_,iFace-1,jFace,kFace,GlobalBlk)
         case(2)
            Rho1 = State_VGB(Rho_,iFace,jFace-1,kFace,GlobalBlk)
         case(3)
            Rho1 = State_VGB(Rho_,iFace,jFace,kFace-1,GlobalBlk)
         end select
         ! Calculate drift speed and whistler speed
         cDrift    = abs(FullBt)*2.0*abs(Rho1 - Rho)/(Rho1 + Rho)
         cWhistler = cPi*abs(FullBn)
         ! Take the faster speed
         cHall     = HallCoeff*InvDxyz*InvRho*max(cWhistler, cDrift)
         !cHall     = HallCoeff*InvDxyz*InvRho*cWhistler
         FastDt = Fast + cHall
         Fast   = Fast + HallCmaxFactor*cHall
      end if

      if(DoAw)then                                   !^CFG IF AWFLUX BEGIN
         if(HallCoeff > 0.0)then
            Cleft   = min(UnLeft, UnRight, HallUnLeft, HallUnRight)
            Cright  = max(UnLeft, UnRight, HallUnLeft, HallUnRight)
            CmaxDt  = max(Cright + FastDt, - Cleft - FastDt)
            Cleft   = Cleft  - Fast
            Cright  = Cright + Fast
            Cmax    = max(Cright, -Cleft)
         else
            Cleft   = min(UnLeft, UnRight) - Fast
            Cright  = max(UnLeft, UnRight) + Fast
            Cmax    = max(Cright, -Cleft)
            CmaxDt = Cmax
         end if
      else                                           !^CFG END AWFLUX
         if(present(Cmax))then
            if(HallCoeff > 0.0)then
               Cmax   = max(abs(Un), abs(HallUnLeft), abs(HallUnRight))
               CmaxDt = Cmax + FastDt
               Cmax   = Cmax + Fast
            else
               Cmax   = abs(Un) + Fast
               CmaxDt = Cmax
            end if
         end if
         if(present(Cleft))  Cleft  = Un - Fast
         if(present(Cright)) Cright = Un + Fast
      end if                                         !^CFG IF AWFLUX

      if(DoTestCell)then
         write(*,*)NameSub,' Un=',Un
         write(*,*)NameSub,' Csound2=',Sound2
         write(*,*)NameSub,' Cfast2=', Fast2
         write(*,*)NameSub,' Discr2=', Discr**2
         write(*,*)NameSub,' Calfven=',sqrt(Alfven2)
         write(*,*)NameSub,' Calfven_normal=',sqrt(Alfven2Normal)
         write(*,*)NameSub,' Cfast=',Fast
         write(*,*)NameSub,' Cmax=',Cmax/Area
      end if

    end subroutine get_mhd_speed
    !========================================================================
    subroutine get_hd_speed

      use ModVarIndexes
      use ModPhysics, ONLY: g
      use ModAdvance, ONLY: State_VGB

      real :: InvRho, Sound2, Sound, Un

      character(len=*), parameter:: NameSub=NameMod//'::get_hd_speed'
      !------------------------------------------------------------------------

      if(DoTestCell)write(*,*) NameSub,' State_V=',State_V(iRho:iP)

      InvRho = 1.0/State_V(iRho)
      Sound2 = g*State_V(iP)*InvRho
      Un = State_V(iUx)*AreaX + State_V(iUy)*AreaY + State_V(iUz)*AreaZ

      Sound = sqrt(Sound2)

      if(DoAw)then                                   !^CFG IF AWFLUX BEGIN
         Cleft   = min(UnLeft, UnRight) - Sound
         Cright  = max(UnLeft, UnRight) + Sound
         Cmax    = max(Cright, -Cleft)
         CmaxDt = Cmax
      else                                           !^CFG END AWFLUX
         if(present(Cmax))then
            Cmax   = abs(Un) + Sound
            CmaxDt = Cmax
         end if
         if(present(Cleft))  Cleft  = Un - Sound
         if(present(Cright)) Cright = Un + Sound
      end if                                         !^CFG IF AWFLUX

      if(DoTestCell)then
         write(*,*)NameSub,' Un     =',Un
         write(*,*)NameSub,' Csound =',Sound
         write(*,*)NameSub,' Cmax   =',Cmax/Area
      end if

    end subroutine get_hd_speed

  end subroutine get_speed_max

end module ModFaceFlux

!^CFG IF ROEFLUX BEGIN
!==============================================================================
subroutine roe_solver(iDir, Flux_V)

  use ModFaceFlux, ONLY: &
       nFlux, &
       iFace, jFace, kFace, Area, Area2, AreaX, AreaY, AreaZ, DoTestCell, &
       StateLeft_V,  StateRight_V, FluxLeft_V, FluxRight_V, &
       StateLeftCons_V, StateRightCons_V, B0x, B0y, B0z, CmaxDt, Unormal_I

  use ModVarIndexes, ONLY: nVar, Rho_, RhoUx_, RhoUy_, RhoUz_, &
       Ux_, Uy_, Uz_, Bx_, By_, Bz_, p_, Energy_, ScalarFirst_, ScalarLast_

  use ModMain,     ONLY: x_, y_, z_, GlobalBlk
  use ModGeometry, ONLY: true_cell
  use ModPhysics,  ONLY: g,gm1,inv_gm1
  use ModNumConst

  use ModGeometry,   ONLY: UseCovariant                      !^CFG IF COVARIANT
  implicit none

  integer, intent(in) :: iDir
  real,    intent(out):: Flux_V(nFlux)

  ! Number of MHD fluxes including the pressure and energy fluxes
  integer, parameter :: nFluxMhd = 9

  ! Named conservative MHD variable indexes + pressure
  integer, parameter :: RhoMhd_=1, RhoUn_=2, RhoUt1_=3, RhoUt2_=4, &
       B1n_=5, B1t1_=6, B1t2_=7, eMhd_=8, pMhd_=9

  ! Number of MHD waves including the divB wave
  integer, parameter :: nWave=8

  ! Named MHD wave indexes
  integer, parameter :: EntropyW_=1, AlfvenRW_=2, AlfvenLW_=3, &
       SlowRW_=4, FastRW_=5, SlowLW_=6, FastLW_=7, DivBW_=8 

  ! Loop variables
  integer :: iFlux, iVar, iWave

  ! Left face
  real :: RhoL,UnL,Ut1L,Ut2L
  real :: BnL,Bt1L,Bt2L,BbL
  real :: B1nL,B1t1L,B1t2L,Bb1L
  real :: pL,eL,aL,CsL,CfL

  ! Right face
  real :: RhoR,UnR,Ut1R,Ut2R
  real :: BnR,Bt1R,Bt2R,BbR
  real :: B1nR,B1t1R,B1t2R
  real :: pR,eR,aR,CsR,CfR

  ! Average (hat)
  real :: RhoH,UnH,Ut1H,Ut2H
  real :: BnH,Bt1H,Bt2H,BbH
  real :: B1nH,B1t1H,B1t2H,Bb1H
  real :: pH,eH,UuH
  real :: aH,CsH,CfH

  ! More face variables
  real :: B0n,B0t1,B0t2

  real :: BetaY, BetaZ, AlphaS, AlphaF

  real :: RhoInvL,RhoInvR,RhoInvH
  real :: RhoSqrtH,    RhoSqrtL,    RhoSqrtR, &
       RhoInvSqrtH, RhoInvSqrtL, RhoInvSqrtR

  ! Jump in the conservative state
  real, dimension(nWave) :: dCons_V

  ! Eigenvalues and jumps in characteristic variable
  real, dimension(nWave) :: Eigenvalue_V, DeltaWave_V 

  ! Eigenvectors
  real, dimension(nWave, nWave)   :: EigenvectorL_VV  ! Left  eigenvectors
  real, dimension(nWave, nFluxMhd):: EigenvectorR_VV  ! Right eigenvectors

  ! Fluxes
  real, dimension(nFluxMhd)       :: Diffusion_V      ! Diffusive fluxes

  ! Logical to use Rusanov flux at inner boundary
  logical :: UseFluxRusanov

  ! Misc. scalar variables
  real :: SignBnH, Tmp1, Tmp2, Tmp3, Gamma1A2Inv, DtInvVolume, AreaFace

  real :: Normal_D(3), Tangent1_D(3), Tangent2_D(3)   !^CFG IF COVARIANT 
  real :: dRhoU_D(3), dB1_D(3)                        !^CFG IF COVARIANT
  !---------------------------------------------------------------------------

  if(UseCovariant)then                                !^CFG IF COVARIANT BEGIN
     ! Obtain the base vectors of the face aligned coordinate system
     Normal_D(x_) = AreaX / Area
     Normal_D(y_) = AreaY / Area
     Normal_D(z_) = AreaZ / Area
     if(Normal_D(z_) < 0.5)then
        ! Tangent1 = Normal x (0,0,1)
        Tangent1_D(x_) =  Normal_D(y_)
        Tangent1_D(y_) = -Normal_D(x_)
        Tangent1_D(z_) = 0.0
        ! Tangent2 = Normal x Tangent1
        Tangent2_D(x_) =  Normal_D(z_)*Normal_D(x_)
        Tangent2_D(y_) =  Normal_D(z_)*Normal_D(y_)
        Tangent2_D(z_) = -Normal_D(x_)**2 - Normal_D(y_)**2
     else
        ! Tangent1 = Normal x (1,0,0)
        Tangent1_D(x_) = 0.0
        Tangent1_D(y_) =  Normal_D(z_)
        Tangent1_D(z_) = -Normal_D(y_)
        ! Tangent2 = Normal x Tangent1
        Tangent2_D(x_) = -Normal_D(y_)**2 - Normal_D(z_)**2
        Tangent2_D(y_) =  Normal_D(x_)*Normal_D(y_)
        Tangent2_D(z_) =  Normal_D(x_)*Normal_D(z_)
     end if
     ! B0 on the face
     B0n   = sum(Normal_D  *(/B0x, B0y, B0z/))
     B0t1  = sum(Tangent1_D*(/B0x, B0y, B0z/))
     B0t2  = sum(Tangent2_D*(/B0x, B0y, B0z/))
     ! Left face
     UnL   = sum(Normal_D  *StateLeft_V(Ux_:Uz_))
     Ut1L  = sum(Tangent1_D*StateLeft_V(Ux_:Uz_))
     Ut2L  = sum(Tangent2_D*StateLeft_V(Ux_:Uz_))
     B1nL  = sum(Normal_D  *StateLeft_V(Bx_:Bz_))
     B1t1L = sum(Tangent1_D*StateLeft_V(Bx_:Bz_))
     B1t2L = sum(Tangent2_D*StateLeft_V(Bx_:Bz_))
     ! Right face
     UnR   = sum(Normal_D  *StateRight_V(Ux_:Uz_))
     Ut1R  = sum(Tangent1_D*StateRight_V(Ux_:Uz_))
     Ut2R  = sum(Tangent2_D*StateRight_V(Ux_:Uz_))
     B1nR  = sum(Normal_D  *StateRight_V(Bx_:Bz_))
     B1t1R = sum(Tangent1_D*StateRight_V(Bx_:Bz_))
     B1t2R = sum(Tangent2_D*StateRight_V(Bx_:Bz_))
     ! Jump
     dRhoU_D = StateRightCons_V(RhoUx_:RhoUz_) - StateLeftCons_V(RhoUx_:RhoUz_)
     dCons_V(RhoUn_)  = sum(Normal_D  *dRhoU_D)
     dCons_V(RhoUt1_) = sum(Tangent1_D*dRhoU_D)
     dCons_V(RhoUt2_) = sum(Tangent2_D*dRhoU_D)
     dB1_D   = StateRightCons_V(Bx_:Bz_) - StateLeftCons_V(Bx_:Bz_)
     dCons_V(B1n_)    = sum(Normal_D  *dB1_D)
     dCons_V(B1t1_)   = sum(Tangent1_D*dB1_D)
     dCons_V(B1t2_)   = sum(Tangent2_D*dB1_D)

  else                                                !^CFG END COVARIANT
     select case (iDir)
     case (x_) ! x face
        ! B0 on the face
        B0n  = B0x
        B0t1 = B0y
        B0t2 = B0z
        ! Left face
        UnL   =  StateLeft_V(Ux_)
        Ut1L  =  StateLeft_V(Uy_)
        Ut2L  =  StateLeft_V(Uz_)
        B1nL  =  StateLeft_V(Bx_)
        B1t1L =  StateLeft_V(By_)
        B1t2L =  StateLeft_V(Bz_)
        ! Right face
        UnR   =  StateRight_V(Ux_ )
        Ut1R  =  StateRight_V(Uy_ )
        Ut2R  =  StateRight_V(Uz_ )
        B1nR  =  StateRight_V(Bx_ )
        B1t1R =  StateRight_V(By_ )
        B1t2R =  StateRight_V(Bz_ )
        ! Jump
        dCons_V(RhoUn_)  = StateRightCons_V(RhoUx_) - StateLeftCons_V(RhoUx_)
        dCons_V(RhoUt1_) = StateRightCons_V(RhoUy_) - StateLeftCons_V(RhoUy_)
        dCons_V(RhoUt2_) = StateRightCons_V(RhoUz_) - StateLeftCons_V(RhoUz_)
        dCons_V(B1n_)    = StateRightCons_V(Bx_)    - StateLeftCons_V(Bx_)
        dCons_V(B1t1_)   = StateRightCons_V(By_)    - StateLeftCons_V(By_)
        dCons_V(B1t2_)   = StateRightCons_V(Bz_)    - StateLeftCons_V(Bz_)
     case (y_) ! y face
        ! B0 on the face
        B0n  = B0y
        B0t1 = B0z
        B0t2 = B0x
        ! Left face
        UnL   =  StateLeft_V(Uy_ )
        Ut1L  =  StateLeft_V(Uz_ )
        Ut2L  =  StateLeft_V(Ux_ )
        B1nL  =  StateLeft_V(By_ )
        B1t1L =  StateLeft_V(Bz_ )
        B1t2L =  StateLeft_V(Bx_ )
        ! Right face
        UnR   =  StateRight_V(Uy_ )
        Ut1R  =  StateRight_V(Uz_ )
        Ut2R  =  StateRight_V(Ux_ )
        B1nR  =  StateRight_V(By_ )
        B1t1R =  StateRight_V(Bz_ )
        B1t2R =  StateRight_V(Bx_ )
        ! Jump
        dCons_V(RhoUn_)  = StateRightCons_V(RhoUy_) - StateLeftCons_V(RhoUy_)
        dCons_V(RhoUt1_) = StateRightCons_V(RhoUz_) - StateLeftCons_V(RhoUz_)
        dCons_V(RhoUt2_) = StateRightCons_V(RhoUx_) - StateLeftCons_V(RhoUx_)
        dCons_V(B1n_)    = StateRightCons_V(By_)    - StateLeftCons_V(By_)
        dCons_V(B1t1_)   = StateRightCons_V(Bz_)    - StateLeftCons_V(Bz_)
        dCons_V(B1t2_)   = StateRightCons_V(Bx_)    - StateLeftCons_V(Bx_)
     case (z_) ! z face
        ! B0 on the face
        B0n  = B0z
        B0t1 = B0x
        B0t2 = B0y
        ! Left face
        UnL   =  StateLeft_V(Uz_ )
        Ut1L  =  StateLeft_V(Ux_ )
        Ut2L  =  StateLeft_V(Uy_ )
        B1nL  =  StateLeft_V(Bz_ )
        B1t1L =  StateLeft_V(Bx_ )
        B1t2L =  StateLeft_V(By_ )
        ! Right face
        UnR   =  StateRight_V(Uz_ )
        Ut1R  =  StateRight_V(Ux_ )
        Ut2R  =  StateRight_V(Uy_ )
        B1nR  =  StateRight_V(Bz_ )
        B1t1R =  StateRight_V(Bx_ )
        B1t2R =  StateRight_V(By_ )
        ! Jump
        dCons_V(RhoUn_ ) = StateRightCons_V(RhoUz_) - StateLeftCons_V(RhoUz_)
        dCons_V(RhoUt1_) = StateRightCons_V(RhoUx_) - StateLeftCons_V(RhoUx_)
        dCons_V(RhoUt2_) = StateRightCons_V(RhoUy_) - StateLeftCons_V(RhoUy_)
        dCons_V(B1n_)    = StateRightCons_V(Bz_)    - StateLeftCons_V(Bz_)
        dCons_V(B1t1_)   = StateRightCons_V(Bx_)    - StateLeftCons_V(Bx_)
        dCons_V(B1t2_)   = StateRightCons_V(By_)    - StateLeftCons_V(By_)
     end select
  end if                                           !^CFG IF COVARIANT

  ! Check if the cell is next to a boundary
  select case(iDir)
  case(x_)
     UseFluxRusanov= true_cell(iFace-1, jFace, kFace, globalBLK) &
          .neqv.     true_cell(iFace  , jFace, kFace, globalBLK)
  case(y_)
     UseFluxRusanov= true_cell(iFace, jFace-1, kFace, globalBLK) &
          .neqv.     true_cell(iFace, jFace  , kFace, globalBLK)
  case(z_)
     UseFluxRusanov= true_cell(iFace, jFace, kFace-1, globalBLK) &
          .neqv.     true_cell(iFace, jFace, kFace  , globalBLK)
  end select

  ! Scalar variables
  RhoL  =  StateLeft_V(rho_)
  pL    =  StateLeft_V(P_ )
  RhoR  =  StateRight_V(rho_)
  pR    =  StateRight_V(P_  )

  ! Jump in scalar conservative variables
  dCons_V(RhoMhd_) = StateRightCons_V(Rho_)    - StateLeftCons_V(Rho_)
  dCons_V(eMhd_)   = StateRightCons_V(Energy_) - StateLeftCons_V(Energy_)

  ! Derived variables
  RhoInvL = 1./RhoL
  BnL  = B0n+B1nL
  Bt1L = B0t1+B1t1L
  Bt2L = B0t2+B1t2L
  BbL  = BnL**2 + Bt1L**2 + Bt2L**2
  aL   = g*pL*RhoInvL

  RhoInvR = 1./RhoR
  BnR  = B0n+B1nR
  Bt1R = B0t1+B1t1R
  Bt2R = B0t2+B1t2R
  BbR  = BnR**2 + Bt1R**2 + Bt2R**2
  aR   = g*pR*RhoInvR

  !\
  ! Hat face
  !/
  RhoH = 0.5*(RhoL + RhoR)
  RhoInvH = 1./RhoH
  UnH  = 0.5*(  UnL +   UnR)
  Ut1H = 0.5*( Ut1L +  Ut1R)
  Ut2H = 0.5*( Ut2L +  Ut2R)
  BnH  = 0.5*(  BnL +   BnR)
  Bt1H = 0.5*( Bt1L +  Bt1R)
  Bt2H = 0.5*( Bt2L +  Bt2R)
  B1nH = 0.5*( B1nL +  B1nR)
  B1t1H= 0.5*(B1t1L + B1t1R)
  B1t2H= 0.5*(B1t2L + B1t2R)
  pH   = 0.5*(   pL +    pR)
  BbH  = BnH**2  + Bt1H**2  + Bt2H**2

  Bb1H = B1nH**2 + B1t1H**2 + B1t2H**2
  aH   = g*pH*RhoInvH

  !if(aL<0.0)then
  !   write(*,*)'NEGATIVE aL Me, iDir, i, j, k, globalBLK',&
  !        aL,iProc,iDir,i,j,k,&
  !        x_BLK(i,j,k,globalBLK),&
  !        y_BLK(i,j,k,globalBLK),&
  !        z_BLK(i,j,k,globalBLK)
  !   call stop_mpi
  !end if
  aL=sqrt(aL)
  aR=sqrt(aR)
  aH=sqrt(aH)

  eL = aL*aL + BbL*RhoInvL
  CfL = max(0., (eL**2 - 4.*aL**2 * BnL**2 * RhoInvL))
  eR = aR**2 + BbR*RhoInvR
  CfR = max(0., (eR**2 - 4.*aR**2 * BnR**2 * RhoInvR))
  eH = aH**2 + BbH*RhoInvH
  CfH = max(0., (eH**2 - 4.*aH**2 * BnH**2 * RhoInvH))

  CfL=sqrt(CfL)
  CfR=sqrt(CfR)
  CfH=sqrt(CfH)

  CsL  = max(0.,0.5*(eL-CfL))
  CfL  = 0.5*(eL+CfL)

  CsR  = max(0.,0.5*(eR-CfR))
  CfR  = 0.5*(eR+CfR)

  CsH  = max(0.,0.5*(eH-CfH))
  CfH  = 0.5*(eH+CfH)

  UuH  = UnH**2 + Ut1H**2 + Ut2H**2
  eH   = pH*inv_gm1 + 0.5*RhoH*UuH + 0.5*Bb1H

  CsL=sqrt(CsL)
  CsR=sqrt(CsR)
  CsH=sqrt(CsH)
  CfL=sqrt(CfL)
  CfR=sqrt(CfR)
  CfH=sqrt(CfH)

  CsL  = min(CsL,aL)
  CfL  = max(CfL,aL)
  CsR  = min(CsR,aR)
  CfR  = max(CfR,aR)
  CsH  = min(CsH,aH)
  CfH  = max(CfH,aH)
  !\
  ! Non-dimensional scaling factors
  !/
  Tmp1 = max(1.00e-08, Bt1H**2 + Bt2H**2)
  Tmp1=sqrt(1./Tmp1)

  if (Tmp1 < 1.0e04) then
     BetaY = Bt1H*Tmp1
     BetaZ = Bt2H*Tmp1
  else
     BetaY = cSqrtHalf
     BetaZ = cSqrtHalf
  end if

  Tmp1 = CfH**2 - CsH**2
  if (Tmp1 > 1.0e-08) then
     AlphaF = max(0.00,(aH**2  - CsH**2)/Tmp1)
     AlphaS = max(0.00,(CfH**2 - aH**2 )/Tmp1)

     AlphaF = sqrt(AlphaF)
     AlphaS = sqrt(AlphaS)
  else if (BnH**2 * RhoInvH <= aH**2 ) then
     AlphaF = 1.00
     AlphaS = 0.00
  else
     AlphaF = 0.00
     AlphaS = 1.00
  endif

  !\
  ! Set some values that are reused over and over
  !/

  RhoSqrtH   =sqrt(RhoH)
  RhoSqrtL   =sqrt(RhoL)
  RhoSqrtR   =sqrt(RhoR)
  RhoInvSqrtH=1./RhoSqrtH
  RhoInvSqrtL=1./RhoSqrtL
  RhoInvSqrtR=1./RhoSqrtR


  SignBnH     = sign(1.,BnH)
  Gamma1A2Inv = gm1 / aH**2

  !\
  ! Eigenvalues
  !/
  Eigenvalue_V(EntropyW_) = UnH
  Eigenvalue_V(AlfvenRW_) = UnH + BnH*RhoInvSqrtH
  Eigenvalue_V(AlfvenLW_) = UnH - BnH*RhoInvSqrtH
  Eigenvalue_V(SlowRW_)   = UnH + CsH
  Eigenvalue_V(FastRW_)   = UnH + CfH
  Eigenvalue_V(SlowLW_)   = UnH - CsH
  Eigenvalue_V(FastLW_)   = UnH - CfH
  Eigenvalue_V(DivBW_)    = UnH

  !\
  ! Entropy fix for Eigenvalues
  !/
  Tmp1 = UnR - UnL
  Tmp1 = max(cTiny, 4.*Tmp1)
  if (abs(Eigenvalue_V(1)) < Tmp1*0.5) then
     Eigenvalue_V(1) = sign(1.,Eigenvalue_V(1))*   &
          ((Eigenvalue_V(1)*Eigenvalue_V(1)/Tmp1) + Tmp1*0.25)
  end if

  Tmp1 = (UnR + BnR*RhoInvSqrtR) - (UnL + BnL*RhoInvSqrtL)
  Tmp1 = max(cTiny,4.*Tmp1)
  if (abs(Eigenvalue_V(2)) < Tmp1*0.5) then
     Eigenvalue_V(2) = sign(1.,Eigenvalue_V(2))*   &
          ((Eigenvalue_V(2)*Eigenvalue_V(2)/Tmp1) + Tmp1*0.25)
  end if

  Tmp1 = (UnR - BnR*RhoInvSqrtR) - (UnL - BnL*RhoInvSqrtL)
  Tmp1 = max(cTiny, 4.*Tmp1)
  if (abs(Eigenvalue_V(3)) < Tmp1*0.5) then
     Eigenvalue_V(3) = sign(1.,Eigenvalue_V(3))*   &
          ((Eigenvalue_V(3)*Eigenvalue_V(3)/Tmp1) + Tmp1*0.25)
  end if

  Tmp1 = (UnR + CsR) - (UnL + CsL)
  Tmp1 = max(cTiny, 4.*Tmp1)
  if (abs(Eigenvalue_V(4)) < Tmp1*0.5) then
     Eigenvalue_V(4) = sign(1.,Eigenvalue_V(4))*   &
          ((Eigenvalue_V(4)*Eigenvalue_V(4)/Tmp1) + Tmp1*0.25)
  end if

  Tmp1 = (UnR+CfR) - (UnL+CfL)
  Tmp1 = max(cTiny, 4.*Tmp1)
  if (abs(Eigenvalue_V(5)) < Tmp1*0.5) then
     Eigenvalue_V(5) = sign(1.,Eigenvalue_V(5))*   &
          ((Eigenvalue_V(5)*Eigenvalue_V(5)/Tmp1) + Tmp1*0.25)
  end if

  Tmp1 = (UnR-CsR) - (UnL-CsL)
  Tmp1 = max(cTiny, 4.*Tmp1)
  if (abs(Eigenvalue_V(6)) < Tmp1*0.5) then
     Eigenvalue_V(6) = sign(1.,Eigenvalue_V(6))*   &
          ((Eigenvalue_V(6)*Eigenvalue_V(6)/Tmp1) + Tmp1*0.25)
  end if

  Tmp1 = (UnR-CfR) - (UnL-CfL)
  Tmp1 = max(cTiny, 4.*Tmp1)
  if (abs(Eigenvalue_V(7)) < Tmp1*0.5) then
     Eigenvalue_V(7) = sign(1.,Eigenvalue_V(7))*   &
          ((Eigenvalue_V(7)*Eigenvalue_V(7)/Tmp1) + Tmp1*0.25)
  end if

  Tmp1 = (UnR) - (UnL)
  Tmp1 = max(cTiny, 4.*Tmp1)
  if (abs(Eigenvalue_V(8)) < Tmp1*0.5) then
     Eigenvalue_V(8) = sign(1.,Eigenvalue_V(8))* &
          ((Eigenvalue_V(8)*Eigenvalue_V(8)/Tmp1) + Tmp1*0.25)
  end if

  !\
  ! Timur's divergence wave fix!!!
  !/
  !original  version
  !      Eigenvalue_V(8)=abs(Eigenvalue_V(8))+aH
  !
  !Enhanced diffusion, the maximum eigenvalue
  Eigenvalue_V(DivbW_) = max( Eigenvalue_V(FastRW_), -Eigenvalue_V(FastLW_))

  ! The original version was proposed by Timur Linde for heliosphere
  ! simulations. Enhanced version was found to be more robust on 8/20/01
  ! The original version was commented out in versions 6x resulting in 
  ! worse stability for the Roe solver.

  ! At inner BC replace all eigenvalues with the enhanced eigenvalue
  ! of divB, which is the maximum eigenvalue
  if(UseFluxRusanov) Eigenvalue_V(1:nWave) = Eigenvalue_V(DivBW_)

  !\
  ! Eigenvectors
  !/
  Tmp1=1./(2.*RhoH*aH**2)
  Tmp2=RhoInvH*cSqrtHalf
  Tmp3=RhoInvSqrtH*cSqrtHalf

  ! Left eigenvector for Entropy wave
  EigenvectorL_VV(1,1) = 1.-0.5*Gamma1A2Inv*UuH
  EigenvectorL_VV(2,1) = Gamma1A2Inv*UnH
  EigenvectorL_VV(3,1) = Gamma1A2Inv*Ut1H
  EigenvectorL_VV(4,1) = Gamma1A2Inv*Ut2H
  EigenvectorL_VV(5,1) = Gamma1A2Inv*B1nH
  EigenvectorL_VV(6,1) = Gamma1A2Inv*B1t1H
  EigenvectorL_VV(7,1) = Gamma1A2Inv*B1t2H
  EigenvectorL_VV(8,1) = -Gamma1A2Inv

  ! Left eigenvector for Alfven wave +
  EigenvectorL_VV(1,2) = (Ut1H*BetaZ-Ut2H*BetaY)*Tmp2
  EigenvectorL_VV(2,2) = 0.
  EigenvectorL_VV(3,2) = -(BetaZ*Tmp2)
  EigenvectorL_VV(4,2) = (BetaY*Tmp2)
  EigenvectorL_VV(5,2) = 0.
  EigenvectorL_VV(6,2) = (BetaZ*Tmp3)
  EigenvectorL_VV(7,2) = -(BetaY*Tmp3)
  EigenvectorL_VV(8,2) = 0.

  ! Left eigenvector for Alfven wave -
  EigenvectorL_VV(1,3) = (Ut1H*BetaZ-Ut2H*BetaY)*Tmp2
  EigenvectorL_VV(2,3) = 0.
  EigenvectorL_VV(3,3) = -(BetaZ*Tmp2)
  EigenvectorL_VV(4,3) = (BetaY*Tmp2)
  EigenvectorL_VV(5,3) = 0.
  EigenvectorL_VV(6,3) = -(BetaZ*Tmp3)
  EigenvectorL_VV(7,3) = (BetaY*Tmp3)
  EigenvectorL_VV(8,3) = 0.

  ! Left eigenvector for Slow magnetosonic wave +
  EigenvectorL_VV(1,4) = Tmp1* &
       (AlphaS*(gm1*UuH/2. - UnH*CsH) - &
       AlphaF*CfH*SignBnH*(Ut1H*BetaY + Ut2H*BetaZ))
  EigenvectorL_VV(2,4) = Tmp1*(AlphaS*(-UnH*gm1+CsH))
  EigenvectorL_VV(3,4) = Tmp1*(-gm1*AlphaS*Ut1H + AlphaF*CfH*BetaY*SignBnH)
  EigenvectorL_VV(4,4) = Tmp1*(-gm1*AlphaS*Ut2H + AlphaF*CfH*BetaZ*SignBnH)
  EigenvectorL_VV(5,4) = Tmp1*(-gm1*B1nH*AlphaS)
  EigenvectorL_VV(6,4) = Tmp1*(-AlphaF*BetaY*aH*RhoSqrtH-gm1*B1t1H*AlphaS)
  EigenvectorL_VV(7,4) = Tmp1*(-AlphaF*BetaZ*aH*RhoSqrtH - gm1*B1t2H*AlphaS)
  EigenvectorL_VV(8,4) = Tmp1*(gm1*AlphaS)

  ! Left eigenvector for Fast magnetosonic wave +
  EigenvectorL_VV(1,5) = Tmp1* &
       (AlphaF*(gm1*UuH/2. - UnH*CfH)+AlphaS*CsH*SignBnH* &
       (Ut1H*BetaY + Ut2H*BetaZ))
  EigenvectorL_VV(2,5) = Tmp1*(AlphaF*(-UnH*gm1+CfH))
  EigenvectorL_VV(3,5) = Tmp1*(-gm1*AlphaF*Ut1H - AlphaS*CsH*BetaY*SignBnH)
  EigenvectorL_VV(4,5) = Tmp1*(-gm1*AlphaF*Ut2H - AlphaS*CsH*BetaZ*SignBnH)
  EigenvectorL_VV(5,5) = Tmp1*(-gm1*B1nH*AlphaF)
  EigenvectorL_VV(6,5) = Tmp1*(AlphaS*BetaY*aH*RhoSqrtH - gm1*B1t1H*AlphaF)
  EigenvectorL_VV(7,5) = Tmp1*(AlphaS*BetaZ*aH*RhoSqrtH - gm1*B1t2H*AlphaF)
  EigenvectorL_VV(8,5) = Tmp1*(gm1*AlphaF)

  ! Left eigenvector for Slow magnetosonic wave -
  EigenvectorL_VV(1,6) = Tmp1* &
       (AlphaS*(gm1*UuH/2. + UnH*CsH) + &
       AlphaF*CfH*SignBnH*(Ut1H*BetaY + Ut2H*BetaZ))
  EigenvectorL_VV(2,6) = Tmp1*(AlphaS*(-UnH*gm1-CsH))
  EigenvectorL_VV(3,6) = Tmp1*(-gm1*AlphaS*Ut1H - AlphaF*CfH*BetaY*SignBnH)
  EigenvectorL_VV(4,6) = Tmp1*(-gm1*AlphaS*Ut2H - AlphaF*CfH*BetaZ*SignBnH)
  EigenvectorL_VV(5,6) = Tmp1*(-gm1*B1nH*AlphaS)
  EigenvectorL_VV(6,6) = Tmp1*(-AlphaF*BetaY*aH*RhoSqrtH-gm1*B1t1H*AlphaS)
  EigenvectorL_VV(7,6) = Tmp1*(-AlphaF*BetaZ*aH*RhoSqrtH-gm1*B1t2H*AlphaS)
  EigenvectorL_VV(8,6) = Tmp1*(gm1*AlphaS)

  ! Left eigenvector for Fast magnetosonic wave -
  EigenvectorL_VV(1,7) = Tmp1* &
       (AlphaF*(gm1*UuH/2. + UnH*CfH) - &
       AlphaS*CsH*SignBnH*(Ut1H*BetaY + Ut2H*BetaZ))
  EigenvectorL_VV(2,7) = Tmp1*(AlphaF*(-UnH*gm1-CfH))
  EigenvectorL_VV(3,7) = Tmp1*(-gm1*AlphaF*Ut1H + AlphaS*CsH*BetaY*SignBnH)
  EigenvectorL_VV(4,7) = Tmp1*(-gm1*AlphaF*Ut2H + AlphaS*CsH*BetaZ*SignBnH)
  EigenvectorL_VV(5,7) = Tmp1*(-gm1*B1nH*AlphaF)
  EigenvectorL_VV(6,7) = Tmp1*(AlphaS*BetaY*aH*RhoSqrtH-gm1*B1t1H*AlphaF)
  EigenvectorL_VV(7,7) = Tmp1*(AlphaS*BetaZ*aH*RhoSqrtH-gm1*B1t2H*AlphaF)
  EigenvectorL_VV(8,7) = Tmp1*(gm1*AlphaF)

  ! Left eigenvector for Divergence wave
  EigenvectorL_VV(1,8) = 0.
  EigenvectorL_VV(2,8) = 0.
  EigenvectorL_VV(3,8) = 0.
  EigenvectorL_VV(4,8) = 0.
  EigenvectorL_VV(5,8) = 1.
  EigenvectorL_VV(6,8) = 0.
  EigenvectorL_VV(7,8) = 0.
  EigenvectorL_VV(8,8) = 0.

  !coefficient for pressure component of the Right vector
  Tmp1=g*max(pL,pR) 

  !Pressure component is not linearly independent and obeys the 
  ! equation as follows:
  !EigenvectorR_VV(1:8,9)=(0.5*UuH*EigenvectorR_VV(1:8,1)-&
  !                     UnH*EigenvectorR_VV(1:8,2)-&
  !                     Ut1H*EigenvectorR_VV(1:8,3)-&
  !                     Ut2H*EigenvectorR_VV(1:8,4)-&
  !                     B1nH*EigenvectorR_VV(1:8,5)-&
  !                     B1t1H*EigenvectorR_VV(1:8,6)-&
  !                     B1t2H*EigenvectorR_VV(1:8,7)+
  !                     EigenvectorR_VV(1:8,8))*inv_gm1         

  ! Right eigenvector for Entropy wave
  EigenvectorR_VV(1,1) = 1.
  EigenvectorR_VV(1,2) = UnH
  EigenvectorR_VV(1,3) = Ut1H
  EigenvectorR_VV(1,4) = Ut2H
  EigenvectorR_VV(1,5) = 0.
  EigenvectorR_VV(1,6) = 0.
  EigenvectorR_VV(1,7) = 0.
  EigenvectorR_VV(1,eMhd_) = 0.5*UuH
  EigenvectorR_VV(1,pMhd_)=cZero

  ! Right eigenvector for Alfven wave +
  EigenvectorR_VV(2,1) = 0.
  EigenvectorR_VV(2,2) = 0.
  EigenvectorR_VV(2,3) = -BetaZ*RhoH*cSqrtHalf
  EigenvectorR_VV(2,4) = BetaY*RhoH*cSqrtHalf
  EigenvectorR_VV(2,5) = 0.
  EigenvectorR_VV(2,6) = BetaZ*RhoSqrtH*cSqrtHalf
  EigenvectorR_VV(2,7) = -BetaY*RhoSqrtH*cSqrtHalf
  EigenvectorR_VV(2,eMhd_) = (BetaY*Ut2H - BetaZ*Ut1H)*RhoH*cSqrtHalf &
       + (B1t1H*BetaZ - B1t2H*BetaY)*RhoSqrtH*cSqrtHalf
  EigenvectorR_VV(2,pMhd_)=cZero

  ! Right eigenvector for Alfven wave -
  EigenvectorR_VV(3,1) = 0.
  EigenvectorR_VV(3,2) = 0.
  EigenvectorR_VV(3,3) = -BetaZ*RhoH*cSqrtHalf
  EigenvectorR_VV(3,4) = BetaY*RhoH*cSqrtHalf
  EigenvectorR_VV(3,5) = 0.
  EigenvectorR_VV(3,6) = -BetaZ*RhoSqrtH*cSqrtHalf
  EigenvectorR_VV(3,7) = BetaY*RhoSqrtH*cSqrtHalf
  EigenvectorR_VV(3,eMhd_) = (BetaY*Ut2H - BetaZ*Ut1H)*RhoH*cSqrtHalf &
       - (B1t1H*BetaZ - B1t2H*BetaY)*RhoSqrtH*cSqrtHalf
  EigenvectorR_VV(3,pMhd_)=cZero

  ! Right eigenvector for Slow magnetosonic wave +
  EigenvectorR_VV(4,1) = RhoH*AlphaS
  EigenvectorR_VV(4,2) = RhoH*AlphaS*(UnH+CsH)
  EigenvectorR_VV(4,3) = RhoH*(AlphaS*Ut1H + AlphaF*CfH*BetaY*SignBnH)
  EigenvectorR_VV(4,4) = RhoH*(AlphaS*Ut2H + AlphaF*CfH*BetaZ*SignBnH)
  EigenvectorR_VV(4,5) = 0.
  EigenvectorR_VV(4,6) = -AlphaF*aH*BetaY*RhoSqrtH
  EigenvectorR_VV(4,7) = -AlphaF*aH*BetaZ*RhoSqrtH
  EigenvectorR_VV(4,eMhd_) = &
       AlphaS*(RhoH*UuH*0.5 + g*pH*inv_gm1+RhoH*UnH*CsH) &
       - AlphaF*(aH*RhoSqrtH*(BetaY*B1t1H + BetaZ*B1t2H) &
       - RhoH*CfH*SignBnH*(Ut1H*BetaY + Ut2H*BetaZ))
  EigenvectorR_VV(4,pMhd_)=Tmp1*AlphaS

  ! Right eigenvector for Fast magnetosonic wave +
  EigenvectorR_VV(5,1) = RhoH*AlphaF
  EigenvectorR_VV(5,2) = RhoH*AlphaF* (UnH+CfH)
  EigenvectorR_VV(5,3) = RhoH* (AlphaF*Ut1H - AlphaS*CsH*BetaY*SignBnH)
  EigenvectorR_VV(5,4) = RhoH* (AlphaF*Ut2H - AlphaS*CsH*BetaZ*SignBnH)
  EigenvectorR_VV(5,5) = 0.
  EigenvectorR_VV(5,6) = AlphaS*aH*BetaY*RhoSqrtH
  EigenvectorR_VV(5,7) = AlphaS*aH*BetaZ*RhoSqrtH
  EigenvectorR_VV(5,eMhd_) = &
       AlphaF*(RhoH*UuH*0.5 + g*pH*inv_gm1+RhoH*UnH*CfH) &
       + AlphaS*(aH*RhoSqrtH*(BetaY*B1t1H + BetaZ*B1t2H) &
       - RhoH*CsH*SignBnH*(Ut1H*BetaY + Ut2H*BetaZ))
  EigenvectorR_VV(5,pMhd_)=Tmp1*AlphaF

  ! Right eigenvector for Slow magnetosonic wave -
  EigenvectorR_VV(6,1) = RhoH*AlphaS
  EigenvectorR_VV(6,2) = RhoH*AlphaS*(UnH-CsH)
  EigenvectorR_VV(6,3) = RhoH* (AlphaS*Ut1H - AlphaF*CfH*BetaY*SignBnH)
  EigenvectorR_VV(6,4) = RhoH* (AlphaS*Ut2H - AlphaF*CfH*BetaZ*SignBnH)
  EigenvectorR_VV(6,5) = 0.
  EigenvectorR_VV(6,6) = - AlphaF*aH*BetaY*RhoSqrtH
  EigenvectorR_VV(6,7) = - AlphaF*aH*BetaZ*RhoSqrtH
  EigenvectorR_VV(6,eMhd_) = &
       AlphaS*(RhoH*UuH*0.5 + g*pH*inv_gm1-RhoH*UnH*CsH) &
       - AlphaF*(aH*RhoSqrtH*(BetaY*B1t1H + BetaZ*B1t2H) &
       + RhoH*CfH*SignBnH*(Ut1H*BetaY + Ut2H*BetaZ))
  EigenvectorR_VV(6,pMhd_)=Tmp1*AlphaS

  ! Right eigenvector for Fast magnetosonic wave -
  EigenvectorR_VV(7,1) = RhoH*AlphaF
  EigenvectorR_VV(7,2) = RhoH*AlphaF* (UnH-CfH)
  EigenvectorR_VV(7,3) = RhoH*(AlphaF*Ut1H + AlphaS*CsH*BetaY*SignBnH)
  EigenvectorR_VV(7,4) = RhoH*(AlphaF*Ut2H + AlphaS*CsH*BetaZ*SignBnH)
  EigenvectorR_VV(7,5) = 0.
  EigenvectorR_VV(7,6) = AlphaS*aH*BetaY*RhoSqrtH
  EigenvectorR_VV(7,7) = AlphaS*aH*BetaZ*RhoSqrtH
  EigenvectorR_VV(7,eMhd_) = &
       AlphaF*(RhoH*UuH*0.5 + g*pH*inv_gm1-RhoH*UnH*CfH) &
       + AlphaS*(aH*RhoSqrtH*(BetaY*B1t1H + BetaZ*B1t2H) &
       + RhoH*CsH*SignBnH*(Ut1H*BetaY + Ut2H*BetaZ))
  EigenvectorR_VV(7,pMhd_)=Tmp1*AlphaF

  ! Right eigenvector for Divergence wave
  EigenvectorR_VV(8,1) = 0.
  EigenvectorR_VV(8,2) = 0.
  EigenvectorR_VV(8,3) = 0.
  EigenvectorR_VV(8,4) = 0.
  EigenvectorR_VV(8,5) = 1.
  EigenvectorR_VV(8,6) = 0.
  EigenvectorR_VV(8,7) = 0.
  EigenvectorR_VV(8,eMhd_) = B1nH
  EigenvectorR_VV(8,pMhd_) = cZero

  !\
  ! Alphas (elemental wave strengths)
  !/
  ! matmul is slower than the loop for the NAG F95 compiler
  ! DeltaWave_V = matmul(dCons_V, EigenvectorL_VV)
  do iWave = 1, nWave
     DeltaWave_V(iWave) = sum(dCons_V*EigenvectorL_VV(:,iWave))
  end do
  !\
  ! Calculate the Roe Interface fluxes 
  ! F = A * 0.5 * [ F_L+F_R - sum_k(|lambda_k| * alpha_k * r_k) ]
  !/
  ! First get the diffusion: sum_k(|lambda_k| * alpha_k * r_k)
  !  Diffusion_V = matmul(abs(Eigenvalue_V)*DeltaWave_V, EigenvectorR_VV)
  do iFlux = 1, nFluxMhd
     Diffusion_V(iFlux) = &
          sum(abs(Eigenvalue_V)*DeltaWave_V*EigenvectorR_VV(:,iFlux))
  end do

  ! Scalar variables
  Flux_V(Rho_   ) = Diffusion_V(RhoMhd_)
  Flux_V(P_     ) = Diffusion_V(pMhd_)
  Flux_V(Energy_) = Diffusion_V(eMhd_)

  ! Rotate n,t1,t2 components back to x,y,z components
  if(UseCovariant)then                                 !^CFG IF COVARIANT BEGIN
     Flux_V(RhoUx_) = Normal_D(x_)  *Diffusion_V(RhoUn_)  &
          +           Tangent1_D(x_)*Diffusion_V(RhoUt1_) &
          +           Tangent2_D(x_)*Diffusion_V(RhoUt2_)
     Flux_V(RhoUy_) = Normal_D(y_)  *Diffusion_V(RhoUn_)  &
          +           Tangent1_D(y_)*Diffusion_V(RhoUt1_) &
          +           Tangent2_D(y_)*Diffusion_V(RhoUt2_)
     Flux_V(RhoUz_) = Normal_D(z_)  *Diffusion_V(RhoUn_)  &
          +           Tangent1_D(z_)*Diffusion_V(RhoUt1_) &
          +           Tangent2_D(z_)*Diffusion_V(RhoUt2_)

     Flux_V(Bx_   ) = Normal_D(x_)  *Diffusion_V(B1n_)  &
          +           Tangent1_D(x_)*Diffusion_V(B1t1_) &
          +           Tangent2_D(x_)*Diffusion_V(B1t2_)
     Flux_V(By_   ) = Normal_D(y_)  *Diffusion_V(B1n_)  &
          +           Tangent1_D(y_)*Diffusion_V(B1t1_) &
          +           Tangent2_D(y_)*Diffusion_V(B1t2_)
     Flux_V(Bz_   ) = Normal_D(z_)  *Diffusion_V(B1n_)  &
          +           Tangent1_D(z_)*Diffusion_V(B1t1_) &
          +           Tangent2_D(z_)*Diffusion_V(B1t2_)
  else                                                 !^CFG END COVARIANT
     select case (iDir)
     case (x_)
        Flux_V(RhoUx_ ) = Diffusion_V(RhoUn_)
        Flux_V(RhoUy_ ) = Diffusion_V(RhoUt1_)
        Flux_V(RhoUz_ ) = Diffusion_V(RhoUt2_)
        Flux_V(Bx_    ) = Diffusion_V(B1n_)
        Flux_V(By_    ) = Diffusion_V(B1t1_)
        Flux_V(Bz_    ) = Diffusion_V(B1t2_)
     case (y_)
        Flux_V(RhoUx_ ) = Diffusion_V(RhoUt2_)
        Flux_V(RhoUy_ ) = Diffusion_V(RhoUn_)
        Flux_V(RhoUz_ ) = Diffusion_V(RhoUt1_)
        Flux_V(Bx_    ) = Diffusion_V(B1t2_)
        Flux_V(By_    ) = Diffusion_V(B1n_)
        Flux_V(Bz_    ) = Diffusion_V(B1t1_)
     case (z_)
        Flux_V(RhoUx_ ) = Diffusion_V(RhoUt1_)
        Flux_V(RhoUy_ ) = Diffusion_V(RhoUt2_)
        Flux_V(RhoUz_ ) = Diffusion_V(RhoUn_)
        Flux_V(Bx_    ) = Diffusion_V(B1t1_)
        Flux_V(By_    ) = Diffusion_V(B1t2_)
        Flux_V(Bz_    ) = Diffusion_V(B1n_)
     end select
  end if                                               !^CFG IF COVARIANT

  ! The diffusive flux for the advected scalar variables is simply
  ! 0.5*|Velocity|*(U_R - U_L)
  do iVar = ScalarFirst_, ScalarLast_
     Flux_V(iVar) = abs(UnH)*(StateRightCons_V(iVar) - StateLeftCons_V(iVar))
  end do

  ! Roe flux = average of left and right flux plus the diffusive flux
  Flux_V  = 0.5*(FluxLeft_V + FluxRight_V - Area*Flux_V)

  ! Normal velocity and maximum wave speed
  Unormal_I(1) = Area*UnH
  CmaxDt       = Area*(abs(UnH) + CfH)

end subroutine roe_solver
!^CFG END ROEFLUX

!===========================================================================

subroutine calc_electric_field(iBlock)

  ! Calculate the total electric field which includes numerical resistivity
  ! This estimate averages the numerical fluxes to the cell centers 
  ! for sake of simplicity.

  use ModSize,       ONLY: nI, nJ, nK
  use ModVarIndexes, ONLY: Bx_,By_,Bz_
  use ModAdvance,    ONLY: Flux_VX, Flux_VY, Flux_VZ, Ex_CB, Ey_CB, Ez_CB
  use ModGeometry,   ONLY: fAx_BLK, fAy_BLK, fAz_BLK !^CFG IF NOT COVARIANT
 
  implicit none
  integer, intent(in) :: iBlock
  !------------------------------------------------------------------------
  !^CFG IF NOT COVARIANT BEGIN
  ! E_x=(fy+fy-fz-fz)/4
  Ex_CB(:,:,:,iBlock) = - 0.25*(                              &
       ( Flux_VY(Bz_,1:nI,1:nJ  ,1:nK  )                      &
       + Flux_VY(Bz_,1:nI,2:nJ+1,1:nK  )) / fAy_BLK(iBlock) - &
       ( Flux_VZ(By_,1:nI,1:nJ  ,1:nK  )                      &
       + Flux_VZ(By_,1:nI,1:nJ  ,2:nK+1)) / fAz_BLK(iBlock) )

  ! E_y=(fz+fz-fx-fx)/4
  Ey_CB(:,:,:,iBlock) = - 0.25*(                              &
       ( Flux_VZ(Bx_,1:nI  ,1:nJ,1:nK  )                      &
       + Flux_VZ(Bx_,1:nI  ,1:nJ,2:nK+1)) / fAz_BLK(iBlock) - &
       ( Flux_VX(Bz_,1:nI  ,1:nJ,1:nK  )                      &
       + Flux_VX(Bz_,2:nI+1,1:nJ,1:nK  )) / fAx_BLK(iBlock) )

  ! E_z=(fx+fx-fy-fy)/4
  Ez_CB(:,:,:,iBlock) = - 0.25*(                              &
       ( Flux_VX(By_,1:nI  ,1:nJ  ,1:nK)                      &
       + Flux_VX(By_,2:nI+1,1:nJ  ,1:nK)) / fAx_BLK(iBlock) - &
       ( Flux_VY(Bx_,1:nI  ,1:nJ  ,1:nK)                      &
       + Flux_VY(Bx_,1:nI  ,2:nJ+1,1:nK)) / fAy_BLK(iBlock))
  !^CFG END COVARIANT
end subroutine calc_electric_field

