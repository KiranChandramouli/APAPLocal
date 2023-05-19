* @ValidationCode : MjoxMzE0NTc0ODMyOkNwMTI1MjoxNjg0NDA4NjEyMjk3OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 May 2023 16:46:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.V.VAL.PAYMENT.INITIAL
*----------------------------------------------------------------------------------------------------------
* Developer    : SAKTHI S
* Date         : 02.08.2010
* Description  : REDO.V.VAL.PAYMENT.INITIAL
*----------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  : --N/A--
* Out : --N/A--
*----------------------------------------------------------------------------------------
* Dependencies:
* -------------
* Calls     : --N/A--
* Called By : --N/A--
*----------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Version          Date          Name              Description
* -------          ----          ----              ------------
*
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.PAYMENT.SCHEDULE

    GOSUB INITIALISE
    GOSUB PROCESS
    GOSUB GOEND
RETURN
*----------------------------------------------------------------------------------------
INITIALISE:
*----------------------------------------------------------------------------------------
    Y.PAY.START.DATE = ""
    Y.PAY.END.DATE = ""
    Y.INITIAL=1
RETURN

*-----------------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------------

    Y.PAY.START.DATE = R.NEW(AA.PS.START.DATE)
    Y.PAY.END.DATE = R.NEW(AA.PS.END.DATE)

    IF NOT(Y.PAY.START.DATE) THEN
        AF = AA.PS.START.DATE
        AV = Y.INITIAL
        ETEXT = 'EB-PAY.SCH.START.DATE.MISSING'
        CALL STORE.END.ERROR
    END
    IF NOT(Y.PAY.END.DATE) THEN
        AF = AA.PS.END.DATE
        AV = Y.INITIAL
        ETEXT = 'EB-PAY.SCH.END.DATE.MISSING'
        CALL STORE.END.ERROR
    END

RETURN

*--------------------
GOEND:
*--------------------
END
