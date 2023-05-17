SUBROUTINE REDO.NOFILE.GARNISHMENT.REPORT(Y.FINAL.ARRAY)
*------------------------------------------------------------
* Description: This is a Nofile enquiry routine to Garnishment report
*------------------------------------------------------------
* Input  Arg : N/A
* Output Arg : Y.FINAL.ARRAY
* Deals With : Enquiry - REDO.NOFILE.GARNISHMENT.REPORT
*------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CATEGORY
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.APAP.H.GARNISH.DETAILS

    GOSUB OPENFILES
    GOSUB SELECTION.CMD
    GOSUB PROCESS

    Y.FINAL.ARRAY = CHANGE(Y.FINAL.ARRAY, @VM, '|')
    Y.FINAL.ARRAY = CHANGE(Y.FINAL.ARRAY, @SM, '~')

    Y.FINAL.ARRAY = SORT(Y.FINAL.ARRAY)

    Y.FINAL.ARRAY = FIELDS(Y.FINAL.ARRAY, '*', 2, 99 )
    Y.FINAL.ARRAY = CHANGE(Y.FINAL.ARRAY, '~', @SM)
    Y.FINAL.ARRAY = CHANGE(Y.FINAL.ARRAY, '|', @VM)

*    D.RANGE.AND.VALUE = VALUE.BK
*    D.LOGICAL.OPERANDS = OPERAND.BK
*    D.FIELDS     = FIELDS.BK

RETURN
*--------------------------------------
OPENFILES:
*--------------------------------------

    FN.APAP.H.GARNISH.DETAILS = 'F.APAP.H.GARNISH.DETAILS'
    F.APAP.H.GARNISH.DETAILS = ''
    CALL OPF(FN.APAP.H.GARNISH.DETAILS,F.APAP.H.GARNISH.DETAILS)

    FN.APAP.H.GARNISH.DETAILS.HIS = 'F.APAP.H.GARNISH.DETAILS$HIS'
    F.APAP.H.GARNISH.DETAILS.HIS = ''
    CALL OPF(FN.APAP.H.GARNISH.DETAILS.HIS, F.APAP.H.GARNISH.DETAILS.HIS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)


    FN.CATEGORY = "F.CATEGORY"
    F.CATEGORY = ""
    CALL OPF(FN.CATEGORY,F.CATEGORY)
    R.CATEGORY = ""
    CAT.ERR = ""


RETURN
*--------------------------------------
SELECTION.CMD:
*--------------------------------------

*    VALUE.BK   = D.RANGE.AND.VALUE
*    OPERAND.BK = D.LOGICAL.OPERANDS
*    FIELDS.BK  = D.FIELDS

    Y.FINAL.ARRAY      = ''
*    D.RANGE.AND.VALUE  = ''
*    D.LOGICAL.OPERANDS = ''
*    D.FIELDS           = ''
*    Y.SEL.DATE.TIME    = ''
*    Y.SEL.CATEGORY     = ''

*   LOCATE 'CATEGORY' IN FIELDS.BK SETTING FLD.POS1 THEN
*       Y.SEL.CATEGORY      = VALUE.BK<FLD.POS1>
*   END

*    FIELDS.ARRAY = 'LOCKED.DEL.TYPE':FM:'CUSTOMER':FM:'ID.NUMBER':FM:'RECEP.DATE'

*    FIELDS.CNT = DCOUNT(FIELDS.ARRAY,FM)
*    Y.VAR1 = 1
*    LOOP
*    WHILE Y.VAR1 LE FIELDS.CNT
*        Y.FIELD = FIELDS.ARRAY<Y.VAR1>
*        LOCATE Y.FIELD IN FIELDS.BK SETTING FLD.POS THEN
*            D.RANGE.AND.VALUE<-1>  =  VALUE.BK<FLD.POS>
*            D.LOGICAL.OPERANDS<-1> =  OPERAND.BK<FLD.POS>
*            D.FIELDS<-1>           =  FIELDS.BK<FLD.POS>
*        END
*        Y.VAR1++
*    REPEAT
*
*    CALL REDO.E.FORM.SEL.STMT(FN.APAP.H.GARNISH.DETAILS, '', '', SEL.CMD)


    SEL.CMD = 'SELECT  ':FN.APAP.H.GARNISH.DETAILS

    LOCATE 'RECEP.DATE' IN D.FIELDS<1> SETTING Y.RECEP.DATE.POS THEN
        Y.RECEP.DATE = D.RANGE.AND.VALUE<Y.RECEP.DATE.POS>
        Y.START.DATE = FIELD(Y.RECEP.DATE, @SM, 1)
        Y.END.DATE = FIELD(Y.RECEP.DATE, @SM, 2)
    END

    LOCATE 'CUSTOMER' IN D.FIELDS SETTING Y.CUSTOMER.POS THEN
        Y.CUSTOMER = D.RANGE.AND.VALUE<Y.CUSTOMER.POS>
        SEL.CMD := ' WITH CUSTOMER EQ ':Y.CUSTOMER
    END

    LOCATE 'CATEGORY' IN D.FIELDS SETTING Y.CATEGORY.POS THEN
        Y.CATEGORY = D.RANGE.AND.VALUE<Y.CATEGORY.POS>
    END

    LOCATE 'ID.NUMBER' IN D.FIELDS<1> SETTING Y.ID.NUMBER.POS THEN
        Y.ID.NUMBER = D.RANGE.AND.VALUE<Y.ID.NUMBER.POS>
        SEL.CMD := ' WITH  IDENTITY.NUMBER EQ ':Y.ID.NUMBER
    END

    LOCATE 'LOCKED.DEL.TYPE' IN D.FIELDS<1> SETTING Y.LOCKED.DEL.TYPE.POS THEN
        Y.LOCKED.DEL.TYPE = D.RANGE.AND.VALUE<Y.LOCKED.DEL.TYPE.POS>
        SEL.CMD := ' WITH LOCKED.DEL.TYPE EQ ':Y.LOCKED.DEL.TYPE
    END


    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
RETURN
*--------------------------------------
PROCESS:
*--------------------------------------

    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE NO.OF.REC
        Y.GARNISH.ID = SEL.LIST<Y.VAR1>
        Y.CATEGORY.SELECT = 'NO'
        CALL F.READ(FN.APAP.H.GARNISH.DETAILS,Y.GARNISH.ID,R.APAP.H.GARNISH.DETAILS,F.APAP.H.GARNISH.DETAILS,GAR.ERR)
        Y.BLOCKED.ACC = R.APAP.H.GARNISH.DETAILS<APAP.GAR.ACCOUNT.NO>

        GOSUB CHECK.CATEGORY
        IF Y.CATEGORY ELSE
            Y.CATEGORY.SELECT = 'YES'
        END

        IF Y.CATEGORY.SELECT EQ 'YES' THEN
            GOSUB GET.DETAILS
            IF Y.FORM.FLAG EQ 'N' ELSE
                GOSUB FORM.ARRAY
            END
        END
        Y.VAR1 += 1
    REPEAT

RETURN
*--------------------------------------
CHECK.CATEGORY:
*--------------------------------------


    Y.BLOCKED.CATEGORY = ''
    Y.ACC.CNT = DCOUNT(Y.BLOCKED.ACC,@VM)
    Y.VAR2 = 1
    LOOP
    WHILE Y.VAR2 LE Y.ACC.CNT
        Y.ACC.ID = Y.BLOCKED.ACC<1,Y.VAR2>
        CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        Y.CAT = R.ACCOUNT<AC.CATEGORY>
        CALL CACHE.READ(FN.CATEGORY, Y.CAT, R.CATEGORY, CAT.ERR)
        Y.DESC = R.CATEGORY<EB.CAT.DESCRIPTION><1,1>
        Y.BLOCKED.CATEGORY<1,-1> = Y.DESC
        IF Y.CATEGORY AND (R.ACCOUNT<AC.CATEGORY> EQ Y.CATEGORY) THEN
            Y.CATEGORY.SELECT = 'YES'
        END
        Y.VAR2 += 1
    REPEAT

RETURN
*--------------------------------------
GET.DETAILS:
*--------------------------------------

    GOSUB RECORD.CREATE.DATE

    IF Y.FORM.FLAG EQ 'N' THEN
        RETURN
    END

    Y.LOCKED.DEL.TYPE    = R.APAP.H.GARNISH.DETAILS<APAP.GAR.LOCKED.DEL.TYPE>
* Y.LOCKED.DEL.TYPE    = R.APAP.H.GARNISH.DETAILS<APAP.GAR.GARNISHM.TYPE>
    Y.TYPE.OF.IDENTITY   = R.APAP.H.GARNISH.DETAILS<APAP.GAR.IDENTITY.TYPE>
    Y.IDENTITY.NUMBER    = R.APAP.H.GARNISH.DETAILS<APAP.GAR.IDENTITY.NUMBER>
    Y.NAME.INDV          = R.APAP.H.GARNISH.DETAILS<APAP.GAR.INDIVIDUAL.NAME>
    Y.GARNISHMENT.AMT    = R.APAP.H.GARNISH.DETAILS<APAP.GAR.GARNISHMENT.AMT>
    Y.LEGAL.ACT.NO       = R.APAP.H.GARNISH.DETAILS<APAP.GAR.NO.OF.LEGAL.ACT>
    Y.LEGAL.ACT.DATE     = R.APAP.H.GARNISH.DETAILS<APAP.GAR.DATE.LEGAL.ACT>
    Y.GARNISH.TYPE       = R.APAP.H.GARNISH.DETAILS<APAP.GAR.GARNISHM.TYPE>
    Y.GARNISH.REASON     = R.APAP.H.GARNISH.DETAILS<APAP.GAR.GARNISH.REASON>
    Y.NAME.CREDITOR      = R.APAP.H.GARNISH.DETAILS<APAP.GAR.NAME.CREDITOR>
    Y.ID.TYPE            = R.APAP.H.GARNISH.DETAILS<APAP.GAR.ID.TYPE>
    Y.ID.NUMBER          = R.APAP.H.GARNISH.DETAILS<APAP.GAR.ID.NUMBER>
    Y.CUSTOMER           = R.APAP.H.GARNISH.DETAILS<APAP.GAR.CUSTOMER>
    Y.LCK.AMT            = R.APAP.H.GARNISH.DETAILS<APAP.GAR.UNLOCKED.AMT>

*PACS00312704 - S

*CHANGE SM TO VM IN Y.LCK.AMT
*CHANGE FM TO VM IN Y.LCK.AMT

    Y.BLOCKED.AMT        = R.APAP.H.GARNISH.DETAILS<APAP.GAR.GARNISH.AMT>

*Y.UNBLOCKED.AMT      = SUM(Y.LCK.AMT)

*Y.UNBLOCKED.AMT = Y.LCK.AMT

    GOSUB GET.UNBLOCKED.AMOUNT

*PACS00312704 - E


    GOSUB GET.UNBLOCKED.ACCOUNT
* Y.PAYMENT.AMOUNT     = R.APAP.H.GARNISH.DETAILS<APAP.GAR.PAYMENT.AMT>
    Y.PAYMENT.AMOUNT     = R.APAP.H.GARNISH.DETAILS<APAP.GAR.GARNISH.AMT.DEL>
    Y.PAYEE              = R.APAP.H.GARNISH.DETAILS<APAP.GAR.BENEFICIARY>
    Y.PAYMENT.DESC       = R.APAP.H.GARNISH.DETAILS<APAP.GAR.PAYMENT.DESC>
    Y.COMMENTS           = R.APAP.H.GARNISH.DETAILS<APAP.GAR.COMMENTS>
    Y.DATE.ELIM = R.APAP.H.GARNISH.DETAILS<APAP.GAR.DATE.TIME>
    Y.DATE.ELIM = '20':Y.DATE.ELIM[1,6]

    Y.INPUTTER   = ''
    Y.AUTHORISER = ''
*    IF Y.DATE.ELIM THEN
    Y.INPUTTER           = R.APAP.H.GARNISH.DETAILS<APAP.GAR.INPUTTER>
    Y.AUTHORISER         = R.APAP.H.GARNISH.DETAILS<APAP.GAR.AUTHORISER>
*    END

RETURN
*------------------------------------------
GET.UNBLOCKED.ACCOUNT:
*------------------------------------------
    Y.UNBLOCKED.ACC = ''
    Y.UNBLOCKED.CATEGORY = ''
    Y.BLOCK.ACC.CNT = DCOUNT(Y.BLOCKED.ACC,@VM)
    Y.VAR3 = 1
    LOOP
    WHILE Y.VAR3 LE Y.BLOCK.ACC.CNT

        Y.ACC.NO = Y.BLOCKED.ACC<1,Y.VAR3>
        IF SUM(R.APAP.H.GARNISH.DETAILS<APAP.GAR.REL.AMT,Y.VAR3>) GT 0 THEN
*Y.UNBLOCKED.CATEGORY<1,-1> = Y.BLOCKED.CATEGORY<1,Y.VAR3>
            Y.UNBLOCKED.ACC<1,-1>      = Y.ACC.NO

            CALL F.READ(FN.ACCOUNT,Y.ACC.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
            Y.UCAT = R.ACCOUNT<AC.CATEGORY>
            CALL CACHE.READ(FN.CATEGORY, Y.UCAT, R.CATEGORY, CAT.ERR)
            Y.UDESC = R.CATEGORY<EB.CAT.DESCRIPTION><1,1>
            Y.UNBLOCKED.CATEGORY<1,-1> = Y.UDESC

        END
        Y.VAR3 += 1
    REPEAT

RETURN
*------------------------------------------
FORM.ARRAY:
*------------------------------------------
*                 1               2                   3                       4                    5                6                     7                    8                   9                  10               11             12              13              14               15                16                   17                  18               19                       20                  21                 22                   23                24             25             26             27            28
    Y.FINAL.ARRAY<-1> = Y.CUSTOMER:'*':Y.DATE:'*':Y.LOCKED.DEL.TYPE:'*':Y.TYPE.OF.IDENTITY:'*':Y.IDENTITY.NUMBER:'*':Y.NAME.INDV:'*':Y.GARNISHMENT.AMT:'*':Y.LEGAL.ACT.NO:'*':Y.LEGAL.ACT.DATE:'*':Y.GARNISH.TYPE:'*':Y.GARNISH.REASON:'*':Y.NAME.CREDITOR:'*':Y.ID.TYPE:'*':Y.ID.NUMBER:'*':Y.GARNISH.ID:'*':Y.CUSTOMER:'*':Y.BLOCKED.AMT:'*':Y.BLOCKED.CATEGORY:'*':Y.BLOCKED.ACC:'*':Y.UNBLOCKED.AMT:'*':Y.UNBLOCKED.CATEGORY:'*':Y.UNBLOCKED.ACC:'*':Y.PAYMENT.AMOUNT:'*':Y.PAYEE:'*':Y.PAYMENT.DESC:'*':Y.COMMENTS:'*':Y.DATE.ELIM:'*':Y.INPUTTER:'*':Y.AUTHORISER
    Y.UNBLOCKED.AMT  = ""


RETURN
*------------------------------------------
RECORD.CREATE.DATE:
*------------------

    Y.CURR.NO = R.APAP.H.GARNISH.DETAILS<APAP.GAR.CURR.NO>

    IF Y.CURR.NO EQ 1 THEN
        Y.DATE.TIME = R.APAP.H.GARNISH.DETAILS<APAP.GAR.DATE.TIME>
        Y.DATE.TIME = Y.DATE.TIME[1,6]
        Y.DATE = ICONV(Y.DATE.TIME, 'D')

        CALL DIETER.DATE(Y.CREATE.DATE, Y.DATE, '')

        Y.DATE = OCONV(Y.DATE, 'D')
    END ELSE
        Y.HIST.GAR.ID = Y.GARNISH.ID:';1'
        Y.HIST.RECORD = ''
        CALL F.READ(FN.APAP.H.GARNISH.DETAILS.HIS, Y.HIST.GAR.ID, R.HIST.GAR.REC, F.APAP.H.GARNISH.DETAILS.HIS, Y.READ.ERR)
        Y.DATE.TIME = R.HIST.GAR.REC<APAP.GAR.DATE.TIME>
        Y.DATE.TIME = Y.DATE.TIME[1,6]
        Y.DATE = ICONV(Y.DATE.TIME, 'D')

        CALL DIETER.DATE(Y.CREATE.DATE, Y.DATE, '')

        Y.DATE = OCONV(Y.DATE, 'D')
    END

    Y.FORM.FLAG = 'N'
    IF Y.RECEP.DATE THEN
        IF (Y.CREATE.DATE GE Y.START.DATE) AND (Y.CREATE.DATE LE Y.END.DATE) THEN
            Y.FORM.FLAG = 'Y'
        END
    END ELSE
        Y.FORM.FLAG = 'Y'
    END

RETURN
*------------------------------------------
GET.UNBLOCKED.AMOUNT:
*--------------------
*PACS00312704 - S - EGA
*Y.AVAIL.BAL = R.APAP.H.GARNISH.DETAILS<APAP.GAR.AVAIL.BAL>


    Y.UNBLOCKED.AMT = ""
    Y.REL.AMOUNT = R.APAP.H.GARNISH.DETAILS<APAP.GAR.REL.AMT>
    ST.CNT = "1"
    DCNT = DCOUNT(Y.BLOCKED.ACC,@VM)
    LOOP
    WHILE ST.CNT LE DCNT
        Y.ACC = Y.BLOCKED.ACC<1,ST.CNT>
        LOCATE Y.ACC IN Y.BLOCKED.ACC<1,1> SETTING Y.ACC.POS THEN
            Y.RELEASE.AMT = Y.REL.AMOUNT<1,Y.ACC.POS>
            IF (Y.RELEASE.AMT AND Y.RELEASE.AMT GT "0") THEN
                Y.SUM.REL.AMT = SUM(Y.RELEASE.AMT)
                Y.UNBLOCKED.AMT<-1> = Y.SUM.REL.AMT
            END
        END
        ST.CNT += 1
    REPEAT

    IF Y.UNBLOCKED.AMT NE "" THEN
        CHANGE @FM TO @VM IN Y.UNBLOCKED.AMT
    END

RETURN

*PACS00312704 - E - EGA
*------------------------------------------------------------------------------------------------------------------------------
END
