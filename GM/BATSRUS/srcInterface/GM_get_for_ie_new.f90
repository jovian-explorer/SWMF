!^CFG COPYRIGHT UM
!^CMP FILE IE
!============================================
!                                           |
!     Magnetosphere/Ionosphere Coupling     |
!     Subroutines here are used with MPI    |
!============================================
module ModFieldAlignedCurrent

  use ModIeGrid
  
  implicit none
  save
  real, allocatable :: bCurrentLocal_VII(:,:,:), bCurrent_VII(:,:,:), &
       FieldAlignedCurrent_II(:,:)

contains

  subroutine init_mod_field_aligned_current(iSize,jSize)
    integer, intent(in) :: iSize, jSize

    if(allocated(FieldAlignedCurrent_II)) RETURN

    call init_mod_ie_grid(iSize, jSize)

    allocate( bCurrent_VII(0:6, nThetaIono, nPhiIono), &
         bCurrentLocal_VII(0:6, nThetaIono, nPhiIono), &
         FieldAlignedCurrent_II(nThetaIono, nPhiIono))

  end subroutine init_mod_field_aligned_current

  !============================================================================

  subroutine calc_field_aligned_current

    use ModVarIndexes,     ONLY: Bx_, Bz_, nVar
    use ModMain,           ONLY: Time_Simulation, TypeCoordSystem, nBlock
    use ModPhysics,        ONLY: rCurrents
    use ModCoordTransform, ONLY: sph_to_xyz
    use CON_planet_field,  ONLY: get_planet_field, map_planet_field
    use CON_axes,          ONLY: transform_matrix
    use ModProcMH,         ONLY: iProc, iComm
    use ModMpi

    ! Map the grid points from the ionosphere radius to rCurrents.
    ! Calculate the field aligned currents there, use the ratio of the
    ! magnetic field strength, and project to the radial direction.
    ! The result is saved into

    integer :: i, j, iHemisphere, iError
    real    :: Phi, Theta, XyzIono_D(3), Xyz_D(3)
    real    :: bIono_D(3), bIono, b_D(3), b, j_D(3), Fac
    real    :: GmSmg_DD(3,3)
    real    :: State_V(Bx_-1:nVar+3)
    !-------------------------------------------------------------------------

    GmSmg_DD = transform_matrix(Time_Simulation, 'SMG', TypeCoordSystem)
    
    do j = 1, nPhiIono
       Phi = j*dPhiIono
       do i = 1, nThetaIono
          Theta = i*dThetaIono
          call sph_to_xyz(rIonosphere,Theta,Phi, XyzIono_D)
          call map_planet_field(Time_Simulation, XyzIono_D, 'SMG NORM', &
               rCurrents, Xyz_D, iHemisphere)
          if(iHemisphere == 0) CYCLE

          ! Convert to GM coordinates
          Xyz_D = matmul(GmSmg_DD, Xyz_D)

          ! Extract currents and magnetic field for this position
          call get_point_data(0.0, Xyz_D, 1, nBlock, Bx_, nVar+3, State_V)

          bCurrentLocal_VII(0:3,i,j) = State_V(Bx_-1:Bz_)     ! Weight and B
          bCurrentLocal_VII(4:6,i,j) = State_V(nVar+1:nVar+3) ! Currents
       end do
    end do

    ! Add up contributions from all PE-s to processor 0
    call MPI_reduce(bCurrentLocal_VII, bCurrent_VII, nThetaIono*nPhiIono*7,&
         MPI_REAL, MPI_SUM, 0, iComm,iError)

    if(iProc /= 0) return

    ! Calculate the field aligned current
    do j = 1, nPhiIono
       Phi = j*dPhiIono
       do i = 1, nThetaIono
          Theta = i*dThetaIono

          ! Calculate magnetic field strength at the ionosphere grid point
          call sph_to_xyz(rIonosphere, Theta, Phi, XyzIono_D)
          call get_planet_field(Time_Simulation, XyzIono_D,'SMG NORM',bIono_D)
          bIono_D = sqrt(sum(bIono_D**2))

          ! Divide MHD values by the total weight if it exceeds 1.0
          if(bCurrent_VII(0,i,j) > 1.0) bCurrent_VII(:,i,j) = &
               bCurrent_VII(:,i,j) / bCurrent_VII(0,i,j)

          ! Extract magnetic field and current
          b_D = bCurrent_VII(1:3,i,j)
          j_D = bCurrent_VII(4:6,i,j)

          ! The strength of the field
          b = sqrt(sum(b_D**2))

          ! Convert b_D into a unit vector
          b_D = b_D / b

          ! Calculate field aligned current
          Fac = sum(b_D*j_D)

          ! Multiply by the ratio of the magnetic field strengths
          Fac = bIono / b * Fac

          ! Take the radial component
          Fac = Fac * sum(b_D*XyzIono_D) / rIonosphere

          ! Store the result
          FieldAlignedCurrent_II(i,j) = Fac

       end do
    end do

  end subroutine calc_field_aligned_current

end module ModFieldAlignedCurrent
!==============================================================================
subroutine GM_get_for_ie(Buffer_II,iSize,jSize,NameVar)

  use ModFieldAlignedCurrent,ONLY: FieldAlignedCurrent_II, &
       init_mod_field_aligned_current, calc_field_aligned_current

  implicit none

  character (len=*), parameter :: NameSub='GM_get_for_ie'

  integer, intent(in) :: iSize, jSize
  real, intent(out), dimension(iSize, jSize) :: Buffer_II
  character (len=*), intent(in) :: NameVar

  logical :: DoTest, DoTestMe
  !--------------------------------------------------------------------------
  call CON_set_do_test(NameSub,DoTest, DoTestMe)
  if(DoTest)write(*,*)NameSub,': starting with NameVar=',NameVar

  if(.not.allocated(FieldAlignedCurrent_II)) &
       call init_mod_field_aligned_current(iSize, jSize)

  select case(NameVar)
  case('JrNorth')
     call calc_field_aligned_current
     Buffer_II = FieldAlignedCurrent_II(1:iSize,:)
  case('JrSouth')
     Buffer_II = FieldAlignedCurrent_II(iSize:2*iSize-1,:)
  case default
     call CON_stop(NameSub//' invalid NameVar='//NameVar)
  end select
  if(DoTest)write(*,*)NameSub,': finished with NameVar=',NameVar

end subroutine GM_get_for_ie
