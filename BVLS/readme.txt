dans RAW.out.20.gz sont donnés la date en col1, la ponderation en col2, les residus R2tot en col3, le reste des cols forme la matrice A2tot

dans BND.out.20 sont données les bornes de l'ajustement BND avec en col 1 BND(1,*)=borne min et en col 2 BND(2,*)=borne max

l'appel de bvls se fait via une interface

    interface

    subroutine bvls ( atilde, btilde, bndtilde, soltilde, chi2, nsetp, w, itilde,  loopA)
      real ( kind ( 1d0 ) ) atilde(:,:)
      real ( kind ( 1d0 ) ) btilde(:)
      real ( kind ( 1d0 ) ) bndtilde(:,:)
      real ( kind ( 1d0 ) ) soltilde(:)
      real ( kind ( 1d0 ) ) chi2
      integer nsetp
      real ( kind ( 1d0 ) ) w(:)
      integer itilde(:)
      integer loopA
    end subroutine

  end interface


avec
call bvls(A2tot,R2tot,BND,solnr_sol,chi2,nsetp,ww,istate,loopA)

#rapport inutilisable
maqao oneview --create-report=one uarch=HASWELL lprof_params="--use-OS-timers" binary=./a.out

#oui
maqao cqa loop=5 a.out uarch=HASWELL of=html

gfortran run.f90 bvlsDP.f90 -O3 -funroll-loops -unroll-and-jam -g3 -march=core-avx2

march et funroll ont l'air inutile pour le moment




25Mo cache/coeur
128Go RAM
utiliser ifortran ?
