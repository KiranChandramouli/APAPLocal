* @ValidationCode : MjotMTIxNDAxODg1MjpVVEYtODoxNjg3Nzc0NzE3NDg2OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Jun 2023 15:48:37
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.CLEAR.RETURN(R.APERTA)
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.B.CLEAR.RETURN
*-------------------------------------------------------------------------
* Description: This routine is a load routine used to load the variables
*
*----------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE        Author                 ODR                             DESCRIPTION
* 21-09-10                          ODR-2010-09-0251                Initial Creation
* 26-06-2023    Narmadha V           Manual R22 conversion            FM to @FM, Command insert file, Call routine format modified
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.DATES
    $INSERT I_F.REDO.OUTWARD.RETURN
    $INSERT I_F.REDO.APAP.CLEAR.PARAM
    $INSERT I_F.REDO.MAPPING.TABLE
    $INSERT I_REDO.B.CLEAR.RETURN.COMMON
    $INSERT I_F.REDO.H.ROUTING.HEADER
* $INSERT I_F.T24.FUND.SERVICES ; Manual R22 conversion
    $USING APAP.TAM
    $USING APAP.REDOAPAP


    CALL F.READ(FN.REDO.MAPPING.TABLE,'OUT.RETURN',R.REDO.MAPPING.TABLE,F.REDO.MAPPING.TABLE,MAP.ERR)
    LOCATE 'TASK' IN R.REDO.MAPPING.TABLE<MAP.TAB.FIELD.NAME,1> SETTING TASK.POS THEN
        TASK.STRT.POS = R.REDO.MAPPING.TABLE<MAP.TAB.START.POS,TASK.POS>
        TASK.LEN.POS = R.REDO.MAPPING.TABLE<MAP.TAB.LENGTH,TASK.POS>
    END
    LOCATE 'DATE' IN R.REDO.MAPPING.TABLE<MAP.TAB.FIELD.NAME,1> SETTING DATE.POS THEN
        DATE.STRT.POS = R.REDO.MAPPING.TABLE<MAP.TAB.START.POS,DATE.POS>
        DATE.LEN.POS = R.REDO.MAPPING.TABLE<MAP.TAB.LENGTH,DATE.POS>
    END
    LOCATE 'BATCH' IN R.REDO.MAPPING.TABLE<MAP.TAB.FIELD.NAME,1> SETTING BATCH.POS THEN
        BATCH.STRT.POS = R.REDO.MAPPING.TABLE<MAP.TAB.START.POS,BATCH.POS>
        BATCH.LEN.POS = R.REDO.MAPPING.TABLE<MAP.TAB.LENGTH,BATCH.POS>
    END
    LOCATE 'DIN' IN R.REDO.MAPPING.TABLE<MAP.TAB.FIELD.NAME,1> SETTING DIN.POS THEN
        DIN.STRT.POS = R.REDO.MAPPING.TABLE<MAP.TAB.START.POS,DIN.POS>
        DIN.LEN.POS = R.REDO.MAPPING.TABLE<MAP.TAB.LENGTH,DIN.POS>
    END
    LOCATE 'ACCOUNT' IN R.REDO.MAPPING.TABLE<MAP.TAB.FIELD.NAME,1> SETTING ACCOUNT.POS THEN
        ACCOUNT.STRT.POS = R.REDO.MAPPING.TABLE<MAP.TAB.START.POS,ACCOUNT.POS>
        ACCOUNT.LEN.POS = R.REDO.MAPPING.TABLE<MAP.TAB.LENGTH,ACCOUNT.POS>
    END
    LOCATE 'SERIAL' IN R.REDO.MAPPING.TABLE<MAP.TAB.FIELD.NAME,1> SETTING SERIES.POS THEN
        SERIES.STRT.POS = R.REDO.MAPPING.TABLE<MAP.TAB.START.POS,SERIES.POS>
        SERIES.LEN.POS = R.REDO.MAPPING.TABLE<MAP.TAB.LENGTH,SERIES.POS>
    END
    LOCATE 'ROUTE' IN R.REDO.MAPPING.TABLE<MAP.TAB.FIELD.NAME,1> SETTING ROUTE.POS THEN
        ROUTE.STRT.POS = R.REDO.MAPPING.TABLE<MAP.TAB.START.POS,ROUTE.POS>
        ROUTE.LEN.POS = R.REDO.MAPPING.TABLE<MAP.TAB.LENGTH,ROUTE.POS>
    END
    LOCATE 'AMOUNT' IN R.REDO.MAPPING.TABLE<MAP.TAB.FIELD.NAME,1> SETTING AMOUNT.POS THEN
        AMOUNT.STRT.POS = R.REDO.MAPPING.TABLE<MAP.TAB.START.POS,AMOUNT.POS>
        AMOUNT.LEN.POS = R.REDO.MAPPING.TABLE<MAP.TAB.LENGTH,AMOUNT.POS>
    END
    LOCATE 'CATEGORY' IN R.REDO.MAPPING.TABLE<MAP.TAB.FIELD.NAME,1> SETTING CATEGORY.POS THEN
        CATEGORY.STRT.POS = R.REDO.MAPPING.TABLE<MAP.TAB.START.POS,CATEGORY.POS>
        CATEGORY.LEN.POS = R.REDO.MAPPING.TABLE<MAP.TAB.LENGTH,CATEGORY.POS>
    END
    LOCATE 'CREDIT.AMOUNT' IN R.REDO.MAPPING.TABLE<MAP.TAB.FIELD.NAME,1> SETTING CREDIT.AMOUNT.POS THEN
        CREDIT.AMOUNT.STRT.POS = R.REDO.MAPPING.TABLE<MAP.TAB.START.POS,CREDIT.AMOUNT.POS>
        CREDIT.AMOUNT.LEN.POS = R.REDO.MAPPING.TABLE<MAP.TAB.LENGTH,CREDIT.AMOUNT.POS>
    END
    LOCATE 'DEBIT.AMOUNT' IN R.REDO.MAPPING.TABLE<MAP.TAB.FIELD.NAME,1> SETTING DEBIT.AMOUNT.POS THEN
        DEBIT.AMOUNT.STRT.POS = R.REDO.MAPPING.TABLE<MAP.TAB.START.POS,DEBIT.AMOUNT.POS>
        DEBIT.AMOUNT.LEN.POS  = R.REDO.MAPPING.TABLE<MAP.TAB.LENGTH,DEBIT.AMOUNT.POS>
    END
    LOCATE 'DRAWER.ACCOUNT' IN R.REDO.MAPPING.TABLE<MAP.TAB.FIELD.NAME,1> SETTING DRAW.ACCT.POS THEN
        DRAW.ACCT.STRT.POS = R.REDO.MAPPING.TABLE<MAP.TAB.START.POS,DRAW.ACCT.POS>
        DRAW.ACCT.LEN.POS = R.REDO.MAPPING.TABLE<MAP.TAB.LENGTH,DRAW.ACCT.POS>
    END
    LOCATE 'CHECK.DIGIT' IN R.REDO.MAPPING.TABLE<MAP.TAB.FIELD.NAME,1> SETTING CHECK.DIGIT.POS THEN
        CHECK.DIGIT.STRT.POS = R.REDO.MAPPING.TABLE<MAP.TAB.START.POS,CHECK.DIGIT.POS>
        CHECK.DIGIT.LEN.POS = R.REDO.MAPPING.TABLE<MAP.TAB.LENGTH,CHECK.DIGIT.POS>
    END
    LOCATE 'IMAGE.NAME' IN R.REDO.MAPPING.TABLE<MAP.TAB.FIELD.NAME,1> SETTING IMAGE.NAME.POS THEN
        IMAGE.NAME.STRT.POS = R.REDO.MAPPING.TABLE<MAP.TAB.START.POS,IMAGE.NAME.POS>
        IMAGE.NAME.LEN.POS = R.REDO.MAPPING.TABLE<MAP.TAB.LENGTH,IMAGE.NAME.POS>
    END

    CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,'SYSTEM',R.REDO.APAP.CLEAR.PARAM,PARAM.ERR)
    VAR.COUNT = 1

    TEMP.COUNT = DCOUNT(R.APERTA,@FM)
    LOOP
        REMOVE TEMP.DATA FROM R.APERTA SETTING POS
    WHILE VAR.COUNT LE TEMP.COUNT
        GOSUB GET.DETAILS
        VAR.COUNT++
    REPEAT
RETURN


GET.DETAILS:
*Fetching the datas from the file record

    ROUTE.VAL = TEMP.DATA[ROUTE.STRT.POS,ROUTE.LEN.POS]
    TASK.VAL = TEMP.DATA[TASK.STRT.POS,TASK.LEN.POS]

    TRANS.DATE.VAL = TEMP.DATA[DATE.STRT.POS,DATE.LEN.POS]
    VAL.DATE = TRANS.DATE.VAL[1,2]
    VAL.MONTH = TRANS.DATE.VAL[3,2]
    VAL.YEAR = TRANS.DATE.VAL[5,4]
    TRANS.DATE.VAL = VAL.YEAR:VAL.MONTH:VAL.DATE

    DRAW.ACCT.VAL = TEMP.DATA[DRAW.ACCT.STRT.POS,DRAW.ACCT.LEN.POS]
    DRAW.ACCT.VAL =   TRIM(DRAW.ACCT.VAL,0,"L")

*    DRAW.ACCT.VAL = 'T24FS':DRAW.ACCT.VAL
*    CALL F.READ(FN.TFS,DRAW.ACCT.VAL,R.TFS,F.TFS,TFS.ERR)
*    DRAW.ACCT = R.TFS<TFS.PRIMARY.ACCOUNT>

    LOTE.VAL = TEMP.DATA[BATCH.STRT.POS,BATCH.LEN.POS]
    DIN.VAL = TEMP.DATA[DIN.STRT.POS,DIN.LEN.POS]

    ACCOUNT.VAL = TEMP.DATA[ACCOUNT.STRT.POS,ACCOUNT.LEN.POS]
    ACCOUNT.VAL = ACCOUNT.VAL + 1
    ACCOUNT.VAL = ACCOUNT.VAL - 1

    CALL F.READ(FN.ACCOUNT,ACCOUNT.VAL,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    IF R.ACCOUNT THEN
        ACCT.OFF.VAL = R.ACCOUNT<AC.ACCOUNT.OFFICER>
        CUSTOMER.VAL = R.ACCOUNT<AC.CUSTOMER>
    END
    VAR.CURRENCY = R.ACCOUNT<AC.CURRENCY>

    IMAGE.VAL = TEMP.DATA[IMAGE.NAME.STRT.POS,IMAGE.NAME.LEN.POS]

    VAL.CHEQUE.NO = TEMP.DATA[SERIES.STRT.POS,SERIES.LEN.POS]
    VAL.CHEQUE.NO = VAL.CHEQUE.NO + 1
    VAL.CHEQUE.NO = VAL.CHEQUE.NO - 1
    AMOUNT.VAL = TEMP.DATA[AMOUNT.STRT.POS,AMOUNT.LEN.POS-2]:'.':TEMP.DATA[AMOUNT.STRT.POS+AMOUNT.LEN.POS-2,2]
    AMOUNT.VAL = AMOUNT.VAL + 1
    AMOUNT.VAL = AMOUNT.VAL - 1

    CATEGORY.VAL = TEMP.DATA[CATEGORY.STRT.POS,CATEGORY.LEN.POS]
    CATEGORY.VAL = TRIM(CATEGORY.VAL,0,"L")

    CREDIT.VAL = TEMP.DATA[CREDIT.AMOUNT.STRT.POS,CREDIT.AMOUNT.LEN.POS]
    CREDIT.VAL = TRIM(CREDIT.VAL,0,"L")
    APAP.TAM.redoGetRejectReason(CREDIT.VAL,Y.REDO.REJECT.REASON);*Manual R22 Conversion
*CREDIT.VAL = CREDIT.VAL + 1
*CREDIT.VAL = CREDIT.VAL - 1

    DEBIT.VAL = TEMP.DATA[DEBIT.AMOUNT.STRT.POS,DEBIT.AMOUNT.LEN.POS]
*IF ROUTE.VAL EQ '999907000' THEN
    LOCATE CATEGORY.VAL IN R.REDO.H.ROUTING.HEADER<REDO.HEAD.INW.CAT.VAL,1> SETTING POS1 THEN
        Y.CATEG.TYPE = R.REDO.H.ROUTING.HEADER<REDO.HEAD.INW.DOC.TYPE,POS1>
        IF  Y.CATEG.TYPE EQ 'HEADER' THEN
            REDO.OUTWARD.RETURN.ID = 'HEADER':'-':ROUTE.VAL
        END ELSE
            REDO.OUTWARD.RETURN.ID = DRAW.ACCT.VAL:'-':VAL.CHEQUE.NO
        END
    END
    CHECK.DIGIT = TEMP.DATA[CHECK.DIGIT.STRT.POS,CHECK.DIGIT.LEN.POS]

    CALL F.READ(FN.REDO.OUTWARD.RETURN,REDO.OUTWARD.RETURN.ID,R.REDO.OUTWARD.RETURN,F.REDO.OUTWARD.RETURN,REDO.CLEAR.ERR)
    VAR.TODAY = TODAY

    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.CLEARING> = TASK.VAL
    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.DATE> = TRANS.DATE.VAL
    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.BATCH> = LOTE.VAL
    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.DIN> = DIN.VAL
*IF ROUTE.VAL EQ '999907000' THEN
    IF Y.CATEG.TYPE EQ 'HEADER' THEN
        R.REDO.OUTWARD.RETURN<CLEAR.RETURN.CHEQUE.NO> = ''
        R.REDO.OUTWARD.RETURN<CLEAR.RETURN.ACCOUNT> = ''
    END

    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.ACCOUNT> = ACCOUNT.VAL
    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.CHEQUE.NO> = VAL.CHEQUE.NO
    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.ROUTE.NO> = ROUTE.VAL
    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.AMOUNT> = AMOUNT.VAL
    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.CURRENCY> = VAR.CURRENCY
    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.CATEGORY> = CATEGORY.VAL
    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.REJECT.REASON> = Y.REDO.REJECT.REASON
    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.DEBIT.QUANTITY> = DEBIT.VAL
    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.CHECK.DIGIT> = CHECK.DIGIT
    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.HANDOVER.STATUS> = 'N'
    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.NARRATIVE> = "Cheque return exist"
    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.DRAWER.ACCT> = DRAW.ACCT.VAL
    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.IMAGE.ID> = IMAGE.VAL
    TEMPTIME = OCONV(TIME(),"MTS")
    TEMPTIME = TEMPTIME[1,5]
    CONVERT ':' TO '' IN TEMPTIME
    CHECK.DATE = DATE()
    DATE.TIME = OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),"R%2"):FMT(OCONV(CHECK.DATE,"DD"),"R%2"):TEMPTIME
    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.DATE.TIME>= DATE.TIME
    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.AUTHORISER> = TNO:'_':OPERATOR
    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.INPUTTER> = TNO:'_':OPERATOR
    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.CURR.NO> = 1
    Y.RET.CO.CODE = ''
    APAP.TAM.redoGetAccCoCode(ACCOUNT.VAL,Y.RET.CO.CODE) ;*Manual R22 Conversion
    IF Y.RET.CO.CODE ELSE
        Y.RET.CO.CODE = ID.COMPANY
    END
    R.REDO.OUTWARD.RETURN<CLEAR.RETURN.CO.CODE>=Y.RET.CO.CODE

    CALL F.WRITE(FN.REDO.OUTWARD.RETURN,REDO.OUTWARD.RETURN.ID,R.REDO.OUTWARD.RETURN)
    IF Y.CATEG.TYPE EQ 'CHEQUE' THEN
        IF VAR.CURRENCY ELSE
            VAR.CURRENCY = LCCY     ;* Incase of Payment Cheques
        END
        APAP.TAM.redoUpdateOutwardReturnChq(ACCOUNT.VAL,REDO.OUTWARD.RETURN.ID) ;* Manual R22 Conversion
        APAP.REDOAPAP.redoApapAchMirrorRetAcctEnt(AMOUNT.VAL,VAR.CURRENCY,REDO.OUTWARD.RETURN.ID) ;* Manual R22 Conversion
    END
RETURN
END
