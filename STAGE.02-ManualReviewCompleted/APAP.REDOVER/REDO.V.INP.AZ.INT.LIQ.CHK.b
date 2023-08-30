* @ValidationCode : MjoyMDY3NzQzNzU4OkNwMTI1MjoxNjgxMTk4MjE4MDkwOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 13:00:18
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
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.AZ.INT.LIQ.CHK

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.V.INP.AZ.INT.LIQ.CHK

*--------------------------------------------------------------------------------
* Description: This Auth routine is too store value for next version (AZ.ACCOUNT)
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO                 REFERENCE                   DESCRIPTION
* 23/09/2014     PRABHU N                                          INITIAL CREATION
*11-04-2023      Conversion Tool    R22 Auto Code conversion          No Changes
*11-04-2023      Samaran T           R22 Manual Code Conversion       No Changes
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT

    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    CALL F.READ(FN.ACCOUNT,ID.NEW,R.ACCOUNT,F.ACCOUNT,Y.ACC.ERR)
    Y.INT.LIQ.ACC=R.ACCOUNT<AC.INTEREST.LIQU.ACCT>
    CALL F.READ(FN.ACCOUNT,Y.INT.LIQ.ACC,R.INT.LIQ.ACC,F.ACCOUNT,Y.INT.LIQ.ERR)
    Y.CUSTOMER=R.INT.LIQ.ACC<AC.CUSTOMER>
    IF NOT(Y.CUSTOMER) THEN
        ETEXT="EB-WAIT.INT.LIQ.ACCT"
        CALL STORE.END.ERROR
    END
RETURN
END
