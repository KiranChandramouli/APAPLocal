* @ValidationCode : MjoxNzM4NzM4MjIwOkNwMTI1MjoxNjg0ODM2MDUxMzg1OklUU1M6LTE6LTE6MzQwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 340
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.NOFILE.MG.ACCT.NO.DROP(Y.ENQ.OUT)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.APAP.NOFILE.MG.ACCT.NO
* ODR NO      : ODR-2009-10-0346
*----------------------------------------------------------------------
*DESCRIPTION: REDO.APAP.NOFILE.MG.ACCT.NO.DROP is a no-file enquiry routine used
* to fetch and ACCOUT NUMBER and ACCOUNT NAME
*IN PARAMETER: NA
*OUT PARAMETER: Y.ENQ.OUT
*LINKED WITH: REDO.APAP.ENQ.MG.ACCT.NO

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*18.08.2011    RIYAS         ODR-2009-10-0346  INITIAL CREATION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*18-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , VM to @VM ,++ to +=
*18-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.APAP.CPH.PARAMETER
    $INSERT I_F.REDO.APAP.MORTGAGES.DETAIL

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
    Y.ENQ.OUT=''

RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
    FN.REDO.APAP.CPH.PARAMETER='F.REDO.APAP.CPH.PARAMETER'

    FN.REDO.APAP.MORTGAGES.DETAIL='F.REDO.APAP.MORTGAGES.DETAIL'
    F.REDO.APAP.MORTGAGES.DETAIL=''
    CALL OPF(FN.REDO.APAP.MORTGAGES.DETAIL,F.REDO.APAP.MORTGAGES.DETAIL)

    FN.ACCOUNT ='F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
    GOSUB GET.DATES.TENOR
    GOSUB GET.NO.OF.RENEW
    GOSUB GET.SEL.REC


RETURN
*----------------------------------------------------------------------
GET.DATES.TENOR:
*----------------------------------------------------------------------


    LOCATE 'TENOR.DATE' IN D.FIELDS SETTING POS1 THEN
        Y.TENOR.DATES =D.RANGE.AND.VALUE<POS1>
    END

    Y.VAL.DATE=FIELD(Y.TENOR.DATES,'-',1)
    Y.MAT.DATE=FIELD(Y.TENOR.DATES,'-',2)

    IF Y.VAL.DATE EQ '' OR Y.MAT.DATE EQ '' THEN
        ENQ.ERROR='EB-REDO.DATE.MISSING'
        CALL STORE.END.ERROR
        GOSUB END1
    END

RETURN
*----------------------------------------------------------------------
GET.NO.OF.RENEW:
*----------------------------------------------------------------------
    Y.PARA.ID='SYSTEM'
    CALL CACHE.READ(FN.REDO.APAP.CPH.PARAMETER,Y.PARA.ID,R.REDO.APAP.CPH.PARAMETER,PARA.ERR)
    Y.NO.OF.RENEW= R.REDO.APAP.CPH.PARAMETER<CPH.PARAM.NO.OF.RENEWALS>
    Y.ALLOWED.STATUS=R.REDO.APAP.CPH.PARAMETER<CPH.PARAM.ALLOWED.STATUS>
    CHANGE @VM TO @FM IN Y.ALLOWED.STATUS
RETURN

*----------------------------------------------------------------------
GET.SEL.REC:
*----------------------------------------------------------------------
    GOSUB GET.CHECK.DATE
    SEL.CMD='SELECT ':FN.REDO.APAP.MORTGAGES.DETAIL:' WITH MATURITY.DATE GE ':Y.CHK.DATE
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    IF NOT(SEL.NOR) THEN
        RETURN
    END

    VAR1=1
    LOOP
    WHILE VAR1 LE SEL.NOR
        Y.STATUS.NOT.FOUND=''
        CALL F.READ(FN.REDO.APAP.MORTGAGES.DETAIL,SEL.LIST<VAR1>,R.REDO.APAP.MORTGAGES.DETAIL,F.REDO.APAP.MORTGAGES.DETAIL,MRTG.ERR)
        Y.LOAN.STATUS = R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.STATUS>
        Y.LOAN.STATUS.CNT=DCOUNT(Y.LOAN.STATUS,@VM)
        VAR2=1
        LOOP
        WHILE VAR2 LE Y.LOAN.STATUS.CNT
            Y.LN.STATUS=Y.LOAN.STATUS<1,VAR2>
*            LOCATE Y.LN.STATUS IN Y.ALLOWED.STATUS SETTING POS2 ELSE
*************PACS00038165 starts *****************
            LOCATE Y.LN.STATUS IN Y.ALLOWED.STATUS SETTING POS2 THEN
************ PACS00038165 Ends ********************
                Y.STATUS.NOT.FOUND=1
            END
            VAR2 += 1 ;*R22 AUTO CODE CONVERSION
        REPEAT
        IF Y.STATUS.NOT.FOUND EQ 1 THEN
            VAR1 += 1
            CONTINUE
        END ELSE
            Y.OUT.PRINC= R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.OUTS.PRINCIPLE>
            Y.BAL.AVAIL =R.REDO.APAP.MORTGAGES.DETAIL<MG.DET.BAL.PRINCIPAL>
            CALL F.READ(FN.ACCOUNT,SEL.LIST<VAR1>,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR)
            Y.ACCOUNT.NAME = R.ACCOUNT<AC.ACCOUNT.TITLE.1>
            Y.ENQ.OUT<-1>=SEL.LIST<VAR1>:"*":Y.ACCOUNT.NAME
        END

        VAR1 += 1
    REPEAT



RETURN

*----------------------------------------------------------------------
GET.CHECK.DATE:
*----------------------------------------------------------------------
    Y.REGION=''
    Y.DIFF.DAYS='C'
    CALL CDD(Y.REGION,Y.VAL.DATE,Y.MAT.DATE,Y.DIFF.DAYS)
    Y.ADD.DAYS=Y.NO.OF.RENEW*Y.DIFF.DAYS
    Y.ADD.DAYS:='C'
    CALL CDT(Y.REGION,Y.VAL.DATE,Y.ADD.DAYS)
    Y.CHK.DATE=Y.VAL.DATE
RETURN
*----------------------------------------------------------------------
END1:
*----------------------------------------------------------------------

END
