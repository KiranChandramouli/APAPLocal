$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.DEP.INVST.RATE(Y.FINAL.ARRAY)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 13-APRIL-2023      Conversion Tool       R22 Auto Conversion - FM to @FM ++ to += , -- to -= and SM to @SM
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
*PACS00311745-Created by Prabhu
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AZ.ACCOUNT


    GOSUB INIT
    GOSUB SELECT.AZ
RETURN

*****
INIT:
*****
    FN.AZ.ACCOUNT = "F.AZ.ACCOUNT"
    F.AZ.ACCOUNT = ""
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.AZ.ACC.HIS="F.AZ.ACCOUNT$HIS"
    F.AZ.ACC.HIS =""
    CALL OPF(FN.AZ.ACC.HIS,F.AZ.ACC.HIS)

    Y.LOC.APP  ='AZ.ACCOUNT'
    Y.LOC.FIELD='ORIG.DEP.AMT'
    Y.LOC.POS  =''
    CALL MULTI.GET.LOC.REF(Y.LOC.APP,Y.LOC.FIELD,Y.LOC.POS)

RETURN
**********
SELECT.AZ:
**********

    SEL.CMD = "SELECT " : FN.AZ.ACCOUNT : " WITH INTEREST.RATE NE ORIG.INTEREST.RATE"

    LOCATE "CO.CODE" IN D.FIELDS SETTING CO.CODE.POS THEN
        SEL.CMD :=" AND CO.CODE EQ ":D.RANGE.AND.VALUE<CO.CODE.POS>
    END

    LOCATE "ALL.IN.ONE.PRODUCT" IN D.FIELDS SETTING PROD.POS THEN
        SEL.CMD :=" AND ALL.IN.ONE.PRODUCT EQ ":D.RANGE.AND.VALUE<PROD.POS>
    END

    CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.REC,ERR)

    LOCATE "MODIFY.DATE" IN D.FIELDS SETTING Y.MOD.DATE.POS THEN
        Y.DATE.RANGE=D.RANGE.AND.VALUE<Y.MOD.DATE.POS>
        CHANGE @SM TO @FM IN Y.DATE.RANGE
        Y.START.DATE=Y.DATE.RANGE<1>
        Y.END.DATE  =Y.DATE.RANGE<2>
        IF NOT(Y.END.DATE) THEN
            Y.END.DATE=Y.START.DATE
        END
    END
    GOSUB PROCESS.LIST

RETURN

*************
PROCESS.LIST:
*************
    Y.LOOP.CNT=1
    LOOP
    WHILE Y.LOOP.CNT LE NO.OF.REC
        Y.AZ.ID=SEL.LIST<Y.LOOP.CNT>
        CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ID,R.AZ.ACC,F.AZ.ACCOUNT,ERR)
        GOSUB PROCESS.HISTORY
        Y.LOOP.CNT += 1
    REPEAT
RETURN
********
PROCESS:
********
    Y.TERM=''

    START.DATE    = R.AZ.ACC<AZ.VALUE.DATE>
    MAT.DATE      = R.AZ.ACC<AZ.MATURITY.DATE>
    Y.DIFF        = "C"
    IF START.DATE NE '' AND MAT.DATE NE '' THEN
        CALL CDD(Y.ID1,START.DATE,MAT.DATE,Y.DIFF)
        IF Y.DIFF GT 30 THEN
            Y.TERM.MNTHS=''
            CALL EB.NO.OF.MONTHS(START.DATE,MAT.DATE,Y.TERM.MNTHS)
            IF Y.TERM.MNTHS EQ '1' THEN
                Y.TERM = Y.TERM.MNTHS:' MES'
            END
            ELSE
                Y.TERM = Y.TERM.MNTHS:' MESES'
            END
        END
        ELSE
            Y.TERM = Y.DIFF:' DIAS'
        END
    END
    Y.FINAL.DATA     =R.AZ.ACC<AZ.CO.CODE>:'*':R.AZ.ACC<AZ.CATEGORY>:'*':Y.AZ.ID:'*':R.AZ.ACC<AZ.CURRENCY>:'*':R.AZ.ACC<AZ.LOCAL.REF><1,Y.LOC.POS>:'*':Y.TERM
    Y.FINAL.DATA    :='*':R.AZ.ACC<AZ.CREATE.DATE>:'*':R.AZ.ACC<AZ.MATURITY.DATE>:'*':Y.INT.RATE.OLD:'*':R.AZ.ACC<AZ.INTEREST.RATE>:'*'
    Y.FINAL.DATA    :=R.AZ.ACC<AZ.INPUTTER>:'*':R.AZ.ACC<AZ.AUTHORISER>
    Y.FINAL.ARRAY<-1>=Y.FINAL.DATA
RETURN
***************
PROCESS.HISTORY:
***************
    Y.CHANGE.DATE ='20':R.AZ.ACC<AZ.DATE.TIME>[1,6]
    Y.INT.RATE.NEW=R.AZ.ACC<AZ.INTEREST.RATE>
    Y.CURR.NO     =R.AZ.ACC<AZ.CURR.NO>
    Y.CURR.NO-    =1
    Y.LOOP.LIM    =1
    LOOP
    WHILE Y.CURR.NO GE Y.LOOP.LIM
        Y.AZ.HIS.ID=Y.AZ.ID:';':Y.CURR.NO
        CALL F.READ(FN.AZ.ACC.HIS,Y.AZ.HIS.ID,R.AZ.ACC.HIS,F.AZ.ACC.HIS,ERR)
        Y.INT.RATE.OLD=R.AZ.ACC.HIS<AZ.INTEREST.RATE>
        IF Y.INT.RATE.NEW NE Y.INT.RATE.OLD THEN
            GOSUB INT.CHANGE.PROCESS
        END
        ELSE
            R.AZ.ACC      =R.AZ.ACC.HIS
            Y.CHANGE.DATE ='20':R.AZ.ACC<AZ.DATE.TIME>[1,6]
            Y.INT.RATE.NEW=R.AZ.ACC<AZ.INTEREST.RATE>
        END
        Y.CURR.NO -= 1
    REPEAT
RETURN
******************
INT.CHANGE.PROCESS:
******************

    IF Y.START.DATE AND Y.END.DATE THEN
        IF  Y.CHANGE.DATE GE Y.START.DATE AND Y.CHANGE.DATE LE Y.END.DATE THEN
            GOSUB PROCESS
        END
        ELSE
            IF Y.CHANGE.DATE LT Y.START.DATE THEN
                Y.CURR.NO=1
            END
        END
    END
    ELSE
        GOSUB PROCESS
    END
    R.AZ.ACC      =R.AZ.ACC.HIS
    Y.CHANGE.DATE ='20':R.AZ.ACC<AZ.DATE.TIME>[1,6]
    Y.INT.RATE.NEW=R.AZ.ACC<AZ.INTEREST.RATE>
RETURN
END
