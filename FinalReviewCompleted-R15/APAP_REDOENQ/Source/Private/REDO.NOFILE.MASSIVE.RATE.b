* @ValidationCode : Mjo4MTU2MTMzOkNwMTI1MjoxNjg1NTQzMTMxNDg4OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 19:55:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOFILE.MASSIVE.RATE(Y.OUT.ARRAY)
*--------------------------------------------------------
* Description: This routine is a nofile enquiry routine to display the details
* of the loan along with interest rate.

* In  Argument:
* Out Argument: Y.OUT.ARRAY

*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*10 Sep 2011     H Ganesh         Massive rate - B.16  INITIAL CREATION
*
* 17-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM,++ to +=
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.AA.ARRANGEMENT
    $USING APAP.TAM
    $USING APAP.AA

    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------

    Y.OUT.ARRAY = ''

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)


RETURN
*-----------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------

    FILE.NAME = FN.AA.ARRANGEMENT

    LOCATE 'MARGIN.ID' IN  D.FIELDS<1> SETTING POS1 THEN
        Y.MARGIN.ID = D.RANGE.AND.VALUE<POS1>
        D.RANGE.AND.VALUE<POS1>=''
        D.LOGICAL.OPERANDS<POS1>=''
        D.FIELDS<POS1>=''

    END

    APAP.REDOENQ.redoEFormSelStmt(FILE.NAME, '', '', SEL.AA.CMD) ;*Manual R22 conversion
    SEL.AA.CMD :=' AND (ARR.STATUS EQ AUTH OR ARR.STATUS EQ CURRENT)'
    CALL EB.READLIST(SEL.AA.CMD,AA.IDS,'',NO.OF.REC,SEL.ERR)
    APAP.AA.redoCheckAaIds(AA.IDS,RETURN.AA.IDS) ;*Manual R22 conversion
    APAP.AA.redoCheckAaIds(aaIds, returnAaIds)

    GOSUB FORM.ARRAY

  
RETURN
*-----------------------------------------------------------------
FORM.ARRAY:
*-----------------------------------------------------------------


    Y.OUT.ARRAY = ''
    Y.FINAL.IDS.CNT = DCOUNT(RETURN.AA.IDS,@FM)

    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.FINAL.IDS.CNT

        Y.AA.ID = FIELD(RETURN.AA.IDS<Y.CNT>,'*',1)
        GOSUB GET.INTEREST.DET
        Y.OUT.ARRAY<-1> = Y.AA.AC.ID:'*':Y.CUS.ID:'*':Y.EFFECTIVE.RATE:'*':FIELD(RETURN.AA.IDS<Y.CNT>,'*',2):'*':FIELD(RETURN.AA.IDS<Y.CNT>,'*',3):'*':FIELD(RETURN.AA.IDS<Y.CNT>,'*',4)

        Y.CNT += 1
    REPEAT

RETURN
*-----------------------------------------------------------------
GET.INTEREST.DET:
*-----------------------------------------------------------------
    OUT.PROP = ''
    PROP.NAME='PRINCIPAL'       ;* Interest Property to obtain
    APAP.TAM.redoGetInterestProperty(Y.AA.ID,PROP.NAME,OUT.PROP,ERR) ;*Manual R22 conversion
    Y.PRIN.PROP=OUT.PROP        ;* This variable hold the value of principal interest property

    Y.ARRG.ID = Y.AA.ID
    PROPERTY.CLASS = 'INTEREST'
    PROPERTY = Y.PRIN.PROP
    EFF.DATE = TODAY
    ERR.MSG = ''
    R.INT.ARR.COND = ''
    APAP.AA.redoCrrGetConditions(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.INT.ARR.COND,ERR.MSG) ;*Manual R22 conversion

    Y.EFFECTIVE.RATE = R.INT.ARR.COND<AA.INT.EFFECTIVE.RATE,1>

    IN.ACC.ID = ''
    IN.ARR.ID = Y.AA.ID
    APAP.TAM.redoConvertAccount(IN.ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT) ;*Manual R22 conversion
    Y.AA.AC.ID = OUT.ID

    CALL F.READ(FN.AA.ARRANGEMENT,Y.ARRG.ID,R.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ERR)
    Y.CUS.ID = R.ARRANGEMENT<AA.ARR.CUSTOMER>



RETURN

END
