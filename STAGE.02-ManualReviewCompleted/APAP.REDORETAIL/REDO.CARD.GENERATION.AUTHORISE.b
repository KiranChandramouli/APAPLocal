* @ValidationCode : MjotMTI0MjQ3OTQ4NTpDcDEyNTI6MTY4MTgyODAwNDI1NjpJVFNTOi0xOi0xOjUzNzA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 19:56:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 5370
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.CARD.GENERATION.AUTHORISE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.GENERATION.AUTH
*--------------------------------------------------------------------------------------------------------
*Description  : This is a authorisation routine to
*Linked With  : REDO.CARD.GENERATION
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                      Reference               Description
*   ------         ------                    -------------            -------------
* 03 Aug 2010    Mohammed Anies K           ODR-2010-03-0400         Initial Creation
* 1 Feb 2011     Kavitha                    ODR-2010-03-0400         HD1101688  Fix
* 8-Apr-2011     Kavitha                    ODR-2010-03-0400         PACS00036007  fix
* 13-MAY-2011    KAVITHA                    ODR-2010-08-0467         PACS00055017  FIX
*10 JUN 2011     KAVITHA                    ODR-2010-08-0467         PACS00063138 FIX
*21 FEB 2012     PRABHU                     PACS00177874             PACS00177874 Changes made to calculate magnetic strip name
*11-04-2023      CONVERSION TOOL            AUTO R22 CODE CONVERSION   VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*11-04-2023      jayasurya H                MANUAL R22 CODE CONVERSION CALL RTN METHOD ADDED

*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.CARD.TYPE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT JBC.h
    $INSERT I_TSS.COMMON
    $INSERT I_F.REDO.CARD.GENERATION
    $INSERT I_F.REDO.CARD.REQUEST
    $INSERT I_F.REDO.CARD.NUMBERS
    $INSERT I_F.REDO.CARD.NO.LOCK
    $INSERT I_F.REDO.CARD.RENEWAL
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT I_F.REDO.CARD.BIN
    $INSERT I_REDO.CARD.GEN.COMMON
    $INSERT I_F.REDO.CARD.REG.STOCK
    $INSERT I_F.LATAM.CARD.ORDER
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    IF V$FUNCTION NE "R" OR R.NEW(REDO.CARD.GEN.RECORD.STATUS) NE 'RNAU' THEN
        GOSUB OPEN.PARA
        GOSUB PROCESS.PARA
    END

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of code file variables are initialised and opened

    FN.REDO.CARD.REG.STK = 'F.REDO.CARD.REG.STOCK'
    F.REDO.CARD.REG.STK = ''
    CALL OPF(FN.REDO.CARD.REG.STK,F.REDO.CARD.REG.STK)

    FN.CARD.RENEWAL = 'F.REDO.CARD.RENEWAL'
    F.CARD.RENEWAL = ''
    CALL OPF(FN.CARD.RENEWAL,F.CARD.RENEWAL)

    FN.REDO.CARD.NO.LOCK = 'F.REDO.CARD.NO.LOCK'
    F.REDO.CARD.NO.LOCK = ''
    CALL OPF(FN.REDO.CARD.NO.LOCK,F.REDO.CARD.NO.LOCK)

    FN.CARD.REQUEST = 'F.REDO.CARD.REQUEST'
    F.CARD.REQUEST = ''
    CALL OPF(FN.CARD.REQUEST,F.CARD.REQUEST)

    FN.REDO.CARD.NUMBERS = 'F.REDO.CARD.NUMBERS'
    F.REDO.CARD.NUMBERS = ''
    CALL OPF(FN.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS)

    FN.COMPANY='F.COMPANY'
    F.COMPANY=''
    CALL OPF(FN.COMPANY,F.COMPANY)

    FN.REDO.INTERFACE.MON.TYPE='F.REDO.INTERFACE.MON.TYPE'
    F.REDO.INTERFACE.MON.TYPE=''
    CALL OPF(FN.REDO.INTERFACE.MON.TYPE,F.REDO.INTERFACE.MON.TYPE)

    FN.CARD.TYPE = 'F.CARD.TYPE'
    F.CARD.TYPE = ''
    CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)

    FN.REDO.CARD.BIN = 'F.REDO.CARD.BIN'
    F.REDO.CARD.BIN = ''
    CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER= ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    GOSUB INIT.TWO
RETURN

*--------
INIT.TWO:
*--------
    LOC.REF.APPLICATION="COMPANY":@FM:"CARD.TYPE"
    LOC.REF.FIELDS='L.CO.BOOK':@FM:'L.CT.BIN'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.CO.BOOK=LOC.REF.POS<1,1>
    POS.L.CT.BIN = LOC.REF.POS<2,1>
    Y.ENT.ID = '' ; CUSTOMER.NO = ''
    ACCT.NO = ''
    Y.WRITE.FLAG=0

    FN.LCO = 'F.LATAM.CARD.ORDER'   ; F.LCO = ''
    CALL OPF(FN.LCO,F.LCO)
    RENEWAL.CNTR = 0 ; REISSUE.CNTR = 0 ; CardIndicator = ''

RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS.PARA:
* Main processing section

    Y.ID.NEW=ID.NEW

    CALL F.READ(FN.CARD.REQUEST,Y.ID.NEW,R.CARD.REQUEST,F.CARD.REQUEST,CARD.ERR)
    IF R.CARD.REQUEST THEN
*HD1101688 -S
        RENEW.FLAG = R.CARD.REQUEST<REDO.CARD.REQ.RENEWAL.FLAG>
        REQ.CARD.TYPE = R.CARD.REQUEST<REDO.CARD.REQ.CARD.TYPE>
    END

    Y.TOT.CARD.TYPES = DCOUNT(R.NEW(REDO.CARD.GEN.CARD.TYPE),@VM)
    Y.INIT.COUNT = 1

    LOOP
    WHILE Y.INIT.COUNT LE Y.TOT.CARD.TYPES
*PACS00063138 -S
        INPUT_PARAM_CARD.REQUEST = ''
        INPUT_PARAM_CMSACT.REQUEST = ''
        INPUT_PARAM_CMS.CARD.REQUEST = ''

        COMMENTS =   R.CARD.REQUEST<REDO.CARD.REQ.VAULT.QTY,Y.INIT.COUNT>
        EMBOSS.NAME = R.CARD.REQUEST<REDO.CARD.REQ.CUSTOMER.NAME,Y.INIT.COUNT>
        PREV.CARD = FIELD(COMMENTS,":",2)
        PREV.CARD = TRIM(PREV.CARD)

        FETCH.CARD.NUM = FIELD(PREV.CARD,".",2)
        ISSUE.INDICATOR = TRIM(FIELD(COMMENTS,":",1))

        CALL F.READ(FN.LCO,PREV.CARD,R.LCO,F.LCO,LCO.ERR)
        IF R.LCO THEN
            Y.EXP.DATE.OLD=''
            RENEWAL.CNTR = R.LCO<CARD.IS.RENEWAL.COUNTER>
            REISSUE.CNTR = R.LCO<CARD.IS.REISSUE.COUNTER>
            IF ISSUE.INDICATOR EQ "SAME" THEN
                Y.EXP.DATE.OLD=R.LCO<CARD.IS.EXPIRY.DATE>
            END
        END

**PACS00055017-S -S

        Y.SERIES.ID = R.NEW(REDO.CARD.GEN.CARD.TYPE)<1,Y.INIT.COUNT>
        Y.BIN.NO = R.NEW(REDO.CARD.GEN.BIN)<1,Y.INIT.COUNT>
        Y.STOCK.ID = Y.BIN.NO
**PACS00055017-E
        IF ISSUE.INDICATOR NE "SAME" THEN
            LOCATE Y.STOCK.ID IN Y.STOCK.ID.LIST SETTING Y.STOCK.ID.POS THEN
                R.REDO.CARD.REG.STK= R.REDO.CARD.REG.STK.ARR<Y.STOCK.ID.POS>
            END
            ELSE
                GOSUB READ.NEXT.SEQ
                Y.STOCK.ID.LIST<-1>=Y.STOCK.ID
                R.REDO.CARD.REG.STK.ARR<-1>=R.REDO.CARD.REG.STK
            END
            IF R.REDO.CARD.REG.STK EQ "" THEN
                Y.SEQ.NO = "000001"
            END ELSE
                Y.SEQ.NO = R.REDO.CARD.REG.STK<REDO.CARD.REG.STOCK.SERIES.BAL>
            END
        END
*PACS00177874 ---START----------------------
        Y.CUST.PROSP.NO = R.CARD.REQUEST<REDO.CARD.REQ.PROSPECT.ID>
        IF NOT(Y.CUST.PROSP.NO) THEN
            LOCATE Y.SERIES.ID IN REQ.CARD.TYPE<1,1> SETTING Y.CUS.PROS.POS THEN
                Y.CUST.PROSP.NO = R.CARD.REQUEST<REDO.CARD.REQ.CUSTOMER.NO,Y.CUS.PROS.POS,Y.INIT.COUNT>
            END
        END
        IF Y.CUST.PROSP.NO THEN
            CALL F.READ(FN.CUSTOMER,Y.CUST.PROSP.NO,R.CUSTOMER,F.CUSTOMER,ERR)
            Y.MAGNETIC.ST.NAME=R.CUSTOMER<EB.CUS.FAMILY.NAME>:'/':R.CUSTOMER<EB.CUS.GIVEN.NAMES>
            Y.MAGNETIC.ST.NAME =Y.MAGNETIC.ST.NAME[1,26]
        END
*PACS00177874---END----------------------------
        GOSUB FETCH.REQ.VALUES

        GOSUB GENERATE.CARD.NOS

        GOSUB UPDATE.REDO.CARD.NUMBERS
**************************************************************************************************************
        Y.CARD.NO = R.NEW(REDO.CARD.GEN.CARD.NUMBERS)<1,Y.INIT.COUNT>
        Y.CARD.TYPE = R.NEW(REDO.CARD.GEN.CARD.TYPE)<1,Y.INIT.COUNT>
        Y.COMP.CODE = R.NEW(REDO.CARD.GEN.AGENCY)<1,Y.INIT.COUNT>

        IF ISSUE.INDICATOR NE "SAME" THEN
            R.REDO.CARD.REG.STK<REDO.CARD.REG.STOCK.SERIES.BAL> = Y.SEQ.NO

            CALL LOG.WRITE(FN.REDO.CARD.REG.STK,Y.STOCK.ID,R.REDO.CARD.REG.STK,'')
            LOCATE Y.STOCK.ID IN Y.STOCK.ID.LIST SETTING Y.STOCK.ID.POS THEN
                R.REDO.CARD.REG.STK.ARR<Y.STOCK.ID.POS>=R.REDO.CARD.REG.STK
            END
            CALL F.RELEASE(FN.REDO.CARD.REG.STK,Y.STOCK.ID,F.REDO.CARD.REG.STK)
        END

        CALL APAP.REDORETAIL.REDO.CARD.GENERATION.WS ;*MANUAL R22 CODE CONVERSION

****************************************************************************************************************
        IF R.NEW(REDO.CARD.GEN.RESPONSE.MSG) EQ 'ERROR' THEN
            Y.INIT.COUNT=Y.TOT.CARD.TYPES
        END
        Y.INIT.COUNT +=1


    REPEAT
*HD1101688 -E

RETURN
*---------------------------------------------------------------------------------------------------------
FETCH.REQ.VALUES:

    Y.CARD.QTY = R.NEW(REDO.CARD.GEN.QTY)<1,Y.INIT.COUNT>
    Y.ACCOUNT.REQ = R.CARD.REQUEST<REDO.CARD.REQ.ACCOUNT.NO,Y.INIT.COUNT>
    Y.PERS.CARD.REQ = R.CARD.REQUEST<REDO.CARD.REQ.PERS.CARD,Y.INIT.COUNT>
    Y.BIN.ID = Y.BIN.NO
    CALL F.READ(FN.REDO.CARD.BIN,Y.BIN.ID,R.REDO.CARD.BIN,F.REDO.CARD.BIN,Y.ERR.BIN)
    IF R.REDO.CARD.BIN THEN
        Y.ENT.ID = R.REDO.CARD.BIN<REDO.CARD.BIN.ENTITY.ID>
    END

    CALL CACHE.READ('F.REDO.APAP.H.PARAMETER','SYSTEM',R.APAP.PARAM,PARAM.ERR)
    Y.DEM=R.APAP.PARAM<PARAM.DELIMITER>

    ACTIVATION = "APAP_EMBOZADO_WEBSERVICES"        ;*Activation key
    EX.USER=OPERATOR
    EX.PC= TSS$CLIENTIP
    ID.PROC=ID.NEW
    MON.TP.REJ = "03"
***ADDED DEFAULT IN LATAM CARD ORDER
    GOSUB FETCH.REQ.VALUES.TWO
RETURN

*-----------------
FETCH.REQ.VALUES.TWO:
*-----------------
    Y.EXPIRY.DATE = R.NEW(REDO.CARD.GEN.EXPIRY)<1,Y.INIT.COUNT>
    Y.AGENCY.GEN = R.NEW(REDO.CARD.GEN.AGENCY)<1,Y.INIT.COUNT>
    Y.TYPE.OF.CARD = R.CARD.REQUEST<REDO.CARD.REQ.TYPE.OF.CARD,Y.INIT.COUNT>
    Y.CARD.NO.AND.LOCK.ID = R.NEW(REDO.CARD.GEN.CARD.TYPE)<1,Y.INIT.COUNT>:'.':R.NEW(REDO.CARD.GEN.AGENCY)
    Y.CARD.NOS.LIST = ''
    Y.CARD.NOS.STATUS = ''

RETURN
*----------------------------------------------------------------------------------------------------------------

******************
GENERATE.CARD.NOS:
******************
*PACS00055017-S

    IF R.NEW(REDO.CARD.GEN.PERSONLISED)<1,Y.INIT.COUNT> EQ '' THEN
        Y.EMBOSS.TYPE = 'PREEMBOZADA'
    END ELSE
        Y.EMBOSS.TYPE = 'PERSONALIZADA'
    END

*PACS00055017 -E

    IF ISSUE.INDICATOR NE "SAME" THEN
        GOSUB DIFFERENT.CARD.PROCESS
    END ELSE

        Y.PERSONALISE.TYPE = R.NEW(REDO.CARD.GEN.PERSONLISED)<1,Y.INIT.COUNT>
        R.NEW(REDO.CARD.GEN.CARD.NUMBERS)<1,1,1> = FETCH.CARD.NUM
        Y.CARD.NOS.LIST = FETCH.CARD.NUM
        Y.GEN.CARD.NO = FETCH.CARD.NUM
        Y.CARD.NOS.STATUS = 'INUSE'
        Y.EMBOSS = Y.EMBOSS.TYPE
        Y.PERSONALISE = Y.PERSONALISE.TYPE
        Y.EXPIRY = Y.EXPIRY.DATE
        Y.CARD.TYPE.NUM = Y.TYPE.OF.CARD
        Y.REQ.ID = ID.NEW
        GOSUB UPDATE.CARD.REQUEST.WEB.SERVICES
        GOSUB UPDATE.CMS.CARD.REQUEST.WEB.SERVICES
        GOSUB UPDATE.CMSACT.REQUEST.WEB.SERVICES

    END

    GOSUB UPDATE.RENEW.NO

RETURN
*--------------------------------------------------------------------------------------------------------
DIFFERENT.CARD.PROCESS:

    Y.PERSONALISE.TYPE = R.NEW(REDO.CARD.GEN.PERSONLISED)<1,Y.INIT.COUNT>

    Y.INIT.CARD.COUNT = 1
    LOOP
    WHILE Y.INIT.CARD.COUNT LE Y.CARD.QTY

        Y.BRANCH.AGENCY = R.NEW(REDO.CARD.GEN.AGENCY)
        BRANCH.DIGIT = Y.BRANCH.AGENCY[7,3]
*PACS00148241 -S
        Y.SEQ.NO = FMT(Y.SEQ.NO,"R%9")

        Y.BIN.SEQ = Y.BIN.NO:Y.SEQ.NO

        GOSUB CALC.CHECK.DIGIT
        Y.GEN.CARD.NO = ''

        Y.GEN.CARD.NO = Y.BIN.NO:Y.SEQ.NO:Y.CHECK.DIGIT

**PACS00148241-E
        R.NEW(REDO.CARD.GEN.CARD.NUMBERS)<1,Y.INIT.COUNT,Y.INIT.CARD.COUNT> = Y.GEN.CARD.NO

        GOSUB ASSIGN.CARD.VALUES

        GOSUB UPDATE.CARD.REQUEST.WEB.SERVICES
        GOSUB UPDATE.CMS.CARD.REQUEST.WEB.SERVICES
        GOSUB UPDATE.CMSACT.REQUEST.WEB.SERVICES

        Y.INIT.CARD.COUNT +=1
        Y.SEQ.NO += 1
    REPEAT

RETURN
*--------------------
ASSIGN.CARD.VALUES:

    IF Y.CARD.NOS.LIST EQ '' THEN
        Y.CARD.NOS.LIST = Y.GEN.CARD.NO
*PACS00055017 -S
        IF Y.EMBOSS.TYPE EQ 'PREEMBOZADA' THEN
            Y.CARD.NOS.STATUS = 'AVAILABLE'
        END ELSE
            Y.CARD.NOS.STATUS = 'INUSE'
        END

        Y.EMBOSS = Y.EMBOSS.TYPE
        Y.PERSONALISE = Y.PERSONALISE.TYPE
        Y.EXPIRY = Y.EXPIRY.DATE
        Y.CARD.TYPE.NUM = Y.TYPE.OF.CARD
        Y.REQ.ID = ID.NEW
        Y.GEN.DATE=TODAY
    END ELSE
        Y.CARD.NOS.LIST := @VM:Y.GEN.CARD.NO

        IF Y.EMBOSS.TYPE EQ 'PREEMBOZADA' THEN
            Y.CARD.NOS.STATUS := @VM:'AVAILABLE'
        END ELSE
            Y.CARD.NOS.STATUS := @VM:'INUSE'
        END
*PACS00055017-E
        Y.EMBOSS := @VM:Y.EMBOSS.TYPE
        Y.PERSONALISE := @VM:Y.PERSONALISE.TYPE
        Y.EXPIRY := @VM:Y.EXPIRY.DATE
        Y.CARD.TYPE.NUM := @VM:Y.TYPE.OF.CARD
        Y.REQ.ID := @VM:ID.NEW
        Y.GEN.DATE:= @VM:TODAY
    END

RETURN
*-------------------------------------------------------------------------------------
READ.NEXT.SEQ:
**********************
*PACS00055017-S

    R.REDO.CARD.REG.STK = ''
    SEQ.ERR = ''
    Y.OPTIONS = ''
    CALL F.READU(FN.REDO.CARD.REG.STK,Y.STOCK.ID,R.REDO.CARD.REG.STK,F.REDO.CARD.REG.STK,SEQ.ERR,Y.OPTIONS)

*    READU R.REDO.CARD.REG.STK FROM F.REDO.CARD.REG.STK,Y.STOCK.ID SETTING Y.REDO.CARD.REG.STK.POS THEN
*END
*PACS00055017-E

RETURN
*--------------------------------------------------------------------------------------------------------
CALC.CHECK.DIGIT:
*****************
    Y.CHECK.DIGIT = ""
    Y.SUM.CHK = ""
    Y.DIGIT.COUNT = 1
    Y.DIGIT.SUM =0
    Y.LEN.DIGIT = LEN(Y.BIN.SEQ)
    Y.CONTINUE.FLAG=1
    LOOP
    WHILE Y.DIGIT.COUNT LE Y.LEN.DIGIT

        Y.DIGIT = Y.BIN.SEQ[Y.DIGIT.COUNT,1]
        Y.EVEN.DIGIT = MOD(Y.DIGIT.COUNT,2)

        IF Y.EVEN.DIGIT NE 0 THEN ;* Check the odd digit and mu
            Y.DIGIT = Y.DIGIT*2
            IF Y.DIGIT GE 10 THEN
                Y.DIGIT.SUM = Y.DIGIT.SUM+Y.DIGIT[1,1]+Y.DIGIT[2,1]
                Y.DIGIT.COUNT += 1
                Y.CONTINUE.FLAG=0
            END

        END
        IF Y.CONTINUE.FLAG THEN
            Y.DIGIT.SUM += Y.DIGIT
            Y.DIGIT.COUNT += 1
        END
        Y.CONTINUE.FLAG=1
    REPEAT

    Y.QUOTIENT = INT(Y.DIGIT.SUM/10)
    Y.REM.DIGIT = MOD(Y.DIGIT.SUM,10)

    IF Y.REM.DIGIT THEN
        Y.CHECK.DIGIT = ((Y.QUOTIENT+1)*10) - Y.DIGIT.SUM
    END ELSE
        Y.CHECK.DIGIT = Y.DIGIT.SUM[2,1]
    END

RETURN
*--------------------------------------------------------------------------------------------------------
UPDATE.REDO.CARD.NUMBERS:

    GOSUB READ.REDO.CARD.NUMBERS
    IF Y.EMBOSS.TYPE EQ 'PREEMBOZADA' THEN
        GOSUB UPDATE.REDO.CARD.NO.LOCK
    END

    CNT.VAL=DCOUNT(R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER>,@VM)
    IF R.REDO.CARD.NUMBERS<REDO.CARD.NUM.GEN.DATE> EQ '' AND R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER> NE '' THEN
        R.REDO.CARD.NUMBERS<REDO.CARD.NUM.GEN.DATE,CNT.VAL>=''
    END

    IF ISSUE.INDICATOR NE "SAME" THEN
        IF R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER> EQ '' THEN
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER> = Y.CARD.NOS.LIST
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.STATUS> = Y.CARD.NOS.STATUS
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.EMBOSS.TYPE>= Y.EMBOSS
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.PERSONAL.TYPE>=Y.PERSONALISE
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.EXPIRY.DATE> = Y.EXPIRY
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.TYPE.OF.CARD> = Y.CARD.TYPE.NUM
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CRD.REQ.ID> = Y.REQ.ID
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.GEN.DATE> =Y.GEN.DATE
        END ELSE
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER> := @VM:Y.CARD.NOS.LIST
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.STATUS> := @VM:Y.CARD.NOS.STATUS
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.EMBOSS.TYPE> := @VM:Y.EMBOSS
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.PERSONAL.TYPE> := @VM:Y.PERSONALISE
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.EXPIRY.DATE> := @VM:Y.EXPIRY
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.TYPE.OF.CARD> := @VM:Y.CARD.TYPE.NUM
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CRD.REQ.ID> := @VM:Y.REQ.ID
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.GEN.DATE> := @VM:Y.GEN.DATE
        END
    END ELSE
        FETCH.AVAIL.NUMBERS = R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER>
        CHANGE @VM TO @FM IN FETCH.AVAIL.NUMBERS
        LOCATE Y.CARD.NOS.LIST IN FETCH.AVAIL.NUMBERS SETTING CARD.AVL.POS THEN

            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.STATUS,CARD.AVL.POS> = Y.CARD.NOS.STATUS
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.EMBOSS.TYPE,CARD.AVL.POS> = Y.EMBOSS
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.PERSONAL.TYPE,CARD.AVL.POS> = Y.PERSONALISE
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.EXPIRY.DATE,CARD.AVL.POS> = Y.EXPIRY
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.TYPE.OF.CARD,CARD.AVL.POS> = Y.CARD.TYPE.NUM
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CRD.REQ.ID,CARD.AVL.POS> = Y.REQ.ID
            R.REDO.CARD.NUMBERS<REDO.CARD.NUM.GEN.DATE,CARD.AVL.POS> = TODAY
        END
    END

    CALL F.WRITE(FN.REDO.CARD.NUMBERS,Y.CARD.NO.AND.LOCK.ID,R.REDO.CARD.NUMBERS)
    IF Y.WRITE.FLAG EQ 0 THEN
        R.CARD.REQUEST<REDO.CARD.REQ.NUMBERS.GEN>='YES'
        Y.ID.NEW=ID.NEW
        CALL F.WRITE(FN.CARD.REQUEST,Y.ID.NEW,R.CARD.REQUEST)
        Y.WRITE.FLAG=1
    END

RETURN
*--------------------------------------------------------------------------------------------------------
UPDATE.REDO.CARD.NO.LOCK:
************************
    GOSUB READ.REDO.CARD.NO.LOCK
    IF R.REDO.CARD.NO.LOCK THEN
        IF R.REDO.CARD.NO.LOCK<REDO.CARD.LOCK.CARD.NUMBER,1> EQ '' THEN
            R.REDO.CARD.NO.LOCK<REDO.CARD.LOCK.CARD.NUMBER,1> = Y.CARD.NOS.LIST<1,1>
        END
    END ELSE
        R.REDO.CARD.NO.LOCK<REDO.CARD.LOCK.CARD.NUMBER,1> = Y.CARD.NOS.LIST<1,1>
    END
    CALL F.WRITE(FN.REDO.CARD.NO.LOCK,Y.CARD.NO.AND.LOCK.ID,R.REDO.CARD.NO.LOCK)
*    WRITE R.REDO.CARD.NO.LOCK ON F.REDO.CARD.NO.LOCK,Y.CARD.NO.AND.LOCK.ID
*    CALL LOG.WRITE(FN.REDO.CARD.NO.LOCK,Y.CARD.NO.AND.LOCK.ID,R.REDO.CARD.NO.LOCK,'')

RETURN
*--------------------------------------------------------------------------------------------------------
READ.REDO.CARD.NUMBERS:

    R.REDO.CARD.NUMBERS = ''
    REDO.CARD.NUMBERS.ERR = ''
    CALL F.READU(FN.REDO.CARD.NUMBERS,Y.CARD.NO.AND.LOCK.ID,R.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS,REDO.CARD.NUMBERS.ERR,Y.OPTIONS)
RETURN
*--------------------------------------------------------------------------------------------------------
**********************
READ.REDO.CARD.NO.LOCK:
**********************
    R.REDO.CARD.NO.LOCK = ''
    REDO.CARD.NO.LOCK.ERR = ''
    CALL F.READU(FN.REDO.CARD.NO.LOCK,Y.CARD.NO.AND.LOCK.ID,R.REDO.CARD.NO.LOCK,F.REDO.CARD.NO.LOCK,REDO.CARD.NO.LOCK.ERR,Y.OPTIONS)
RETURN
*--------------------------------------------------------------------------------------------------------
UPDATE.RENEW.NO:

    LOCATE Y.SERIES.ID IN REQ.CARD.TYPE<1,1> SETTING REQ.POS THEN
        CUSTOMER.NO = R.CARD.REQUEST<REDO.CARD.REQ.CUSTOMER.NO,REQ.POS,Y.INIT.COUNT>
        ACCT.NO = R.CARD.REQUEST<REDO.CARD.REQ.ACCOUNT.NO,REQ.POS,Y.INIT.COUNT>
    END
    CARD.RENEW.ID = CUSTOMER.NO:"-":ACCT.NO
    CALL F.READ(FN.CARD.RENEWAL,CARD.RENEW.ID,R.CARD.RENEWAL,F.CARD.RENEWAL,RENEW.ERR)
    IF R.CARD.RENEWAL THEN

        GET.CARD.NUMBERS = R.CARD.RENEWAL<REDO.RENEW.PREV.CARD.NO>
        CHANGE @VM TO @FM IN GET.CARD.NUMBERS
        LOCATE PREV.CARD IN GET.CARD.NUMBERS SETTING CARD.POS THEN
            R.CARD.RENEWAL<REDO.RENEW.NEXT.CARD.NO,CARD.POS> = Y.SERIES.ID:".":Y.GEN.CARD.NO
            R.CARD.RENEWAL<REDO.RENEW.ISSUE.TYPE,CARD.POS> = ISSUE.INDICATOR
        END
        CALL F.WRITE(FN.CARD.RENEWAL,CARD.RENEW.ID,R.CARD.RENEWAL)
    END
*PACS00063138-E
RETURN
*------------------------------------------------------------------------------
************************************
UPDATE.CARD.REQUEST.WEB.SERVICES:


    RESPONSE.CODE=''
    Pan = Y.GEN.CARD.NO
    IF Y.EXP.DATE.OLD THEN
        ExpiryDate=Y.EXP.DATE.OLD
    END
    ELSE
        ExpiryDate = Y.EXPIRY.DATE
    END
    PinRetryCount = 0
    CardPVV = ' '
    CardPVKI=' '
    RegionCode = R.APAP.PARAM<PARAM.REGION.CODE>
    Y.COMP.CODE = Y.AGENCY.GEN
    CALL CACHE.READ(FN.COMPANY, Y.COMP.CODE, R.COMPANY.REC, COMP.ERR)
    IF R.COMPANY.REC THEN
        BranchId=R.COMPANY.REC<EB.COM.LOCAL.REF,POS.L.CO.BOOK>
        BranchId=FMT(BranchId,'3"0"R')
    END
    AllowInternetTxn = '0'
    CardType = Y.ENT.ID
    CardStatus=70
*PACS00177874 -S
    IF RENEW.FLAG EQ 'YES' THEN
        CardStatus=70
    END
*PACS00177874-E
    CardLanguage = R.APAP.PARAM<PARAM.CARD.LANGG>
    ConsentDate  = '        '
    IF INPUT_PARAM_CARD.REQUEST EQ '' THEN
        INPUT_PARAM_CARD.REQUEST = Pan:Y.DEM:ExpiryDate:Y.DEM:PinRetryCount:Y.DEM:CardPVV:Y.DEM:CardPVKI:Y.DEM:RegionCode:Y.DEM:BranchId:Y.DEM:AllowInternetTxn:Y.DEM:CardType:Y.DEM:CardStatus:Y.DEM:CardLanguage:Y.DEM:ConsentDate
    END ELSE
        INPUT_PARAM_CARD.REQUEST<1,-1> = Pan:Y.DEM:ExpiryDate:Y.DEM:PinRetryCount:Y.DEM:CardPVV:Y.DEM:CardPVKI:Y.DEM:RegionCode:Y.DEM:BranchId:Y.DEM:AllowInternetTxn:Y.DEM:CardType:Y.DEM:CardStatus:Y.DEM:CardLanguage:Y.DEM:ConsentDate
    END

RETURN
*------------------------------------------------------------------------------
***************************************
UPDATE.CMS.CARD.REQUEST.WEB.SERVICES:
***************************************

    DESC=''
    EXP.DATE = Y.EXPIRY.DATE
    IF Y.EMBOSS.TYPE EQ 'PREEMBOZADA' THEN
        CardIndicator= R.APAP.PARAM<PARAM.PRINCIPAL.IND>
        EmbossingType = 1
        EmbossedName = ' '
        MagneticStripName = 'VISA CARDHOLDER'
    END ELSE
        GOSUB PERSONALISE.CARD.IND
    END

    CardIssueDate= TODAY
*PACS00055017-S
    IF Y.PERS.CARD.REQ EQ 'URGENTE' THEN
        EmbossingType:=1
    END ELSE
        EmbossingType:=0
    END
*PACS00055017-E
    IF INPUT_PARAM_CMS.CARD.REQUEST EQ '' THEN
        INPUT_PARAM_CMS.CARD.REQUEST = Pan:Y.DEM:EXP.DATE:Y.DEM:CardIndicator:Y.DEM:CardIssueDate:Y.DEM:EmbossedName:Y.DEM:MagneticStripName:Y.DEM:EmbossingType
    END ELSE
        INPUT_PARAM_CMS.CARD.REQUEST<1,-1> = Pan:Y.DEM:EXP.DATE:Y.DEM:CardIndicator:Y.DEM:CardIssueDate:Y.DEM:EmbossedName:Y.DEM:MagneticStripName:Y.DEM:EmbossingType
    END

RETURN
*------------------------------------------------------------------------------
PERSONALISE.CARD.IND:

    EmbossingType= 0

    IF Y.TYPE.OF.CARD EQ "PRINCIPAL" THEN
        CardIndicator= R.APAP.PARAM<PARAM.PRINCIPAL.IND>
    END ELSE
        CardIndicator=R.APAP.PARAM<PARAM.ADITIONAL.IND>
    END
    Y.ACC.NO=Y.ACCOUNT.REQ
    CALL F.READ(FN.ACCOUNT,Y.ACC.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    IF R.ACCOUNT THEN

* IF CardIndicator EQ '' THEN
*     Y.CATEGORY=R.ACCOUNT<AC.CATEGORY>
*    Y.PARAM.CATEG=R.APAP.PARAM<PARAM.CORPORATE.CATEG>
*    CHANGE VM TO FM IN Y.PARAM.CATEG
*    LOCATE Y.CATEGORY IN Y.PARAM.CATEG SETTING CAT.POS THEN
*        CardIndicator=R.APAP.PARAM<PARAM.CORPORATE.IND>
*    END
*END
*PACS00094453-S
        EmbossedName = EMBOSS.NAME
*PACS00177874 -S
        MagneticStripName = Y.MAGNETIC.ST.NAME
*PACS00177874 -E
*PACS00094453-E
    END

RETURN
*-----------------------------------------------------------------------------
**************************************
UPDATE.CMSACT.REQUEST.WEB.SERVICES:
**************************************
    DESC=''
    CardSequence = RENEWAL.CNTR + REISSUE.CNTR + 1
    CardType = Y.ENT.ID

    IF ISSUE.INDICATOR EQ "SAME" THEN
        CMSFunction='03'
    END ELSE
        CMSFunction='01'
    END
    Y.DATE.TIME = R.NEW(REDO.CARD.GEN.DATE.TIME)
    ActivityDate = TODAY
    TEMPTIME = OCONV(TIME(),"MTS")
    Y.F = FIELD(TEMPTIME,':',1,1)
    Y.S = FIELD(TEMPTIME,':',2,1)
    Y.T     = FIELD(TEMPTIME,':',3,1)
    Y.DATE.TIME = Y.F:Y.S:Y.T
    ActivityTime  = Y.DATE.TIME

    IF INPUT_PARAM_CMSACT.REQUEST EQ '' THEN
        INPUT_PARAM_CMSACT.REQUEST = Pan:Y.DEM:CardSequence:Y.DEM:CardType:Y.DEM:RegionCode:Y.DEM:BranchId:Y.DEM:CMSFunction:Y.DEM:ActivityDate:Y.DEM:ActivityTime
    END ELSE
        INPUT_PARAM_CMSACT.REQUEST<1,-1> = Pan:Y.DEM:CardSequence:Y.DEM:CardType:Y.DEM:RegionCode:Y.DEM:BranchId:Y.DEM:CMSFunction:Y.DEM:ActivityDate:Y.DEM:ActivityTime
    END
RETURN
*------------------------------------------------------------------------------
END
