* @ValidationCode : Mjo2NTA2MjI0Mzc6Q3AxMjUyOjE2ODQzMzA2MDE5MzU6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 May 2023 19:06:41
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
SUBROUTINE REDO.CHECK.MARGIN.IDS(Y.AA.IDS.LIST,Y.RATE.CHANGE.ID,Y.RETURN.IDS)
*---------------------------------------------------------------------
*Description: This routine is to filter arrangement IDS as per condition defined in REDO.RATE.CHANGE template.
*---------------------------------------------------------------------
* Input Arg:   Y.AA.IDS.LIST -> List of arrangement IDS.
*              Y.RATE.CHANGE.ID -> REDO.RATE.CHANGE ID.
* Output Arg: Y.RETURN.IDS   -> List of arrangement IDS and related margin IDS.

*-----------------------------------------------------------------------------
* Modification History :
*
*   Date            Who                   Reference               Description
* 05 Dec 2011   H Ganesh               Massive rate              Initial Draft
** 21-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 21-04-2023 Skanda R22 Manual Conversion - CALL RTN FORMAT MODIFIED
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.REDO.RATE.CHANGE
    $USING APAP.AA

    GOSUB OPEN.FILES
    GOSUB GET.LOCAL.REF
    GOSUB PROCESS

RETURN
*---------------------------------------------------------------------
OPEN.FILES:
*---------------------------------------------------------------------
    FN.REDO.RATE.CHANGE = 'F.REDO.RATE.CHANGE'
    F.REDO.RATE.CHANGE = ''
    CALL OPF(FN.REDO.RATE.CHANGE,F.REDO.RATE.CHANGE)

RETURN
*---------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------
    Y.RETURN.IDS = ''
    CALL F.READ(FN.REDO.RATE.CHANGE,Y.RATE.CHANGE.ID,R.REDO.RATE.CHANGE,F.REDO.RATE.CHANGE,RATE.ERR)

    R.ARRAY    = ''
    R.ARRAY<1> = R.REDO.RATE.CHANGE<REDO.RT.CAMPAIGN.TYPE>
    R.ARRAY<2> = R.REDO.RATE.CHANGE<REDO.RT.AFFIL.COMP>
    R.ARRAY<3> = R.REDO.RATE.CHANGE<REDO.RT.MARGIN.ID>
    R.ARRAY<4> = R.REDO.RATE.CHANGE<REDO.RT.BY.DEFAULT>

    GOSUB PROCESS.REMAIN

RETURN
*---------------------------------------------------------------------
PROCESS.REMAIN:
*---------------------------------------------------------------------
    Y.IDS.CNT = DCOUNT(Y.AA.IDS.LIST,@FM)
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.IDS.CNT
        ARR.ID = Y.AA.IDS.LIST<Y.CNT>
        GOSUB CHECK.MARGIN
        Y.CNT += 1 ;* R22 Auto conversion
    REPEAT
RETURN
*---------------------------------------------------------------------
CHECK.MARGIN:
*---------------------------------------------------------------------
    GOSUB CUSTOMER.PROD.CONDITION
    Y.MARGIN = ''
*CALL REDO.GET.MARGIN.ID(Y.ARR.CAMP.TYPE,Y.ARR.AFF.COMP,R.ARRAY,Y.MARGIN) ;*R22 MANUAL CODE CONVERSION
    CALL APAP.TAM.redoGetMarginId(Y.ARR.CAMP.TYPE,Y.ARR.AFF.COMP,R.ARRAY,Y.MARGIN) ;*R22 MANUAL CODE CONVERSION
    IF Y.MARGIN THEN
        Y.RETURN.IDS<-1> = ARR.ID:'*':Y.MARGIN
    END

RETURN
*---------------------------------------------------------------------
CUSTOMER.PROD.CONDITION:
*---------------------------------------------------------------------

    EFF.DATE = TODAY
    PROP.CLASS='CUSTOMER'
    PROPERTY = ''
    R.CONDITION.CUST = ''
    ERR.MSG = ''
*CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.CUST,ERR.MSG)  ;*R22 MANUAL CODE CONVERSION
    CALL APAP.AA.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.CUST,ERR.MSG) ;*R22 MANUAL CODE CONVERSION
    Y.ARR.CAMP.TYPE = R.CONDITION.CUST<AA.CUS.LOCAL.REF,POS.L.AA.CAMP.TY>
    Y.ARR.AFF.COMP  = R.CONDITION.CUST<AA.CUS.LOCAL.REF,POS.L.AA.AFF.COM>

RETURN
*------------------------------------------------------------------------
GET.LOCAL.REF:
*------------------------------------------------------------------------

    LOC.REF.APPLICATION="AA.PRD.DES.CUSTOMER"
    LOC.REF.FIELDS="L.AA.CAMP.TY":@VM:"L.AA.AFF.COM"
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AA.CAMP.TY = LOC.REF.POS<1,1>
    POS.L.AA.AFF.COM = LOC.REF.POS<1,2>

RETURN

END
