*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.ALERTA.REPRECIO

$INSERT T24.BP I_COMMON
$INSERT T24.BP I_EQUATE
$INSERT T24.BP I_AA.LOCAL.COMMON
$INSERT T24.BP I_F.AA.ARRANGEMENT
$INSERT T24.BP I_F.AA.ARRANGEMENT.ACTIVITY
$INSERT BP I_F.ST.L.APAP.COVI.PRELACIONIII

    GOSUB INIT
    GOSUB PROCESS

RETURN

INIT:

FN.ST.L.APAP.COVID.PRELACIONIII = 'F.ST.L.APAP.COVI.PRELACIONIII'
FV.ST.L.APAP.COVID.PRELACIONIII = ''
CALL OPF (FN.ST.L.APAP.COVID.PRELACIONIII,FV.ST.L.APAP.COVID.PRELACIONIII)

RETURN

PROCESS:
********
Y.OVERRIDE      = R.NEW(AA.ARR.ACT.OVERRIDE)
Y.ARRG.ID      = R.NEW(AA.ARR.ACT.ARRANGEMENT)
Y.ACTIVITY     = R.NEW(AA.ARR.ACT.ACTIVITY)

Y.MONTO.COVID19 = 0

 IF Y.ACTIVITY EQ 'LENDING-CHANGE-PRINCIPALINT' OR Y.ACTIVITY EQ 'LENDING-CHANGE-PENALTINT' THEN

    CALL F.READ(FN.ST.L.APAP.COVID.PRELACIONIII,Y.ARRG.ID,R.L.APAP.COVID.PRELACIONIII,FV.ST.L.APAP.COVID.PRELACIONIII,ERROR.1)
    Y.MONTO.COVID19 = R.L.APAP.COVID.PRELACIONIII<ST.L.A76.MONTO.COVI19>

    IF Y.MONTO.COVID19 GT 0 THEN
        TEXT = 'L.APAP.REPRECIO.OVR.MSG';
        CURR.NO = DCOUNT(R.NEW(AA.ARR.ACT.OVERRIDE),VM) + 1; 
        CALL STORE.OVERRIDE(CURR.NO)
    END

  END

RETURN