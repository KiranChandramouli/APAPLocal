* @ValidationCode : MjoxMTY2NTA0ODQyOkNwMTI1MjoxNjkwMjY0MjU3MTQ3OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:20:57
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
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.AUT.CPH.MODIFY
*------------------------------------------------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.APAP.AUT.CPH.MODIFY
*Date              : 17.08.2010
*-----------------------------------------------------------------------------------------------------------------
*Description: REDO.APAP.AUT.CPH.MODIFY is an authorisation routine for the version AZ.ACCOUNT,MODIFY.CPH
*             which updates the changes made in CPH to table REDO.APAP.CPH.DET
* Date                   who                   Reference
* 04-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION VM TO @VM AND FM TO @FM AND SM TO @SM
* 04-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  : --N/A--
* Out : --N/A--
*------------------------------------------------------------------------------------------------------------------
* Dependencies:
* -------------
* Calls     : --N/A--
* Called By : --N/A--
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Date              Name              Reference                    Version
* -------           ----              ----------                   --------
* 17.08.2010       Sakthi S       ODR-2009-10-0346 B.21           Initial Version
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.APAP.CPH.DETAIL
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AZ.ACCOUNT
    $USING APAP.TAM

    GOSUB MAIN.PARA
    GOSUB GOEND
RETURN
*------------------------------------------------------------------------------------------------------------------
MAIN.PARA:
*------------------------------------------------------------------------------------------------------------------
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA
RETURN
*------------------------------------------------------------------------------------------------------------------
OPEN.PARA:
*------------------------------------------------------------------------------------------------------------------
    FN.REDO.APAP.CPH.DET = 'F.REDO.APAP.CPH.DETAIL'
    F.REDO.APAP.CPH.DET = ''
    R.REDO.APAP.CPH.DET = ''
    Y.REDO.APAP.CPH.DET.ERR = ''
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    R.ACCOUNT.REC = ''
    Y.ACCOUNT.ERR = ''
    CALL OPF(FN.REDO.APAP.CPH.DET,F.REDO.APAP.CPH.DET)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
RETURN
*------------------------------------------------------------------------------------------------------------------
PROCESS.PARA:
*------------------------------------------------------------------------------------------------------------------
    GOSUB READ.CPH.DET
    GOSUB FIND.MULTI.LOCAL.REF

    Y.OLD.ACCTS = R.OLD(AZ.LOCAL.REF)<1,LOC.L.MG.ACT.NO.POS>
    Y.NEW.ACCTS = R.NEW(AZ.LOCAL.REF)<1,LOC.L.MG.ACT.NO.POS>
    IF NOT(Y.NEW.ACCTS) THEN
        GOSUB GOEND
    END
    Y.AZ.REC.STATUS = R.NEW(AZ.RECORD.STATUS)
    IF Y.AZ.REC.STATUS EQ 'INAU' THEN
        LOOP
            REMOVE Y.OLD.ACT FROM Y.OLD.ACCTS SETTING Y.OLD.MG.POS
        WHILE Y.OLD.ACT:Y.OLD.MG.POS
            GOSUB FIND.DELINKED.MGS
        REPEAT
        GOSUB FIND.LINKED.MGS
        GOSUB MOVE.TO.HIS.AND.NEW
    END
    IF Y.AZ.REC.STATUS EQ 'RNAU' THEN
        GOSUB READ.CPH.DET
        GOSUB MOVE.TO.HIS.AND.NEW
        CALL F.DELETE(FN.REDO.APAP.CPH.DETAIL,Y.CPH.DET.ID)
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
READ.CPH.DET:
*------------------------------------------------------------------------------------------------------------------
    Y.CPH.DET.ID = ID.NEW
    CALL F.READ(FN.REDO.APAP.CPH.DET,Y.CPH.DET.ID,R.REDO.APAP.CPH.DET,F.REDO.APAP.CPH.DET,Y.REDO.APAP.CPH.DET.ERR)
RETURN
*------------------------------------------------------------------------------------------------------------------
FIND.MULTI.LOCAL.REF:
*------------------------------------------------------------------------------------------------------------------
    APPL.ARRAY = 'AZ.ACCOUNT':@FM:'AA.ARR.OVERDUE'
    FLD.ARRAY = 'L.MG.ACT.NO':@FM:'L.LOAN.STATUS.1'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.MG.ACT.NO.POS  = FLD.POS<1,1>
    LOC.L.LOAN.STATUS.1= FLD.POS<2,1>
RETURN
*------------------------------------------------------------------------------------------------------------------
FIND.DELINKED.MGS:
*------------------------------------------------------------------------------------------------------------------

    CHANGE @SM TO @FM IN Y.NEW.ACCTS
    LOCATE Y.OLD.ACT IN Y.NEW.ACCTS SETTING Y.OLD.IN.NEW.POS THEN
        DEL Y.NEW.ACCTS<Y.OLD.IN.NEW.POS>
    END ELSE
        GOSUB CLEAR.DELINKED.MGS
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
FIND.LINKED.MGS:
*------------------------------------------------------------------------------------------------------------------
    IF Y.NEW.ACCTS THEN
        LOOP
            REMOVE Y.NEW.ACT FROM Y.NEW.ACCTS SETTING Y.NEW.MG.POS
        WHILE Y.NEW.ACT:Y.NEW.MG.POS
            GOSUB GET.NEW.MG.DET
            GOSUB UPD.NEW.MG.DET
        REPEAT
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
CLEAR.DELINKED.MGS:
*------------------------------------------------------------------------------------------------------------------
    LOCATE Y.OLD.ACT IN R.REDO.APAP.CPH.DET<CPH.DET.LOAN.ACT.NO,1> SETTING Y.DEL.MG.POS THEN
        DEL R.REDO.APAP.CPH.DET<CPH.DET.LOAN.ACT.NO,Y.DEL.MG.POS>
        DEL R.REDO.APAP.CPH.DET<CPH.DET.ARR.ID,Y.DEL.MG.POS>
        DEL R.REDO.APAP.CPH.DET<CPH.DET.ACT.NAME,Y.DEL.MG.POS>
        DEL R.REDO.APAP.CPH.DET<CPH.DET.STATUS,Y.DEL.MG.POS>
        DEL R.REDO.APAP.CPH.DET<CPH.DET.OUTS.PRINCIPAL,Y.DEL.MG.POS>
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
GET.NEW.MG.DET:
*------------------------------------------------------------------------------------------------------------------
    GOSUB READ.ACCOUNT
    Y.ARR.ID = R.ACCOUNT.REC<AC.ARRANGEMENT.ID>
    Y.LOAN.AC.NAME = R.ACCOUNT.REC<AC.SHORT.TITLE>
    Y.LOAN.ACT.NOS = R.REDO.APAP.CPH.DET<CPH.DET.LOAN.ACT.NO>
    Y.COUNT = DCOUNT(Y.LOAN.ACT.NOS,@VM)
    Y.COUNT += 1
    GOSUB UPDATE.STATUS
*APAP.REDOAPAP.REDO.APAP.GET.OUTSTANDING.AMT(TODAY,Y.ARR.ID,Y.OUTS.PRINCIPLE)
    APAP.REDOAPAP.redoApapGetOutstandingAmt(TODAY,Y.ARR.ID,Y.OUTS.PRINCIPLE)
RETURN
*------------------------------------------------------------------------------------------------------------------
READ.ACCOUNT:
*------------------------------------------------------------------------------------------------------------------
    CALL F.READ(FN.ACCOUNT,Y.NEW.ACT,R.ACCOUNT.REC,F.ACCOUNT,Y.ACCOUNT.ERR)
RETURN
*------------------------------------------------------------------------------------------------------------------
UPDATE.STATUS:
*------------------------------------------------------------------------------------------------------------------
    PROP.CLASS = 'OVERDUE'
    GOSUB GET.CONDITIONS
    Y.STATUS = R.REC<AA.OD.LOCAL.REF,LOC.L.LOAN.STATUS.1>
    Y.STAT.COUNT = DCOUNT(Y.STATUS,@SM)
    Y.COUNT2 = 1
    LOOP
    WHILE Y.COUNT2 EQ Y.STAT.COUNT
        R.REDO.APAP.CPH.DET<CPH.DET.STATUS,Y.COUNT,Y.COUNT2> = FIELD(Y.STATUS,@SM,Y.COUNT2,1)
        Y.COUNT2 += 1
    REPEAT
RETURN
*------------------------------------------------------------------------------------------------------------------
GET.CONDITIONS:
*------------------------------------------------------------------------------------------------------------------
    AA.ID = Y.ARR.ID
    EFF.DATE = ''
    PROPERTY = ''
    R.CONDITION = ''
    ERR.MSG = ''
*   CALL REDO.CRR.GET.CONDITIONS(AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.REC,ERR.MSG)
    APAP.TAM.redoCrrGetConditions(AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.REC,ERR.MSG) ;*R22 Manual Code Conversion
RETURN
*------------------------------------------------------------------------------------------------------------------
UPD.NEW.MG.DET:
*------------------------------------------------------------------------------------------------------------------
    R.REDO.APAP.CPH.DET<CPH.DET.LOAN.ACT.NO,Y.COUNT> = Y.NEW.ACT
    R.REDO.APAP.CPH.DET<CPH.DET.ARR.ID,Y.COUNT> = Y.ARR.ID
    R.REDO.APAP.CPH.DET<CPH.DET.ACT.NAME,Y.COUNT> = Y.LOAN.AC.NAME
    R.REDO.APAP.CPH.DET<CPH.DET.OUTS.PRINCIPAL,Y.COUNT> = Y.OUTS.PRINCIPLE
RETURN
*------------------------------------------------------------------------------------------------------------------
MOVE.TO.HIS.AND.NEW:
*------------------------------------------------------------------------------------------------------------------
    Y.TOT.LENGTH = CPH.DET.AUDIT.DATE.TIME
    DIM  R.MAT.REC(CPH.DET.AUDIT.DATE.TIME)
    MATPARSE R.MAT.REC FROM R.REDO.APAP.CPH.DET
    CALL EB.HIST.REC.WRITE(FN.REDO.APAP.CPH.DET,Y.CPH.DET.ID,MAT R.MAT.REC,Y.TOT.LENGTH)
RETURN
*------------------------------------------------------------------------------------------------------------------
GOEND:
*------------------------------------------------------------------------------------------------------------------
END
*-----------------------------------------------*END OF SUBROUTINE*-------------------------------------------------
