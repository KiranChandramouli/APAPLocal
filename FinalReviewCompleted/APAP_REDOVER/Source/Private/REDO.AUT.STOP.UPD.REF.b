* @ValidationCode : MjotMTU2MTEzODk4MDpDcDEyNTI6MTY4MjQxMjMyNzE5MzpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUT.STOP.UPD.REF
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This service is used to stop all the cheques of in PAYMENT.STOP
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*-----------------------------------------------------------------------
*MODIFICATION HISTORY:

*-------------------------------------------------------------------------------

* DATE			WHO		REFERENCE			DESCRIPTION

* 06-04-2023	CONVERSION TOOL		AUTO R22 CODE CONVERSION	 NO CHANGE
* 06-04-2023	MUTHUKUMAR M		MANUAL R22 CODE CONVERSION	 NO CHANGE

*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.PAYMENT.STOP
    $INSERT I_F.REDO.PAYMENT.STOP.ACCOUNT
*-----------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------

    Y.ID.CUR.CHRG = ''
    FN.PAYMENT.STOP.STMT = 'F.PAYMENT.STOP.STMT'
    F.PAYMENT.STOP.STMT  = ''
    CALL OPF(FN.PAYMENT.STOP.STMT,F.PAYMENT.STOP.STMT)
    LREF.APPLN="PAYMENT.STOP"
    LREF.FIELDS="L.PS.STOP.REF"
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APPLN,LREF.FIELDS,LREF.POS)
    POS.L.PS.STOP.REF = LREF.POS<1,1>
RETURN
**********
PROCESS:
**********
    Y.STMT.ID = R.NEW(AC.PAY.STMT.NOS)<1,1>
    CALL F.READ(FN.PAYMENT.STOP.STMT,Y.STMT.ID,R.PAYMENT.STOP.STMT,F.PAYMENT.STOP.STMT,PAYMENT.STOP.STMT.ERR)
    R.PAYMENT.STOP.STMT<-1> = R.NEW(AC.PAY.LOCAL.REF)<1,POS.L.PS.STOP.REF>
    CALL F.WRITE(FN.PAYMENT.STOP.STMT,Y.STMT.ID,R.PAYMENT.STOP.STMT)
RETURN
END
