* @ValidationCode : MjotNTg1MDExNDkxOkNwMTI1MjoxNjg1Njg5MTM2NDY2OklUU1M6LTE6LTE6LTI3OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 Jun 2023 12:28:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -27
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.CHQ.RET.LOAN.ST
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.INP.CHQ.RET.LOAN.ST
*--------------------------------------------------------------------------------------------------------
*Description       : Routine used to update the loan status.

*In  Parameter     :
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 17 OCT 2011        MARIMUTHU S              PACS00146454             Initial Creation
*11-04-2023         Conversion Tool        R22 Auto Code conversion          VM TO @VM
*11-04-2023         Samaran T               R22 Manual Code Conversion       CALL RTN FORMAT MODIFIED
*********************************************************************************************************


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LOAN.CHQ.RETURN
    $USING APAP.TAM

MAIN:

    GOSUB PROCESS
    GOSUB PGM.END

RETURN

PROCESS:

    Y.AA.ID = ID.NEW
    Y.CHQ.STS = R.NEW(LN.CQ.RET.CHEQUE.STATUS)
    Y.RET.CHQ.CNTR = R.NEW(LN.CQ.RET.CHEQUE.RET.CTR)

    Y.CNT = DCOUNT(Y.CHQ.STS,@VM)
    R.NEW(LN.CQ.RET.CHEQUE.RET.CTR) = Y.CNT

    Y.CNT.RR = ''
    LOOP
    WHILE Y.CNT GT 0 DO
        FLG += 1
        Y.CHQ.STT = Y.CHQ.STS<1,FLG>
        IF Y.CHQ.STT EQ 'REVERSADO' THEN
            Y.CNT.RR += 1
        END
        Y.CNT -= 1
    REPEAT
    IF Y.CNT.RR LT 3 THEN
        GOSUB PROCESS.LOAN.ST
    END

RETURN

PROCESS.LOAN.ST:

    GOSUB GET.PROPERTY
    ACT.ID = "LENDING-UPDATE-":OD.PROPERTY
    OFS.SRC = 'REDO.AA.OVR.UPD'
    OPTIONS = ''
    OFS.MSG.ID = ''
    OFS.STRING.FINAL="AA.ARRANGEMENT.ACTIVITY,APAP/I/PROCESS,,,ARRANGEMENT:1:1=":Y.AA.ID:",ACTIVITY:1:1=":ACT.ID:",PROPERTY:1:1=":OD.PROPERTY:",FIELD.NAME:1:1=LOCAL.REF:4:1,FIELD.VALUE:1:1="
    CALL OFS.POST.MESSAGE(OFS.STRING.FINAL,OFS.MSG.ID,OFS.SRC,OPTIONS)

RETURN

GET.PROPERTY:

    IN.PROPERTY.CLASS = 'OVERDUE'
*CALL REDO.GET.PROPERTY.NAME(Y.AA.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,OD.PROPERTY,OUT.ERR)
    APAP.TAM.redoGetPropertyName(Y.AA.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,OD.PROPERTY,OUT.ERR)   ;*R22 MANAUAL CODE CONVERSION

RETURN

PGM.END:

END
