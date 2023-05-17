SUBROUTINE REDO.AZ.DATE.CALC.SELECT
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: MANJU.G
* PROGRAM NAME: REDO.AZ.DATE.CALC.SELECT
* ODR NO      : ODR-2011-05-0118
*----------------------------------------------------------------------
*DESCRIPTION:Difference between VALUE.DATE date and opening date of the contract MATURITY.DATE the module AZ
***************
*IN PARAMETER: NA
*OUT PARAMETER: NA
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*25.05.2010  Manju.G     ODR-2011-05-0118      INITIAL CREATION
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.DATES
    $INSERT I_REDO.AZ.DATE.CALC.COMMON

    GOSUB PROCESS
RETURN
********
PROCESS:
********
    Y.DATE              = TODAY
    Y.LAST.WORKING.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    SEL.CMD = "SELECT ":FN.AZ.ACCOUNT:" WITH CREATE.DATE EQ ":Y.DATE:" OR (VALUE.DATE GT ":Y.LAST.WORKING.DATE:" AND VALUE.DATE LE ":Y.DATE:")"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,CK.ERR)
    CALL BATCH.BUILD.LIST('', SEL.LIST)
RETURN
END
