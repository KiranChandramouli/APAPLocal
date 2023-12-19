* @ValidationCode : MjotNjMzMjY2NTU6Q3AxMjUyOjE2ODQ0OTEwNDY0Mzc6SVRTUzotMTotMToxMDAwOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1000
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.V.VAL.INS.POLICIES
*------------------------------------------------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.V.VAL.INS.POLICIES
*Date              : 20.05.2010
*-----------------------------------------------------------------------------------------------------------------
* Description : This routine will be used to perform various checks on the
* fields in the version APAP.H.INSURANCE.DETAILS,INP
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
* 20.05.2010      Rashmitha M        ODR-2009-12-0275            Initial Version
* 13.07.2010      Sakthi S           ODR-2009-12-0275            Changes done for INS.COMPNAY(REDO.APAP.H.COMP.NAME)
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   CALL ROUTINE ADDED
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.REDO.T.AUTH.ARRANGEMENT
    $INSERT I_F.COLLATERAL
    $INSERT I_F.AA.TERM.AMOUNT

    $INSERT I_F.REDO.APAP.H.COMP.NAME
    $INSERT I_F.REDO.H.POLICY.NUMBER
    $USING APAP.AA

    GOSUB INITIALISE
    GOSUB OPENFILES
    GOSUB MAIN.PROCESS

RETURN
*------------------------------------------------------------------------------------------------------------------
**********
INITIALISE:
**********
    FN.REDO.T.AUTH.ARRANGEMENT = 'F.REDO.T.AUTH.ARRANGEMENT'
    F.REDO.T.AUTH.ARRANGEMENT  = ''

    FN.COLLATERAL = 'F.COLLATERAL'
    F.COLLLATERAL = ''

    FN.AA.ARR.TERM.AMOUNT = 'F.AA.ARR.TERM.AMOUNT'
    F.AA.ARR.TERM.AMOUNT  = ''
*
    FN.REDO.APAP.H.COMP.NAME = 'F.REDO.APAP.H.COMP.NAME'
    F.REDO.APAP.H.COMP.NAME = ''
    R.REDO.APAP.H.COMP.NAME = ''
    Y.APAP.H.COMP.ERR = ''
*
    FN.REDO.H.POLICY.NUMBER = 'F.REDO.H.POLICY.NUMBER'
    F.REDO.H.POLICY.NUMBER  = ''
    R.REDO.H.POLICY.NUMBER = ''
    Y.REDO.POL.NUM.ERR = ''
    Y.POLICY.NUMBER = ''
*
RETURN
*------------------------------------------------------------------------------------------------------------------
**********
OPENFILES:
**********
    CALL OPF(FN.REDO.T.AUTH.ARRANGEMENT,F.REDO.T.AUTH.ARRANEGMENT)
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)
    CALL OPF(FN.REDO.APAP.H.COMP.NAME,F.REDO.APAP.H.COMP.NAME)
*
    CALL OPF(FN.REDO.H.POLICY.NUMBER,F.REDO.H.POLICY.NUMBER)
*
RETURN
*------------------------------------------------------------------------------------------------------------------
********
MAIN.PROCESS:
********

    Y.INS.POL.COUNT = DCOUNT(R.NEW(INS.DET.INS.POLICY.TYPE),@VM)
    Y.INT = 1
    LOOP
    WHILE Y.INT LE Y.INS.POL.COUNT
        INS.POLICY.TYPE = R.NEW(INS.DET.INS.POLICY.TYPE)<1,Y.INT>
        CLASS.POLICY    = R.NEW(INS.DET.CLASS.POLICY)<1,Y.INT,1>

        GOSUB SUB.PROCESS1
        GOSUB SUB.PROCESS2
        GOSUB SUB.PROCESS3
        GOSUB SUB.PROCESS4
        GOSUB SUB.PROCESS5
        GOSUB SUB.PROCESS6
        Y.INT += 1

    REPEAT

RETURN

*--------------------------------------------------------------------------------------------------------------------
*********
SUB.PROCESS1:
*********
    IF INS.POLICY.TYPE EQ 'FHA' AND CLASS.POLICY NE 'FHA' THEN
        AF = INS.DET.INS.POLICY.TYPE
        AV = Y.INT
        ETEXT ='EB-REDO.CLASS.POLICY'
        CALL STORE.END.ERROR
    END

    IF  INS.POLICY.TYPE EQ 'VU' AND CLASS.POLICY NE 'GROUP' THEN
        AF = INS.DET.INS.POLICY.TYPE
        AV = Y.INT
        ETEXT = 'EB-REDO.CLASS.POLICY.GROUP'
        CALL STORE.END.ERROR
    END

*    IF INS.POLICY.TYPE NE 'VU' OR INS.POLICY.TYPE NE 'VI' AND R.NEW(INS.DET.COLLATERAL.ID) EQ '' THEN1

    IF INS.POLICY.TYPE EQ 'FHA' OR INS.POLICY.TYPE EQ 'VE' AND R.NEW(INS.DET.COLLATERAL.ID) EQ '' THEN
        TEXT = 'ASSO.COLLATERAL.SHOULD.NOT.BE.BLANK'
        CURR.NO ='1'
        CALL STORE.OVERRIDE(CURR.NO)
    END

RETURN
*------------------------------------------------------------------------------------------------------------------
*********
SUB.PROCESS2:
*********
    ARR.ID = R.NEW(INS.DET.ASSOCIATED.LOAN)
    CALL F.READ(FN.REDO.T.AUTH.ARRANGEMENT,ARR.ID,R.AUTH.ARR,F.REDO.T.AUTH.ARRANGEMENT,Y.ERR)
    IF R.AUTH.ARR NE '' AND R.AUTH.ARR<REDO.ARR.INS.POLICY.TYPE> EQ INS.POLICY.TYPE THEN
        AF = INS.DET.INS.POLICY.TYPE
        AV = Y.INT
        ETEXT = "EB-LOAN.ALREADY.EXISTS"
        CALL STORE.END.ERROR
    END

    IF R.AUTH.ARR NE '' AND R.AUTH.ARR<REDO.ARR.COLLATERAL.ID> EQ R.NEW(INS.DET.COLLATERAL.ID) THEN
        AF=INS.DET.COLLATERAL.ID
        AV = Y.INT
        ETEXT ="EB-COLLATERAL.ALREADY.EXISTS"
        CALL STORE.END.ERROR
    END

    MANAG.TYPE = R.NEW(INS.DET.MANAGEMENT.TYPE)
    IF CLASS.POLICY EQ 'ED' AND MANAG.TYPE NE 'Not Included on Fee' THEN
        AF=INS.DET.CLASS.POLICY
        AV = Y.INT
        ETEXT="EB-REDO.NOT.INCLUDED.FEE"
        CALL STORE.END.ERROR
    END

    IF CLASS.POLICY EQ 'FHA' AND MANAG.TYPE EQ 'Not Included on Fee' THEN
        AF=INS.DET.CLASS.POLICY
        AV = Y.INT
        ETEXT= "EB-REDO.NOT.INCLUDED.FEE.FHA"
        CALL STORE.END.ERROR
    END
    IF CLASS.POLICY EQ 'GROUP' AND INS.POLICY.TYPE NE "VU" THEN
        Y.DUMMY.VAR = 'Included on Fee'
        IF MANAG.TYPE NE Y.DUMMY.VAR THEN
            AF=INS.DET.CLASS.POLICY
            AV = Y.INT
            ETEXT="EB-REDO.INCLUDED.FEE"
            CALL STORE.END.ERROR
        END
    END

RETURN
*------------------------------------------------------------------------------------------------------------------
**********
SUB.PROCESS3:
***********

    START.DATE = R.NEW(INS.DET.POL.START.DATE)
    END.DATE = R.NEW(INS.DET.POL.EXP.DATE)

    IF CLASS.POLICY EQ 'GROUP' AND INS.POLICY.TYPE NE "VU" AND START.DATE EQ '' THEN
        AF=INS.DET.POL.START.DATE
        ETEXT="EB-REDO.CHARGE.START.DATE"
        CALL STORE.END.ERROR
    END
    IF CLASS.POLICY EQ 'GROUP' AND INS.POLICY.TYPE EQ "VU" THEN
        IF MANAG.TYPE NE "Not Included on Fee" THEN
            AF=INS.DET.INS.POLICY.TYPE
            AV = Y.INT
            ETEXT ="EB-REDO.FEE.TYPE.LIFE.POLICIES"
            CALL STORE.END.ERROR
        END
    END
*
    Y.INS.COMPANY.ID = ''
    Y.INS.COMPANY.NAME = ''
    Y.INS.COMPANY.ID = R.NEW(INS.DET.INS.COMPANY)
    CALL F.READ(FN.REDO.APAP.H.COMP.NAME,Y.INS.COMPANY.ID,R.REDO.APAP.H.COMP.NAME,F.REDO.APAP.H.COMP.NAME,Y.APAP.H.COMP.ERR)
    IF NOT(Y.APAP.H.COMP.ERR) THEN
        Y.INS.COMPANY.NAME = R.REDO.APAP.H.COMP.NAME<REDO.CMP.INS.COMP.NAME>

        IF CLASS.POLICY EQ 'FHA' AND Y.INS.COMPANY.NAME  NE "BNV" THEN
            AF=INS.DET.CLASS.POLICY
            AV = Y.INT
            ETEXT = "EB-REDO.BNV.INSURANCE.POLICY"
            CALL STORE.END.ERROR
        END
    END
*


    Y.INS.COMPANY.CNT = ''
    Y.INS.COMPANY.CNT = DCOUNT(Y.INS.COMPANY.ID,@VM) ;*R22 AUTO CONVERSION
    IF Y.INS.COMPANY.CNT GT '1' AND CLASS.POLICY NE 'GROUP' THEN
        AF=INS.DET.CLASS.POLICY
        AV = Y.INT
        ETEXT = "EB-REDO.GROUP.INSURANCE.POLICY"
        CALL STORE.END.ERROR
    END
*
RETURN
*------------------------------------------------------------------------------------------------------------------
*********
SUB.PROCESS4:
*********


    ARR.ID = R.NEW(INS.DET.ASSOCIATED.LOAN)
    Y.PROPERTY = ""
    PROPERTY='COMMITMENT'
    ARR.ID.TERM.AMOUNT= ARR.ID
    EFF.DATE=TODAY
    PROP.CLASS='TERM.AMOUNT'
    R.Condition.comm=''
    ERR.MSG=''

*    CALL REDO.CRR.GET.CONDITIONS(ARR.ID.TERM.AMOUNT,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition.comm,ERR.MSG)
*R22 MANUAL CONVERSION
*APAP.AA.REDO.CRR.GET.CONDITIONS(ARR.ID.TERM.AMOUNT,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition.comm,ERR.MSG) ;*R22 MANUAL CODE CONVERSION
    APAP.AA.redoCrrGetConditions(ARR.ID.TERM.AMOUNT,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition.comm,ERR.MSG) ;*R22 MANUAL CODE CONVERSION

    IF INS.POLICY.TYPE NE 'PVC' OR INS.POLICY.TYPE NE 'VE' THEN
        INS.AMNT = '';
        INS.AMNT = R.Condition.comm<AA.AMT.AMOUNT>
        R.NEW(INS.DET.INS.AMOUNT) = INS.AMNT          ;*R.AUTH.ARR<REDO.ARR.INS.AMOUNT>
    END ELSE
        COLL.ID = R.NEW(INS.DET.COLLATERAL.ID)
        CALL F.READ(FN.COLLATERAL,COLL.ID,R.COLL,F.COLLATERAL,Y.ERR)
        IF R.COLL NE '' AND INS.POLICY.TYPE EQ 'VE' THEN
            R.NEW(INS.DET.INS.AMOUNT) =R.COLL<COLL.NOMINAL.VALUE>
        END ELSE
            IF R.COLL NE '' AND INS.POLICY.TYPE EQ 'PVC' THEN
                R.NEW(INS.DET.INS.AMOUNT) =R.COLL<COLL.THIRD.PARTY.VALUE>
            END
        END
    END
    IF INS.POLICY.TYPE EQ 'FHA' OR INS.POLICY.TYPE EQ 'VU' AND CLASS.POLICY EQ 'ED' AND R.NEW(INS.DET.MON.POL.AMT) NE '' THEN
        AF=INS.DET.MON.POL.AMT
        ETEXT ='EB-REDO.MONTHLY.POLICY.AMT'
        CALL STORE.END.ERROR
    END
    IF INS.POLICY.TYPE  NE 'FHA' AND INS.POLICY.TYPE NE 'VU' AND CLASS.POLICY NE 'ED' AND R.NEW(INS.DET.MON.POL.AMT) EQ '' THEN
        AF=INS.DET.INS.POLICY.TYPE
        AV=Y.INT
        ETEXT = 'EB-MON.POL.AMT.IS.MANDATORY'
        CALL STORE.END.ERROR
    END

RETURN
*------------------------------------------------------------------------------------------------------------------
*********
SUB.PROCESS5:
*********

    IF INS.POLICY.TYPE NE 'VE' AND R.NEW(INS.DET.MON.POL.AMT.DATE) NE '' THEN
        AF= INS.DET.MON.POL.AMT.DATE
        ETEXT ='EB-REDO.MONTHLY.POLICY.DATE'
        CALL STORE.END.ERROR
    END
    Y.EXTRA.AMT = R.NEW(INS.DET.EXTRA.AMT)
    IF Y.EXTRA.AMT THEN
*  IF INS.POLICY.TYPE EQ 'FHA' OR INS.POLICY.TYPE EQ 'VU' OR CLASS.POLICY EQ 'ED' THEN
        IF INS.POLICY.TYPE EQ 'FHA' OR INS.POLICY.TYPE EQ 'VU' AND CLASS.POLICY EQ 'ED' THEN
            MON.POL.AMT =  R.NEW(INS.DET.MON.POL.AMT)
            T(10)<7> ='NOINPUT'
            IF MON.POL.AMT NE '' THEN
                AF= INS.DET.MON.POL.AMT
                ETEXT = "EB-REDO.NO.POLICY.AMT"
                CALL STORE.END.ERROR
            END
        END
    END

    R.NEW(INS.DET.MON.TOT.PRE.AMT) = R.NEW(INS.DET.MON.POL.AMT) + R.NEW(INS.DET.EXTRA.AMT)


*  IF INS.POLICY.TYPE NE 'VU' OR INS.POLICY.TYPE NE 'FHA' AND R.NEW(INS.DET.TOTAL.PRE.AMT) NE '' THEN
    IF INS.POLICY.TYPE EQ 'VU' OR INS.POLICY.TYPE EQ 'VE' AND R.NEW(INS.DET.TOTAL.PRE.AMT) NE '' THEN
        AF= INS.DET.TOTAL.PRE.AMT
        ETEXT= "EB-REDO.PREMIUM.AMOUNT"
        CALL STORE.END.ERROR
    END

    IF CLASS.POLICY EQ 'GROUP' AND V$FUNCTION EQ 'I' THEN

        POL.START.DATE = R.NEW(INS.DET.POL.START.DATE)
        POL.ORG.DATE= R.NEW(INS.DET.POLICY.ORG.DATE)
        R.NEW(INS.DET.POL.START.DATE) = R.NEW(INS.DET.POLICY.ORG.DATE)

    END

RETURN
*------------------------------------------------------------------------------------------------------------------
*********
SUB.PROCESS6:
*********
    IF V$FUNCTION EQ 'A' THEN
        IF CLASS.POLICY EQ 'GROUP' AND R.NEW(INS.DET.POL.START.DATE) NE R.NEW(INS.DET.POLICY.ORG.DATE) THEN
            TEXT ="REDO-POLICY.START.DATE"
            CURR.NO='1'
            CALL STORE.OVERRIDE(CURR.NO)

        END
    END
    IF CLASS.POLICY EQ 'FHA' THEN
        R.NEW(INS.DET.POL.START.DATE) = R.AUTH.ARR<REDO.ARR.INS.CTRL.RC.DAT>
    END


    IF CLASS.POLICY EQ 'ED' THEN
        R.NEW(INS.DET.POL.EXP.DATE) =  R.Condition.comm<AA.AMT.MATURITY.DATE>
    END

    EXP.DATE1 = R.NEW(INS.DET.POL.EXP.DATE)
    MAT.DATE1 = R.Condition.comm<AA.AMT.MATURITY.DATE>

    IF EXP.DATE1 LE TODAY OR EXP.DATE1 GT MAT.DATE1 THEN
        AF=INS.DET.POL.EXP.DATE
        ETEXT ='EB-CHECK.POL.EXP.DATE'
        CALL STORE.END.ERROR
    END

*  IF INS.POLICY.TYPE NE 'ED' THEN


    IF CLASS.POLICY EQ 'GROUP' THEN
        CALL F.READ(FN.REDO.H.POLICY.NUMBER,INS.POLICY.TYPE,R.REDO.H.POLICY.NUMBER,F.REDO.H.POLICY.NUMBER,Y.REDO.POL.NUM)
        Y.POLICY.NUMBER = R.REDO.H.POLICY.NUMBER<REDO.ARR.POL.POLICY.NUMBER>
        R.NEW(INS.DET.SEN.POLICY.NUMBER) = Y.POLICY.NUMBER
        GOSUB UPDATE.POLICY.NO
    END



    R.NEW(INS.DET.POLICY.STATUS) = 'CURRENT'

RETURN
*------------------------------------------------------------------------------------------------------------------
*****************
UPDATE.POLICY.NO:
*****************

    CALL F.READ(FN.REDO.H.POLICY.NUMBER,INS.POLICY.TYPE,R.REDO.H.POLICY.NUMBER,F.REDO.H.POLICY.NUMBER,Y.REDO.POL.NUM.ERR)
    Y.POLICY.NUMBER = R.REDO.H.POLICY.NUMBER<REDO.ARR.POL.POLICY.NUMBER>
    Y.POLICY.NUMBER += 1
    R.NEW(INS.DET.POLICY.NUMBER) = Y.POLICY.NUMBER
    R.REDO.H.POLICY.NUMBER<REDO.ARR.POL.POLICY.NUMBER> = Y.POLICY.NUMBER
    CALL F.WRITE(FN.REDO.H.POLICY.NUMBER,INS.POLICY.TYPE,R.REDO.H.POLICY.NUMBER)

RETURN
*------------------------------------------------------------------------------------------------------------------
END
