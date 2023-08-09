* @ValidationCode : MjotNjQ1Mjk4MjQzOkNwMTI1MjoxNjkwMTY2ODUwNTQzOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:17:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA
SUBROUTINE REDO.AA.UPDATE.OVERDUE.STATUS(Y.ID)
***************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.UPDATE.CHQ.RETURN.B10
*--------------------------------------------------------------------------------------------------
*Description       :

*In  Parameter     : ARR.ID
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                    Reference                 Description
*   ------             -----                 -------------              -------------
* 17 OCT 2011        MARIMUTHU S            PACS00146454              Initial Creation
*
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*14-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     NO CHANGE
*14-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   CALL RTN FORMAT CAN BE MODIFIED
*---------------------------------------------------------------------------------------	-
* This routine is used to raise LENDING-UPDATE-OVERDUE activity if returned cheque count meets 3
***************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.REDO.LOAN.CHQ.RETURN
    $INSERT I_REDO.B.CHQ.UPD.STATUS.COMMON
    $USING APAP.TAM
*-------------------------------------------------------------------------------------------------------------------
MAIN:

*    GOSUB GET.REV.COUNT

    L.LOAN.COND = "ThreeReturnedChecks"
    GOSUB PROCESS

RETURN
*-------------------------------------------------------------------------------------------------------------------
GET.REV.COUNT:



    CALL F.READ(FN.REDO.LOAN.CHQ.RETURN,Y.ID,R.REDO.LOAN.CHQ.RETURN,F.REDO.LOAN.CHQ.RETURN,Y.LCR.ERR)

*   REVERSED = R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.STATUS>
    REVERSED = R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.STATUS> ;*R22 MANUAL CONVERSION : RET.CHEQUE.STATUS field missing in table

    REV.COUNT = COUNT(REVERSED,"REVERSADO")

    L.LOAN.COND = 'NULL'

    IF (REV.COUNT GE 3) THEN

        L.LOAN.COND = "ThreeReturnedChecks"

    END

RETURN
*-------------------------------------------------------------------------------------------------------------------

PROCESS:

    GOSUB GET.PROPERTY
    ACT.ID = "LENDING-UPDATE-":OD.PROPERTY
    OFS.SRC = 'REDO.AA.OVR.UPD'
    OPTIONS = ''
    OFS.MSG.ID = ''
    OFS.STRING.FINAL="AA.ARRANGEMENT.ACTIVITY,APAP/I/PROCESS,,,ARRANGEMENT:1:1=":Y.ID:",ACTIVITY:1:1=":ACT.ID:",PROPERTY:1:1=":OD.PROPERTY:",FIELD.NAME:1:1=LOCAL.REF:4:1,FIELD.VALUE:1:1=":L.LOAN.COND
    CALL OFS.POST.MESSAGE(OFS.STRING.FINAL,OFS.MSG.ID,OFS.SRC,OPTIONS)

RETURN
*-------------------------------------------------------------------------------------------------------------------
GET.PROPERTY:

    IN.PROPERTY.CLASS = 'OVERDUE'
*CALL REDO.GET.PROPERTY.NAME(Y.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,OD.PROPERTY,OUT.ERR)
    APAP.TAM.redoGetPropertyName(Y.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,OD.PROPERTY,OUT.ERR) ;*R22 MANUAL CODE CONVERSION

RETURN
*-------------------------------------------------------------------------------------------------------------------
END
