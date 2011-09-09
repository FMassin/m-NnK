	program VmodelNLL2tomoTV


	character*(*) name_model
	character*1 PouS
	integer NX, NY, NZ
	real V(NX*NY*NZ), Vit(NX, NY, NZ) 

c----------------------------- input 
	write(*,*) ' enter the NLLoc model name '
	read(*,'(a)') name_model
	write(*,*) ' P ou S ? '
	read(*,'(a)') PouS

c----------------------------- read NLLoc model
	read(5,*) Vit

	open(7,file=name_model,access='direct',recl=4*NX*NY*NZ)

	kc=0
	do k=1,NZ
	   do j=1,NY
	      do i=1,NX
	         kc=kc+1
	         V(kc)=Vit(i,j,k)
	      end do
	   end do
	end do

	call subwrite(7,1,V,NX*NY*NZ)
	stop
	end


	open(40, file = 'model'//PouS//'_local',
1           status = 'unknown',
2           form = 'unformatted',
3           access = 'direct',
4           recl = 512)
	write(40, rec = 1) V, NX, NY, NZ, OX, OY, OZ, HX, HY, HZ
	close(40)
	stop
	end
