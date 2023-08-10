*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.CHK.TELLP.RT
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT TAM.BP I_F.REDO.TELLER.PROCESS


    GOSUB LOAD.LOCREF
    GOSUB MAKE.NO.INPUT

    RETURN
LOAD.LOCREF:
    APPL.NAME.ARR = "REDO.TELLER.PROCESS"
    FLD.NAME.ARR = "L.TTP.PASO.RAPI"
    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)

    Y.L.TTP.PASO.RAPI.POS = FLD.POS.ARR<1,1>

    RETURN
MAKE.NO.INPUT:
    T.LOCREF<Y.L.TTP.PASO.RAPI.POS,7> = 'NOINPUT'

    RETURN

END
