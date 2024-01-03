* @ValidationCode : MjotMTkwNjU3MTQyMzpDcDEyNTI6MTY4MjQxMjM0NzQ5MDpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE  REDO.V.INP.ARCIB.ACCT.UPLOAD
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* THIS IS AN INPUT ROUTINE TO DEFAULT THE ACCOUNT NUMBER BASED ON CREDIT CURRENCY

* INPUT/OUTPUT:
*--------------

* OUT : N/A

* DEPENDDENCIES:
*-------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*11-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*11-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AI.REDO.ARCIB.PARAMETER
$INSERT I_F.ACCOUNT
$INSERT I_GTS.COMMON
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.STANDING.ORDER
GOSUB PROCESS
RETURN

*~~~~~~~~~~~~~~~
PROCESS:
*~~~~~~~~~~~~~~~

FN.AI.REDO.ARCIB.PARAMETER = 'F.AI.REDO.ARCIB.PARAMETER'
F.AI.REDO.ARCIB.PARAMETER  = ''
CALL OPF(FN.AI.REDO.ARCIB.PARAMETER,F.AI.REDO.ARCIB.PARAMETER)


Y.TXN.TYPE = R.NEW(FT.TRANSACTION.TYPE)

*CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,'SYSTEM',R.AI.REDO.ARCIB.PARAMETER,ERR.MPAR)
IDVAR.1 = 'SYSTEM' ;* R22 AUTO CONVERSION
CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,IDVAR.1,R.AI.REDO.ARCIB.PARAMETER,ERR.MPAR);* R22 AUTO CONVERSION

IF NOT(ERR.MPAR) THEN
Y.SUPPLIER.INT.ACCT = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.SUPPLIER.INT.ACCT>
Y.SUPPLIER.TXN.CODE = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.SUPPLIER.TXN.CODE>
Y.PAYROLL.INT.ACCT = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.PAYROLL.INT.ACCT>
Y.PAYROLL.TXN.CODE = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.PAYROLL.TXN.CODE>
END

IF Y.TXN.TYPE EQ Y.PAYROLL.TXN.CODE THEN
R.NEW(FT.CREDIT.ACCT.NO) = Y.PAYROLL.INT.ACCT
END ELSE
R.NEW(FT.CREDIT.ACCT.NO) = Y.SUPPLIER.INT.ACCT
END

RETURN
END
