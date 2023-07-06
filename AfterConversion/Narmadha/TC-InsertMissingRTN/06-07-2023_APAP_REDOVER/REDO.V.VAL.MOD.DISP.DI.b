* @ValidationCode : MjotMTc2NDU5ODY3NTpVVEYtODoxNjg4NjQwNDgyMDk3OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Jul 2023 16:18:02
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.VAL.MOD.DISP.DI
*
* Subroutine Type : ROUTINE
* Attached to     : REDO.V.VAL.MOD.DISP.DI
* Attached as     : ROUTINE
* Primary Purpose :
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Pablo Castillo De La Rosa - TAM Latin America
* Date            : Calc all values if the user change a values for VNG
*                   "VALOR NOMINAL DE LA GARANTIA"
*Modification history
*Date                Who               Reference                  Description
*20-04-2023      conversion tool     R22 Auto code conversion     No changes
*20-04-2023      Mohanraj R          R22 Manual code conversion   No changes
*06-07-2023      Narmadha V          Manual R22 Conversion        Call routine format modified
*-----------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $USING APAP.TAM

    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END


RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
    VAR.VNG = COMI

    R.NEW(COLL.EXECUTION.VALUE) = VAR.VNG
    R.NEW(COLL.GEN.LEDGER.VALUE) = VAR.VNG

*IF THE MAX VALUES IS NOT SET THEN SET THE SAME VALUE
    Y.MAX = R.NEW(COLL.MAXIMUM.VALUE)

    IF LEN(Y.MAX) EQ 0 THEN
        R.NEW(COLL.MAXIMUM.VALUE) = VAR.VNG
    END

*CALC THE REA VALUE
    CALL APAP.REDOVER.redoVValReaCollateral();* Manual R22 Conversion, Call routine format modified


RETURN
*----------------------------------------------------------------------------

INITIALISE:
*=========
    PROCESS.GOAHEAD = 1
    FN.COLLATERAL   = 'F.COLLATERAL'
    F.COLLATERAL    = ''
    R.COLLATERAL    = ''


RETURN

*------------------------
OPEN.FILES:
*=========
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
RETURN
*------------
END
