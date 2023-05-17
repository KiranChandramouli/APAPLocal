SUBROUTINE REDO.STLMT.VAL.DELAY
**************************************************************************
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :DHAMU.S
*  Program   Name    :REDO.STLMT.VAL.DELAY
*********************************************************
*Description:This routine is to identify delay in submission of liquidation on
*             based on PURCHASE.DATE and configured days in REDO.H.ATM.PARAMETER
***********************************************************************
*LINKED WITH: NA
*IN PARAMETER: NA
*OUT PARAMETER: REDO.VISA.STLMT.FILE.PROCESS
******************************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*03.12.2010   S DHAMU       ODR-2010-08-0469  INITIAL CREATION
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT I_F.ATM.REVERSAL


    GOSUB PROCESS

RETURN


*******
PROCESS:
********


    Y.PARAM.DAYS=R.REDO.APAP.H.PARAMETER<PARAM.LOCK.DAYS>
    ATM.REVERSAL.ID=CARD.NUMBER:'.':Y.FIELD.VALUE
    CALL F.READU(FN.ATM.REVERSAL,ATM.REVERSAL.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,ATM.REV.ERR,'')
    IF R.ATM.REVERSAL EQ '' THEN
        ERROR.MESSAGE='NO.MATCH.TRANSACTION'
        RETURN
    END


    Y.ATM.REV.LOC.DATE=R.ATM.REVERSAL<AT.REV.T24.DATE>
    YREGION=''
    Y.ADD.DAYS='+':Y.PARAM.DAYS:'C'
*    CALL CDT(YREGION,Y.ATM.REV.LOC.DATE,Y.ADD.DAYS)


*    IF Y.ATM.REV.LOC.DATE LT TODAY THEN
*        ERROR.MESSAGE='DELAY.SUBMISSION'
*    END

RETURN
END
