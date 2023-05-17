SUBROUTINE REDO.ITEM.REQ.ORDER.STATUS(LN.ARRAY)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : TAM.E.NOF.LOAN.EXP.DATE
*--------------------------------------------------------------------------------------------------------
*Description  : This is nofile enquiry routine is used to retrieve the Expiration loan List from multiple files
*Linked With  : Enquiry REDO.E.NOF.LOAN.EXP.DATE
*In Parameter : N/A
*Out Parameter: LN.ARRAY
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------                -------------            -------------
*  15th SEPT 2010   JEEVA T              ODR-2010-03-0152        Initial Creation

*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.REDO.H.ORDER.DETAILS

    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------
    FN.REDO.H.ORDER.DETAILS='F.REDO.H.ORDER.DETAILS'
    F.REDO.H.ORDER.DETAILS = ''
    CALL OPF(FN.REDO.H.ORDER.DETAILS,F.REDO.H.ORDER.DETAILS)

    FN.EB = 'F.EB.LOOKUP'
    F.EB = ''
    CALL OPF(FN.EB,F.EB)

    FN.REDO.H.ORDER.DETAILS.HIS='F.REDO.H.ORDER.DETAILS$HIS'
    F.REDO.H.ORDER.DETAILS.HIS = ''
    CALL OPF(FN.REDO.H.ORDER.DETAILS.HIS,F.REDO.H.ORDER.DETAILS.HIS)


    LOCATE "ORDER.REF" IN D.FIELDS<1> SETTING Y.ORDER.REF.POS THEN
        Y.ORDER.REF.VAL = D.RANGE.AND.VALUE<Y.ORDER.REF.POS>
        CHANGE @SM TO ' ' IN Y.ORDER.REF.VAL
    END
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    GOSUB SELECT.CMD
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    LOOP
        REMOVE Y.ID FROM SEL.LIST SETTING POS
    WHILE Y.ID : POS
        CALL F.READ(FN.REDO.H.ORDER.DETAILS,Y.ID,R.REDO.H.ORDER.DETAILS,F.REDO.H.ORDER.DETAILS,Y.ERR)
        GOSUB HIS.PROCESS
        Y.ORDER.REF = Y.ORDER.REF.VAL
        GOSUB VALUES.REDO.H.ORDER.DETAILS
        GOSUB ASSIGN.VALUES

    REPEAT
RETURN
*-----------------------------------------------------------------------------
HIS.PROCESS:
*-----------------------------------------------------------------------------

    Y.CUR.NO = R.REDO.H.ORDER.DETAILS<RE.ORD.CURR.NO>
    Y.CNT = '1'
    Y.AUTH.HIS.LIST = ''
    Y.INPUT.HIS.LIST = ''
    Y.STATUS.HIS.LIST = ''
    Y.STATUS.HIS = ''
    Y.REG.QNTY = ''
    Y.RETURN.QNTY.HIS = ''
    Y.REASON.HIS = ''
    LOOP
    WHILE Y.CNT LT Y.CUR.NO
        Y.HIS.ID = Y.ID:';':Y.CNT
        CALL F.READ(FN.REDO.H.ORDER.DETAILS.HIS,Y.HIS.ID,R.REDO.H.ORDER.DETAILS.HIS,F.REDO.H.ORDER.DETAILS.HIS,Y.ERR.HIS.1)

        Y.STATUS.HIS = R.REDO.H.ORDER.DETAILS.HIS<RE.ORD.ORDER.STATUS>
        Y.INPUTTER = R.REDO.H.ORDER.DETAILS.HIS<RE.ORD.INPUTTER>
        Y.AUTH = R.REDO.H.ORDER.DETAILS.HIS<RE.ORD.AUTHORISER>
        Y.SERIES.FROM = R.REDO.H.ORDER.DETAILS.HIS<RE.ORD.SERIES.FROM>
        Y.SERIES.TO =   R.REDO.H.ORDER.DETAILS.HIS<RE.ORD.SERIES.TO>
        Y.RETURN.QNTY1 = R.REDO.H.ORDER.DETAILS.HIS<RE.ORD.RETURN.QUANTITY>
        Y.REASON.HIS<1,-1> = R.REDO.H.ORDER.DETAILS<RE.ORD.REASON.REJECT>

        IF Y.SERIES.FROM AND Y.SERIES.TO THEN
            Y.CNT.FR.VAL.CHK = DCOUNT(Y.SERIES.FROM,@VM)
            Y.CNT.F = 1
            LOOP
            WHILE Y.CNT.F LE Y.CNT.FR.VAL.CHK
                Y.SERIES.HIS.LIST1<1,-1> = Y.SERIES.FROM<1,Y.CNT.F>:"-":Y.SERIES.TO<1,Y.CNT.F>
                Y.CNT.F += 1
            REPEAT
            Y.SERIES.HIS.LIST<-1> = Y.SERIES.HIS.LIST1
            Y.SERIES.HIS.LIST1 = ''
        END ELSE
            Y.SERIES.HIS.LIST<-1> = '$'
        END
        Y.AUTH.HIS.LIST<-1> = FIELD(Y.AUTH,"_",2)
        Y.INPUT.HIS.LIST<-1> =FIELD(Y.INPUTTER,"_",2)
        Y.STATUS.HIS.LIST<-1> = Y.STATUS.HIS
        Y.RETURN.QNTY.HIS<-1> = Y.RETURN.QNTY1
        Y.CNT += 1
    REPEAT
*    CHANGE '*' TO '' IN Y.SERIES.HIS.LIST

RETURN
*-----------------------------------------------------------------------------
SELECT.CMD:
*-----------------------------------------------------------------------------

    SEL.CMD= "SELECT ":FN.REDO.H.ORDER.DETAILS:" WITH ORDER.REFERENCE EQ ":Y.ORDER.REF.VAL
RETURN
*-----------------------------------------------------------------------------
VALUES.REDO.H.ORDER.DETAILS:
*-----------------------------------------------------------------------------

    Y.NULL = '' ; Y.STATUS = '' ; Y.REASON = '' ; Y.SERIRES.FROM = '' ; Y.SERIRES.TO ='' ; Y.SER ='' ; Y.REG.QNTY = ''
    Y.QNTY = ''
    Y.COMPANY = R.REDO.H.ORDER.DETAILS<RE.ORD.REQUEST.COMPANY>
    Y.ITEM.CODE =    R.REDO.H.ORDER.DETAILS<RE.ORD.ITEM.CODE>
    Y.DES       =    R.REDO.H.ORDER.DETAILS<RE.ORD.DESCRIPTION>
    Y.REG.QNTY = R.REDO.H.ORDER.DETAILS<RE.ORD.REQUEST.QUANTITY>
    Y.ORDER.DELIVER =R.REDO.H.ORDER.DETAILS<RE.ORD.DELEVIRY.QUANTITY>
    Y.SER = ''

    Y.REQ.DATE = R.REDO.H.ORDER.DETAILS<RE.ORD.DATE>
    Y.DATE.SAP = R.REDO.H.ORDER.DETAILS<RE.ORD.DATE.SUBMIT.TO.SAP>
    Y.DELIV.DATE = R.REDO.H.ORDER.DETAILS<RE.ORD.DELEVIRY.DATE>
    Y.RECEIV.DATE = R.REDO.H.ORDER.DETAILS<RE.ORD.RECEIPT.DATE>
    Y.SERIRES.FROM = R.REDO.H.ORDER.DETAILS<RE.ORD.SERIES.FROM>
    Y.SERIRES.TO = R.REDO.H.ORDER.DETAILS<RE.ORD.SERIES.TO>

    IF Y.SERIRES.FROM AND Y.SERIRES.TO THEN
        Y.CNT.FR.VAL.CHK1 = DCOUNT(Y.SERIRES.FROM,@VM)
        Y.CNT.F1 = 1
        LOOP
        WHILE Y.CNT.F1 LE Y.CNT.FR.VAL.CHK1
            Y.SER<-1> = Y.SERIRES.FROM<1,Y.CNT.F1>:"-":Y.SERIRES.TO<1,Y.CNT.F1>
            Y.CNT.F1 += 1
        REPEAT
        CHANGE @FM TO '   ' IN Y.SER
    END
    Y.REASON = R.REDO.H.ORDER.DETAILS<RE.ORD.REASON.REJECT>
    IF NOT(Y.REASON) AND NOT(Y.REG.QNTY) THEN
        Y.REG.QNTY = R.REDO.H.ORDER.DETAILS<RE.ORD.CANCEL.QUANTITY>
        Y.REASON = R.REDO.H.ORDER.DETAILS<RE.ORD.CANCEL.REASON>
        Y.EB.ID = 'L.CANCEL.REASON*':Y.REASON
        Y.LAN = R.USER<EB.USE.LANGUAGE>
        IF Y.EB.ID THEN
            CALL F.READ(FN.EB,Y.EB.ID,R.EB,F.EB,Y.ER.RB)
            Y.REASON = R.EB<EB.LU.DESCRIPTION,Y.LAN>
        END
    END

    IF NOT(Y.REASON) AND NOT(Y.REG.QNTY) THEN
        Y.REG.QNTY = R.REDO.H.ORDER.DETAILS<RE.ORD.DESTROY.QUANTITY>
        Y.REASON = R.REDO.H.ORDER.DETAILS<RE.ORD.DESTROY.REASON>
    END

    IF NOT(Y.REG.QNTY) THEN
        Y.REG.QNTY = R.REDO.H.ORDER.DETAILS<RE.ORD.TRANSFER.QUANTITY>
    END

    IF R.REDO.H.ORDER.DETAILS<RE.ORD.RETURN.QUANTITY> THEN
        Y.REG.QNTY = R.REDO.H.ORDER.DETAILS<RE.ORD.RETURN.QUANTITY>
    END

    Y.ORDER.REFER = R.REDO.H.ORDER.DETAILS<RE.ORD.ORDER.REFERENCE>
    IF Y.REASON.HIS THEN
*Y.REASON<1,-1> = Y.REASON.HIS
    END
    IF Y.REQ.DATE THEN
        Y.QNTY<1,-1> = Y.REG.QNTY
        Y.DATE = Y.REQ.DATE
    END
    IF Y.DATE.SAP THEN
        Y.QNTY<1,-1> = Y.NULL
        Y.DATE<1,-1> = Y.DATE.SAP
    END
    IF Y.DATE.SAP AND Y.REASON THEN
        Y.REASON = '*'
    END
    IF Y.DELIV.DATE AND Y.REASON THEN
        Y.REASON<1,-1> = '*'
    END
    IF Y.DELIV.DATE THEN
        Y.QNTY<1,-1> = Y.ORDER.DELIVER
        Y.DATE<1,-1> = Y.DELIV.DATE
    END
    IF Y.RECEIV.DATE AND Y.REASON THEN
        Y.REASON<1,-1> = '*'
    END
    IF Y.RECEIV.DATE AND Y.SERIES.HIS.LIST THEN
        Y.QNTY<1,-1> = Y.REG.QNTY
        Y.DATE<1,-1> = Y.RECEIV.DATE
    END
    LOCATE '*' IN Y.REASON<1,1> SETTING POS.RES THEN
        Y.REASON<1,-1> = R.REDO.H.ORDER.DETAILS<RE.ORD.REASON.REJECT>
    END

    Y.INPUT.LIVE = R.REDO.H.ORDER.DETAILS<RE.ORD.INPUTTER>
    Y.AUTHO.LIVE = R.REDO.H.ORDER.DETAILS<RE.ORD.AUTHORISER>
    CHANGE @FM TO @VM IN Y.STATUS

    Y.STATUS.LIVE = R.REDO.H.ORDER.DETAILS<RE.ORD.ORDER.STATUS>
    IF Y.STATUS.HIS.LIST THEN
        Y.STATUS.LIST.VAL = Y.STATUS.HIS.LIST:@FM:Y.STATUS.LIVE
    END ELSE
        Y.STATUS.LIST.VAL = Y.STATUS.LIVE
    END
    IF Y.AUTH.HIS.LIST THEN
        Y.AUTHO.LIST = Y.AUTH.HIS.LIST:@FM:FIELD(Y.AUTHO.LIVE,"_",2)
    END ELSE
        Y.AUTHO.LIST = FIELD(Y.AUTHO.LIVE,"_",2)
    END
    IF Y.INPUT.HIS.LIST THEN
        Y.INPUT.LIST = Y.INPUT.HIS.LIST:@FM:FIELD(Y.INPUT.LIVE,"_",2)
    END ELSE
        Y.INPUT.LIST = FIELD(Y.INPUT.LIVE,"_",2)
    END

    CHANGE @VM TO '  ' IN Y.SERIES.HIS.LIST
*    CHANGE '*' TO VM IN Y.SERIES.HIS.LIST
    CHANGE '$' TO '' IN Y.SERIES.HIS.LIST
    IF Y.SERIES.HIS.LIST THEN
        Y.SERIES = Y.SERIES.HIS.LIST:@FM:Y.SER
    END ELSE
        Y.SERIES = Y.SER
    END

    CHANGE @FM TO @VM IN Y.STATUS.LIST.VAL
    CHANGE @FM TO @VM IN Y.INPUT.LIST
    CHANGE @FM TO @VM IN Y.AUTHO.LIST
    CHANGE @FM TO @VM IN Y.SERIES
    CHANGE '*' TO '' IN Y.REASON

RETURN
*-----------------------------------------------------------------------------
ASSIGN.VALUES:
*-----------------------------------------------------------------------------

    IF Y.SERIES EQ '-' THEN
        Y.SERIES = ''
    END
    GOSUB CHECK.STATUS.REASON

    IF Y.INPUTTER EQ '' THEN
        Y.INPUTTER.2 = Y.INPUT.LIVE
    END ELSE
        Y.INPUTTER.2 = Y.INPUTTER
    END
*                         1            2           3          4              5          6        7              8                     9            10                11             12            13
    LN.ARRAY<-1> = Y.ORDER.REFER:"*":Y.COMPANY:"*":" ":"*":Y.ITEM.CODE:"*":Y.DES:"*":Y.QNTY:"*":Y.DATE:"*":Y.STATUS.LIST.VAL:"*":Y.SERIES:"*":Y.INPUT.LIST:"*":Y.AUTHO.LIST:"*":Y.REASON:"*":Y.INPUTTER.2
    GOSUB NULLIFY
RETURN
*-----------------------------------------------------------------------------
CHECK.STATUS.REASON:
*-----------------------------------------------------------------------------

    Y.CNT.STA = DCOUNT(Y.STATUS.LIST.VAL,@VM)
    Y.CNT.STA1= DCOUNT(Y.REASON,@VM)

    LOOP
    WHILE Y.CNT.STA1 GT Y.CNT.STA
        Y.CNT.STA2 = Y.CNT.STA1 - 1
        Y.REASON<1,Y.CNT.STA2> = Y.REASON<1,Y.CNT.STA1>
        Y.REASON<1,Y.CNT.STA1> = ''
        Y.CNT.STA1 -= 1
    REPEAT
RETURN
*-----------------------------------------------------------------------------
NULLIFY:
*-----------------------------------------------------------------------------
    Y.ORDER.REFER =  '' ;
    Y.COMPANY= '' ;
    Y.ITEM.CODE = '' ;
    Y.DES= '' ;
    Y.QNTY = '' ;
    Y.DATE = '' ;
    Y.STATUS= '' ;
    Y.SERIES = '';

RETURN
END
