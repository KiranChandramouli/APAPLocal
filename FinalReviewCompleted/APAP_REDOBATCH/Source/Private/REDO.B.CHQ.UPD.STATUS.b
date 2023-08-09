<<<<<<< Updated upstream
* @ValidationCode : MjotNTI3NjQ1MzY0OkNwMTI1MjoxNjkwMjY0MzUzNTIyOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:22:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
=======
* @ValidationCode : MjoxNTk5MTcwNjM4OkNwMTI1MjoxNjg0ODU0MzgyMTI5OklUU1M6LTE6LTE6MTcyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 172
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
>>>>>>> Stashed changes
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CHQ.UPD.STATUS(Y.LOAN.NO)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.CHQ.UPD.STATUS
*--------------------------------------------------------------------------------------------------------
*Description       : This is an MULTI-THREAD main PROCESS routine, This routine will check if the value
*                    in Cheque returned date is one year back from today.s date, then change the status DROPPED
*In  Parameter     : ARR.ID -
*Out Parameter     : N/A
*Files  Used       : REDO.LOAN.CHQ.RETURN      As          I-o     Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date              Who                  Reference                Description
*   ------            -----               -------------             -------------
* 26 OCT 2011     MARIMUTHU S                                      Initial Creation
<<<<<<< Updated upstream
* Date                   who                   Reference
=======
* Date                   who                   Reference              
>>>>>>> Stashed changes
* 10-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION VM TO @VM AND SM TO @SM AND ++ TO += 1
* 10-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.REDO.LOAN.CHQ.RETURN
    $INSERT I_REDO.B.CHQ.UPD.STATUS.COMMON
    $INSERT I_F.REDO.APAP.CLEAR.PARAM
<<<<<<< Updated upstream
    $USING APAP.TAM
=======
>>>>>>> Stashed changes
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB UPD.CHQ.STATUS

    GOSUB UPDATE.OVERDUE

RETURN
*--------------------------------------------------------------------------------------------------------
***************
UPD.CHQ.STATUS:
***************
    CALL OCOMO("Processing : ":Y.LOAN.NO)
    Y.MAX.RETURN.CHQ = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.MAX.RET.CHEQUES>
    IF Y.MAX.RETURN.CHQ ELSE
        CALL OCOMO("Max return chq is not parameter in REDO.APAP.CLEAR.PARAM":Y.MAX.RETURN.CHQ)
        Y.MAX.RETURN.CHQ = 3      ;*Incase of not parameter.
    END
    R.REDO.LOAN.CHQ.RETURN = ''
    TRIGGER.OD = ''
    CALL F.READ(FN.REDO.LOAN.CHQ.RETURN,Y.LOAN.NO,R.REDO.LOAN.CHQ.RETURN,F.REDO.LOAN.CHQ.RETURN,Y.LCR.ERR)

    IF R.REDO.LOAN.CHQ.RETURN THEN
        GOSUB UPDATE.CHQ.RETURN
    END

RETURN

*------------------------------------------------------------
UPDATE.CHQ.RETURN:
*------------------------------------------------------------
    Y.RETURN.CNT       = 0
    Y.DATE             = R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.TXN.DATE>

    Y.VAR1 = 1
    Y.DATE.CNT = DCOUNT(Y.DATE,@VM)
    LOOP
    WHILE Y.VAR1 LE Y.DATE.CNT
        Y.RETURNED.CHEQUES = R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.CHEQUE.REF,Y.VAR1>
        Y.RET.CHQ.CNT = DCOUNT(Y.RETURNED.CHEQUES,@SM)
        Y.VAR2 = 1
        LOOP
        WHILE Y.VAR2 LE Y.RET.CHQ.CNT
            IF R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.EXP.DATE,Y.VAR1,Y.VAR2> LT TODAY THEN
                R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.STATUS,Y.VAR1,Y.VAR2> = 'DROPPED'
            END ELSE
                Y.RETURN.CNT += 1
            END
            Y.VAR2 += 1
        REPEAT
        Y.VAR1 += 1
    REPEAT
    R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.NO.OF.RET.CHQ> = Y.RETURN.CNT
    CALL F.WRITE(FN.REDO.LOAN.CHQ.RETURN,Y.LOAN.NO,R.REDO.LOAN.CHQ.RETURN)

RETURN
*--------------
UPDATE.OVERDUE:
*--------------


    IF R.REDO.LOAN.CHQ.RETURN<LN.CQ.RET.NO.OF.RET.CHQ> LT Y.MAX.RETURN.CHQ THEN
        IN.ARR.ID = ''
        OUT.ID = ''
<<<<<<< Updated upstream
*      CALL REDO.CONVERT.ACCOUNT(Y.LOAN.NO,IN.ARR.ID,OUT.ID,ERR.TEXT)
        APAP.TAM.redoConvertAccount(Y.LOAN.NO,IN.ARR.ID,OUT.ID,ERR.TEXT) ;*R22 Manual Code Conversion
=======
        CALL REDO.CONVERT.ACCOUNT(Y.LOAN.NO,IN.ARR.ID,OUT.ID,ERR.TEXT)
>>>>>>> Stashed changes
        ARR.ID = OUT.ID

        IN.PROPERTY.CLASS='OVERDUE'
        PROPERTY=''
<<<<<<< Updated upstream
*     CALL REDO.GET.PROPERTY.NAME(ARR.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,PROPERTY,OUT.ERR)
        APAP.TAM.redoGetPropertyName(ARR.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,PROPERTY,OUT.ERR) ;*R22 Manual Code Conversion
=======
        CALL REDO.GET.PROPERTY.NAME(ARR.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,PROPERTY,OUT.ERR)

>>>>>>> Stashed changes
        EFF.DATE = ''
        PROP.CLASS='OVERDUE'
        R.CONDITION = ''
        ERR.MSG = ''
<<<<<<< Updated upstream
*     CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
        APAP.TAM.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)  ;*R22 Manual Code Conversion
=======
        CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
>>>>>>> Stashed changes
        Y.STATUS = 'ThreeReturnedChecks'

        LOCATE Y.STATUS IN R.CONDITION<AA.OD.LOCAL.REF,POS.L.LOAN.COND,1> SETTING COND.POS THEN
            IF COND.POS EQ 1 THEN
                Y.VALUE = 'NULL'
            END ELSE
                Y.VALUE = '|-|'
            END
        END ELSE
            CALL OCOMO("3 Ret Chq status not found in Loan")
            RETURN
        END
        ACT.ID = "LENDING-UPDATE-":PROPERTY
        OFS.STRING.FINAL="AA.ARRANGEMENT.ACTIVITY,APAP/I/PROCESS,,,ARRANGEMENT:1:1=":ARR.ID:",ACTIVITY:1:1=":ACT.ID:",PROPERTY:1:1=":PROPERTY
        OFS.STRING.FINAL:= ",FIELD.NAME:1:1=LOCAL.REF:":POS.L.LOAN.COND:':':COND.POS:",FIELD.VALUE:1:1=":Y.VALUE
        OFS.SRC = 'REDO.AA.OVR.UPD'
        OPTIONS = ''
        OFS.MSG.ID = ''
        CALL OFS.POST.MESSAGE(OFS.STRING.FINAL,OFS.MSG.ID,OFS.SRC,OPTIONS)

        CALL OCOMO("Processed the Loan-":Y.LOAN.NO:"-Pos-":COND.POS:"-Val-":Y.VALUE)

    END ELSE
        CALL OCOMO("Processed the Loan but no change in status - ":Y.LOAN.NO)
    END

RETURN
END
