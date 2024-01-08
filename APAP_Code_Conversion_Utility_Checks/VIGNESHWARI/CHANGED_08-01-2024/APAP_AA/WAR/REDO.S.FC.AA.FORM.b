* @ValidationCode : MjotMTk3NTQ1ODExODpDcDEyNTI6MTcwNDQzOTQ5NjE4Mjp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Jan 2024 12:54:56
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
SUBROUTINE REDO.S.FC.AA.FORM(AA.ID, AA.ARR)
*
* Subroutine Type : ROUTINE
* Attached to     : ROUTINE REDO.E.NOF.DATCUST
* Attached as     : ROUTINE
* Primary Purpose : To return value of AA.ARR.OVERDUE>L.LOAN.STATUS.1  FIELD
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
* 30.03.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 30.03.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*-----------------------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
*$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.AA.PAYMENT.SCHEDULE
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

IF Y.REV.RT.TYPE.POS GT 0 THEN
*CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARRG.ID, PROPERTY.CLASS,'','', RET.IDS, INT.COND, RET.ERR)
AA.Framework.GetArrangementConditions(Y.ARRG.ID, PROPERTY.CLASS,'','', RET.IDS, INT.COND, RET.ERR);* R22 AUTO CONVERSION
AA.ARR = INT.COND<AA.PS.LOCAL.REF,Y.REV.RT.TYPE.POS,1>  ;* This hold the Value in the local field
END
RETURN
*------------------------
INITIALISE:
*=========
PROCESS.GOAHEAD = 1
Y.ARRG.ID = AA.ID
PROPERTY.CLASS = 'PAYMENT.SCHEDULE'
LOC.REF.APPL="AA.ARR.PAYMENT.SCHEDULE"
LOC.REF.FIELDS="L.AA.FORM"
LOC.REF.POS=""
AA.ARR = 'NULO'
RETURN

*------------------------
OPEN.FILES:
*=========

RETURN
*------------
END
