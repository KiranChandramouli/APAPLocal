* @ValidationCode : MjoxODg1NTM3NjU5OkNwMTI1MjoxNjg0ODM2MDMzMDE2OklUU1M6LTE6LTE6NTAyOjE6ZmFsc2U6Ti9BOlIyMl9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 502
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.AUT.CPH.OPEN
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.AUT.CPH.OPEN
*------------------------------------------------------------------------------
*Description  : REDO.APAP.AUT.CPH.OPEN is an authorisation routine for the
*               version AZ.ACCOUNT, OPEN.CPH which populates table
*               REDO.APAP.CPH.DET with the linked loan and deposit details
*Linked With  : AZ.ACCOUNT,OPEN.CPH
*In Parameter : N/A
*Out Parameter: N/A
*Linked File  : REDO.APAP.CPH.DET,F.ACCOUNT
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------          ------               -------------            -------------
* 30-07-2010        JEEVA T         ODR-2009-10-0346 B.21       Initial Creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   SM to @SM , CONVERT to CHANGE , FM to @FM , ++ to += , TNO to C$T24.SESSION.NO
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_GTS.COMMON
    $INSERT I_F.USER
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.REDO.APAP.CPH.DETAIL

*--------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
RETURN
*--------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
    FN.REDO.APAP.CPH.DETAIL='F.REDO.APAP.CPH.DETAIL'
    F.REDO.APAP.CPH.DETAIL= ''
    CALL OPF(FN.REDO.APAP.CPH.DETAIL,F.REDO.APAP.CPH.DETAIL)
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT= ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
RETURN
*------------------------------------------------------------------------------
**********
PROCESS.PARA:
**********
    GOSUB FIND.MULTI.LOCAL.REF

    Y.MG.ACT.NOS=R.NEW(AZ.LOCAL.REF)<1,LOC.L.MG.ACT.NO.POS>
    IF NOT(Y.MG.ACT.NOS) THEN
        RETURN
    END
    IF R.NEW(AZ.RECORD.STATUS) EQ 'INAU' THEN
        GOSUB UPDATE.CPH.DETAIL
    END
    IF R.NEW(AZ.RECORD.STATUS) EQ 'RNAU' THEN
        GOSUB DELETE.CPH.DETAIL
    END
RETURN

*-------------------------------------------------------------------------

**********
UPDATE.CPH.DETAIL:
**********
    Y.CPH.DET.ID=ID.NEW
    GOSUB READ.CPH.DET
    R.REDO.APAP.CPH.DETAIL<CPH.DET.DEP.ACT.NO>=ID.NEW

    Y.AC.ID=Y.CPH.DET.ID
    GOSUB READ.ACCOUNT
    Y.DEP.ACT.NAME=R.ACCOUNT<AC.SHORT.TITLE>
    R.REDO.APAP.CPH.DETAIL<CPH.DET.DEP.ACT.NAME>=Y.DEP.ACT.NAME
    R.REDO.APAP.CPH.DETAIL<CPH.DET.START.DATE>=R.NEW(AZ.VALUE.DATE)
    R.REDO.APAP.CPH.DETAIL<CPH.DET.END.DATE>=R.NEW(AZ.MATURITY.DATE)
    R.REDO.APAP.CPH.DETAIL<CPH.DET.PRINCIPAL>=R.NEW(AZ.ORIG.PRINCIPAL)
*CALL APAP.REDOAPAP.REDO.APAP.GET.MATURITY.AMT(ID.NEW,Y.MAT.AMT)
    CALL APAP.REDOAPAP.redoApapGetMaturityAmt(ID.NEW,Y.MAT.AMT)
    R.REDO.APAP.CPH.DETAIL<CPH.DET.MATURITY.AMT>=Y.MAT.AMT
    Y.ACT.COUNT=DCOUNT(Y.MG.ACT.NOS,@SM)
    Y.COUNT=1
    LOOP
        Y.MG.AC.NO=FIELD(Y.MG.ACT.NOS,@SM,Y.COUNT,1)
        Y.AC.ID=Y.MG.AC.NO
        GOSUB READ.ACCOUNT
        Y.ARR.ID=R.ACCOUNT<AC.ARRANGEMENT.ID>
        Y.LOAN.AC.NAME=R.ACCOUNT<AC.SHORT.TITLE>
        GOSUB UPDATE.STATUS
*CALL APAP.REDOAPAP.REDO.APAP.GET.OUTSTANDING.AMT(TODAY,Y.ARR.ID,Y.OUTS.PRINCIPLE)
        CALL APAP.REDOAPAP.redoApapGetOutstandingAmt(TODAY,Y.ARR.ID,Y.OUTS.PRINCIPLE)
        Y.OUTS.PRINCIPLE=ABS(Y.OUTS.PRINCIPLE)
        GOSUB ASSIGN.LOAN.VALUES
        Y.COUNT += 1
    WHILE Y.COUNT LE Y.ACT.COUNT
    REPEAT

    GOSUB WRITE.CPH.DET
RETURN
*-------------------------------------------------------------------------
*************
UPDATE.STATUS:
*************


    PROP.CLASS='OVERDUE'
    GOSUB GET.CONDITIONS
    Y.STATUS=R.REC<AA.OD.LOCAL.REF,LOC.L.LOAN.STATUS.1>
    Y.SV.POS=1
    Y.STAT.COUNT=DCOUNT(Y.STATUS,@SM)
    LOOP
        Y.STATUS.ARR=R.REDO.APAP.CPH.DETAIL<CPH.DET.STATUS,Y.COUNT>
        Y.FIELD.VALUE=FIELD(Y.STATUS,@SM,Y.SV.POS)
        LOCATE Y.FIELD.VALUE IN Y.STATUS.ARR<1,1,1> SETTING POS THEN
        END ELSE
            R.REDO.APAP.CPH.DETAIL<CPH.DET.STATUS,Y.COUNT,Y.SV.POS>=Y.FIELD.VALUE
        END
        Y.SV.POS += 1 ;*R22 AUTO CODE CONVERSION
    WHILE Y.SV.POS EQ Y.STAT.COUNT
    REPEAT
RETURN
*-------------------------------------------------------------------------
***************
GET.CONDITIONS:
***************
    AA.ID = Y.ARR.ID
    EFF.DATE =''
    PROPERTY=''
    R.REC = ''
    ERR.MSG = ''
    CALL REDO.CRR.GET.CONDITIONS(AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.REC,ERR.MSG)
RETURN


*-------------------------------------------------------------------------
**********
READ.ACCOUNT:
**********
    CALL F.READ(FN.ACCOUNT,Y.AC.ID,R.ACCOUNT,F.ACCOUNT,Y.ACCOUNT.ERR)
RETURN
*-------------------------------------------------------------------------
**********
READ.CPH.DET:
**********
    CALL F.READ(FN.REDO.APAP.CPH.DETAIL,Y.CPH.DET.ID,R.REDO.APAP.CPH.DETAIL,F.REDO.APAP.CPH.DETAIL,Y.REDO.APAP.CPH.DETAIL.ERR)
RETURN
*-------------------------------------------------------------------------

**********
ASSIGN.LOAN.VALUES:
**********
    R.REDO.APAP.CPH.DETAIL<CPH.DET.LOAN.ACT.NO,Y.COUNT>=Y.MG.AC.NO
    R.REDO.APAP.CPH.DETAIL<CPH.DET.ARR.ID,Y.COUNT>=Y.ARR.ID
    R.REDO.APAP.CPH.DETAIL<CPH.DET.ACT.NAME,Y.COUNT>=Y.LOAN.AC.NAME
    R.REDO.APAP.CPH.DETAIL<CPH.DET.OUTS.PRINCIPAL,Y.COUNT>=Y.OUTS.PRINCIPLE
RETURN
*-------------------------------------------------------------------------
**********
WRITE.CPH.DET:
**********
    TEMPTIME = OCONV(TIME(),"MTS")
    TEMPTIME = TEMPTIME[1,5]
    CHANGE ':' TO '' IN TEMPTIME
    CHECK.DATE = DATE()

    R.REDO.APAP.CPH.DETAIL<CPH.DET.DATE.TIME>=OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),"R%2"):OCONV(CHECK.DATE,"DD"):TEMPTIME
    R.REDO.APAP.CPH.DETAIL<CPH.DET.CURR.NO> = R.NEW(AZ.CURR.NO)
    R.REDO.APAP.CPH.DETAIL<CPH.DET.INPUTTER>=C$T24.SESSION.NO:'_':OPERATOR ;*R22 AUTO CODE CONVERSION
    R.REDO.APAP.CPH.DETAIL<CPH.DET.AUTHORISER>=C$T24.SESSION.NO:'_':OPERATOR
    R.REDO.APAP.CPH.DETAIL<CPH.DET.DEPT.CODE>=R.USER<EB.USE.DEPARTMENT.CODE>
    R.REDO.APAP.CPH.DETAIL<CPH.DET.CO.CODE>=ID.COMPANY
    R.REDO.APAP.CPH.DETAIL<CPH.DET.RECORD.STATUS>=''
    CALL F.WRITE(FN.REDO.APAP.CPH.DETAIL,Y.CPH.DET.ID,R.REDO.APAP.CPH.DETAIL)
RETURN
*-------------------------------------------------------------------------
**********
DELETE.CPH.DETAIL:
**********
    Y.CPH.DET.ID=ID.NEW
    CALL F.DELETE(FN.REDO.APAP.CPH.DETAIL,Y.CPH.DET.ID)
RETURN
*-------------------------------------------------------------------------
**********
FIND.MULTI.LOCAL.REF:
**********
    APPL.ARRAY ='AZ.ACCOUNT':@FM:"AA.ARR.OVERDUE"
    FLD.ARRAY ='L.MG.ACT.NO':@FM:'L.LOAN.STATUS.1'
    FLD.POS =''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.MG.ACT.NO.POS= FLD.POS<1,1>
    LOC.L.LOAN.STATUS.1=FLD.POS<2,1>
RETURN
*-------------------------------------------------------------------------
END
