
!
!      TEC_NMF2_HMF2-3D-QUADB.F
!

!      does quadratic fit

!      uses 3D interpolated data: dene0, balt0, blat0, blon0
!      to calculate tec (tecu.dat),
!                   nmf2 (nmf2u.dat),
!                   hmf2 (hmf2u.dat)

!      array indices for interpolated data

       include "param_diagB.inc"

!       parameter ( nx   = 100,
!     .             ny   = 100,
!     .             nl   = 12,
!     .             nt   =  38  )


!      arrays of interpolated data

       real blat0(nx,ny,nl),blon0(nx,ny,nl),balt0(nx,ny,nl)
       real dene0(nx,ny,nl,nt)

!      tec, nmf2, hmf2 arrays
 
       real tec(nx,nl,nt),nmf2(nx,nl,nt),hmf2(nx,nl,nt)
       integer jmax(nx,nl,nt)

!      open interpolated data files

       open(unit=13,file='blat0.dat', form='unformatted')
       open(unit=14,file='blon0.dat', form='unformatted')
       open(unit=15,file='balt0.dat', form='unformatted')
       open(unit=16,file='dene0B.dat', form='unformatted')

!      open tec, nmf2, hmf2 files

       open(unit=21,file='tecub.dat',   form='unformatted')
       open(unit=22,file='nmf2ub.dat',  form='unformatted')
       open(unit=23,file='hmf2ub.dat',  form='unformatted')

!      read in 'interpolated' data
 
       print *,'reading blat0'
       read(13) blat0
       print *,'reading blon0'
       read(14) blon0
       print *,'reading balt0'
       read(15) balt0
       print *,'reading dene0'
!       do n = 1,nt
!         print *, ' time step n = ',n
!         read(16) dene0tmp
!         do k = 1,nl
!           do j = 1,ny
!             do i = 1,nx
!               dene0(i,j,k,n) = dene0tmp(i,j,k)
!             enddo
!           enddo
!         enddo
!       enddo
       read(16) dene0

!      calculate total electron content (tec)

       print *,'setting tecB'

       do n = 1,nt
         do k = 1,nl
           do ix = 1,nx
             tec(ix,k,n) = 0.

!             do iy = 1,ny-1

             iy = 1
             do while (balt0(ix,iy,k) .lt. 1.e3 .and. iy .le. ny-1) 
               dely0       = balt0(ix,iy+1,k) - balt0(ix,iy,k)
               tec(ix,k,n) = tec(ix,k,n) 
     .                       + dene0(ix,iy,k,n) * dely0 * 1.e-7
               iy = iy + 1
             enddo
           enddo
         enddo
       enddo

       write(21) tec

!      calculate nmf2 and hmf2

       print *,'setting nmf2 and hmf2'

       do n = 1,nt
         do k = 1,nl
           do i = 1,nx
             denmax      = 1.e-6
             jmax(i,k,n) = 1.
             do j = 1,ny-1
               if ( dene0(i,j,k,n) .ge. denmax ) then
                 denmax      = dene0(i,j,k,n)
                 jmax(i,k,n) = j
               endif
             enddo
           enddo
         enddo
       enddo

       do n = 1,nt
         do k = 1,nl
           do i = 1,nx
             nmf2(i,k,n) = dene0(i,jmax(i,k,n),k,n)
             hmf2(i,k,n) = balt0(i,jmax(i,k,n),k)
           enddo
         enddo
       enddo

!       go to 100

       do n = 1,nt
         do k = 1,nl
           do i = 1,nx
             j1   = jmax(i,k,n) - 1
             j2   = jmax(i,k,n)
             j3   = jmax(i,k,n) + 1
             z1   = balt0(i,j1,k)
             z2   = balt0(i,j2,k)
             z3   = balt0(i,j3,k)
             f1   = dene0(i,j1,k,n)
             f2   = dene0(i,j2,k,n)
             f3   = dene0(i,j3,k,n)
             det = z1 * z1 * ( z2 - z3 ) -
     .             z1 * ( z2 * z2 - z3 * z3 ) +
     .             ( z2 * z2 * z3 - z2 * z3 * z3 )
             adet = f1 * ( z2 - z3 ) -
     .              z1 * ( f2 - f3 ) +
     .              ( f2 * z3 - z2 * f3 )
             bdet = z1 * z1 * ( f2 - f3 ) -
     .              f1 * ( z2 * z2 - z3 * z3 ) +
     .              ( z2 * z2 * f3 - f2 * z3 * z3 )
             cdet = z1 * z1 * ( z2 * f3 - f2 * z3 ) -
     .              z1 * ( z2 * z2 * f3 - f2 * z3 * z3 ) + 
     .              f1 * ( z2 * z2 * z3 - z2 * z3 * z3 )
             a    = adet / det
             b    = bdet / det
             c    = cdet / det
             if ( a .eq. 0) then
               hmf2(i,k,n) = balt0(i,1,k)
               nmf2(i,k,n) = dene0(i,1,k,n)
             else
               hmf2(i,k,n) = -b / 2. / a
               zmax        = hmf2(i,k,n)
               nmf2(i,k,n) = a * zmax * zmax + b * zmax + c
             endif
             if ( hmf2(i,k,n) .gt. 1000. ) hmf2(i,k,n) = 85.
           enddo
         enddo
       enddo

 100   continue

       write(22) nmf2
       write(23) hmf2

       stop
       end

       
