* @ValidationCode : MjotMzA4NDcwNDAzOkNwMTI1MjoxNjgxODgzNDUzNTkwOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Apr 2023 11:20:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.VAL.AZ.FREQ.DATE
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.VAL.AZ.FREQ.DATE
*------------------------------------------------------------------------------
*Description  : REDO.APAP.VAL.AZ.FREQ.DATE is  used to validate the Frequency
*               Date in AZ.ACCOUNT modiefied versions.
*Linked With  : AZ.ACCOUNT Modification versions
*In Parameter : N/A
*Out Parameter: N/A
*Files Used   : AZ.ACCOUNT
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*19-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   ++ to+= VM to @VM
*19-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------

*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT

**************************************************************************
**********
MAIN.PARA:
**********


    IF MESSAGE NE 'VAL' THEN
        RETURN
    END

    GOSUB PROCESS.PARA
RETURN
**************************************************************************
*************
PROCESS.PARA:
*************

    Y.FREQ.LIST = COMI
    Y.VAL.DATE  = R.NEW(AZ.VALUE.DATE)
    Y.TODAY     = TODAY
    Y.TOT.FREQ = DCOUNT(Y.FREQ.LIST,@VM) ; SET.AV = AV ; SET.AF = AF
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.TOT.FREQ
*       Y.TYPE = R.NEW(AZ.TYPE.OF.SCHDLE)<1,Y.CNT>
        Y.TYPE = R.NEW(AZ.TYPE.OF.SCHDLE)<1,AV>
        IF Y.TYPE EQ 'R' THEN
            Y.FREQ = Y.FREQ.LIST<1,Y.CNT>
            Y.FREQ.DATE = Y.FREQ[1,8]
            IF (Y.FREQ.DATE EQ Y.TODAY) OR (Y.FREQ.DATE EQ Y.VAL.DATE) OR (Y.FREQ.DATE GT TODAY) ELSE
                AF = AZ.FREQUENCY
                ETEXT = 'EB-REDO.AZ.FREQ.DATE'
                CALL STORE.END.ERROR
            END
        END
        Y.CNT += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT

    AV = SET.AV
    AF = SET.AF

RETURN
**************************************************************************
END
