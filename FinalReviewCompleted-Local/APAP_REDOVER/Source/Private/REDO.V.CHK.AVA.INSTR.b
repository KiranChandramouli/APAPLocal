* @ValidationCode : Mjo4MDk5MTY0NjE6Q3AxMjUyOjE2ODI0MTIzNDQzOTA6SGFyaXNodmlrcmFtQzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:44
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
SUBROUTINE REDO.V.CHK.AVA.INSTR

* Subroutine Type : ROUTINE
* Attached to     : REDO.V.CHK.AVA.INSTR
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
* Date            :
*
*-----------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*10-04-2023            Conversion Tool             R22 Auto Code conversion                      FM TO @FM VM TO @VM
*10-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*--------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
    $INSERT I_F.ACCOUNT
    $INSERT I_GTS.COMMON
* Tus Start
    $INSERT I_F.EB.CONTRACT.BALANCES
* Tus End
    GOSUB INITIALISE
    GOSUB OPEN.FILES

    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END


RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
* Get the account number (fix deposit or deposits )
    VAR.CUENTA = R.NEW(COLL.LOCAL.REF)<1,WPOS.INSTRUMENT.NUM>
    VAR.TIPO = R.NEW(COLL.COLLATERAL.TYPE)
    Y.ERR = ""
    CALL F.READ(FN.ACCOUNT,VAR.CUENTA,R.ACCOUNT,F.ACCOUNT,Y.ERR)
* Tus Start
    R.ECB = ''
    ECB.ERR = ''
    CALL EB.READ.HVT("EB.CONTRACT.BALANCES", VAR.CUENTA, R.ECB, ECB.ERR)
*VAR.SALDO =  R.ACCOUNT<AC.WORKING.BALANCE>
    VAR.SALDO =  R.ECB<ECB.WORKING.BALANCE>
* Tus End
*
*///ACCOUNTS///
    IF VAR.TIPO EQ 151 OR VAR.TIPO EQ 153 THEN
        R.NEW(COLL.LOCAL.REF)<1,WPOS.DISPO.GARA.INST> = VAR.SALDO         ;*Set the avaliable instrument amount
    END
*
*///DEPOSITS///
    IF VAR.TIPO EQ 152 THEN
        R.NEW(COLL.LOCAL.REF)<1,WPOS.DISPO.GARA.INST> = VAR.SALDO         ;*Set the avaliable instrument
*
    END
*
RETURN
*----------------------------------------------------------------------------


INITIALISE:
*=========
*
    PROCESS.GOAHEAD = 1
*
    FN.ACCOUNT   = 'F.ACCOUNT'
    F.ACCOUNT    = ''
    R.ACCOUNT    = ''
*
*Read the local fields
    WCAMPO    = "L.COL.NUM.INSTR"
    WCAMPO<2> = "L.AVA.AMO.INS"
*
    WCAMPO = CHANGE(WCAMPO,@FM,@VM)
    WCAMPO := @FM:"L.AC.AV.BAL"
    YPOS=0
    Y.APPLICATION = "COLLATERAL":@FM:"ACCOUNT"
*Get the position for all fields
    CALL MULTI.GET.LOC.REF(Y.APPLICATION,WCAMPO,YPOS)
    WPOS.INSTRUMENT.NUM   = YPOS<1,1>
    WPOS.DISPO.GARA.INST  = YPOS<1,2>
    WPOS.AC.DIS           = YPOS<2,1>
*
    VAR.CUENTA = ''
    VAR.SALDO  =  ''
*
RETURN
*
*------------------------
OPEN.FILES:
*=========
*
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
RETURN
*------------
END
