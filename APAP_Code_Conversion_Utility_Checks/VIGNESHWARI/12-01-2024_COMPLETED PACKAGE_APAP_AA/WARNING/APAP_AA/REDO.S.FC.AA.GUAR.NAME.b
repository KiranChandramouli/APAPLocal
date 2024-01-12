* @ValidationCode : Mjo4OTU1ODI4NTg6Q3AxMjUyOjE3MDQ0Mzk1MzAzNjE6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jan 2024 12:55:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.AA
SUBROUTINE REDO.S.FC.AA.GUAR.NAME(AA.ID, AA.ARR)
*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose : To return value of AA.ARR.TERM.AMOUNT>L.COL.GUAR.NAME  FIELD
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
* AA.ARR - data returned to the routine
*
* Error Variables:
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            :
*
*
* Date             Who                   Reference      Description
* 30.03.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM, I TO I.VAR
* 30.03.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*-----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
*$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.AA.TERM.AMOUNT
$INSERT I_F.COLLATERAL
   $USING AA.Framework

GOSUB INITIALISE
GOSUB OPEN.FILES

IF PROCESS.GOAHEAD THEN
GOSUB PROCESS
END

RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
Y.REV.RT.TYPE.POS = LOC.REF.POS<1,1>
*Y.TEMP = 0

IF Y.REV.RT.TYPE.POS GT 0 THEN
*CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARRG.ID, PROPERTY.CLASS,'','', RET.IDS, INT.COND, RET.ERR)
AA.Framework.GetArrangementConditions(Y.ARRG.ID, PROPERTY.CLASS,'','', RET.IDS, INT.COND, RET.ERR);* R22 AUTO CONVERSION
ID.COLLATERAL = INT.COND<1,AA.AMT.LOCAL.REF,Y.REV.RT.TYPE.POS>    ;* This hold the Value in the local field
IF NOT(ID.COLLATERAL) THEN
AA.ARR = 'NULO'
END ELSE
LOC.REF.APPL="COLLATERAL"
LOC.REF.FIELDS="L.COL.GUAR.NAME"
CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
POS.GUAR.NAME = LOC.REF.POS<1,1>
NRO.COLL = DCOUNT(ID.COLLATERAL,@VM)
FOR I.VAR=1 TO NRO.COLL     ;** R22 Auto conversion - I TO I.VAR
*CALL F.READ(FN.COLLATERAL,ID.COLLATERAL<I.VAR>,R.COLLATERAL,F.COLLATERAL,"")   ;** R22 Auto conversion - I TO I.VAR
IDVAR.1 = "" ;* R22 AUTO CONVERSION
CALL F.READ(FN.COLLATERAL,ID.COLLATERAL<I.VAR>,R.COLLATERAL,F.COLLATERAL,IDVAR.1)   ;** R22 Auto conversion - I TO I.VAR;* R22 AUTO CONVERSION
IF NOT(R.COLLATERAL) THEN
AA.ARR = 'NULO'
END ELSE
IF AA.ARR THEN
AA.ARR := "#"
END
AA.ARR := R.COLLATERAL<COLL.LOCAL.REF,POS.GUAR.NAME>
END
NEXT
IF NOT(AA.ARR) THEN
AA.ARR = 'NULO'
END

END

END ELSE
AA.ARR = 'NO.EXISTE'
END
RETURN
*------------------------
INITIALISE:
*=========
PROCESS.GOAHEAD = 1
Y.ARRG.ID = AA.ID
PROPERTY.CLASS = 'TERM.AMOUNT'
LOC.REF.APPL="AA.ARR.TERM.AMOUNT"
LOC.REF.FIELDS="L.AA.COL"
FN.COLLATERAL = "F.COLLATERAL"
F.COLLATERAL = ""
R.COLLATERAL = ""
LOC.REF.POS=" "
AA.ARR = ""
RETURN

*------------------------
OPEN.FILES:
*=========
CALL OPF(FN.COLLATERAL,F.COLLATERAL)

RETURN
*------------
END
