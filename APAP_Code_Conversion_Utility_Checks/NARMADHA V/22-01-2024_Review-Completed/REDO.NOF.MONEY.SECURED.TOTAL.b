* @ValidationCode : MjoyOTY3MDQ4NzpVVEYtODoxNzA1OTI1NDYwNTQ1OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 22 Jan 2024 17:41:00
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
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.MONEY.SECURED.TOTAL(Y.SELECT)
*------------------------------------------------------------------------------------------------------------------------------------------------------
*  Company   Name    : Asociacion Popular de Ahorros y Prestamos
*  Developed By      : MANJU.G
*  ODR Number        : ODR-2010-08-0431
*  Program   Name    : REDO.NOF.MONEY.SECURE
*------------------------------------------------------------------------------------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*------------------------------------------------------------------------------------------------------------------------------------------------------
* In  : --N/A--
* Out : Y.OUT.ARRAY
*------------------------------------------------------------------------------------------------------------------------------------------------------
* DESCRIPTION       : This is a NOFILE enquiry routine to get a report that shows
*                     all insurance daily entries report
*------------------------------------------------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE            WHO             REFERENCE            DESCRIPTION
*  -----           ----            ----------           -----------
*  11-Nov-2010     MANJU.G        ODR-2010-03-0140     INITIAL CREATION
*  13-Nov-2010     Naveenkumar N  ODR-2010-03-0140     Amendment for Completion of Routine
*  27-Sep-2011     Pradeep S      PACS00133293         Field position changed for REDO.CALL.LIST.CATEG
* 13-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM  and SM to @SM
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes
* 19-01-2024       Narmadha V              R22 Utility Changes  - ID Variable used instead of hardcoding
*-------------------------------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.MM.MONEY.MARKET
    $INSERT I_F.CUSTOMER
    $INSERT I_F.SECURITY.POSITION
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.SEC.ACC.MASTER
    $INSERT I_F.REDO.CALL.LIST.CATEG
*------------------------------------------------------------------------------------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

RETURN
*------------------------------------------------------------------------------------------------------------------------------------------------------
INIT:
    FN.MM.MONEY.MARKET = "F.MM.MONEY.MARKET"       ; FN.SECURITY.POSITION = "F.SECURITY.POSITION"       ; FN.SECURITY.MASTER = "F.SECURITY.MASTER"
    F.MM.MONEY.MARKET  = ""                        ; F.SECURITY.POSITION  = ""                          ; F.SECURITY.MASTER  = ""
    R.MM.MONEY.MARKET  = ""                        ; R.SECURITY.POSITION  = ""                          ; R.SECURITY.MASTER  = ""
    E.MM.MONEY.MARKET  = ""                        ; E.SECURITY.POSITION  = ""                          ; E.SECURITY.MASTER  = ""
    CALL OPF(FN.MM.MONEY.MARKET,F.MM.MONEY.MARKET) ; CALL OPF(FN.SECURITY.POSITION,F.SECURITY.POSITION) ; CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)
*
    FN.CUSTOMER        = "F.CUSTOMER"              ; FN.SEC.ACC.MASTER = "F.SEC.ACC.MASTER"             ; FN.REDO.CALL.LIST.CATEG = "F.REDO.CALL.LIST.CATEG"
    F.CUSTOMER         = ""                        ; F.SEC.ACC.MASTER  = ""                             ; F.REDO.CALL.LIST.CATEG  = ""
    R.CUSTOMER         = ""                        ; R.SEC.ACC.MASTER  = ""                             ; R.REDO.CALL.LIST.CATEG  = ""
    E.CUSTOMER         = ""                        ; E.SEC.ACC.MASTER  = ""                             ; E.REDO.CALL.LIST.CATEG  = ""
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)               ; CALL OPF(FN.SEC.ACC.MASTER,F.SEC.ACC.MASTER)       ; CALL OPF(FN.REDO.CALL.LIST.CATEG,F.REDO.CALL.LIST.CATEG)
*
    Y.DATE             = "" ; Y.CURRENCY         = "" ; Y.SELECT          = "" ; Y.SEL.DATE        = "" ; Y.CURRENCY         = "" ; TYPE.OF.INST.FIXED = "" ; TOTAL.SUMMARYS = ""
    INSTITUTION.FIXED  = "" ; FACE.VALUE.FIXED   = "" ; ACC.VALUE.FIXED   = "" ; Y.TOTAL.FIXED     = "" ; TYPE.OF.INST.PLACE = "" ; INSTITUTION.PLACE  = "" ;
    FACE.VALUE.PLACE   = "" ; ACC.VALUE.PLACE    = "" ; Y.TOTAL.PLACE     = "" ; TYPE.OF.INST.CALL = "" ; INSTITUTION.CALL   = "" ; FACE.VALUE.CALL    = "" ;
    ACC.VALUE.CALL     = "" ; Y.TOTAL.CALL       = "" ; TYPE.OF.INST.BOND = "" ; INSTITUTION.BOND  = "" ; FACE.VALUE.BOND    = "" ; ACC.VALUE.BOND     = "" ;
    Y.TOTAL.BOND       = "" ; TYPE.OF.INST.SHARE = "" ; INSTITUTION.SHARE = "" ; FACE.VALUE.SHARE  = "" ; ACC.VALUE.SHARE    = "" ; Y.TOTAL.SHARE      = "" ;
    TOTAL.FACE         = "" ; Y.TOT.FIXED.FACE   = "" ; Y.TOT.PLACE.FACE  = "" ; Y.TOT.CALL.FACE   = "" ; Y.TOT.BOND.FACE    = "" ; Y.TOT.SHARE.FACE   = "" ;
    TOTAL.ACC          = "" ; Y.TOT.FIXED.ACC    = "" ; Y.TOT.PLACE.FACE  = "" ; Y.TOT.CALL.ACC    = "" ; Y.TOT.BOND.ACC     = "" ; Y.TOT.SHARE.ACC    = "" ;
    Y.TOT.PLACE.ACC    =0;Y.TOT.CALL.ACC=0;Y.TOT.FIXED.ACC=0;Y.TOT.BOND.ACC=0;Y.TOT.SHARE.ACC=0
RETURN
*------------------------------------------------------------------------------------------------------------------------------------------------------
PROCESS:

    LOCATE "DATE" IN ENQ.SELECTION<2,1> SETTING Y.POS THEN
        Y.SEL.DATE =  ENQ.SELECTION<4,Y.POS>
    END

    LOCATE "CURRENCY" IN ENQ.SELECTION<2,1> SETTING CUR.POS THEN
        Y.CURRENCY = ENQ.SELECTION<4,CUR.POS>
    END

*CALL F.READ(FN.REDO.CALL.LIST.CATEG,"SYSTEM",R.REDO.CALL.LIST.CATEG,F.REDO.CALL.LIST.CATEG,E.REDO.CALL.LIST.CATEG)
*CALL CACHE.READ(FN.REDO.CALL.LIST.CATEG,"SYSTEM",R.REDO.CALL.LIST.CATEG,E.REDO.CALL.LIST.CATEG)   ;*PACS00133293 - S/E
    IDVAR.1 = "SYSTEM" ;* R22 Utility Changes
    CALL CACHE.READ(FN.REDO.CALL.LIST.CATEG,IDVAR.1,R.REDO.CALL.LIST.CATEG,E.REDO.CALL.LIST.CATEG)   ;*PACS00133293 - S/E;* R22 Utility Changes

    LOCATE "TSN7.PL1" IN R.REDO.CALL.LIST.CATEG<1,1> SETTING PL1.POS THEN
        Y.PL1 = R.REDO.CALL.LIST.CATEG<CALL.LIST.CATEG.CATEGORY><1,PL1.POS>
        CHANGE @SM TO @VM IN Y.PL1  ;*PACS00133293 - S/E
    END
    LOCATE "TSN7.PL2" IN R.REDO.CALL.LIST.CATEG<1,1> SETTING PL2.POS THEN
        Y.PL2 = R.REDO.CALL.LIST.CATEG<CALL.LIST.CATEG.CATEGORY,PL2.POS>
        CHANGE @SM TO @VM IN Y.PL2  ;*PACS00133293 - S/E
    END
    LOCATE "TSN7.PL3" IN R.REDO.CALL.LIST.CATEG<1,1> SETTING PL3.POS THEN
        Y.PL3 = R.REDO.CALL.LIST.CATEG<CALL.LIST.CATEG.CATEGORY,PL3.POS>
        CHANGE @SM TO @VM IN Y.PL3  ;*PACS00133293 - S/E
    END
    LOCATE "TSN7-PLACE" IN R.REDO.CALL.LIST.CATEG<1,1> SETTING TSN7.PLACE.POS THEN
        Y.PLACE.CATEG = R.REDO.CALL.LIST.CATEG<CALL.LIST.CATEG.CATEGORY,TSN7.PLACE.POS>
        CHANGE @SM TO @VM IN Y.PLACE.CATEG    ;*PACS00133293 - S/E
    END
    LOCATE "TSN7-CALL" IN R.REDO.CALL.LIST.CATEG<1,1> SETTING TSN7.CALL.POS THEN
        Y.CALL.CATEG = R.REDO.CALL.LIST.CATEG<CALL.LIST.CATEG.CATEGORY,TSN7.CALL.POS>
        CHANGE @SM TO @VM IN Y.CALL.CATEG     ;*PACS00133293 - S/E
    END

    GOSUB SETTING.FLAG

    BEGIN CASE
        CASE Y.FLAG EQ "1"
            GOSUB PROCESS.ONE
        CASE Y.FLAG EQ "2"
            GOSUB PROCESS.TWO
        CASE Y.FLAG EQ "3"
            GOSUB PROCESS.THREE
        CASE Y.FLAG EQ "4"
            GOSUB PROCESS.FOUR
        CASE Y.FLAG EQ "5"
            GOSUB PROCESS.FIVE
        CASE Y.FLAG EQ "6"
            GOSUB PROCESS.SIX
    END CASE

    IF Y.SELECT EQ "" THEN
        Y.SELECT = Y.SEL.DATE:"*":Y.CURRENCY
    END

RETURN
*------------------------------------------------------------------------------------------------------------------------------------------------------
PROCESS.ONE:
    GOSUB INVEST.FIXED
RETURN

PROCESS.TWO:
    GOSUB INVEST.PLACE
RETURN

PROCESS.THREE:
    GOSUB INVEST.CALL
RETURN

PROCESS.FOUR:
    GOSUB SECURE.BOND
RETURN

PROCESS.FIVE:
    GOSUB SECURE.SHARE
RETURN

PROCESS.SIX:
    GOSUB INVEST.FIXED
    GOSUB INVEST.PLACE
    GOSUB INVEST.CALL
    GOSUB SECURE.BOND
    GOSUB SECURE.SHARE
RETURN
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
INVEST.FIXED:
*
    SEL.FIXED      = "SELECT ":FN.MM.MONEY.MARKET:" BY CUSTOMER.ID":" WITH (CATEGORY MATCHES ":Y.PL1:" OR CATEGORY MATCHES ":Y.PL2:" OR CATEGORY MATCHES ":Y.PL3:") AND VALUE.DATE EQ ":Y.SEL.DATE:" AND CURRENCY EQ ":Y.CURRENCY:" AND MATURITY.DATE GE ":TODAY
    SEL.FIXED.LIST = "" ; NOR.FIXED = "" ; ERR.FIXED = ""
    CALL EB.READLIST(SEL.FIXED,SEL.FIXED.LIST,"",NOR.FIXED,ERR.FIXED)
*
    Y.CUS.LIST           = ""
    TYPE.OF.INST.FIXED   = "Fixed"
    LOOP
        REMOVE Y.SINGLE FROM SEL.FIXED.LIST SETTING FIXED.POS
    WHILE Y.SINGLE:FIXED.POS
        CALL F.READ(FN.MM.MONEY.MARKET,Y.SINGLE,R.MM.MONEY.MARKET,F.MM.MONEY.MARKET,E.MM.MONEY.MARKET)
        Y.CUST.FIXED               = R.MM.MONEY.MARKET<MM.CUSTOMER.ID>
        CALL F.READ(FN.CUSTOMER,Y.CUST.FIXED,R.CUSTOMER,F.CUSTOMER,E.CUSTOMER)

        LOCATE Y.CUST.FIXED IN Y.CUS.LIST <1> SETTING Y.CUS.POS THEN
            INSTITUTION.FIXED = R.CUSTOMER<EB.CUS.SHORT.NAME>
            FACE.VALUE.FIXED += R.MM.MONEY.MARKET<MM.PRINCIPAL>
            ACC.VALUE.FIXED  += R.MM.MONEY.MARKET<MM.PRINCIPAL>

        END ELSE
            IF Y.CUS.LIST THEN
                GOSUB DISPLAY.ALL.FIELDS
                TYPE.OF.INST.FIXED         = ""
                Y.TOT.FIXED.FACE += FACE.VALUE.FIXED
                Y.TOT.FIXED.ACC  += ACC.VALUE.FIXED
            END
            Y.CUS.LIST<-1>    = Y.CUST.FIXED
            INSTITUTION.FIXED = R.CUSTOMER<EB.CUS.SHORT.NAME>
            FACE.VALUE.FIXED  = R.MM.MONEY.MARKET<MM.PRINCIPAL>
            ACC.VALUE.FIXED   = R.MM.MONEY.MARKET<MM.PRINCIPAL>
        END
    REPEAT

    IF Y.CUS.LIST THEN
        GOSUB DISPLAY.ALL.FIELDS
        TYPE.OF.INST.FIXED    = ""
        Y.TOT.FIXED.FACE     += FACE.VALUE.FIXED
        Y.TOT.FIXED.ACC     += ACC.VALUE.FIXED
    END

RETURN
*----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
INVEST.PLACE:
*
    SEL.PLACE      = "SELECT ":FN.MM.MONEY.MARKET:" BY CUSTOMER.ID":" WITH CATEGORY EQ ":Y.PLACE.CATEG:" AND VALUE.DATE EQ ":Y.SEL.DATE:" AND CURRENCY EQ ":Y.CURRENCY:" AND MATURITY.DATE GE ":TODAY

    SEL.PLACE.LIST = "" ; NOR.PLACE = "" ; ERR.PLACE = ""
    CALL EB.READLIST(SEL.PLACE,SEL.PLACE.LIST,"",NOR.PLACE,ERR.PLACE)
*
    Y.CUS.LIST           = ""
    Y.CUS.POS            = ""
    TYPE.OF.INST.PLACE   = "Fixed"
    LOOP
        REMOVE Y.SINGLE.PLACE FROM SEL.PLACE.LIST SETTING PLACE.POS
    WHILE Y.SINGLE.PLACE:PLACE.POS
        CALL F.READ(FN.MM.MONEY.MARKET,Y.SINGLE.PLACE,R.MM.MONEY.MARKET,F.MM.MONEY.MARKET,E.MM.MONEY.MARKET)
        Y.CUST.PLACE               = R.MM.MONEY.MARKET<MM.CUSTOMER.ID>
        CALL F.READ(FN.CUSTOMER,Y.CUST.PLACE,R.CUSTOMER,F.CUSTOMER,E.CUSTOMER)

        LOCATE Y.CUST.PLACE IN Y.CUS.LIST <1> SETTING Y.CUS.POS THEN
            INSTITUTION.PLACE = R.CUSTOMER<EB.CUS.SHORT.NAME>
            FACE.VALUE.PLACE += R.MM.MONEY.MARKET<MM.PRINCIPAL>
            ACC.VALUE.PLACE  += R.MM.MONEY.MARKET<MM.PRINCIPAL>
        END ELSE
            IF Y.CUS.LIST THEN
                GOSUB DISPLAY.ALL.FIELDS
                TYPE.OF.INST.PLACE         = ""
                Y.TOT.PLACE.FACE += FACE.VALUE.PLACE
                Y.TOT.PLACE.ACC += ACC.VALUE.PLACE
            END
            Y.CUS.LIST<-1>    = Y.CUST.PLACE
            INSTITUTION.PLACE = R.CUSTOMER<EB.CUS.SHORT.NAME>
            FACE.VALUE.PLACE  = R.MM.MONEY.MARKET<MM.PRINCIPAL>
            ACC.VALUE.PLACE   = R.MM.MONEY.MARKET<MM.PRINCIPAL>
        END
    REPEAT

    IF Y.CUS.LIST THEN
        GOSUB DISPLAY.ALL.FIELDS
        TYPE.OF.INST.PLACE         = ""
        Y.TOT.PLACE.FACE += FACE.VALUE.PLACE
        Y.TOT.PLACE.ACC += ACC.VALUE.PLACE
    END

RETURN
*------------------------------------------------------------------------------------------------------------------------------------------------------
INVEST.CALL:
*
    SEL.CALL      = "SELECT ":FN.MM.MONEY.MARKET:" BY CUSTOMER.ID":" WITH CATEGORY EQ ":Y.CALL.CATEG:" AND VALUE.DATE EQ ":Y.SEL.DATE:" AND CURRENCY EQ ":Y.CURRENCY:" AND MATURITY.DATE GE ":TODAY
    SEL.CALL.LIST = "" ; NOR.CALL = "" ;ERR.CALL = ""
    CALL EB.READLIST(SEL.CALL,SEL.CALL.LIST,"",NOR.CALL,ERR.CALL)
*
    Y.CUS.LIST           = ""
    Y.CUS.POS            = ""

    TYPE.OF.INST.CALL   = "Call"
    LOOP
        REMOVE Y.SINGLE.CALL FROM SEL.CALL.LIST SETTING CALL.POS
    WHILE Y.SINGLE.CALL:CALL.POS
        CALL F.READ(FN.MM.MONEY.MARKET,Y.SINGLE.CALL,R.MM.MONEY.MARKET,F.MM.MONEY.MARKET,E.MM.MONEY.MARKET)
        Y.CUST.CALL               = R.MM.MONEY.MARKET<MM.CUSTOMER.ID>
        CALL F.READ(FN.CUSTOMER,Y.CUST.CALL,R.CUSTOMER,F.CUSTOMER,E.CUSTOMER)

        LOCATE Y.CUST.CALL IN Y.CUS.LIST <1> SETTING Y.CUS.POS THEN
            INSTITUTION.CALL  = R.CUSTOMER<EB.CUS.SHORT.NAME>
            FACE.VALUE.CALL  += R.MM.MONEY.MARKET<MM.PRINCIPAL>
            ACC.VALUE.CALL   += R.MM.MONEY.MARKET<MM.PRINCIPAL>
        END ELSE
            IF Y.CUS.LIST THEN
                GOSUB DISPLAY.ALL.FIELDS
                TYPE.OF.INST.CALL         = ""
                Y.TOT.CALL.FACE  += FACE.VALUE.CALL
                Y.TOT.CALL.ACC   += ACC.VALUE.CALL
            END
            Y.CUS.LIST<-1>   = Y.CUST.CALL
            INSTITUTION.CALL = R.CUSTOMER<EB.CUS.SHORT.NAME>
            FACE.VALUE.CALL  = R.MM.MONEY.MARKET<MM.PRINCIPAL>
            ACC.VALUE.CALL   = R.MM.MONEY.MARKET<MM.PRINCIPAL>
        END
    REPEAT

    IF Y.CUS.LIST THEN
        GOSUB DISPLAY.ALL.FIELDS
        TYPE.OF.INST.CALL         = ""
        Y.TOT.CALL.FACE  += FACE.VALUE.CALL
        Y.TOT.CALL.ACC   += ACC.VALUE.CALL
    END


RETURN
*------------------------------------------------------------------------------------------------------------------------------------------------------
SECURE.BOND:
*
    SEL.BOND      = "SELECT ":FN.SECURITY.POSITION:" BY SECURITY.NUMBER"
    SEL.BOND.LIST = "" ; NOR.BOND = "" ; ERR.BOND = ""
    CALL EB.READLIST(SEL.BOND,SEL.BOND.LIST,"",NOR.BOND,ERR.BOND)
*
    Y.SEC.LIST                           = ""
    Y.SEC.POS                            = ""
    TYPE.OF.INST.BOND                    = "Bond"
    LOOP
        REMOVE Y.SINGLE.BOND FROM SEL.BOND.LIST SETTING BOND.POS
    WHILE Y.SINGLE.BOND:BOND.POS
        CALL F.READ(FN.SECURITY.POSITION,Y.SINGLE.BOND,R.SECURITY.POSITION,F.SECURITY.POSITION,E.SECURITY.POSITION)
        Y.SECURITY.NUMBER                = R.SECURITY.POSITION<SC.SCP.SECURITY.NUMBER>
        Y.SECURITY.ACCOUNT               = R.SECURITY.POSITION<SC.SCP.SECURITY.ACCOUNT>
        Y.DATE.LAST.TRADED               = R.SECURITY.POSITION<SC.SCP.DATE.LAST.TRADED>

        CALL F.READ(FN.SECURITY.MASTER,Y.SECURITY.NUMBER,R.SECURITY.MASTER,F.SECURITY.MASTER,E.SECURITY.MASTER)
        Y.PRICE.CURRENCY                 = R.SECURITY.MASTER<SC.SCM.PRICE.CURRENCY>
        Y.BOND.OR.SHARE                  = R.SECURITY.MASTER<SC.SCM.BOND.OR.SHARE>
        Y.MATURITY.DATE                  = R.SECURITY.MASTER<SC.SCM.MATURITY.DATE>

        CALL F.READ(FN.SEC.ACC.MASTER,Y.SECURITY.ACCOUNT,R.SEC.ACC.MASTER,F.SEC.ACC.MASTER,E.SEC.ACC.MASTER)
        Y.DEALER.BOOK                    = R.SEC.ACC.MASTER<SC.SAM.DEALER.BOOK>

        IF Y.DATE.LAST.TRADED GE Y.SEL.DATE AND Y.PRICE.CURRENCY EQ Y.CURRENCY AND Y.BOND.OR.SHARE EQ 'B' AND Y.DEALER.BOOK NE '' AND Y.MATURITY.DATE GE TODAY THEN
            LOCATE Y.SECURITY.NUMBER IN Y.SEC.LIST <1> SETTING Y.SEC.POS THEN
                INSTITUTION.BOND         = R.SECURITY.MASTER<SC.SCM.COMPANY.NAME>
                FACE.VALUE.BOND         += R.SECURITY.POSITION<SC.SCP.CLOSING.BAL.NO.NOM>
                Y.LAST.PRICE             = R.SECURITY.MASTER<SC.SCM.LAST.PRICE>
                Y.ACC.VALUE              = R.SECURITY.POSITION<SC.SCP.CLOSING.BAL.NO.NOM>
                ACC.VALUE.BOND          += (Y.ACC.VALUE * Y.LAST.PRICE)
            END ELSE
                IF Y.SEC.LIST THEN
                    GOSUB DISPLAY.ALL.FIELDS
                    TYPE.OF.INST.BOND    = ""
                    Y.TOT.BOND.FACE         += FACE.VALUE.BOND
                    Y.TOT.BOND.ACC          += ACC.VALUE.BOND
                END
                Y.SEC.LIST<-1>           = Y.SECURITY.NUMBER
                INSTITUTION.BOND         = R.SECURITY.MASTER<SC.SCM.COMPANY.NAME>
                FACE.VALUE.BOND          = R.SECURITY.POSITION<SC.SCP.CLOSING.BAL.NO.NOM>
                Y.LAST.PRICE             = R.SECURITY.MASTER<SC.SCM.LAST.PRICE>
                Y.ACC.VALUE              = R.SECURITY.POSITION<SC.SCP.CLOSING.BAL.NO.NOM>
                ACC.VALUE.BOND           = Y.ACC.VALUE * Y.LAST.PRICE
            END
        END
    REPEAT

    IF Y.SEC.LIST THEN
        GOSUB DISPLAY.ALL.FIELDS
        TYPE.OF.INST.BOND                = ""
        Y.TOT.BOND.FACE         += FACE.VALUE.BOND
        Y.TOT.BOND.ACC          += ACC.VALUE.BOND
    END

RETURN
*------------------------------------------------------------------------------------------------------------------------------------------------------
SECURE.SHARE:
*
    SEL.SHARE      = "SELECT ":FN.SECURITY.POSITION:" BY SECURITY.NUMBER"
    SEL.SHARE.LIST = "" ; NOR.SHARE = "" ; ERR.SHARE = ""
    CALL EB.READLIST(SEL.SHARE,SEL.SHARE.LIST,"",NOR.SHARE,ERR.SHARE)
*
    Y.SEC.LIST                           = ""
    Y.SEC.POS                            = ""
    TYPE.OF.INST.SHARE                   = "Share"

    LOOP
        REMOVE Y.SINGLE.SHARE FROM SEL.SHARE.LIST SETTING SHARE.POS
    WHILE Y.SINGLE.SHARE:SHARE.POS
        CALL F.READ(FN.SECURITY.POSITION,Y.SINGLE.SHARE,R.SECURITY.POSITION,F.SECURITY.POSITION,E.SECURITY.POSITION)
        Y.DATE.LAST.TRADED               = R.SECURITY.POSITION<SC.SCP.DATE.LAST.TRADED>
        Y.SECURITY.NUMBER                = R.SECURITY.POSITION<SC.SCP.SECURITY.NUMBER>
        Y.SECURITY.ACCOUNT               = R.SECURITY.POSITION<SC.SCP.SECURITY.ACCOUNT>

        CALL F.READ(FN.SECURITY.MASTER,Y.SECURITY.NUMBER,R.SECURITY.MASTER,F.SECURITY.MASTER,E.SECURITY.MASTER)
        Y.PRICE.CURRENCY                 = R.SECURITY.MASTER<SC.SCM.PRICE.CURRENCY>
        Y.BOND.OR.SHARE                  = R.SECURITY.MASTER<SC.SCM.BOND.OR.SHARE>

        CALL F.READ(FN.SEC.ACC.MASTER,Y.SECURITY.ACCOUNT,R.SEC.ACC.MASTER,F.SEC.ACC.MASTER,E.SEC.ACC.MASTER)
        Y.DEALER.BOOK                    = R.SEC.ACC.MASTER<SC.SAM.DEALER.BOOK>

        IF Y.DATE.LAST.TRADED GE Y.SEL.DATE AND Y.PRICE.CURRENCY EQ Y.CURRENCY AND Y.BOND.OR.SHARE EQ 'S' AND Y.DEALER.BOOK NE '' THEN
            LOCATE Y.SECURITY.NUMBER IN Y.SEC.LIST <1> SETTING Y.SEC.POS THEN
                INSTITUTION.SHARE        = R.SECURITY.MASTER<SC.SCM.COMPANY.NAME>
                FACE.VALUE.SHARE        += R.SECURITY.POSITION<SC.SCP.CLOSING.BAL.NO.NOM>
                Y.LAST.PRICE             = R.SECURITY.MASTER<SC.SCM.LAST.PRICE>
                Y.ACC.VALUE              = R.SECURITY.POSITION<SC.SCP.CLOSING.BAL.NO.NOM>
                ACC.VALUE.SHARE         += (Y.ACC.VALUE * Y.LAST.PRICE)
            END ELSE
                IF Y.SEC.LIST THEN
                    GOSUB DISPLAY.ALL.FIELDS
                    TYPE.OF.INST.SHARE   = ""
                    Y.TOT.SHARE.FACE    += FACE.VALUE.SHARE
                    Y.TOT.SHARE.ACC     += ACC.VALUE.SHARE
                END
                Y.SEC.LIST<-1>           = Y.SECURITY.NUMBER
                INSTITUTION.SHARE        = R.SECURITY.MASTER<SC.SCM.COMPANY.NAME>
                FACE.VALUE.SHARE         = R.SECURITY.POSITION<SC.SCP.CLOSING.BAL.NO.NOM>
                Y.LAST.PRICE             = R.SECURITY.MASTER<SC.SCM.LAST.PRICE>
                Y.ACC.VALUE              = R.SECURITY.POSITION<SC.SCP.CLOSING.BAL.NO.NOM>
                ACC.VALUE.SHARE          = (Y.ACC.VALUE * Y.LAST.PRICE)
            END
        END
    REPEAT

    IF Y.SEC.LIST THEN
        GOSUB DISPLAY.ALL.FIELDS
        TYPE.OF.INST.BOND        = ""
        Y.TOT.SHARE.FACE        += FACE.VALUE.SHARE
        Y.TOT.SHARE.ACC         += ACC.VALUE.SHARE
    END

    TOTAL.FACE = (Y.TOT.FIXED.FACE + Y.TOT.PLACE.FACE + Y.TOT.CALL.FACE + Y.TOT.BOND.FACE + Y.TOT.SHARE.FACE)
    TOTAL.ACC  = (Y.TOT.FIXED.ACC  + Y.TOT.PLACE.ACC  + Y.TOT.CALL.ACC  + Y.TOT.BOND.ACC  + Y.TOT.SHARE.ACC)

    Y.SELECT  = TOTAL.FACE:"*":TOTAL.ACC:"*":
RETURN
*------------------------------------------------------------------------------------------------------------------------------------------------------
DISPLAY.ALL.FIELDS:
*
    Y.SELECT<-1> = Y.SEL.DATE:"*":Y.CURRENCY:"*":TYPE.OF.INST.FIXED:"*":INSTITUTION.FIXED:"*":FACE.VALUE.FIXED:"*":ACC.VALUE.FIXED:"*":Y.TOTAL.FIXED:"*":
    Y.SELECT    := TYPE.OF.INST.PLACE:"*":INSTITUTION.PLACE:"*":FACE.VALUE.PLACE:"*":ACC.VALUE.PLACE:"*":Y.TOTAL.PLACE:"*"
    Y.SELECT    := TYPE.OF.INST.CALL:"*":INSTITUTION.CALL:"*":FACE.VALUE.CALL:"*":ACC.VALUE.CALL:"*":Y.TOTAL.CALL:"*"
    Y.SELECT    := TYPE.OF.INST.BOND:"*":INSTITUTION.BOND:"*":FACE.VALUE.BOND:"*":ACC.VALUE.BOND:"*":Y.TOTAL.BOND:"*"
    Y.SELECT    := TYPE.OF.INST.SHARE:"*":INSTITUTION.SHARE:"*":FACE.VALUE.SHARE:"*":ACC.VALUE.SHARE:"*":
RETURN
*------------------------------------------------------------------------------------------------------------------------------------------------------
SETTING.FLAG:
    IF ENQ.SELECTION<1> EQ "REDO.INVSMT.FV.AC.PL" THEN
        Y.FLAG = "1"
    END
    IF ENQ.SELECTION<1> EQ "REDO.INVSMT.FV.AC.PLACE" THEN
        Y.FLAG = "2"
    END
    IF ENQ.SELECTION<1> EQ "REDO.INVSMT.FV.AC.PL.CALL" THEN
        Y.FLAG = "3"
    END
    IF ENQ.SELECTION<1> EQ "REDO.INVSMT.FV.AC.BND" THEN
        Y.FLAG = "4"
    END
    IF ENQ.SELECTION<1> EQ "REDO.INVSMT.FV.AC.SHR" THEN
        Y.FLAG = "5"
    END
    IF ENQ.SELECTION<1> EQ "APAP.INVSMNT.FV.AC" OR ENQ.SELECTION<1> EQ "REDO.INVSMT.FV.AC.TOTAL" THEN
        Y.FLAG = "6"
    END
RETURN
END
