SUBROUTINE REDO.NOF.GARNISH.SEIZURE(Y.ENQ.OUT)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.NOF.GARNISH.SEIZURE
*--------------------------------------------------------------------------------------------------------
*Description       :
*
*Linked With       : Enquiry
*In  Parameter     :
*Out Parameter     : Y.ENQ.OUT
*Files  Used       : APAP.H.GARNISH.DETAILS                    As              I               Mode
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
*     02.11.2010           Mudassir V          ODR-2010-03-0144           Initial Creation
*     18.08.2011           Prabhu N            PACS00103352               fix for  PACS00103352-EB.LOOKUP added
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.GARNISH.DETAILS
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CATEGORY
    $INSERT I_BATCH.FILES
    $INSERT I_F.LOCKING
    $INSERT I_F.TSA.SERVICE
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB INIT
    GOSUB OPENFILE

    GOSUB PROCESS
    IF ENQ.ERROR THEN
        ENQ.ERROR = ' '
        RETURN
    END
    GOSUB PROCESS1
RETURN
*-------------------------------------------------------------------------------------------------------
*****
INIT:
*****
    Y.POS = ''  ;  R.APAP.H.GARNISH.H.DETAILS ='' ; L.AC.STATUS2   ='' ;  SEL.LIST = '' ; Y.ACT     = '' ;  Y.DATE    = ''
    Y.TYPE.ID = ''   ; Y.ID.NUM  = '' ; Y.GAR.CUST = '' ; Y.GAR.AMT  = '' ; Y.LEGAL.ACT.NUM = ''  Y.LEGAL.ACT.DATE = ''
    Y.GAR.TYPE = '' ;  Y.REASON.GAR = '' ; Y.CRED.NAME  = '' ; Y.EXEC.GAR.TYPE = '' ; Y.EXEC.GAR.NUM  = '' ; Y.GAR.REF = ''
    Y.CUST.NUM  = '' ;  Y.BLOCK.AMT = '' ; Y.BLOCK.ACCT = '' ; Y.BACCT.CATEG = '' ;  Y.PAY.AMT = '' ; Y.PAYEE = '' ; Y.BENF  = ''
    Y.COMMENTS = ''  ;  Y.PRO.DATE.TIME = '' ; Y.INPUT = '' ;  Y.AUT   = '' ;  Y.AC.HIS.IDS = '' ; Y.SEL.CLIENT = ''

RETURN

*********
OPENFILE:
**********

    FN.ACCOUNT  = 'F.ACCOUNT'
    F.ACCOUNT   = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AC.LOCKED.EVENTS  = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS   = ''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

    FN.AC.LOCKED.EVENTS.HIS  = 'F.AC.LOCKED.EVENTS$HIS'
    F.AC.LOCKED.EVENTS.HIS = ''
    CALL OPF(FN.AC.LOCKED.EVENTS.HIS,F.AC.LOCKED.EVENTS.HIS)

    FN.APAP.H.GARNISH.DETAILS = 'F.APAP.H.GARNISH.DETAILS'
    F.APAP.H.GARNISH.DETAILS  =''
    CALL OPF(FN.APAP.H.GARNISH.DETAILS,F.APAP.H.GARNISH.DETAILS)

    FN.CATEGORY  = 'F.CATEGORY'
    F.CATEGORY   = ''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

RETURN
*-------------------------------------------------------------------------------------------------------
********
PROCESS:
********

    LOCATE "RECEPTION.DATE" IN D.FIELDS<1> SETTING Y.POS THEN
        Y.SEL.DATE = D.RANGE.AND.VALUE<Y.POS>
    END

    LOCATE "ACT.TYPE" IN D.FIELDS<1> SETTING Y.POS THEN
        Y.SEL.ACT.TYPE  = D.RANGE.AND.VALUE<Y.POS>
    END

    LOCATE "CLIENT.NUMBER" IN D.FIELDS<1> SETTING Y.POS THEN
        Y.SEL.CLIENT = D.RANGE.AND.VALUE<Y.POS>
    END

    LOCATE "SEIZURE.ID" IN D.FIELDS<1> SETTING Y.POS THEN
        Y.SEL.SEIZURE = D.RANGE.AND.VALUE<Y.POS>
    END

    LOCATE "ACCOUNT.INVESTMENT" IN D.FIELDS<1> SETTING Y.POS THEN
        Y.SEL.ACCT = D.RANGE.AND.VALUE<Y.POS>
    END

    SEL.CMD.MAIN = "SELECT ":FN.APAP.H.GARNISH.DETAILS:" WITH @ID"

    IF Y.SEL.DATE NE '' THEN
        Y.SEL.DATE1 = Y.SEL.DATE[3,6]
        Y.SEL.DATE1 = Y.SEL.DATE1:"0000"
        CHANGE @SM TO ' ' IN Y.SEL.DATE
        Y.SEL.DATE2 = FIELD(Y.SEL.DATE," ",2)
        Y.SEL.DATE2 = Y.SEL.DATE2[3,6]
        Y.SEL.DATE2 = Y.SEL.DATE2:"2359"
        SEL.CMD.MAIN:=" AND DATE.TIME GE ":Y.SEL.DATE1:" AND DATE.TIME LE ":Y.SEL.DATE2
    END
    IF Y.SEL.ACT.TYPE NE '' THEN
        GOSUB ACT.TYPE.SEL
    END
    ELSE
        Y.SEL.ACT.TYPE = 'ALL'
        GOSUB ACT.TYPE.SEL
    END
RETURN
*---------------------------------------------------------------------------------------------
ACT.TYPE.SEL:
**************
    CHANGE @SM TO ' ' IN Y.SEL.ACT.TYPE

    BEGIN CASE

        CASE Y.SEL.ACT.TYPE EQ 'SEIZURE'

            SEL.CMD.ACT.AC = "SELECT ":FN.ACCOUNT: " WITH L.AC.STATUS2 EQ GARNISHMENT"
            CALL EB.READLIST(SEL.CMD.ACT.AC,SEL.LIST.ACCT,NOR,'',ERR)
            CHANGE @FM TO ' ' IN SEL.LIST.ACCT

            SEL.CMD.ACT.LOK ="SELECT ":FN.AC.LOCKED.EVENTS:" WITH ACCOUNT.NUMBER EQ ":SEL.LIST.ACCT:" AND L.AC.LOCKE.TYPE EQ GARNISHMENT OR L.AC.STATUS2 EQ GARNISHMENT"
            CALL EB.READLIST(SEL.CMD.ACT.LOK,SEL.LIST.LOCK,NOR,'',ERR)

            LOOP
                REMOVE Y.LIST.LOCK FROM SEL.LIST.LOCK SETTING POS
            WHILE Y.LIST.LOCK:POS
                GOSUB FIND.MULTI.LOCAL.REF
                CALL F.READ(FN.AC.LOCKED.EVENTS,Y.LIST.LOCK,R.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS,LOCK.ERR)
                Y.GAR.REF.NO = R.AC.LOCKED.EVENTS<AC.LCK.LOCAL.REF,LOC.L.AC.GAR.REF.NO>
                LOCATE Y.GAR.REF.NO IN Y.AC.LOCK.IDS SETTING LOCK.POS ELSE
                    Y.AC.LOCK.IDS<-1> = Y.GAR.REF.NO
                END

            REPEAT

            CHANGE @FM TO ' ' IN Y.AC.LOCK.IDS
*PACS00103352-S
            SEL.CMD.MAIN :=" EQ ":Y.AC.LOCK.IDS:" AND WITH LOCKED.DEL.TYPE NE 'GARNISHMENT.DELETION'"
*PACS00103352-E
        CASE Y.SEL.ACT.TYPE EQ 'RELEASE OF SEIZURE'
*PACS00103352-S
            SEL.CMD.MAIN:=" AND WITH LOCKED.DEL.TYPE EQ 'GARNISHMENT.DELETION'"
*PACS00103352-E
        CASE Y.SEL.ACT.TYPE = 'ALL'

            SEL.CMD.ACT.AC = "SELECT ":FN.ACCOUNT:" WITH L.AC.STATUS2 EQ GARNISHMENT "
            CALL EB.READLIST(SEL.CMD.ACT.AC,SEL.LIST.ACCT,NOR,'',ERR)
            CHANGE @FM TO ' ' IN SEL.LIST.ACCT

            SEL.CMD.ACT.LOK = "SELECT ":FN.AC.LOCKED.EVENTS:" WITH ACCOUNT.NUMBER EQ ":SEL.LIST.ACCT:" AND L.AC.LOCKE.TYPE EQ GARNISHMENT OR L.AC.STATUS2 EQ GARNISHMENT"
            CALL EB.READLIST(SEL.CMD.ACT.LOK,SEL.LIST.LOCK,NOR,'',ERR)

            LOOP
                REMOVE Y.LIST.LOCK FROM SEL.LIST.LOCK SETTING POS
            WHILE Y.LIST.LOCK:POS
                GOSUB FIND.MULTI.LOCAL.REF
                CALL F.READ(FN.AC.LOCKED.EVENTS,Y.LIST.LOCK,R.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS,LOCK.ERR)
                Y.GAR.REF.NO = R.AC.LOCKED.EVENTS<AC.LCK.LOCAL.REF,LOC.L.AC.GAR.REF.NO>
                LOCATE Y.GAR.REF.NO IN Y.AC.LOCK.IDS SETTING LOCK.POS ELSE
                    Y.AC.LOCK.IDS<-1> = Y.GAR.REF.NO
                END
            REPEAT


            SEL.CMD.ACT.AC = "SELECT ":FN.ACCOUNT:" WITH L.AC.STATUS2 EQ GARNISHMENT "
            CALL EB.READLIST(SEL.CMD.ACT.AC,SEL.LIST.ACCT,NOR,'',ERR)
            CHANGE @FM TO ' ' IN SEL.LIST.ACCT

            SEL.CMD.HIS.LOK = "SELECT ":FN.AC.LOCKED.EVENTS.HIS:" WITH ACCOUNT.NUMBER EQ ":SEL.LIST.ACCT:" AND RECORD.STATUS EQ REVE AND L.AC.LOCKE.TYPE EQ GARNISHMENT OR L.AC.STATUS2 EQ GARNISHMENT"
            CALL EB.READLIST(SEL.CMD.HIS.LOK,SEL.HIS.LOCK,NOR,'',ERR)

            LOOP
                REMOVE Y.HIS.LOCK FROM SEL.HIS.LOCK SETTING POS
            WHILE Y.HIS.LOCK:POS
                GOSUB FIND.MULTI.LOCAL.REF
                CALL F.READ(FN.AC.LOCKED.EVENTS.HIS,Y.HIS.LOCK,R.AC.LOCKED.EVENTS.HIS.SEL,F.AC.LOCKED.EVENTS.HIS,ACC.HIS.ERR)
                Y.GAR.HIS.NO = R.AC.LOCKED.EVENTS.HIS.SEL<AC.LCK.LOCAL.REF,LOC.L.AC.GAR.REF.NO>
                LOCATE Y.GAR.HIS.NO IN Y.AC.HIS.IDS SETTING LOCK.POS ELSE
                    Y.AC.HIS.IDS<-1> = Y.GAR.HIS.NO
                END
            REPEAT

            LOOP
                REMOVE Y.AC.HIS.ID FROM Y.AC.HIS.IDS SETTING POS
            WHILE Y.AC.HIS.ID:POS
                LOCATE Y.AC.HIS.ID IN Y.AC.LOCK.IDS SETTING HIS.POS ELSE
                    Y.AC.LOCK.IDS<-1> = Y.AC.HIS.ID
                END
            REPEAT

            Y.AC.LOCKED.ID = Y.AC.LOCK.IDS

            CHANGE @FM TO ' ' IN Y.AC.LOCKED.ID

            SEL.CMD.MAIN :=" EQ ":Y.AC.LOCKED.ID

        CASE 1
            ENQ.ERROR = 1

    END CASE

RETURN
*----------------------------------------------------------------------------------------------
PROCESS1:
*------------

    IF Y.SEL.CLIENT NE '' THEN
        SEL.CMD.MAIN:=" AND CUSTOMER EQ ":Y.SEL.CLIENT
    END

    IF Y.SEL.SEIZURE NE '' THEN
        SEL.CMD.MAIN:=" AND @ID EQ ":Y.SEL.SEIZURE
    END
    SEL.CMD.MAIN := " BY DATE.TIME"

    CALL EB.READLIST(SEL.CMD.MAIN,SEL.LIST.MAIN,NOR.MAIN,'',ERR.MAIN)

    IF Y.SEL.ACCT NE '' THEN
        CHANGE @FM TO ' ' IN SEL.LIST.MAIN
        SEL.LCK.AC = "SELECT ":FN.AC.LOCKED.EVENTS:" WITH L.AC.GAR.REF.NO MATCHES ":SEL.LIST.MAIN:" AND ACCOUNT.NUMBER EQ ":Y.SEL.ACCT
        CALL EB.READLIST(SEL.LCK.AC,SEL.LIST.LOCK,'',NOR.LOCK.SEL,ERR.MAIN)
        Y.NOR.LOCK = 1
        LOOP
        WHILE Y.NOR.LOCK LE NOR.LOCK.SEL
            Y.SEL.ID = SEL.LIST.LOCK<Y.NOR.LOCK>
            CALL F.READ(FN.AC.LOCKED.EVENTS,Y.SEL.ID,R.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS,ACC.ERR)
            Y.GAR.REF.NO = R.AC.LOCKED.EVENTS<AC.LCK.LOCAL.REF,LOC.L.AC.GAR.REF.NO>
            LOCATE Y.GAR.REF.NO IN SEL.LIST.ACL SETTING LOCK.POS ELSE
                SEL.LIST.ACL<-1> = Y.GAR.REF.NO
            END
            Y.NOR.LOCK += 1
        REPEAT
        SEL.LIST.MAIN :=" EQ ":SEL.LIST.ACL
    END

    CALL EB.READLIST(SEL.CMD.MAIN,SEL.LIST.MAIN,NOR.MAIN,'',ERR.MAIN)

    LOOP
        REMOVE SEL.ID FROM SEL.LIST.MAIN SETTING SEL.POS
    WHILE SEL.ID:SEL.POS

        GOSUB GARNISH.DETAILS


        Y.ENQ.OUT<-1> = Y.DATE :'*': Y.ACT :'*': Y.TYPE.ID :'*': Y.ID.NUM :'*': Y.GAR.CUST :'*': Y.GAR.AMT :'*': Y.LEGAL.ACT.NUM :'*': Y.LEGAL.ACT.DATE :'*': Y.GAR.TYPE :'*': Y.REASON.GAR :'*': Y.CRED.NAME :'*': Y.EXEC.GAR.TYPE :'*': Y.EXEC.GAR.NUM :'*': Y.GAR.REF :'*': Y.CUST.NUM :'*': Y.BLOCK.AMT :'*': Y.BACCT.CATEG  :'*': Y.BLOCK.ACT :'*': Y.REV.AMOUNT:'*': Y.UNBLOCK.ACCT :'*': Y.REV.ACCT :'*': Y.PAY.AMT :'*': Y.PAYEE :'*': Y.PAYMENT.CONCEPT :'*': Y.COMMENTS :'*': Y.PRO.DATE.TIME :'*': Y.INPUT :'*': Y.AUTH
*                          1             2            3               4             5                 6                  7                      8                  9                 10                11                  12                    13                14                15                16               17                  18                 19               20                 21                22             23             24                      25                26                  27            28
        GOSUB NULLIFY.VALUES

    REPEAT
RETURN
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'AC.LOCKED.EVENTS'
    FLD.ARRAY  = 'L.AC.GAR.REF.NO'
    FLD.POS    = ''

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    LOC.L.AC.GAR.REF.NO    = FLD.POS<1,1>

RETURN
*
NULLIFY.VALUES:

    Y.DATE = ''
    Y.ACT = ''
    Y.TYPE.ID = ''
    Y.ID.NUM = ''
    Y.GAR.CUST = ''
    Y.GAR.AMT = ''
    Y.LEGAL.ACT.NUM = ''
    Y.LEGAL.ACT.DATE = ''
    Y.GAR.TYPE = ''
    Y.REASON.GAR = ''
    Y.CRED.NAME = ''
    Y.EXEC.GAR.TYPE = ''
    Y.EXEC.GAR.NUM = ''
    Y.GAR.REF = ''
    Y.CUST.NUM = ''
    Y.BLOCK.AMT = ''
    Y.BACCT.CATEG = ''
    Y.BLOCK.ACT = ''
    Y.REV.AMOUNT = ''
    Y.UNBLOCK.ACCT = ''
    Y.REV.ACCT = ''
    Y.PAY.AMT = ''
    Y.PAYEE = ''
    Y.PAYMENT.CONCEPT = ''
    Y.COMMENTS = ''
    Y.PRO.DATE.TIME = ''
    Y.INPUT = ''
    Y.AUTH = ''
RETURN
********************
GARNISH.DETAILS:
*********************
    CALL F.READ(FN.APAP.H.GARNISH.DETAILS,SEL.ID,R.APAP.H.GARNISH.DETAILS,F.APAP.H.GARNISH.DETAILS,GARNISH.DETAILS.ERR)
    Y.DATE          = R.APAP.H.GARNISH.DETAILS<APAP.GAR.DATE.TIME>
    IF Y.SEL.ACT.TYPE EQ 'ALL' THEN
        Y.LOCKED.DEL.TYPE = R.APAP.H.GARNISH.DETAILS<APAP.GAR.LOCKED.DEL.TYPE>
        IF Y.LOCKED.DEL.TYPE EQ 'Garnishment deletion' THEN
            Y.ACT = 'RELEASE OF SEIZURE'
        END
        ELSE
            Y.ACT = 'SEIZURE'
        END
    END
    ELSE
        Y.ACT           = Y.SEL.ACT.TYPE
    END
    Y.TYPE.ID       = R.APAP.H.GARNISH.DETAILS<APAP.GAR.IDENTITY.TYPE>
    Y.ID.NUM        = R.APAP.H.GARNISH.DETAILS<APAP.GAR.ID.NUMBER>
    Y.GAR.CUST      = R.APAP.H.GARNISH.DETAILS<APAP.GAR.INDIVIDUAL.NAME>
    Y.GAR.AMT       = R.APAP.H.GARNISH.DETAILS<APAP.GAR.GARNISHMENT.AMT>
    Y.LEGAL.ACT.NUM = R.APAP.H.GARNISH.DETAILS<APAP.GAR.NO.OF.LEGAL.ACT>
    Y.LEGAL.ACT.DATE= R.APAP.H.GARNISH.DETAILS<APAP.GAR.DATE.OF.LEGAL.ACT>
    Y.GAR.TYPE = R.APAP.H.GARNISH.DETAILS<APAP.GAR.GARNISHMENT.TYPE>
    Y.REASON.GAR = R.APAP.H.GARNISH.DETAILS<APAP.GAR.GARNISH.REASON>
    Y.CRED.NAME  = R.APAP.H.GARNISH.DETAILS<APAP.GAR.NAME.CREDITOR>
    Y.EXEC.GAR.TYPE = R.APAP.H.GARNISH.DETAILS<APAP.GAR.ID.TYPE>
    Y.EXEC.GAR.NUM  = R.APAP.H.GARNISH.DETAILS<APAP.GAR.ID.NUMBER>
    Y.GAR.REF  =  SEL.ID
    Y.CUST.NUM = R.APAP.H.GARNISH.DETAILS<APAP.GAR.CUSTOMER>
    Y.REV.AMOUNT = R.APAP.H.GARNISH.DETAILS<APAP.GAR.GARNISH.AMT.DEL>
    Y.UNBLOCK.ACCT = R.APAP.H.GARNISH.DETAILS<APAP.GAR.LOCKED.DEL.TYPE>
    IF Y.ACT EQ 'SEIZURE' THEN
        SEL.BLOCK.AMT =" SELECT ":FN.AC.LOCKED.EVENTS:" WITH L.AC.GAR.REF.NO EQ ":Y.GAR.REF:" AND L.AC.STATUS2 EQ GARNISHMENT "
        CALL EB.READLIST(SEL.BLOCK.AMT,SEL.LIST," ",NO.OF.RECS,REC.ERR)
        LOOP
            REMOVE Y.SEL.ID FROM SEL.LIST SETTING POS
        WHILE Y.SEL.ID:POS
            GOSUB GET.LOCKED.ACCT.DETS
        REPEAT
    END
    IF Y.ACT EQ 'RELEASE OF SEIZURE' THEN
        SEL.BLOCK.AMT =" SELECT ":FN.AC.LOCKED.EVENTS.HIS:" WITH L.AC.GAR.REF.NO EQ ":Y.GAR.REF:" AND L.AC.STATUS2 EQ GARNISHMENT AND RECORD.STATUS EQ REVE "
        CALL EB.READLIST(SEL.BLOCK.AMT,SEL.LIST," ",NO.OF.RECS,REC.ERR)
        LOOP
            REMOVE Y.SEL.ID FROM SEL.LIST SETTING POS
        WHILE Y.SEL.ID:POS
            GOSUB GET.LOCKED.ACCT.DETS.HIS
        REPEAT

    END
    Y.PAY.AMT = R.APAP.H.GARNISH.DETAILS<APAP.GAR.PAYMENT.AMT>
    Y.PAYEE   = R.APAP.H.GARNISH.DETAILS<APAP.GAR.BENEFICIARY>
    Y.PAYMENT.CONCEPT   = R.APAP.H.GARNISH.DETAILS<APAP.GAR.PAYMENT.DESC>
    Y.COMMENTS    = R.APAP.H.GARNISH.DETAILS<APAP.GAR.COMMENTS>
    Y.PRO.DATE.TIME=R.APAP.H.GARNISH.DETAILS<APAP.GAR.DATE.TIME>
    Y.INPUT  = R.APAP.H.GARNISH.DETAILS<APAP.GAR.INPUTTER>
    Y.AUTH    = R.APAP.H.GARNISH.DETAILS<APAP.GAR.AUTHORISER>
RETURN
**********************
GET.LOCKED.ACCT.DETS:
**********************
    CALL F.READ(FN.AC.LOCKED.EVENTS,Y.SEL.ID,R.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS,ACC.ERR)
    IF Y.BLOCK.AMT THEN
        Y.BLOCK.AMT := @VM:R.AC.LOCKED.EVENTS<AC.LCK.LOCKED.AMOUNT>
    END ELSE
        Y.BLOCK.AMT = R.AC.LOCKED.EVENTS<AC.LCK.LOCKED.AMOUNT>
    END
    IF Y.BLOCK.ACT THEN
        Y.BLOCK.ACT := @VM:R.AC.LOCKED.EVENTS<AC.LCK.ACCOUNT.NUMBER>
    END ELSE
        Y.BLOCK.ACT = R.AC.LOCKED.EVENTS<AC.LCK.ACCOUNT.NUMBER>
    END
    IF Y.UNBLOCK.ACCT EQ 'Garnishment deletion' THEN
        IF Y.REV.ACCT THEN
            Y.REV.ACCT := @VM:R.AC.LOCKED.EVENTS<AC.LCK.ACCOUNT.NUMBER>
        END ELSE
            Y.REV.ACCT = R.AC.LOCKED.EVENTS<AC.LCK.ACCOUNT.NUMBER>
        END
    END ELSE
        Y.REV.ACCT = ''
    END
    CALL F.READ(FN.ACCOUNT,R.AC.LOCKED.EVENTS<AC.LCK.ACCOUNT.NUMBER>,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    CATEGORY.VAL = R.ACCOUNT<AC.CATEGORY>
    CALL CACHE.READ(FN.CATEGORY, CATEGORY.VAL, R.CATEGORY, CATEGORY.ERR)
    IF Y.BACCT.CATEG THEN
        Y.BACCT.CATEG := @VM:R.CATEGORY<EB.CAT.DESCRIPTION>
    END ELSE
        Y.BACCT.CATEG = R.CATEGORY<EB.CAT.DESCRIPTION>
    END
RETURN
*-----------------------------
GET.LOCKED.ACCT.DETS.HIS:
*-----------------------------

    CALL F.READ(FN.AC.LOCKED.EVENTS.HIS,Y.SEL.ID,R.AC.LOCKED.EVENTS.HIS,F.AC.LOCKED.EVENTS.HIS,ACC.HIS.ERR)
    IF Y.BLOCK.AMT THEN
        Y.BLOCK.AMT := @VM:R.AC.LOCKED.EVENTS.HIS<AC.LCK.LOCKED.AMOUNT>
    END ELSE
        Y.BLOCK.AMT = R.AC.LOCKED.EVENTS.HIS<AC.LCK.LOCKED.AMOUNT>
    END
    IF Y.BLOCK.ACT THEN
        Y.BLOCK.ACT := @VM:R.AC.LOCKED.EVENTS.HIS<AC.LCK.ACCOUNT.NUMBER>
    END ELSE
        Y.BLOCK.ACT = R.AC.LOCKED.EVENTS.HIS<AC.LCK.ACCOUNT.NUMBER>
    END
    IF Y.UNBLOCK.ACCT EQ 'Garnishment deletion' THEN
        IF Y.REV.ACCT THEN
            Y.REV.ACCT := @VM:R.AC.LOCKED.EVENTS.HIS<AC.LCK.ACCOUNT.NUMBER>
        END ELSE
            Y.REV.ACCT = R.AC.LOCKED.EVENTS.HIS<AC.LCK.ACCOUNT.NUMBER>
        END
    END ELSE
        Y.REV.ACCT = ''
    END
    CALL F.READ(FN.ACCOUNT,R.AC.LOCKED.EVENTS.HIS<AC.LCK.ACCOUNT.NUMBER>,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    CATEGORY.VAL = R.ACCOUNT<AC.CATEGORY>
    CALL CACHE.READ(FN.CATEGORY, CATEGORY.VAL, R.CATEGORY, CATEGORY.ERR)
    IF Y.BACCT.CATEG THEN
        Y.BACCT.CATEG := @VM:R.CATEGORY<EB.CAT.DESCRIPTION>
    END ELSE
        Y.BACCT.CATEG = R.CATEGORY<EB.CAT.DESCRIPTION>
    END
RETURN
*--------------------------------------------------------------------------------------------------------
END
