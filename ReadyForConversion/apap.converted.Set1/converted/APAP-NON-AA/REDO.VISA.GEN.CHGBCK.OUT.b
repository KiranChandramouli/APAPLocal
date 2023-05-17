SUBROUTINE REDO.VISA.GEN.CHGBCK.OUT(OUT.ID)
*********************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.VISA.GEN.CHGBCK.OUT
***********************************************************************************
*Description: This routine is to settle the transaction when it is approved manually
*****************************************************************************
*linked with: REDO.VISA.OUTGOING
*In parameter: Y.VISA.OUT.ID
*Out parameter: NA
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*07.12.2010   S DHAMU       ODR-2010-08-0469  INITIAL CREATION
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.VISA.OUTGOING
    $INSERT I_F.REDO.VISA.STLMT.PARAM
    $INSERT I_REDO.VISA.GEN.CHGBCK.OUT.COMMON



    GOSUB PROCESS

RETURN

********
PROCESS:
********
    Y.VISA.OUT.ID=OUT.ID
    ERROR.MESSAGE=''
    CALL F.READ(FN.REDO.VISA.OUTGOING,Y.VISA.OUT.ID,R.REDO.VISA.OUTGOING,F.REDO.VISA.OUTGOING,REDO.VISA.OUTGOING.ERR)

    IF R.REDO.VISA.OUTGOING NE '' AND R.REDO.VISA.OUTGOING<VISA.OUT.STATUS> EQ 'PENDING' THEN
        GOSUB PERFORM.OUTFILE.GEN
    END

RETURN
*----------------------------------------------------------------------
PERFORM.OUTFILE.GEN:
*----------------------------------------------------------------------


    TC.CODE = R.REDO.VISA.OUTGOING<VISA.OUT.TRANSACTION.CODE>

    LOCATE TC.CODE IN R.REDO.VISA.STLMT.PARAM<VISA.STM.PARAM.TXN.CODE,1> SETTING POS.TC THEN
        OUT.RTN = R.REDO.VISA.STLMT.PARAM<VISA.STM.PARAM.OUT.PROCESS.RTN,POS.TC>
        OUT.USR.DEF.RTN =R.REDO.VISA.STLMT.PARAM<VISA.STM.PARAM.OUT.USR.DEF.RTN,POS.TC>
        ACCT.OUT.RTN = R.REDO.VISA.STLMT.PARAM<VISA.STM.PARAM.OUT.ACCT.RTN,POS.TC>
    END

    IF OUT.RTN NE '' THEN
        CALL @OUT.RTN(R.REDO.VISA.OUTGOING)
    END
    IF OUT.USR.DEF.RTN NE '' THEN
        CALL @OUT.USR.DEF.RTN
    END
    IF ACCT.OUT.RTN NE '' THEN
        CALL @ACCT.OUT.RTN
    END

    IF ERROR.MESSAGE EQ '' THEN
        CALL F.DELETE(FN.REDO.VISA.CHGBCK.LOG,OUT.ID)
    END


RETURN

END
