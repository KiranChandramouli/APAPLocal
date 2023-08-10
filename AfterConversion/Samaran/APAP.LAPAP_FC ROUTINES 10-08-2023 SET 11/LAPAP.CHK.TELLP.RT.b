$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.CHK.TELLP.RT
*----------------------------------------------------------------------------------------------------
*MODIFICATION HISTORY
* Date                  Who                    Reference                        Description
* ----                  ----                     ----                              ----
* 09-08-2023           Samaran T         R22 Manual Code Conversion     BP is removed from insert file.
*-------------------------------------------------------------------------------------------------------------
    $INSERT  I_COMMON ;*R22 MANUAL CODE CONVERSION.START
    $INSERT  I_EQUATE
    $INSERT  I_F.REDO.TELLER.PROCESS  ;*R22 MANUAL CODE CONVERSION.END


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
