	program rdNNK
	parameter (NPTMAX2 = 5000, NSTAMAX = 60)

	character*80 evstr
	character*14 uid
	character*10 staname
	character*4 station(NSTAMAX)
	character*80 evlist, stationfile
	real signal(NPTMAX2)
	logical staOK, h71exist, stnexist

	call read_fname(evlist, stationfile)
	call read_stations(stationfile, station, nsta)
	open(10, file = evlist,
     1           status = "old")

10	continue
	   read(10, *, end = 20) uid
	   write(6,*) uid
	   evstr = uid(length(sacdir)-16:length(sacdir))
	   call rd_wr_hdr0(evstr, uid, t0, h71exist)
	   if (h71exist) then
	      istn = 0
	      do ista = 1, nsta
	         write(6,*) station(ista)
	         call rd_sac(evstr, station(ista), uid, signal, 
     1                       tref, srate, stnexist)
	         if (stnexist) then
	            call rd_wr_hdr(station(ista), t0, tarr, staOK)
	            if (staOK) then
	               istn = istn + 1
	               call write_dat(istn, tarr, tref, srate, signal)
	            end if
	         end if
	      end do
	      close(40)
	      close(80)
	   end if
	go to 10
20	continue
	close(10)

	stop
	end

c----------------------------------------------------------------------
	subroutine read_fname(evlist, stationfile)

	character*(*) evlist, stationfile

	write(6,*) 'Please enter events/directories list name : '
	read(5, '(a)') evlist
	write(6,*) 'Please enter the station list name : '
	read(5, '(a)') stationfile

	return
	end

c----------------------------------------------------------------------
	subroutine read_stations(stationfile,station, nsta)

	character*(*) station(*), stationfile

	open(10, file = stationfile, status = 'old')
	i = 1
10	continue
	   read(10, '(a10)', end = 20) station(i)
	   i = i + 1
	go to 10
20	continue
	nsta = i - 1
	write(6,*) 'nsta = ', nsta

	return
	end

c----------------------------------------------------------------------
	subroutine rd_wr_hdr0(evstr, uid, t0, h71exist)

	parameter (SRATE = 0.01, IOFFSET = 100)
	
	character*(*) evstr, uid
	character*35 ch
	character*80 fname
	logical h71exist

	fname = uid(1:length(uid))//'/'//evstr(1:length(evstr))//'.h71'
	write(6,*) fname

	open(70, file = fname(1:length(fname)), 
     1           status = 'old', err = 10)
	
	read(70,*)
	read(70, 
     1   '(13x,f5.2,2(i4,f6.2),f7.2,8x,i2,4x,i3,3x,f4.2,2(1x,f4.1))', 
     2            end = 10) 
     3             t0, ilat, flat, ilon, flon, zdepth, 
     4             ns, igap, rms, erh, erz
	ylat = ilat + flat / 60. 
	xlon = ilon + flon / 60.
	write(6,*) 'ylat = ', ylat, ' xlon = ', xlon, 
     1             ' zdepth = ', zdepth

	open(40, file = uid//'/'//evstr(1:length(evstr))//'.dat',
     1           status = 'unknown',
     2           form = 'unformatted',
     3           access = 'direct',
     4           recl = 512)
	open(80, file = uid//'/'//evstr(1:length(evstr))//'.hdr',
     1           status = 'unknown')
c Attention au changement f8.5 --> f8.3 pour la latitude!!!
	write(80, 
     1 '(a12,f5.2,1x,f8.3,1x,f9.5,1x,f6.3,2(1x,i3),1x,f4.2,2(1x,f4.1))')
     2              uid,t0,ylat,xlon,zdepth,ns,igap,rms,erh,erz
	write(80, '(a12,1x,f5.3,2(1x,i3))') uid, SRATE, IOFFSET, ns

	h71exist = .true.
	return

10	continue
	h71exist = .false.
	return
	end

c------------------------------------------------------------------
	subroutine rd_wr_hdr(sta, t0, tarr, staOK)

	character*4 stn, ch
	character*10 sta
	logical staOK

	staOK = .false.
	read(70, '(1x,a4)', end = 10) ch
	do while (ch(2:4) .ne. 'STN')
	   read(70, '(1x,a4)', end = 10) ch
	end do
	read(70, '(1x,a4,1x,f5.1,2(1x,i3),11x,f5.2,1x,f5.2)', end = 10) 
     1             stn, dist, iazm, iain, tarr, tp
c On considère que les trois composantes ont les mêmes temps d arrivées et les mêmes paramètres de rai! Permet de récupérer des signaux (E,N) non pointés.
	do while (stn(1:3) .ne. sta(4:6) .and. (stn(1:3) .ne. '   '))
	   read(70, '(1x,a4,1x,f5.1,2(1x,i3),11x,f5.2,1x,f5.2)', 
     1                end = 10) 
     1                stn, dist, iazm, iain, tarr, tp
	end do
	if (stn(1:3) .eq. sta(4:6)) then
	   if (tp .lt. 0.) tp = tp + 60.
	   write(80, '(a4,1x,f6.3,1x,f5.2,2(1x,i3),2x,i1)')
     1                 sta(4:6), tp, dist, iazm, iain, 1
	   staOK = .true.
	end if
10	continue
	rewind(70)
c	write(6,*) 'tp = ', tp

	return
	end

c------------------------------------------------------------------
        subroutine rd_sac(evstr, staname, uid, signal, 
     1                    tref, srate, stnexist)
        parameter (NPTMAX = 5000)

	character*80 evid, evstr, fname
	character*14 uid
	character*10 staname
	logical stnexist

        real float_header(70)
        integer int_header(40)
        character*192 char_header
        real buffer(NPTMAX), signal(*)

        
        fname = uid(1:length(uid))//'/'//staname//'.sac.linux'
c	write(6,*) fname
        open(50, file = fname,
     1           status = 'old',
     2           form = 'unformatted',
     3           access = 'direct',
     4           recl = 20636,
     5           err = 10)

        read(50, rec = 1) float_header, int_header, char_header, buffer
        close(50)

	do i = 1, NPTMAX
	   signal(i) = buffer(i)
	end do

c	write(6,*) int_header
c	open(60, file = 'dummy')
c	if (staname .eq. 'TCRE') then
c	   write(60, '(f10.4)') (buffer(i), i = 1, NPTMAX)
c	end if
c	close(60)
c        do i = 1, 70
c           write(6,*) "i = ", i, " ", float_header(i)
c        end do

c	write(uid, '(a2,a6,3i2.2)') '20', evstr(7:12),
c     1       int_header(3), int_header(4), int_header(5)
c     2       nint(int_header(5)+int_header(6)/1000.)
c	write(6,*) uid
	tref = int_header(5)+int_header(6)/1000.
c        tref = float_header(6)
	srate = float_header(1)

	stnexist = .true.
	return

10	continue
	stnexist = .false.
	close(50)
	return
	end

c------------------------------------------------------------------
	subroutine write_dat(istn, tarr, tref, srate, signal)
        parameter (MAX_QLOOK = 256, NPRE_EVT = 100)
c        parameter (MAX_QLOOK = 1024, NPRE_EVT = 100)
c Voir si on ne peut pas améliorer la résolution du signal.

        integer*2 qlook(MAX_QLOOK)
	real signal(*)

	tp = tarr - tref
	if (tp .le. 0.) tp = tp + 60.
        iP = nint(tp / srate)
c	write(6,*) 'tarr = ', tarr, ' t0s = ', tref, ' srate = ', srate
c	write(6,*) 'iP = ', iP
        iBeg = iP - NPRE_EVT
        iEnd = iBeg + MAX_QLOOK - 1
c        write(6,*) "iBeg = ", iBeg, " iEnd = ", iEnd
c	open(60, file = 'dummy')
        do i = iBeg, iEnd
c           write(60, *) signal(i)
           qlook(i - iBeg + 1) = signal(i)
        end do
c        close(60)
        write(40, rec = istn) qlook 

        return
        end
        
c------------------------------------------------------------------
        function length(ch)

        character*(*) ch
        integer ich

        ich = 1
        do while ((ch(ich:ich) .ne. " ") .and. (ich .le. len(ch)))
           ich = ich + 1
        end do

        length = ich - 1

        end
