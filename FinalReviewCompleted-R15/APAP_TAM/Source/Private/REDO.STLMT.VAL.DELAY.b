* @ValidationCode : MjoxNjA5MDcwMzcwOkNwMTI1MjoxNzAzNzcxMTMxOTA0OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 28 Dec 2023 19:15:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM

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
** 17-04-2023 R22 Auto Conversion no changes
** 17-04-2023 Skanda R22 Manual Conversion - No changes
*20-12-2023   VIGNESHWARI   ADDED COMMENT FOR INTERFACE CHANGES        ATM � By Santiago
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT I_F.ATM.TRANSACTION	;*Fix ATM � By Santiago -changes "F.ATM.REVERSAL" to "F.ATM.TRANSACTION"

    GOSUB PROCESS

RETURN


*******
PROCESS:
********


    Y.PARAM.DAYS=R.REDO.APAP.H.PARAMETER<PARAM.LOCK.DAYS>
    ATM.TRANSACTION.ID=CARD.NUMBER:'.':Y.FIELD.VALUE	;*Fix ATM � By Santiago -changes "REVERSAL" to "TRANSACTION" -start
    CALL F.READU(FN.ATM.TRANSACTION,ATM.TRANSACTION.ID,R.ATM.TRANSACTION,F.ATM.TRANSACTION,ATM.REV.ERR,'')
    IF R.ATM.TRANSACTION EQ '' THEN	;*Fix ATM � By Santiago -end
        ERROR.MESSAGE='NO.MATCH.TRANSACTION'
        RETURN
    END


    Y.ATM.REV.LOC.DATE=R.ATM.TRANSACTION<AT.REV.VALUE.DATE>	;*Fix ATM � By Santiago -changes "REVERSAL" , "AT.REV.T24.DATE" to "TRANSACTION" , "AT.REV.VALUE.DATE"
    YREGION=''
    Y.ADD.DAYS='+':Y.PARAM.DAYS:'C'
*    CALL CDT(YREGION,Y.ATM.REV.LOC.DATE,Y.ADD.DAYS)


*    IF Y.ATM.REV.LOC.DATE LT TODAY THEN
*        ERROR.MESSAGE='DELAY.SUBMISSION'
*    END

RETURN
END
