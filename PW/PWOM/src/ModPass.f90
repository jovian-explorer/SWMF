module ModFieldLine

  use ModParameters
  use ModCommonPlanet,ONLY: nVar
  implicit none

  private
  public put_field_line, get_field_line

  real    ::  PassState_CV(maxGrid,nVar)

  logical :: IsVariableDtPW, DoLogPW
  real    :: TimePW,MaxLineTimePW,DToutputPW, DTpolarwindPW,GeoMagLatPW,&
       GeoMagLonPW,JrPW,nDimPW,uJoule2PW
  real    :: wHorizontalPW
  integer :: nStepPw,iUnitInputPW,      &
       iUnitOutputPW,iUnitGraphicsPW,                 &
       iUnitSourceGraphicsPW,iUnitRestartPW,          &
       iUnitCollisionPW,iUnitRestartInPW,iLinePW,nLinePW
  CHARACTER(7) :: TypeSolverPW
  character*100 :: NameRestartPW
  real  :: rPW_C(maxGrid)
contains

  !***************************************************************************
  !  Put polarwind variables into Mod_PW for passing 
  !***************************************************************************

  subroutine put_field_line(State_CV, &
       GeoMagLat_I,GeoMagLon_I,Jr,wHorizontal,uJoule2,                  &
       iUnitOutput,iUnitGraphics, NameRestart,iLine,Time,   &
       MaxLineTime,TypeSolver,IsVariableDt,DToutput,nAlt,DoLog,&
       nStep,r_C)

    use ModParameters
    use ModCommonPlanet,ONLY: nVar
    
    real, intent(in) :: State_CV(maxGrid,nVar)
    real, optional, intent(in) :: Time,MaxLineTime,DToutput,uJoule2
    real, optional, intent(in) :: r_C(maxGrid)
    real,    intent(in)     :: GeoMagLat_I,GeoMagLon_I,Jr,wHorizontal  
    integer, optional,intent(in)  :: iUnitOutput,iUnitGraphics,iLine,nAlt,nStep
    character*100,optional,intent(in):: NameRestart
    character(7),optional,intent(in)::TypeSolver
    logical,optional,intent(in) :: IsVariableDt,DoLog
    !-------------------------------------------------------------------------
    
    PassState_CV(:,:) = State_CV(:,:)
    GeoMagLatPW = GeoMagLat_I
    GeoMagLonPW = GeoMagLon_I
    JrPW        = Jr
    wHorizontalPW   = wHorizontal
    

    if (present(nAlt))          nDimPW = nAlt
    
    if (present(Time))          TimePW = Time
    if (present(MaxLineTime))   MaxLineTimePW  = MaxLineTime
    if (present(iUnitGraphics)) iUnitGraphicsPW= iUnitGraphics
    if (present(NameRestart))   NameRestartPW  = NameRestart
    if (present(iLine))         iLinePW        = iLine
    if (present(iUnitOutput))   iUnitOutputPW  = iUnitOutput
    if (present(TypeSolver))    TypeSolverPW   = TypeSolver
    if (present(IsVariableDt))  IsVariableDtPW = IsVariableDt
    if (present(DToutput))      DToutputPW     = DToutput
    if (present(DoLog))         DoLogPW        = DoLog
    if (present(nStep))         nStepPW        = nStep
    if (present(r_c))           rPw_C(:)       = r_C(:)
    if (present(uJoule2))       uJoule2PW      = uJoule2

  end subroutine put_field_line

  !***************************************************************************
  !  Get polarwind variables from Mod_PW 
  !***************************************************************************

  subroutine get_field_line(State_CV,& 
       GeoMagLat_I,GeoMagLon_I,Jr,wHorizontal,uJoule2,                  &
       iUnitOutput,iUnitGraphics, NameRestart,iLine,Time,   &
       MaxLineTime,TypeSolver,IsVariableDt,DToutput, nAlt,DoLog,&
       nStep,r_C)

    use ModParameters
    use ModCommonPlanet, ONLY: nVar

    real, intent(out):: State_CV(MaxGrid,nVar)


    real,    intent(out)     :: GeoMagLat_I, GeoMagLon_I,Jr, wHorizontal           
    
    character*100,optional,intent(out):: NameRestart
    character(7),optional,intent(out):: TypeSolver
    logical,optional,intent(out)      :: IsVariableDt,DoLog
    real, optional, intent(out)       :: Time,MaxLineTime,DToutput,uJoule2
    real, optional, intent(out)        :: r_C(maxGrid)
    integer, optional,intent(out)     :: iUnitOutput,iUnitGraphics,iLine,nAlt,nStep
    !--------------------------------------------------------------------------
    
    State_CV(:,:)= PassState_CV(:,:)
    GeoMagLat_I = GeoMagLatPW
    GeoMagLon_I = GeoMagLonPW
    Jr        = JrPW
    wHorizontal = wHorizontalPW
   

    

    if (present(nAlt))          nAlt = nDimPW
    if (present(Time))          Time = TimePW
    if (present(MaxLineTime))   MaxLineTime = MaxLineTimePW
    if (present(iUnitGraphics)) iUnitGraphics =iUnitGraphicsPW
    if (present(NameRestart))   NameRestart=NameRestartPW
    if (present(iLine))         iLine = iLinePW
    if (present(iUnitOutput))   iUnitOutput=iUnitOutputPW
    if (present(TypeSolver))    TypeSolver =TypeSolverPW
    if (present(IsVariableDt))  IsVariableDt=IsVariableDtPW
    if (present(DToutput))      DToutput=DToutputPW
    if (present(DoLog))         DoLog=DoLogPW
    if (present(nStep))         nStep        = nStepPW
    if (present(r_C))           r_C(:)       = rPw_C(:)
    if (present(uJoule2))       uJoule2      = uJoule2PW
  end subroutine get_field_line

end module ModFieldLine
