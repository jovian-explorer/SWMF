!^CMP COPYRIGHT UM
!===========================================================!
!           SWMF: Space Weather Modeling Framework          |
!                   University of Michigan                  |
!============================================================
!BOP 
!
!QUOTE: \chapter{Control Module}
!QUOTE: \section{CON/Control: Main Executable and Control}
!MODULE: swmf - the main program for the stand-alone SWMF executable
!INTERFACE:
program SWMF

  !USES:
  use CON_main,      ONLY: initialize, finalize
  use CON_session,   ONLY: init_session, do_session
  use CON_io,        ONLY: read_inputs
  use CON_variables, ONLY: iErrorSwmf
  use ModMpi,        ONLY: MPI_SUCCESS

  implicit none

  !LOCAL VARIABLES:
  integer :: iErrorMpi     ! MPI error code
  logical :: IsLastSession ! true if last session

  !REVISION HISTORY:
  ! 09/01/05 G.Toth - initial version
  ! 09/09/05 G.Toth - moved session loop here from CON_main::run 
  !                   to avoid an ifort 8.070 compiler bug on the Altix
  !
  !DESCRIPTION:
  ! This main program is for the stand alone SWMF.
  ! It uses methods from CON\_main, CON\_session and CON\_io.
  ! The same methods can also be used from the swmf\_interface, 
  ! when the SWMF is run as a library, e.g. by an ESMF application.
  ! The main program does the following steps:
  ! \begin{verbatim}
  ! intialize MPI
  ! initialize the SWMF 
  ! loop over sessions
  !    read input parameters for the session
  !    initilize session
  !    execute session
  !    exit from loop if it is the last session
  ! finalize the SWMF
  ! finalize MPI
  ! \end{verbatim}
  ! \newpage

  !EOP
  !---------------------------------------------------------------------------
  !BOC
  call MPI_init(iErrorMpi)
  if(iErrorMpi  /= MPI_SUCCESS) stop 'SWMF_ERROR: MPI_init FAILED'
  !\
  ! Initialize SWMF
  !/
  call initialize
  if(iErrorSwmf /= 0)then
     call MPI_Finalize(iErrorMpi)
     stop
  end if
  !\
  ! Execute sessions. Each session can use different input parameters.
  !/
  do
     ! read input parameters for one session
     call read_inputs(IsLastSession)
     if(iErrorSwmf /= 0) EXIT

     ! initialize session
     call init_session
     if(iErrorSwmf /= 0) EXIT

     ! execute session
     call do_session(IsLastSession)

     ! Exit if IsLastSession was set to true or an error occured
     if(IsLastSession .or. iErrorSwmf /= 0) EXIT

  end do
  !\
  ! Finalize SWMF
  !/
  if(iErrorSwmf == 0) call finalize

  call MPI_finalize(iErrorMpi)
  !EOC
end program SWMF
