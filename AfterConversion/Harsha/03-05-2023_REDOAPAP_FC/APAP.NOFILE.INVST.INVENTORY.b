* @ValidationCode : MjoxMDk3MDM0Mzk2OkNwMTI1MjoxNjgyNTAyNjE3MjQwOklUU1M6LTE6LTE6NTAzMzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Apr 2023 15:20:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 5033
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE APAP.NOFILE.INVST.INVENTORY(Y.FINAL.ARRAY)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : A C Rajkumar
* Program Name  : APAP.NOFILE.INVST.INVENTORY
* ODR NUMBER    : ODR-2010-08-0422
*----------------------------------------------------------------------------------
* Description   : This is a NOFILE routine for the enquiry APAP.ENQ.INVST.INVENT
* In parameter  : None
* out parameter : None
*----------------------------------------------------------------------------------
*    Date           Author          Reference           Description
* 07-Oct-2010    Sridharan Dhamu  ODR-2010-08-0422   Initial creation
* 27-Oct-2010    A C Rajkumar     ODR-2010-08-0422   Ammendments and changes
*                                                    based on the Functionality
* 19-Dec-2011    Pradeep S        PACS00167211       New selection field added
* 21-May-2012    Pradeep S        PACS00198127       Spanish labels added & Selection changed
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @FM , VM to @VM , F.READ to CACHE.READ
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*-----------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.MM.MONEY.MARKET
    $INSERT I_F.SC.TRADING.POSITION
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.SUB.ASSET.TYPE
    $INSERT I_F.SECURITY.SUPP
    $INSERT I_F.SEC.ACC.MASTER
    $INSERT I_F.CATEGORY
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CENTRAL.BANK
*
    GOSUB OPEN.PARA
    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB INIT
    GOSUB LOCATE.IDS
    GOSUB FORM.SEL.LIST
*
RETURN
*
*=========
OPEN.PARA:
*=========
*
    FN.MM.MONEY.MARKET = 'F.MM.MONEY.MARKET'
    F.MM.MONEY.MARKET  = ''
    CALL OPF(FN.MM.MONEY.MARKET,F.MM.MONEY.MARKET)

    FN.SC.TRADING.POSITION = 'F.SC.TRADING.POSITION'
    F.SC.TRADING.POSITION  = ''
    CALL OPF(FN.SC.TRADING.POSITION,F.SC.TRADING.POSITION)

    FN.SEC.TRADE = 'F.SEC.TRADE'
    F.SEC.TRADE  = ''
    CALL OPF(FN.SEC.TRADE,F.SEC.TRADE)

    FN.SECURITY.MASTER = 'F.SECURITY.MASTER'
    F.SECURITY.MASTER  = ''
    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)

    FN.SUB.ASSET.TYPE = 'F.SUB.ASSET.TYPE'
    F.SUB.ASSET.TYPE  = ''
    CALL OPF(FN.SUB.ASSET.TYPE,F.SUB.ASSET.TYPE)

    FN.SECURITY.SUPP = 'F.SECURITY.SUPP'
    F.SECURITY.SUPP  = ''
    CALL OPF(FN.SECURITY.SUPP,F.SECURITY.SUPP)

    FN.CATEGORY = 'F.CATEGORY'
    F.CATEGORY  = ''
    CALL OPF(FN.CATEGORY,F.CATEGORY)

    FN.CENTRAL.BANK = 'F.CENTRAL.BANK'
    F.CENTRAL.BANK  = ''
    CALL OPF(FN.CENTRAL.BANK,F.CENTRAL.BANK)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.SAM = 'F.SEC.ACC.MASTER'
    F.SAM  = ''
    CALL OPF(FN.SAM,F.SAM)

RETURN
*
*====================
FIND.MULTI.LOCAL.REF:
*====================
*
    APPL.ARRAY = "MM.MONEY.MARKET":@FM:"SEC.TRADE"
    FLD.ARRAY = "L.MM.OWN.PORT":@FM:"L.SC.TRN.YIELD"
    FLD.POS = ""
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.MM.OWN.PORT  = FLD.POS<1,1>
    LOC.L.SC.TRN.YIELD = FLD.POS<2,1>

RETURN
*
*====
INIT:
*====
*
    Y.SEL.LIST.ARRAY = ''   ; Y.TXN.ID = ''            ; Y.TYPE.OF.INST = ''      ; Y.PORT.FOLIO = ''      ; Y.ISSUER = ''       ; Y.FACE.VALUE = ''
    Y.PAID.AMOUNT = ''      ; Y.ISSUE.DATE = ''        ; Y.VALUE.DATE = ''        ; Y.RENOVATION = ''      ; Y.MAT.DATE = ''     ; Y.YIELD = ''
    Y.COUPON = ''           ; Y.DAYS = ''              ; Y.FOOT.DISP = ''         ; Y.TOT.FACE.COUPON = '' ; Y.TOT.FACE.YIELD = ''
    Y.TOT.FACE.VALUE = ''   ; Y.TYPE.OF.INVST = ''     ; Y.TYPE.INVST.POS = ''    ; LAST.IDS = ''          ; STP.ID.LIST = ''    ; STP.ID.LIST.ASSET = ''
    Y.FACIAL.COUPON = ''    ; Y.FACIAL.YIELD = ''      ; Y.COUPON = ''            ; Y.MM.CATEGORY = ''     ; Y.ARRAY.2 = ''      ; Y.DUMMY = '' ;
    Y.FOOT.YIELD.BNK = ''   ; Y.FOOT.COUPON.BNK = ''   ; Y.FOOT.ISSUER = ''       ; Y.FOOT.FACE.AMT = ''   ; Y.FOOT.YIELD = ''   ; Y.FOOT.COUPON = ''
    Y.DISP.FACE.VALUE = ''  ; Y.DISP.FACE.COUPON = ''  ; Y.DISP.FACE.YIELD = ''   ; Y.CURRENCY = ''        ; Y.TRADER = ''       ; Y.INVST.AS.ON = ''
    Y.TYPE.OF.INSTRMNT = '' ; Y.PORTFOLIO = ''         ; Y.COUNTERPARTY = ''      ; Y.MATURITY.DATE = ''   ; Y.FACIAL.YIELD = '' ; Y.FACIAL.COUPON = ''
    Y.FOOT.DISP = ''        ; Y.ARRAY.5 = ''           ; Y.FOOT.FACE.AMT.BNK = '' ; Y.FOOT.ISSUER.BNK = ''

RETURN
*
*==========
LOCATE.IDS:
*==========
*
    LOCATE "INVST.AS.ON" IN D.FIELDS<1> SETTING INVST.POS THEN
        Y.INVST.AS.ON = D.RANGE.AND.VALUE<INVST.POS>
        SEL.CMD.MM = "SELECT ":FN.MM.MONEY.MARKET:" WITH VALUE.DATE LE ":Y.INVST.AS.ON        ;* PACS00198127 - S/E
        SEL.CMD.SC = "SELECT ":FN.SC.TRADING.POSITION
*SEL.CMD.SC = "SELECT ":FN.SC.TRADING.POSITION:" WITH VALUE.DATE GE ":Y.INVST.AS.ON ;* PACS00167211 - S/E
    END

    LOCATE "CURRENCY" IN D.FIELDS<1> SETTING CCY.POS THEN
        Y.CURRENCY = D.RANGE.AND.VALUE<CCY.POS>
        SEL.CMD.MM := " AND CURRENCY EQ ":Y.CURRENCY
        SEL.CMD.SC := " WITH SECURITY.CCY EQ ":Y.CURRENCY
    END

    LOCATE "TRADER" IN D.FIELDS<1> SETTING TRADER.POS THEN
        Y.TRADER = D.RANGE.AND.VALUE<TRADER.POS>
*SEL.CMD.SC := " AND DEALER.BOOK EQ ":Y.TRADER
        Y.TRADER.FLAG = 1
    END ELSE
        Y.TRADER = 'ALL'
    END

    LOCATE "PORTFOLIO" IN D.FIELDS<1> SETTING PORT.POS THEN
        Y.PORTFOLIO = D.RANGE.AND.VALUE<PORT.POS>
        Y.OPERATOR = D.LOGICAL.OPERANDS<PORT.POS>
        YOPERATOR = OPERAND.LIST<D.LOGICAL.OPERANDS<PORT.POS>>
        GOSUB CHECK.OPERAND
    END ELSE
        Y.PORTFOLIO = 'ALL'
    END

*PACS00167211 - S
    LOCATE "PORTFOLIO.TYPE" IN D.FIELDS<1> SETTING PORT.TYPE.POS THEN
        Y.PORTFOLIO.TYPE = D.RANGE.AND.VALUE<PORT.TYPE.POS>
    END ELSE
        Y.PORTFOLIO.TYPE = 'ALL'
    END
*PACS00167211 - E

    LOCATE "COUNTERPARTY" IN D.FIELDS<1> SETTING CTR.PARTY.POS THEN
        Y.COUNTERPARTY = D.RANGE.AND.VALUE<CTR.PARTY.POS>
        SEL.CMD.MM := " AND CUSTOMER.ID EQ ":Y.COUNTERPARTY
        SEL.CMD.SC := " AND DEALER.BOOK LIKE ...":Y.COUNTERPARTY:"..."
    END ELSE
        Y.COUNTERPARTY = 'ALL'
    END

    LOCATE "MATURITY.DATE" IN D.FIELDS<1> SETTING MAT.DATE.POS THEN
        Y.MAT.FLAG = 1
        Y.MATURITY.DATE = D.RANGE.AND.VALUE<MAT.DATE.POS>

        GOSUB MAT.DATE.VALUES

        STP.ID.LIST = STP.ID.LIST.TEMP.DATE
    END ELSE
        Y.MATURITY.DATE = 'ALL'
    END

    LOCATE "TYPE.OF.INSTRMNT" IN D.FIELDS<1> SETTING INSTRMNT.POS THEN
        Y.TYPE.OF.INSTRMNT = D.RANGE.AND.VALUE<INSTRMNT.POS>

        IF Y.TYPE.OF.INSTRMNT EQ 'MONEY.MARKET' THEN
            Y.FLAG.INSTRMNT.MM = 1
        END
        IF Y.TYPE.OF.INSTRMNT EQ 'BOND' OR Y.TYPE.OF.INSTRMNT EQ 'SHARE' THEN
            Y.FLAG.INSTRMNT.SC = 1
        END
        GOSUB INSTRMNT.TYPE.VALUES
        STP.ID.LIST = STP.ID.LIST.TEMP
    END ELSE
        Y.TYPE.OF.INSTRMNT = 'ALL'
    END

RETURN

*
*=============
CHECK.OPERAND:
*=============
*PACS00167211 - New Section

    BEGIN CASE

        CASE Y.OPERATOR MATCHES "1":@VM:"3":@VM:"4":@VM:"5":@VM:"8":@VM:"9"
            SEL.CMD.MM := " AND L.MM.OWN.PORT ":YOPERATOR:" ":Y.PORTFOLIO
            SEL.CMD.SC := " AND DEALER.BOOK ":YOPERATOR:" ":Y.PORTFOLIO
        CASE Y.OPERATOR EQ "2"
            YUBOUND = FIELD(Y.PORTFOLIO, @SM, 1)
            YLBOUND = FIELD(Y.PORTFOLIO, @SM, 2)
            SEL.CMD.MM := " AND L.MM.OWN.PORT GE ":"'" : YUBOUND : "'"
            SEL.CMD.MM := " AND "
            SEL.CMD.MM := " L.MM.OWN.PORT LE ":"'" : YLBOUND : "'"

            SEL.CMD.SC := " AND DEALER.BOOK GE ":"'" : YUBOUND : "'"
            SEL.CMD.SC := " AND "
            SEL.CMD.SC := " DEALER.BOOK LE ":"'" : YLBOUND : "'"
        CASE Y.OPERATOR EQ "10"
            YUBOUND = FIELD(Y.PORTFOLIO, @SM, 1)
            YLBOUND = FIELD(Y.PORTFOLIO, @SM, 2)
            SEL.CMD.MM := " AND L.MM.OWN.PORT LT ":"'" : YUBOUND : "'"
            SEL.CMD.MM := " OR "
            SEL.CMD.MM := " L.MM.OWN.PORT GT ":"'" : YLBOUND : "'"

            SEL.CMD.SC := " AND DEALER.BOOK LT ":"'" : YUBOUND : "'"
            SEL.CMD.SC := " OR "
            SEL.CMD.SC := " DEALER.BOOK GT ":"'" : YLBOUND : "'"
        CASE Y.OPERATOR EQ "6"
            SEL.CMD.MM := " AND L.MM.OWN.PORT LIKE ":Y.PORTFOLIO
            SEL.CMD.SC := " AND DEALER.BOOK LIKE ":Y.PORTFOLIO
        CASE Y.OPERATOR EQ "7"
            SEL.CMD.MM := " AND L.MM.OWN.PORT UNLIKE ":Y.PORTFOLIO
            SEL.CMD.SC := " AND DEALER.BOOK UNLIKE ":Y.PORTFOLIO
    END CASE

RETURN

*
*====================
INSTRMNT.TYPE.VALUES:
*====================
*
    IF STP.ID.LIST THEN
        STP.ID.LIST.INST = STP.ID.LIST
    END ELSE
        CALL EB.READLIST(SEL.CMD.SC,STP.ID.LIST.INST,'',NOF.REC.2,Y.ERR.2)
    END
    LOOP
        REMOVE Y.STP.ID FROM STP.ID.LIST.INST SETTING STP.POS
    WHILE Y.STP.ID:STP.POS
        CALL F.READ(FN.SC.TRADING.POSITION,Y.STP.ID,R.SC.TRADING.POSITION,F.SC.TRADING.POSITION,Y.ERR.SC.TRADING.POSITION)
        Y.SC.SEC.CODE = R.SC.TRADING.POSITION<SC.TRP.SECURITY.CODE>
        Y.SAM.ID   = R.SC.TRADING.POSITION<SC.TRP.DEALER.BOOK>
        GOSUB READ.SAM  ;* PACS00167211
        CALL F.READ(FN.SECURITY.MASTER,Y.SC.SEC.CODE,R.SECURITY.MASTER,F.SECURITY.MASTER,Y.ERR.SECURITY.MASTER)
        Y.BS            = R.SECURITY.MASTER<SC.SCM.BOND.OR.SHARE>
        Y.TEMP.MAT.DATE = R.SECURITY.MASTER<SC.SCM.MATURITY.DATE>
        IF Y.BS EQ 'B' THEN ;*R22 AUTO CODE CONVERSION
            Y.BS = 'BOND'
        END ELSE
            Y.BS = 'SHARE'
        END
        BEGIN CASE
            CASE Y.MATURITY.DATE NE 'ALL'
                IF (Y.TEMP.MAT.DATE EQ Y.MATURITY.DATE) AND (Y.TYPE.OF.INSTRMNT EQ Y.BS) AND Y.SAM.TYPE.FLAG THEN
                    STP.ID.LIST.TEMP<-1> = Y.STP.ID
                END
            CASE Y.MATURITY.DATE EQ 'ALL'
                IF Y.TYPE.OF.INSTRMNT EQ Y.BS AND Y.SAM.TYPE.FLAG THEN
                    STP.ID.LIST.TEMP<-1> = Y.STP.ID
                END
        END CASE
    REPEAT

RETURN

*
*========
READ.SAM:
*========
*PACS00167211 - New Section

    CALL F.READ(FN.SAM,Y.SAM.ID,R.SAM,F.SAM,Y.ERR.SAM)
    Y.SAM.TYPE = R.SAM<SC.SAM.PORTFOLIO.TYPE>
    Y.SAM.TYPE.FLAG = @TRUE
    IF (Y.PORTFOLIO.TYPE NE 'ALL') AND (Y.PORTFOLIO.TYPE NE Y.SAM.TYPE) THEN
        Y.SAM.TYPE.FLAG = @FALSE
    END

RETURN

*
*===============
MAT.DATE.VALUES:
*===============
*
    SEL.CMD.MM := " AND MATURITY.DATE EQ ":Y.MATURITY.DATE

    CALL EB.READLIST(SEL.CMD.SC,STP.ID.LIST,'',NOF.REC.2,Y.ERR.2)

    LOOP
        REMOVE Y.STP.ID FROM STP.ID.LIST SETTING STP.POS
    WHILE Y.STP.ID:STP.POS
        CALL F.READ(FN.SC.TRADING.POSITION,Y.STP.ID,R.SC.TRADING.POSITION,F.SC.TRADING.POSITION,Y.ERR.SC.TRADING.POSITION)
        Y.SC.SEC.CODE = R.SC.TRADING.POSITION<SC.TRP.SECURITY.CODE>
        CALL F.READ(FN.SECURITY.MASTER,Y.SC.SEC.CODE,R.SECURITY.MASTER,F.SECURITY.MASTER,Y.ERR.SECURITY.MASTER)
        Y.MAT.DATE = R.SECURITY.MASTER<SC.SCM.MATURITY.DATE>

        IF Y.MATURITY.DATE EQ Y.MAT.DATE THEN
            STP.ID.LIST.TEMP.DATE<-1> = Y.STP.ID
        END

    REPEAT
RETURN
*
*=============
FORM.SEL.LIST:
*=============
*
    IF Y.TYPE.OF.INSTRMNT THEN

        IF Y.FLAG.INSTRMNT.MM EQ '1' THEN
            Y.TYPE.OF.APP = 'MM.MONEY.MARKET'
        END

        IF Y.FLAG.INSTRMNT.SC EQ '1' THEN
            Y.TYPE.OF.APP = 'SC.TRADING.POSITION'
        END

        IF Y.FLAG.INSTRMNT.MM EQ '' AND Y.FLAG.INSTRMNT.SC EQ '' THEN
            Y.TYPE.OF.APP = 'MM.MONEY.MARKET':@FM:'SC.TRADING.POSITION'
        END

        LOOP
            REMOVE Y.PARAM.ID FROM Y.TYPE.OF.APP SETTING Y.POS
        WHILE Y.PARAM.ID:Y.POS
            GOSUB CHECK.PARAM
        REPEAT
    END

    GOSUB SEL.VALUES

RETURN
*
*===========
CHECK.PARAM:
*===========
*
    IF Y.PARAM.ID[1,2] EQ 'MM' THEN

*CALL F.READ(FN.CENTRAL.BANK,'SYSTEM',R.CENTRAL.BANK,F.CENTRAL.BANK,Y.ERR.CENTRAL.BANK)
        CALL CACHE.READ(FN.CENTRAL.BANK,'SYSTEM',R.CENTRAL.BANK,Y.ERR.CENTRAL.BANK)

        Y.CATEG.SEL             = R.CENTRAL.BANK<CEN.BK.CATEGORY>
        Y.CENTRAL.BNK.CATEG     = R.CENTRAL.BANK<CEN.BK.CENTRAL.BANK.CATEG>
        Y.CENTRAL.BNK.CUST      = R.CENTRAL.BANK<CEN.BK.CENT.BANK.CUST>


        Y.MM.REC = Y.CATEG.SEL:@VM:Y.CENTRAL.BNK.CATEG

        CHANGE @VM TO " " IN Y.MM.REC

        Y.CATEG.LIST = Y.MM.REC

        GOSUB GET.MM.PROCESSED.IDS

    END ELSE

        GOSUB GET.STP.PROCESSED.IDS

    END

RETURN
*
*====================
GET.MM.PROCESSED.IDS:
*====================
*MM Final EB.READLIST
*
    SEL.CMD.MM := " AND CATEGORY EQ ":Y.CATEG.LIST
    CALL EB.READLIST(SEL.CMD.MM,SEL.LIST1,'',NOF.REC.1,Y.ERR.1)

RETURN
*
*=====================
GET.STP.PROCESSED.IDS:
*=====================
*
*    IF Y.FLAG.INSTRMNT.SC EQ '1' THEN
*        IF STP.ID.LIST.TEMP NE '' THEN
*            IF STP.ID.LIST EQ '' THEN
*                CALL EB.READLIST(SEL.CMD.SC,STP.ID.LIST,'',NOF.REC.2,Y.ERR.2)
*            END
*        END
*    END ELSE
*        IF STP.ID.LIST EQ '' THEN
*            CALL EB.READLIST(SEL.CMD.SC,STP.ID.LIST,'',NOF.REC.2,Y.ERR.2)
*        END
*    END

    IF Y.MAT.FLAG OR Y.FLAG.INSTRMNT.SC THEN
        GOSUB ULITIMATE.IDS
    END ELSE
        CALL EB.READLIST(SEL.CMD.SC,STP.ID.LIST,'',NOF.REC.2,Y.ERR.2)
        GOSUB ULITIMATE.IDS
    END

RETURN

*=============
ULITIMATE.IDS:
*=============

    LOOP
        REMOVE Y.STP.ID FROM STP.ID.LIST SETTING STP.POS
    WHILE Y.STP.ID:STP.POS

        CALL F.READ(FN.SC.TRADING.POSITION,Y.STP.ID,R.SC.TRADING.POSITION,F.SC.TRADING.POSITION,Y.ERR.SC.TRADING.POSITION)
        Y.SC.SEC.CODE = R.SC.TRADING.POSITION<SC.TRP.SECURITY.CODE>
        CALL F.READ(FN.SECURITY.MASTER,Y.SC.SEC.CODE,R.SECURITY.MASTER,F.SECURITY.MASTER,Y.ERR.SECURITY.MASTER)
        Y.SUB.ASSET.TYPE = R.SECURITY.MASTER<SC.SCM.SUB.ASSET.TYPE>
        IF Y.SUB.ASSET.TYPE GE 100 AND Y.SUB.ASSET.TYPE LE 399 THEN
            STP.ID.LIST.ASSET<-1> = Y.STP.ID
        END

    REPEAT

    STP.ID.LIST = STP.ID.LIST.ASSET

RETURN
*
*==========
SEL.VALUES:
*==========
*
    IF SEL.LIST1 NE '' AND STP.ID.LIST NE '' THEN
        LAST.IDS = SEL.LIST1:@FM:STP.ID.LIST
    END

    IF SEL.LIST1 NE '' AND STP.ID.LIST EQ '' THEN
        LAST.IDS = SEL.LIST1
    END

    IF STP.ID.LIST NE '' AND SEL.LIST1 EQ '' THEN
        LAST.IDS = STP.ID.LIST
    END

    LOOP
        REMOVE Y.ID FROM LAST.IDS SETTING Y.POS
    WHILE Y.ID:Y.POS
        Y.TXN.ID = Y.ID[1,2]

        IF Y.TXN.ID EQ 'MM' THEN

            GOSUB FETCH.VALUES.MM
            IF MM.TRAD.FLAG EQ '1' THEN
                GOSUB FORM.ARRAY
            END
        END ELSE

            GOSUB FETCH.VALUES.SEC
        END
*IF Y.SAM.TYPE.FLAG THEN         ;* PACS00167211 - S/E
*IF Y.TRADER.FLAG EQ '1' THEN
*IF SC.TRAD.FLAG EQ '1' OR MM.TRAD.FLAG EQ '1' THEN
*GOSUB FORM.ARRAY
*END
*END ELSE
*GOSUB FORM.ARRAY
*END
*END

    REPEAT

    GOSUB FINAL.ARRAY

RETURN
*
*===============
FETCH.VALUES.MM:
*===============
*
    CALL F.READ(FN.MM.MONEY.MARKET, Y.ID, R.MM.MONEY.MARKET, F.MM.MONEY.MARKET, Y.ERR.MM.MONEY.MARKET)
    Y.TRADER.TEMP = Y.TRADER
    IF R.MM.MONEY.MARKET THEN

        Y.MAT.DATE = R.MM.MONEY.MARKET<MM.MATURITY.DATE>
        IF LEN(Y.MAT.DATE) EQ 8 AND Y.MAT.DATE LT Y.INVST.AS.ON THEN
            RETURN
        END

*PACS00167211 - S
        Y.SAM.ID   = R.MM.MONEY.MARKET<MM.LOCAL.REF,LOC.L.MM.OWN.PORT>
        GOSUB READ.SAM
        IF NOT(Y.SAM.TYPE.FLAG) THEN
            RETURN
        END
*PACS00167211 - E
        Y.INP.FULL = R.MM.MONEY.MARKET<MM.INPUTTER>
        Y.INP.NAME = FIELD(Y.INP.FULL,'_',2,1)
        IF Y.TRADER.FLAG EQ '1' THEN
            IF Y.TRADER.TEMP EQ Y.INP.NAME THEN
                GOSUB MM.PROC
                MM.TRAD.FLAG = '1'
            END
        END ELSE
            GOSUB MM.PROC
            MM.TRAD.FLAG = '1'
        END
    END

RETURN
*
*=======
MM.PROC:
*=======
*
    Y.TXN.ID.N       = Y.ID
    Y.MM.CATEGORY    = R.MM.MONEY.MARKET<MM.CATEGORY>

    R.CATEGORY     = ''
    Y.ERR.CATEGORY = ''
    CALL CACHE.READ(FN.CATEGORY, Y.MM.CATEGORY, R.CATEGORY, Y.ERR.CATEGORY) ;*R22 AUTO CODE CONVERSION
    IF R.CATEGORY THEN

        Y.TYPE.OF.INST.TEMP = R.CATEGORY<EB.CAT.DESCRIPTION,LNGG>

        IF NOT(Y.TYPE.OF.INST.TEMP) THEN
            Y.TYPE.OF.INST.TEMP = R.CATEGORY<EB.CAT.DESCRIPTION,1>
        END

        Y.LEN.TYPE = LEN(Y.TYPE.OF.INST.TEMP)

        Y.TEMP.STAR = Y.TYPE.OF.INST.TEMP[1,3]

        IF Y.TEMP.STAR EQ '***' THEN

            Y.TYPE.OF.INST = Y.TYPE.OF.INST.TEMP[4,Y.LEN.TYPE]

        END ELSE

            Y.TYPE.OF.INST = Y.TYPE.OF.INST.TEMP

        END
    END

    Y.PORT.FOLIO    = R.MM.MONEY.MARKET<MM.LOCAL.REF,LOC.L.MM.OWN.PORT>
    Y.ISSUER.NO     = R.MM.MONEY.MARKET<MM.CUSTOMER.ID>
    Y.FACE.VALUE    = R.MM.MONEY.MARKET<MM.PRINCIPAL>
    Y.PAID.AMOUNT   = R.MM.MONEY.MARKET<MM.PRINCIPAL>
    Y.ISSUE.DATE    = R.MM.MONEY.MARKET<MM.VALUE.DATE>
    Y.VALUE.DATE    = R.MM.MONEY.MARKET<MM.VALUE.DATE>
    Y.RENOVATION    = R.MM.MONEY.MARKET<MM.ROLLOVER.DATE>
    Y.MAT.DATE      = R.MM.MONEY.MARKET<MM.MATURITY.DATE>
    IF LEN(Y.MAT.DATE) NE 8 THEN

        Y.MAT.DATE := 'D'
        CALL CALENDAR.DAY(Y.VALUE.DATE,'+',Y.MAT.DATE)
    END

    GOSUB ISSUER.DETS

    Y.YIELD         = R.MM.MONEY.MARKET<MM.INTEREST.RATE>
    Y.COUPON        = R.MM.MONEY.MARKET<MM.INTEREST.RATE>

    IF Y.MAT.DATE NE '' AND Y.VALUE.DATE NE '' THEN
        IF LEN(Y.MAT.DATE) EQ 8 THEN
            Y.REGION = ''
            Y.DAYS   = 'C'
            CALL CDD(Y.REGION, Y.MAT.DATE, Y.VALUE.DATE, Y.DAYS)
            Y.DAYS = ABS(Y.DAYS)
        END ELSE
            Y.DAYS = Y.MAT.DATE
        END
    END

RETURN
*
*================
FETCH.VALUES.SEC:
*================
*
    Y.TRADER.TEMP = Y.TRADER
    R.SC.TRADING.POSITION = ""
    Y.ERR.SC.TRADING.POSITION = ""
    CALL F.READ(FN.SC.TRADING.POSITION,Y.ID,R.SC.TRADING.POSITION,F.SC.TRADING.POSITION,Y.ERR.SC.TRADING.POSITION)
    IF R.SC.TRADING.POSITION THEN
*PACS00167211 - S
        Y.SAM.ID = R.SC.TRADING.POSITION<SC.TRP.DEALER.BOOK>
        Y.SM.ID  = R.SC.TRADING.POSITION<SC.TRP.SECURITY.CODE>
        GOSUB READ.SAM
        IF NOT(Y.SAM.TYPE.FLAG) THEN
            RETURN
        END

        D.FIELDS            = 'SECURITY.NUMBER':@FM:'SECURITY.ACCOUNT':@FM:'TO.TRADE.DATE'
        D.RANGE.AND.VALUE   = Y.SM.ID:@FM:Y.SAM.ID:@FM:Y.INVST.AS.ON        ;* PACS00198127 - S/E
        D.LOGICAL.OPERANDS  = '1':@FM:'1':@FM:'8'
        Y.DATA = ''
        CALL E.MB.NOF.GET.TRANS.BW.DATES(Y.DATA)

        IF NOT(Y.DATA) THEN
            Y.SAM.TYPE.FLAG = @FALSE
            RETURN
        END

        GOSUB PROCESS.SEC

*PACS00167211 - E
        Y.DEALER.NAME = R.SC.TRADING.POSITION<SC.TRP.DEALER.BOOK>
*IF Y.TRADER.FLAG EQ '1' THEN
*IF Y.TRADER.TEMP EQ Y.DEALER.NAME THEN
*GOSUB SC.PROC
*SC.TRAD.FLAG = '1'
*END
*END ELSE
*GOSUB SC.PROC
*END
    END
RETURN

*
*============
PROCESS.SEC:
*============
* New section for SC transactions

    Y.SC.REV.MARKER = FIELDS(Y.DATA,"*",11,1)
    Y.ST.IDS = FIELDS(Y.DATA,"*",6,1)
    Y.SC.TOT.CNT = DCOUNT(Y.DATA,@FM)
    Y.SC.FACE.VALUES = FIELDS(Y.DATA,"*",10,1)
    Y.SC.CNT = 1

    LOOP
    WHILE Y.SC.CNT LE Y.SC.TOT.CNT
        IF Y.SC.REV.MARKER<Y.SC.CNT> NE "R" AND Y.ST.IDS<Y.SC.CNT>[1,2] EQ "SC" THEN
            Y.TXN.ID.N = Y.ST.IDS<Y.SC.CNT>
            Y.FACE.VALUE = ABS(Y.SC.FACE.VALUES<Y.SC.CNT>)
            GOSUB SC.PROC
        END
        Y.SC.CNT += 1
    REPEAT

RETURN

*
*=======
SC.PROC:
*=======
*

    Y.SC.SEC.CODE = R.SC.TRADING.POSITION<SC.TRP.SECURITY.CODE>
    Y.PORT.FOLIO  = R.SC.TRADING.POSITION<SC.TRP.DEALER.BOOK>

    R.SECURITY.MASTER = ""
    Y.ERR.SECURITY.MASTER = ""
    CALL F.READ(FN.SECURITY.MASTER,Y.SC.SEC.CODE,R.SECURITY.MASTER,F.SECURITY.MASTER,Y.ERR.SECURITY.MASTER)

    IF R.SECURITY.MASTER THEN
        Y.ISSUER        = R.SECURITY.MASTER<SC.SCM.SHORT.NAME>
        Y.SC.LAST.PRICE = R.SECURITY.MASTER<SC.SCM.LAST.PRICE>
        Y.ISSUE.DATE    = R.SECURITY.MASTER<SC.SCM.ISSUE.DATE>
        Y.COUPON.T      = R.SECURITY.MASTER<SC.SCM.INTEREST.RATE>
        Y.MAT.DATE      = R.SECURITY.MASTER<SC.SCM.MATURITY.DATE>
        Y.SUB.ASST.TYPE = R.SECURITY.MASTER<SC.SCM.SUB.ASSET.TYPE>

        IF Y.MAT.DATE AND Y.MAT.DATE LT Y.INVST.AS.ON THEN
            RETURN
        END
    END

    Y.PAID.AMOUNT = Y.FACE.VALUE * Y.SC.LAST.PRICE

    R.SUB.ASSET.TYPE = ""
    Y.ERR.SUB.ASSET.TYPE = ""
    CALL CACHE.READ(FN.SUB.ASSET.TYPE, Y.SUB.ASST.TYPE, R.SUB.ASSET.TYPE, Y.ERR.SUB.ASSET.TYPE)
    IF R.SUB.ASSET.TYPE THEN
        Y.TYPE.OF.INST = R.SUB.ASSET.TYPE<SC.CSG.DESCRIPTION,LNGG>
        IF NOT(Y.TYPE.OF.INST) THEN
            Y.TYPE.OF.INST = R.SUB.ASSET.TYPE<SC.CSG.DESCRIPTION,1>
        END
    END

    R.SEC.TRADE = ""
    Y.ERR.SEC.TRADE = ""
    CALL F.READ(FN.SEC.TRADE,Y.TXN.ID.N,R.SEC.TRADE,F.SEC.TRADE,Y.ERR.SEC.TRADE)

    IF R.SEC.TRADE THEN
        Y.VALUE.DATE = R.SEC.TRADE<SC.SBS.VALUE.DATE>
        Y.YIELD = R.SEC.TRADE<SC.SBS.LOCAL.REF,LOC.L.SC.TRN.YIELD>
        Y.COUPON = R.SEC.TRADE<SC.SBS.INTEREST.RATE>
    END

    IF Y.MAT.DATE NE '' AND Y.VALUE.DATE NE '' THEN
        Y.REG.SC = ''
        Y.DAYS   = 'C'
        CALL CDD(Y.REG.SC, Y.MAT.DATE, Y.VALUE.DATE, Y.DAYS)
        Y.DAYS = ABS(Y.DAYS)
    END

    GOSUB FORM.ARRAY

RETURN
*
*===========
ISSUER.DETS:
*===========
*
    R.CUSTOMER = ''
    Y.ERR.CUSTOMER = ''
    CALL F.READ(FN.CUSTOMER,Y.ISSUER.NO,R.CUSTOMER,F.CUSTOMER,Y.ERR.CUSTOMER)
    IF R.CUSTOMER THEN
        Y.ISSUER = R.CUSTOMER<EB.CUS.SHORT.NAME>
    END

RETURN
*
*==========
FORM.ARRAY:
*==========
*
    GOSUB INS.FOOT.VALUES

    Y.SEL.LIST.ARRAY = Y.CURRENCY:'*':Y.TRADER:'*':Y.INVST.AS.ON:'*':Y.TYPE.OF.INSTRMNT:'*':Y.PORTFOLIO:'#':Y.PORTFOLIO.TYPE:'*':Y.COUNTERPARTY:'*':Y.MATURITY.DATE

    IF Y.ISSUER.NO NE '' AND Y.CENTRAL.BNK.CUST NE '' THEN
        IF Y.ISSUER.NO EQ Y.CENTRAL.BNK.CUST THEN
            GOSUB CUST.VALUE
        END
    END


    IF Y.MM.CATEGORY NE '' AND Y.CENTRAL.BNK.CATEG NE '' THEN
        IF Y.MM.CATEGORY EQ Y.CENTRAL.BNK.CATEG THEN
            GOSUB BANCO.CENTRAL.VALUES
        END
    END

    Y.FACIAL.COUPON = DROUND(Y.FACIAL.COUPON,2)
    Y.FACIAL.YIELD  = DROUND(Y.FACIAL.YIELD,2)
    Y.YIELD         = DROUND(Y.YIELD,2)
    Y.COUPON        = DROUND(Y.COUPON,2)

*Kickback Fix
*IF Y.TXN.ID.N[1,2] NE 'MM' THEN
*Y.YIELD = Y.YIELD * 100
*END

    Y.FACE.VALUE    = FMT(Y.FACE.VALUE,"R2,#70")
    Y.PAID.AMOUNT   = FMT(Y.PAID.AMOUNT,"R2,#70")
    Y.FACIAL.YIELD  = FMT(Y.FACIAL.YIELD,"R2,#15")
    Y.FACIAL.COUPON = FMT(Y.FACIAL.COUPON,"R2,#15")
    Y.YIELD         = FMT(Y.YIELD,"R4,#10")         ;* PACS00198127 -S/E
    Y.COUPON        = FMT(Y.COUPON,"R4,#10")        ;* PACS00198127 -S/E

    Y.ISSUE.DATE = OCONV(Y.ISSUE.DATE,"DI")
    Y.ISSUE.DATE = OCONV(Y.ISSUE.DATE,"D4")

    Y.ARRAY.2<-1>    = Y.SEL.LIST.ARRAY:'*':Y.TXN.ID.N:'*':Y.TYPE.OF.INST:'*':Y.PORT.FOLIO:'*':Y.ISSUER:'*':Y.FACE.VALUE:'*':Y.PAID.AMOUNT:'*':Y.ISSUE.DATE:'*':Y.VALUE.DATE:'*':Y.RENOVATION:'*':Y.MAT.DATE:'*':Y.YIELD:'*':Y.COUPON:'*':Y.DAYS:'*':Y.FACIAL.YIELD:'*':Y.FACIAL.COUPON:'*':Y.FOOT.DISP

    Y.FACE.VALUE = '' ; Y.PAID.AMOUNT = '' ; SC.TRAD.FLAG = '' ; MM.TRAD.FLAG = '' ; Y.PORT.FOLIO = '' ; Y.ISSUER = ''
    Y.RENOVATION = '' ; Y.MAT.DATE = '' ; Y.YIELD = '' ; Y.COUPON = '' ; Y.DAYS = '' ; Y.FACIAL.YIELD = '' ; Y.FACIAL.COUPON = ''


RETURN
*
*==========
CUST.VALUE:
*==========
*
    Y.FOOT.ISSUER      = 'Total Banco Central sin O/N'
    Y.FOOT.FACE.AMT.T += Y.FACE.VALUE
    Y.FOOT.FACE.AMT    = DROUND(Y.FOOT.FACE.AMT.T,2)
    Y.FOOT.YIELD.T    += Y.YIELD
    Y.FOOT.YIELD       = DROUND(Y.FOOT.YIELD.T,2)
    Y.FOOT.COUPON.T   += Y.COUPON
    Y.FOOT.COUPON      = DROUND(Y.FOOT.COUPON.T,2)

RETURN
*
*====================
BANCO.CENTRAL.VALUES:
*====================
*
    Y.FOOT.ISSUER.BNK       = 'Overnight en Banco Central'
    Y.FOOT.FACE.AMT.BNK.T  += Y.FACE.VALUE
    Y.FOOT.FACE.AMT.BNK     = DROUND(Y.FOOT.FACE.AMT.BNK.T,2)
    Y.FOOT.YIELD.BNK.T     += Y.YIELD
    Y.FOOT.YIELD.BNK        = DROUND(Y.FOOT.YIELD.BNK.T,2)
    Y.FOOT.COUPON.BNK.T    += Y.COUPON
    Y.FOOT.COUPON.BNK       = DROUND(Y.FOOT.COUPON.BNK.T,2)

RETURN
*
*===============
INS.FOOT.VALUES:
*===============
*
    Y.FACIAL.YIELD  = (Y.FACE.VALUE * Y.YIELD)
    Y.FACIAL.COUPON = (Y.FACE.VALUE * Y.COUPON)

    IF Y.MM.CATEGORY EQ '' AND Y.CENTRAL.BNK.CATEG EQ '' THEN
        GOSUB FOOT.VAL
    END

    IF Y.MM.CATEGORY NE Y.CENTRAL.BNK.CATEG THEN
        GOSUB FOOT.VAL
    END

RETURN
*
*========
FOOT.VAL:
*========
*
    LOCATE Y.TYPE.OF.INST IN Y.TYPE.OF.INVST<1,1> SETTING Y.TYPE.INVST.POS THEN
        Y.TOT.FACE.VALUE<1,Y.TYPE.INVST.POS> += Y.FACE.VALUE
        Y.TOT.FACE.YIELD<1,Y.TYPE.INVST.POS> += Y.FACIAL.YIELD
        Y.TOT.FACE.COUPON<1,Y.TYPE.INVST.POS> += Y.FACIAL.COUPON
    END ELSE
        INS Y.FACIAL.COUPON BEFORE Y.TOT.FACE.COUPON<1,-1>
        INS Y.FACIAL.YIELD BEFORE Y.TOT.FACE.YIELD<1,-1>
        INS Y.FACE.VALUE BEFORE Y.TOT.FACE.VALUE<1,-1>
        INS Y.TYPE.OF.INST BEFORE Y.TYPE.OF.INVST<1,-1>
    END

RETURN
*
*===========
FINAL.ARRAY:
*===========
*
    CHANGE @VM TO @FM IN Y.TOT.FACE.COUPON
    CHANGE @VM TO @FM IN Y.TOT.FACE.YIELD
    CHANGE @VM TO @FM IN Y.TOT.FACE.VALUE
    CHANGE @VM TO @FM IN Y.TYPE.OF.INVST

    Y.CNT.DISP = DCOUNT(Y.TOT.FACE.COUPON,@FM)
    Y.I=1
    LOOP
    WHILE Y.I LE Y.CNT.DISP

        Y.DISP.FACE.VALUE  = FIELD(Y.TOT.FACE.VALUE,@FM,Y.I)

        Y.DISP.FACE.COUPON = FIELD(Y.TOT.FACE.COUPON,@FM,Y.I)/Y.DISP.FACE.VALUE
        Y.DISP.FACE.COUPON = DROUND(Y.DISP.FACE.COUPON,2)

        Y.DISP.FACE.YIELD  = FIELD(Y.TOT.FACE.YIELD,@FM,Y.I)/Y.DISP.FACE.VALUE
        Y.DISP.FACE.YIELD  = DROUND(Y.DISP.FACE.YIELD,2)

        Y.DISP.OF.INVST    = FIELD(Y.TYPE.OF.INVST,@FM,Y.I)

        Y.DISP.FACE.VALUE  = FMT(Y.DISP.FACE.VALUE,"R2,#70")
        Y.DISP.FACE.COUPON = FMT(Y.DISP.FACE.COUPON,"R2,#10")

        LOCATE 'BONDS' IN Y.DISP.OF.INVST SETTING BOND.POS THEN
            Y.DISP.FACE.YIELD = Y.DISP.FACE.YIELD * 100
        END
        Y.DISP.FACE.YIELD  = FMT(Y.DISP.FACE.YIELD,"R2,#10")

        Y.ARRAY.5<-1> = Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DISP.OF.INVST:'*':Y.DISP.FACE.VALUE:'*':Y.DISP.FACE.YIELD:'*':Y.DISP.FACE.COUPON:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY
        Y.I += 1

    REPEAT

    Y.TOT.DISP  = 'Total General sin O/N'

    CHANGE @VM TO @FM IN Y.DISP.FACE.VALUE
    CHANGE @VM TO @FM IN Y.DISP.FACE.COUPON
    CHANGE @VM TO @FM IN Y.DISP.FACE.YIELD

    Y.TOT.FACIAL.FACE.VALUE = SUM(Y.TOT.FACE.VALUE)
    Y.TOT.FACIAL.YIELD      = SUM(Y.TOT.FACE.YIELD) / SUM(Y.TOT.FACE.VALUE)
    Y.TOT.FACIAL.COUPON     = SUM(Y.TOT.FACE.COUPON) / SUM(Y.TOT.FACE.VALUE)

    Y.TOT.FACIAL.YIELD      = DROUND(Y.TOT.FACIAL.YIELD,2)
    Y.TOT.FACIAL.COUPON     = DROUND(Y.TOT.FACIAL.COUPON,2)

    Y.DUMMY          = ''

    Y.IN.SUM         = 'Resumen de Inversiones'

*PACS00198127 - S
    Y.ARR.1 = 'Tipo de Inversion'
    Y.ARR.2 = 'Monto Valor Facial'
    Y.ARR.3 = 'Yield Promedio en %'
    Y.ARR.4 = 'Cupon Promedio en %'
*PACS00198127 - E

    Y.ARR.6 = 'Total General'
    Y.ARR.7 = Y.FOOT.FACE.AMT.BNK + SUM(Y.TOT.FACE.VALUE)
    Y.ARR.7 = FMT(Y.ARR.7,"R2,#70")       ;* PACS00167211 - S/E


    Y.ARRAY.3        = Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.IN.SUM:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY

    Y.ARRAY.4        = Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.ARR.1:'*':Y.ARR.2:'*':Y.ARR.3:'*':Y.ARR.4:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY

    IF Y.TOT.FACIAL.FACE.VALUE THEN
        Y.TOT.FACIAL.FACE.VALUE = FMT(Y.TOT.FACIAL.FACE.VALUE,"R2,#70")
        Y.TOT.FACIAL.YIELD      = FMT(Y.TOT.FACIAL.YIELD,"R2,#10")
        Y.TOT.FACIAL.COUPON     = FMT(Y.TOT.FACIAL.COUPON,"R2,#10")
    END

    Y.ARRAY.6        = Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.TOT.DISP:'*':Y.TOT.FACIAL.FACE.VALUE:'*':Y.TOT.FACIAL.YIELD:'*':Y.TOT.FACIAL.COUPON:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY

    IF Y.FOOT.FACE.AMT.BNK THEN
        Y.FOOT.FACE.AMT.BNK = FMT(Y.FOOT.FACE.AMT.BNK,"R2,#70")
        Y.FOOT.YIELD.BNK    = FMT(Y.FOOT.YIELD.BNK,"R2,#10")
        Y.FOOT.COUPON.BNK   = FMT(Y.FOOT.COUPON.BNK,"R2,#10")
    END

    Y.ARRAY.7        = Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.FOOT.ISSUER.BNK:'*':Y.FOOT.FACE.AMT.BNK:'*':Y.FOOT.YIELD.BNK:'*':Y.FOOT.COUPON.BNK:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY

    Y.ARRAY.8        = Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.ARR.6:'*':Y.ARR.7:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY

    IF Y.FOOT.FACE.AMT THEN
        Y.FOOT.FACE.AMT = FMT(Y.FOOT.FACE.AMT,"R2,#70")
        Y.FOOT.YIELD    = FMT(Y.FOOT.YIELD,"R2,#10")
        Y.FOOT.COUPON   = FMT(Y.FOOT.COUPON,"R2,#10")
    END

    Y.ARRAY.9        = Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.FOOT.ISSUER:'*':Y.FOOT.FACE.AMT:'*':Y.FOOT.YIELD:'*':Y.FOOT.COUPON:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY:'*':Y.DUMMY

    Y.FINAL.ARRAY    = Y.ARRAY.2:@FM:Y.ARRAY.3:@FM:Y.ARRAY.4:@FM:Y.ARRAY.5:@FM:Y.ARRAY.6:@FM:Y.ARRAY.7:@FM:Y.ARRAY.8:@FM:Y.ARRAY.9
RETURN
END
