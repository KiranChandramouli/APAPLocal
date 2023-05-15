* @ValidationCode : MjoxMTMzOTI2NTYzOkNwMTI1MjoxNjgyMDczMjQwMzk3OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:04:00
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
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.VAL.MONTO.MLV
***********************************************************
* esvalerio - 03/01/22
* VALIDACION ABONO MLV:
* VERSIONES: TELLER,LAPAP.PAYOFF.CANCEL.MLV.CASHIN,TELLER,LAPAP.PAYOFF.CANCEL.MLV.CHQOBCO,
* TELLER,LAPAP.PAYOFF.CANCEL.MLV.ACCT.TFR
* EB.API,RAD>LAPAP.WS.VPLUS.T24.MLV
* jars/LAPAP/ws-vplus-t24-mlv.jar
***********************************************************
* 500 PESOS! Se ve mucho doc pero luego me lo vas agradecer
***********************************************************
**Errores Y.CAJJJ.ERROR
*1 Fatal error creating thread
*2 Cannot create JVM
*3 Cannot find class
*4 Unicode conversion error
*5 Cannot find method
*6 Cannot find object constructor
*7 Cannot instantiate object
*************************************************************

*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*21-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*21-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*---------------------------------------------------------------------------------------------------------

    $INSERT I_EQUATE   ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_GTS.COMMON
    $INSERT I_F.DATES    ;*R22 AUTO CODE CONVERSION.END


    GOSUB LOAD.VARIABLES
    GOSUB INIT
RETURN


LOAD.VARIABLES:
***************

    Y.LOCAL.REF = 'LOCAL.REF';
    Y.LOCAL.FIELDS = '';
    Y.LOCAL.FIELDS.POS = '';

    Y.LOCAL.FIELDS<1,1>   = 'L.TT.MSG.DESC'

    CALL EB.FIND.FIELD.NO(APPLICATION, Y.LOCAL.REF)
    CALL MULTI.GET.LOC.REF(APPLICATION, Y.LOCAL.FIELDS, Y.LOCAL.FIELDS.POS)

    MSG.DESC.POS          = Y.LOCAL.FIELDS.POS<1,1>
RETURN


INIT:
*****
    GOSUB PROCESS
RETURN

PROCESS:

************************
    Y.MONTO.INGRESADO  = R.NEW(TT.TE.AMOUNT.LOCAL.1)
    Y.MSG              = R.NEW(Y.LOCAL.REF)<1,MSG.DESC.POS>
    CHANGE ':'  TO @FM IN Y.MSG
    Y.MONTO.ADEUDADO = Y.MSG<2>

    IF Y.MONTO.INGRESADO GE Y.MONTO.ADEUDADO THEN
        MESSAGE = "EL MONTO INGRESADO ES MAYOR O IGUAL AL MONTO ADEUDADO"
        E = MESSAGE
        ETEXT = E
        CALL ERR
        RETURN
    END

RETURN
END
