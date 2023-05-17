SUBROUTINE REDO.B.INW.PROCESS.SELECT
*-----------------------------------------------------------------------------
* Description:
* This routine is a multithreaded routine to select the records in the mentioned applns
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : ganesh r
* PROGRAM NAME : REDO.B.INW.PROCESS.SELECT
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE         DESCRIPTION
* 21.09.2010  ganesh r            ODR-2010-09-0148  INITIAL CREATION.
*------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.APAP.CLEARING.INWARD
    $INSERT I_F.REDO.CLEARING.PROCESS
    $INSERT I_F.REDO.APAP.CLEAR.PARAM
    $INSERT I_REDO.B.INW.PROCESS.COMMON
    $INSERT I_BATCH.FILES


*------------------------------------------------------------------------------------------

    GOSUB PROCESS
RETURN

PROCESS:
*------------------------------------------------------------------------------------------

* Reading the values from REDO.APAP.CLEAR.PARAM table

    SEL.CMD = "SSELECT ":FN.REDO.APAP.CLEARING.INWARD:" WITH ACCOUNT.NO NE '' AND STATUS EQ '' BY ACCOUNT.NO BY AMOUNT"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
RETURN
END
